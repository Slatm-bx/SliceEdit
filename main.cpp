#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

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
    //engine.addImageProvider();

    engine.loadFromModule("Videoedit", "Main");

    return app.exec();
}
