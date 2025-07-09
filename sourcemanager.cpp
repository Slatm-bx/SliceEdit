#include "sourcemanager.h"
#include <QDir>
#include <iostream>

SourceManager::SourceManager()
{
    m_outputPath = QDir::tempPath() + "/SliceEdit/";
    QDir dir;
    if (!dir.exists(m_outputPath)) dir.mkdir(m_outputPath);
}

SourceManager::~SourceManager()
{
    std::cerr << "清除:" << m_outputPath.toStdString() << "\n";
    QDir dir(m_outputPath);
    if (dir.exists(m_outputPath)) {
        if (dir.removeRecursively())
            std::cerr << "缓存清除！\n";
        else
            std::cerr << "缓存清除失败\n";
    }
}
