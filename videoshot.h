#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>
#include <QUrl>
#include <string>

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h" //格式转换库
#include "libavutil/imgutils.h"
}

class VideoShot : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    QML_ELEMENT
public:
    explicit VideoShot(QObject *parent = nullptr);
    ~VideoShot();

    QUrl source() const;
    void setSource(const QUrl source);

    Q_INVOKABLE void shot(int num); //截图函数

signals:
    void sourceChanged();

private:
    QUrl m_source; //Qurl
    int m_num;
    int m_nowNum; //当前截图数量
    AVFormatContext *m_fmt_ctx = nullptr;
};
