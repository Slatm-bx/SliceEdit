#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>
#include <QUrl>
#include <thread>

class VideoShot : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit VideoShot(QObject *parent = nullptr);
    ~VideoShot();

    Q_INVOKABLE void shotThread(QUrl source, int num, QString outputPath);

signals:
    void shotFinished();

private:
    void shot(QUrl source, int num = 3, QString outputPath = "/disk/F/project/Image/");
    std::thread m_thread;
};
