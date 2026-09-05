#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "productmanager.h" // Include your ProductManager header

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // 1. Instantiate ProductManager
    ProductManager productManager;

    // 2. Register ProductManager object as a context property for QML
    // This makes 'productManager' accessible globally inside main.qml
    engine.rootContext()->setContextProperty("productManager", &productManager);

    // 3. Load the main QML file
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
