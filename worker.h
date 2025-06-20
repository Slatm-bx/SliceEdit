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
                                 QUrl outName); //QUrl inName, QUrl outName);
};
