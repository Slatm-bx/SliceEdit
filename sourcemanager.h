#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

class SourceManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    SourceManager();
    ~SourceManager();

private:
    QString m_outputPath;
};
