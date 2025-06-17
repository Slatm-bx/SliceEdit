#include "videoshot.h"
#include <QtMultimedia/QMediaPlayer>
#include <QtMultimedia/QVideoFrame>
#include <QtMultimedia/QVideoSink>
#include <iostream>

VideoShot::VideoShot(
    QObject *parent)
    : QObject{parent}
    , m_player(new QMediaPlayer(this))
    , m_sink(new QVideoSink(this))

{
    m_spacing = 0;

    m_player->setVideoSink(m_sink);
}

QUrl VideoShot::source() const
{
    return m_source;
}

void VideoShot::setSource(
    const QUrl source)
{
    m_source = source;
    emit sourceChanged();
    m_player->setSource(source);
}

int VideoShot::spacing() const
{
    return m_spacing;
}

void VideoShot::setSpacing(
    const int spacing)
{
    m_spacing = spacing;
    emit spacingChanged();
    std::cerr << "spacing:" << spacing << "\n";

    if (!m_source.isEmpty()) {
        m_player->setPosition(m_spacing);
        m_player->play();
        QVideoFrame frame = m_sink->videoFrame();
        if (frame.isValid())
            std::cerr << "frame有效\n";
        else
            std::cerr << "frame无效\n";
        if (frame.map(QVideoFrame::ReadOnly)) {
            QImage image = frame.toImage();
            image.save("/disk/F/project/Image/output.jpg", "JPEG", 90);
            std::cerr << "/disk/F/project/Image/output.jpg\n";

            frame.unmap();
        } else {
            std::cerr << "frame map失败\n";
        }
        m_player->pause();
    }
}

// QImage VideoShot::image() const
// {
//     if (m_source.isEmpty())
//         return QImage();
//     m_player->setPosition(m_spacing);
//     QVideoFrame frame = m_sink->videoFrame();
//     return frame.toImage();
// }
