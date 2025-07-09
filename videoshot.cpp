#include "videoshot.h"
#include <iostream>
#include <thread>
#include <mutex>
#include <QDir>

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h" //格式转换库
}

VideoShot::VideoShot(
    QObject *parent)
    : QObject{parent}

{
    m_outputPath = QDir::tempPath() + "/SliceEdit/";
    QDir dir;
    if (!dir.exists(m_outputPath))
        dir.mkdir(m_outputPath);
}

VideoShot::~VideoShot()
{
    for (std::thread &a : m_threads) {
        if (a.joinable())
            a.join();
    }
    std::cerr << "清除:" << m_outputPath.toStdString() << "\n";
    QDir dir(m_outputPath);
    if (dir.exists(m_outputPath)) {
        if (dir.removeRecursively())
            std::cerr << "缓存清除！\n";
        else
            std::cerr << "缓存清除失败\n";
    }
}

void VideoShot::shot(
    QUrl source, int num, QString outputPath)
{
    //m_lock.lock();
    AVFormatContext *fmt_ctx{nullptr};                   //必须为空，不然第29秒后就炸
    AVCodecContext *dec_ctx{nullptr}, *enc_ctx{nullptr}; //解编码上下文
    SwsContext *sws_ctx{nullptr};                        //色彩转换
    AVFrame *dec_frame{nullptr}, *enc_frame{nullptr};    //帧

    int videoIndex = -1;

    //输入检测
    if (source.isEmpty()) {
        std::cerr << "输入文件为空\n";
        return;
    }
    if (outputPath.isEmpty()) {
        std::cerr << "输出位置为空\n";
        return;
    }
    if (num <= 0) {
        std::cerr << "指定数量不能小于等于0\n";
        return;
    }

    std::cerr << "开始截图\n输入路径:" << source.toLocalFile().toStdString() << "\n数量:" << num
              << "\n输出路径:" << outputPath.toStdString() << "\n";

    int ret = avformat_open_input(&fmt_ctx,
                                  source.toLocalFile().toStdString().c_str(),
                                  nullptr,
                                  nullptr);
    if (ret < 0) {
        char errBuf[AV_ERROR_MAX_STRING_SIZE];
        av_strerror(ret, errBuf, sizeof(errBuf));
        qDebug() << "错误:" << errBuf;
        return;
    }

    if (avformat_find_stream_info(fmt_ctx, nullptr) < 0) {
        std::cerr << "无法获取流信息\n";
        return;
    }

    videoIndex = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    if (videoIndex < 0) {
        std::cerr << "未找到视频流\n";
        return;
    }

    //获取流的环境（部分与解码器上下文有关）
    AVCodecParameters *codec_par{nullptr};
    codec_par = fmt_ctx->streams[videoIndex]->codecpar;
    const AVCodec *dec_codec{nullptr};

    dec_codec = avcodec_find_decoder(codec_par->codec_id);
    dec_ctx = avcodec_alloc_context3(dec_codec);

    avcodec_parameters_to_context(dec_ctx, codec_par);
    //dec_ctx->hw_device_ctx = NULL;

    if (avcodec_open2(dec_ctx, dec_codec, nullptr) < 0) {
        std::cerr << "无法打开解码器\n";
        return;
    }

    // 编码器配置（MJPEG）
    const AVCodec *enc_codec{nullptr};
    enc_codec = avcodec_find_encoder(AV_CODEC_ID_MJPEG);
    enc_ctx = avcodec_alloc_context3(enc_codec);
    enc_ctx->width = dec_ctx->width;
    enc_ctx->height = dec_ctx->height;
    enc_ctx->time_base = fmt_ctx->streams[videoIndex]->time_base; // 时间基
    enc_ctx->pix_fmt = AV_PIX_FMT_YUV420P;                        // 改为标准YUV420P
    enc_ctx->color_range = AVCOL_RANGE_JPEG;                      // 显式设置完全范围

    if (avcodec_open2(enc_ctx, enc_codec, nullptr) < 0) {
        std::cerr << "无法打开编码器\n";
        return;
    }

    // 分配解码帧内存
    dec_frame = av_frame_alloc();
    if (!dec_frame) {
        std::cerr << "无法分配解码帧内存\n";
        return;
    }

    // 分配编码帧内存
    enc_frame = av_frame_alloc();
    if (!enc_frame) {
        std::cerr << "无法分配编码帧内存\n";
        return;
    }
    enc_frame->format = enc_ctx->pix_fmt;
    enc_frame->width = enc_ctx->width;
    enc_frame->height = enc_ctx->height;

    if (av_frame_get_buffer(enc_frame, 32) < 0) {
        std::cerr << "无法分配缓冲区\n";
        return;
    }

    sws_ctx = sws_getContext(dec_ctx->width,
                             dec_ctx->height,
                             dec_ctx->pix_fmt,
                             enc_ctx->width,
                             enc_ctx->height,
                             enc_ctx->pix_fmt,
                             SWS_BILINEAR, //双线性插值算法（速度与质量的平衡）
                             nullptr,
                             nullptr,
                             nullptr);

    if (!sws_ctx) {
        std::cerr << "无法创建颜色转换上下文\n";
        return;
    }

    AVPacket pkt;
    AVPacket *enc_pkt = nullptr;
    enc_pkt = av_packet_alloc();
    enc_pkt->data = nullptr;
    enc_pkt->size = 0;
    int frameCount{0};
    double timeBase = av_q2d(fmt_ctx->streams[videoIndex]->time_base);
    double totaltime = fmt_ctx->streams[videoIndex]->duration * timeBase;
    std::cerr << "总时间:" << totaltime << "\n";
    double spacingTime = totaltime / num;
    double lastTime = 0.0; //记录下个截取的时间

    while (av_read_frame(fmt_ctx, &pkt) >= 0) {
        if (pkt.stream_index == videoIndex) {
            if (avcodec_send_packet(dec_ctx, &pkt) < 0) {
                std::cerr << "发送数据包错误\n";
                continue;
            }
            while (avcodec_receive_frame(dec_ctx, dec_frame) >= 0) {
                //时间计算
                bool save{false};

                if (dec_frame->pts != AV_NOPTS_VALUE) {
                    double currentTime = timeBase * dec_frame->pts;
                    if (lastTime == 0.0) {
                        lastTime = spacingTime;
                        save = true;
                    }
                    if (lastTime < currentTime) {
                        save = true;
                        lastTime += spacingTime;
                    }
                }

                if (save)
                // 解码帧转编码帧 转格式
                {
                    sws_scale(sws_ctx,
                              dec_frame->data,
                              dec_frame->linesize,
                              0,
                              dec_ctx->height,
                              enc_frame->data,
                              enc_frame->linesize);

                    if (avcodec_send_frame(enc_ctx, enc_frame) < 0) {
                        std::cerr << "发送帧到编码器失败\n";
                    }

                    while (avcodec_receive_packet(enc_ctx, enc_pkt) >= 0) {
                        QString filename = QString("%1frame%2.jpg").arg(outputPath).arg(frameCount);
                        frameCount++;

                        FILE *fd = fopen(filename.toStdString().c_str(), "wb");
                        if (!fd) {
                            std::cerr << "创建失败:" << filename.toStdString() << "\n";
                            continue;
                        }
                        fwrite(enc_pkt->data, 1, enc_pkt->size, fd);
                        fclose(fd);
                    }
                }
            }
        }
    }
    av_packet_unref(&pkt);
    av_packet_free(&enc_pkt);

    sws_freeContext(sws_ctx);
    av_frame_free(&dec_frame);
    av_frame_free(&enc_frame);
    avcodec_free_context(&dec_ctx);
    avcodec_free_context(&enc_ctx);
    avformat_close_input(&fmt_ctx);
    emit shotFinished((int) totaltime);
    //m_lock.unlock();
    std::cerr << "截图结束\n";
}
void VideoShot::shotThread(
    QUrl source, int num, QString outputPath)
{
    if (source.isEmpty()) {
        std::cerr << "输入文件为空\n";
        return;
    }
    if (outputPath.isEmpty()) {
        std::cerr << "输出位置为空\n";
        return;
    }
    if (num <= 0) {
        std::cerr << "指定数量不能小于等于0\n";
        return;
    }
    m_threads.emplace_back(std::thread(&VideoShot::shot, this, source, num, outputPath));
}

QString VideoShot::tmpPath()
{
    return QDir::tempPath();
}
