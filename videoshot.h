#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>
#include <QUrl>
#include <thread>
#include <vector>

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
    void shot(QUrl source, int num, QString outputPath);
    std::vector<std::thread> m_threads; //线程池
};
