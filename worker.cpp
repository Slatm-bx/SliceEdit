#include "worker.h"
#include <string>
#include <iostream>
#include <fstream>
#include <QFileInfo>
#include <QString>
#include <QUrl>
extern "C" {
#include <stdio.h>
#include <libavutil/log.h>
#include <libavformat/avformat.h>
#include <libavutil/timestamp.h>
}

Worker::Worker(QObject *parent) : QObject{parent} {}

void Worker::cutOneVideo(double startime,
                         double endtime,
                         QUrl inName,
                         // QUrl outName)
                         QString outName) //QUrl inName, QUrl outName) //QString inName,QString outName
{
    std::string infileName = inName.toLocalFile().toStdString();
    std::string outfileName = outName.toStdString();
    std::cout << "infileName: " << infileName << " outfileName: " << outfileName << std::endl;

    //
    const AVOutputFormat *ofmt = nullptr;
    AVPacket *pkt = av_packet_alloc();
    int ret, i;

    //构建输入AVFormatContext
    AVFormatContext *ifmt_ctx = nullptr;
    if (avformat_open_input(&ifmt_ctx, infileName.data(), 0, 0) < 0) {
        fprintf(stderr, "can't open file: %s", infileName.data());
        return;
    }

    //让AVFormatContext获取视频的流信息
    if (avformat_find_stream_info(ifmt_ctx, 0) < 0) {
        fprintf(stderr, "failed to retrieve input stream information");
        return;
    }
    //输出输入的流媒体文件按信息
    av_dump_format(ifmt_ctx, 0, "", 0);

    //构建输出AVFormatContext
    // ofmt = ifmt_ctx->oformat;
    AVFormatContext *ofmt_ctx = nullptr;
    avformat_alloc_output_context2(&ofmt_ctx,
                                   nullptr,
                                   nullptr,
                                   outfileName.data()); //为输出媒体文件分配和初始化格式上下文
    if (ofmt_ctx == nullptr) {
        fprintf(stderr, "can't create output file");
        return;
    }

    //创建AVStream，为ofmt_ctx中的stream信息申请独立空间
    for (int i = 0; i < ifmt_ctx->nb_streams; i++) {
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVStream *out_stream = avformat_new_stream(ofmt_ctx, nullptr);
        if (!out_stream) {
            fprintf(stderr, "创建输出流失败\n");
            return;
        }
        // 复制编解码参数
        avcodec_parameters_copy(out_stream->codecpar, in_stream->codecpar);
        // 设置时间基（与输入流一致）
        out_stream->time_base = in_stream->time_base;
    }
    // 5. 打开输出文件
    if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
        if ((ret = avio_open(&ofmt_ctx->pb, outfileName.c_str(), AVIO_FLAG_WRITE)) < 0) {
            fprintf(stderr, "无法打开输出文件: %s\n", av_err2str(ret));
            return;
        }
    }

    // 6. 写入文件头
    if ((ret = avformat_write_header(ofmt_ctx, nullptr)) < 0) {
        fprintf(stderr, "写入文件头失败: %s\n", av_err2str(ret));
        return;
    }

    // 定位到起始时间附近的关键帧startime * AV_TIME_BASE, AVSEEK_FLAG_ANY)
    if ((ret = av_seek_frame(ifmt_ctx, -1, startime * AV_TIME_BASE, AVSEEK_FLAG_BACKWARD)) < 0) {
        fprintf(stderr, "定位失败: %s\n", av_err2str(ret));
        return;
    }
    //AVPacket 是压缩数据的载体，用于存储和传输。
    //AVFrame 是原始数据的载体，用于处理和渲染。

    // 读取并写入数据包
    while (av_read_frame(ifmt_ctx, pkt) >= 0) {
        AVStream *in_stream = ifmt_ctx->streams[pkt->stream_index];
        // AVStream *out_stream = ofmt_ctx->streams[pkt->stream_index];

        int64_t start_ts = (int64_t) (startime / av_q2d(in_stream->time_base)); //得到时间戳;
        // 检查时间戳是否在剪辑范围内
        //av_compare_ts(pkt->pts, in_stream->time_base, end_ts, in_stream->time_base) >= 0//不准
        if (av_q2d(in_stream->time_base) * pkt->pts > endtime) {
            av_packet_unref(pkt);
            break; // 超出结束时间，停止写入
        }

        // 调整时间戳（相对剪辑起点）
        // pkt->pts = av_rescale_q(pkt->pts - start_ts, in_stream->time_base, out_stream->time_base);
        // pkt->dts = av_rescale_q(pkt->dts - start_ts, in_stream->time_base, out_stream->time_base);
        // pkt->duration = av_rescale_q(pkt->duration, in_stream->time_base, out_stream->time_base);
        pkt->pts = pkt->pts - start_ts;
        pkt->dts = pkt->dts - start_ts;
        pkt->duration = pkt->duration;
        //AVPacket 中的 duration 表示该数据包（通常包含一个压缩帧）在播放时的持续时间，其单位为对应流的时间基（time_base）
        pkt->pos = -1; // 让FFmpeg自动计算新位置

        // 写入数据包
        if ((ret = av_interleaved_write_frame(ofmt_ctx, pkt)) < 0) {
            fprintf(stderr, "写入数据包失败: %s\n", av_err2str(ret));
            av_packet_unref(pkt);
            return;
        }
        av_packet_unref(pkt);
    }

    // 8. 写入文件尾
    av_write_trailer(ofmt_ctx);

    if (ofmt_ctx && !(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) { avio_closep(&ofmt_ctx->pb); }
    avformat_close_input(&ifmt_ctx);
    avformat_free_context(ofmt_ctx);
    av_packet_free(&pkt);
}

void Worker::saveAllVideos(const QVariantList &startTimes, const QVariantList &endTimes, QUrl inName, QString outName)
{
    QString localFile = inName.toLocalFile();

    //  使用QFileInfo提取后缀
    QFileInfo fileInfo(localFile);
    QString suffix = fileInfo.suffix();

    std::string outfileName = outName.toStdString();
    std::cout << outfileName << '\n';
    std::string clipsOutFile = "/tmp/VideoShot/";
    if (startTimes.size() != endTimes.size()) {
        qWarning() << "时间区间数量不匹配";
        return;
    }

    // 转换为double处理
    QVector<double> stimes, etimes;
    for (const QVariant &st : startTimes) {
        stimes.append(st.toDouble());
    }
    for (const QVariant &et : endTimes) {
        etimes.append(et.toDouble());
    }

    QVector<QString> outputFiles; // 用于存储生成的剪辑文件名
    for (int i = 0; i < stimes.count(); i++) {
        QString oneoutfilename = QString::fromStdString(clipsOutFile) + "clip" + QString::number(i) + "." + suffix;
        cutOneVideo(stimes[i], etimes[i], inName, oneoutfilename);
        outputFiles.append(oneoutfilename); // 记录生成的文件名
    }

    std::vector<std::string> input_files;

    for (const QString &filename : outputFiles) {
        input_files.push_back(filename.toStdString());
    }

    for (const std::string &filename : input_files) {
        std::cout << filename << '\n';
    }
    // 调用函数合并视频
    if (isSaveAllVideo(outfileName, input_files)) {
        std::cout << "操作成功！" << std::endl;
    } else {
        std::cerr << "操作失败！" << std::endl;
    }
}

bool Worker::isSaveAllVideo(const std::string &output_filename, const std::vector<std::string> &input_files)
{
    // 1. 创建临时文件 filelist.txt
    std::ofstream filelist("filelist.txt");
    if (!filelist.is_open()) {
        std::cerr << "无法创建 filelist.txt" << std::endl;
        return false;
    }

    for (const auto &file : input_files) {
        filelist << "file '" << file << "'" << std::endl;
    }
    filelist.close();

    // 3. 构建 FFmpeg 命令
    std::string command = "ffmpeg -f concat -safe 0 -i filelist.txt -c copy \"" + output_filename + "\"";

    // 4. 执行命令
    std::cout << "执行命令: " << command << std::endl;
    int ret = std::system(command.c_str());
    if (ret != 0) {
        std::cerr << "FFmpeg 合并失败 (返回值: " << ret << ")" << std::endl;
        std::remove("filelist.txt"); // 清理临时文件
        return false;
    }

    // 5. 删除临时文件
    std::remove("filelist.txt");
    std::cout << "视频合并成功: " << output_filename << std::endl;
    return true;
}
