#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
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

    return app.exec();
}
