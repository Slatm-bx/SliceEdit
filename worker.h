#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QString>

class Worker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit Worker(QObject *parent = nullptr);

public slots:
    Q_INVOKABLE void cutOneVideo(double startime,
                                 double endtime,
                                 QUrl inName,
                                 QString outfileName); //QUrl inName, QUrl outName);

    Q_INVOKABLE void saveAllVideos(const QVariantList &startTimes,
                                   const QVariantList &endTimes,
                                   QUrl inName,
                                   QString outName);
    Q_INVOKABLE bool isSaveAllVideo(const std::string &output_filename, const std::vector<std::string> &input_files);
};
