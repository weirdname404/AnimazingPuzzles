#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ganalytics.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("AnimazingPuzzles");
    QGuiApplication::setApplicationVersion("0.1");
    QGuiApplication app(argc, argv);

    qmlRegisterType<GAnalytics>("analytics", 0, 1, "Tracker");
    QQmlApplicationEngine engine;

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("resPrefix", "assets:/");
#else
    engine.rootContext()->setContextProperty("resPrefix", "file:res/");
#endif

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
