#ifndef PRODUCTMANAGER_H
#define PRODUCTMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QTcpSocket>
#include <QAbstractSocket>

class ProductManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
        QVariantList products
        READ getProducts
        NOTIFY productsChanged
    )

    Q_PROPERTY(
        bool isConnected
        READ isConnected
        NOTIFY connectionChanged
    )

public:
    explicit ProductManager(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getProducts();

    bool isConnected() const;

    Q_INVOKABLE int addProduct(
        QString name,
        int volume,
        double mcap,
        double cr
    );

    Q_INVOKABLE bool updateProduct(
        int id,
        QString name,
        int volume,
        double mcap,
        double cr
    );

    Q_INVOKABLE void deleteProduct(int id);

    Q_INVOKABLE void saveProducts();

    Q_INVOKABLE void connectToServer();

    Q_INVOKABLE void disconnectFromServer();

    Q_INVOKABLE void sendProducts();

signals:

    void productsChanged();

    void connectionChanged(
        bool connected
    );

    void statusMessage(
        const QString &message,
        bool isError
    );

    void dataSent();

private slots:

    void onConnected();

    void onDisconnected();

    void onErrorOccurred(
        QAbstractSocket::SocketError socketError
    );

private:

    void setupDatabase();

    QTcpSocket *socket;
};

#endif // PRODUCTMANAGER_H
