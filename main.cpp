#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "worker.h"
int main(
    int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    Worker w{};
    engine.rootContext()->setContextProperty("Worker", &w);
    engine.loadFromModule("Videoedit", "Main");
    app.setWindowIcon(QIcon(":/icon/icons/SliceEdit.png"));
    if (QIcon(":/icon/icons/SliceEdit.png").isNull())
        qDebug() << "为空";

    return app.exec();
}
