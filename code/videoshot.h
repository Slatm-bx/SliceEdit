//视频按时间截图

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>
#include <QUrl>
#include <thread>
#include <vector>
//#include <mutex>

class VideoShot : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit VideoShot(QObject *parent = nullptr);
    ~VideoShot();

    Q_INVOKABLE void shotThread(QUrl source, int num, QString outputPath);
    Q_INVOKABLE QString tmpPath();

signals:
    void shotFinished(int time);
    //void timeRead(int ms);

private:
    void shot(QUrl source, int num, QString outputPath);
    std::vector<std::thread> m_threads; //线程池
    //std::mutex m_lock;  不需要互斥锁
    QString m_outputPath;
};
