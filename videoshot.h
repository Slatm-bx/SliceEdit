#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>
#include <QUrl>
#include <QtMultimedia/QMediaPlayer>
#include <QtMultimedia/QVideoSink>
#include <QImage>

class VideoShot : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(
        int spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)
    QML_ELEMENT
public:
    explicit VideoShot(QObject *parent = nullptr);

    QUrl source() const;
    void setSource(const QUrl source);

    int spacing() const;
    void setSpacing(const int spacing);

signals:
    void sourceChanged();
    void spacingChanged();

private:
    QUrl m_source;
    int m_spacing;
    QMediaPlayer *m_player;
    QVideoSink *m_sink;
};
