#include "productmanager.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>
#include <QVariantMap>
#include <QDateTime>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStringList>

#include<QHostAddress>


ProductManager::ProductManager(QObject *parent)
    : QObject(parent),
      socket(new QTcpSocket(this))
{
    // ============================================================
    // TCP SOCKET SIGNALS
    // ============================================================

    connect(socket,
            &QTcpSocket::connected,
            this,
            &ProductManager::onConnected);

    connect(socket,
            &QTcpSocket::disconnected,
            this,
            &ProductManager::onDisconnected);

#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)

    connect(socket,
            &QTcpSocket::errorOccurred,
            this,
            &ProductManager::onErrorOccurred);

#else

    connect(socket,
            QOverload<QAbstractSocket::SocketError>::of(
                &QTcpSocket::error),
            this,
            &ProductManager::onErrorOccurred);

#endif


    // ============================================================
    // SERVER RESPONSE
    //
    // Server sends:
    //
    // TRANSFER_RESULT:OK:5
    //
    // Only after receiving this response do we emit dataSent().
    // ============================================================

    connect(socket,
            &QTcpSocket::readyRead,
            this,
            [this]()
            {
                if (!socket)
                    return;

                QByteArray response = socket->readAll();

                if (response.isEmpty())
                    return;

                qDebug() << "";
                qDebug() << "========================================";
                qDebug() << "SERVER RESPONSE";
                qDebug() << "========================================";

                qDebug() << response;

                QString responseText =
                        QString::fromUtf8(response).trimmed();

                qDebug() << "SERVER RESPONSE TEXT:"
                         << responseText;


                // ====================================================
                // SERVER TRANSFER SUCCESS
                // ====================================================

                if (responseText.startsWith(
                            "TRANSFER_RESULT:OK:"))
                {
                    QStringList parts =
                            responseText.split(":");

                    int count = 0;

                    if (parts.size() >= 3)
                    {
                        count =
                                parts.at(2).toInt();
                    }


                    qDebug() << "";
                    qDebug() << "========================================";
                    qDebug() << "SERVER CONFIRMED TRANSFER";
                    qDebug() << "PRODUCT COUNT:"
                             << count;
                    qDebug() << "========================================";


                    emit statusMessage(
                                QString("%1 product(s) received by server.")
                                .arg(count),
                                false
                                );


                    // IMPORTANT:
                    // Data Sent signal is emitted only after
                    // server confirmation.

                    emit dataSent();
                }
                else
                {
                    qDebug() << "";
                    qDebug() << "========================================";
                    qDebug() << "UNEXPECTED SERVER RESPONSE";
                    qDebug() << "========================================";

                    qDebug() << responseText;


                    emit statusMessage(
                                "Server response was not successful.",
                                true
                                );
                }
            });


    // ============================================================
    // DATABASE SETUP
    // ============================================================

    setupDatabase();
}


// ================================================================
// IS CONNECTED
// ================================================================

bool ProductManager::isConnected() const
{
    return socket &&
           socket->state() ==
           QAbstractSocket::ConnectedState;
}


// ================================================================
// DATABASE SETUP
// ================================================================

void ProductManager::setupDatabase()
{
    QSqlDatabase db;

    if (QSqlDatabase::contains("products_connection"))
    {
        db =
                QSqlDatabase::database(
                    "products_connection");
    }
    else
    {
        db =
                QSqlDatabase::addDatabase(
                    "QSQLITE",
                    "products_connection");

        db.setDatabaseName(
                    "productsDB.db");
    }


    if (!db.isOpen())
    {
        if (!db.open())
        {
            qDebug() << "Database open error:"
                     << db.lastError().text();

            return;
        }

        qDebug() << "Database opened successfully.";
    }


    // ============================================================
    // CREATE TABLE
    // ============================================================

    QSqlQuery query(db);

    bool success =
            query.exec(
                "CREATE TABLE IF NOT EXISTS products ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "productName TEXT UNIQUE,"
                "volume INTEGER,"
                "marketCap REAL,"
                "creditRating REAL,"
                "createdAt TEXT,"
                "updatedAt TEXT,"
                "savedAt TEXT"
                ")"
                );


    if (!success)
    {
        qDebug() << "Table creation error:"
                 << query.lastError().text();
    }


    // ============================================================
    // ADD MISSING COLUMNS FOR OLD DATABASE
    // ============================================================

    query.exec(
                "ALTER TABLE products "
                "ADD COLUMN createdAt TEXT"
                );

    query.exec(
                "ALTER TABLE products "
                "ADD COLUMN updatedAt TEXT"
                );

    query.exec(
                "ALTER TABLE products "
                "ADD COLUMN savedAt TEXT"
                );


    // ============================================================
    // FIX EMPTY CREATED / UPDATED / SAVED TIMES
    // ============================================================

    QString currentTime =
            QDateTime::currentDateTime()
            .toString("yyyy-MM-dd HH:mm:ss");


    query.prepare(
                "UPDATE products "
                "SET createdAt = ? "
                "WHERE createdAt IS NULL "
                "OR createdAt = ''"
                );

    query.addBindValue(currentTime);
    query.exec();


    query.prepare(
                "UPDATE products "
                "SET updatedAt = createdAt "
                "WHERE updatedAt IS NULL "
                "OR updatedAt = ''"
                );

    query.exec();


    query.prepare(
                "UPDATE products "
                "SET savedAt = updatedAt "
                "WHERE savedAt IS NULL "
                "OR savedAt = ''"
                );

    query.exec();


    qDebug() << "Database setup completed.";
}


// ================================================================
// GET PRODUCTS
// ================================================================

QVariantList ProductManager::getProducts()
{
    QVariantList list;


    QSqlDatabase db =
            QSqlDatabase::database(
                "products_connection");


    if (!db.isOpen())
    {
        qDebug() << "Database is not open.";

        return list;
    }


    QSqlQuery query(db);


    if (!query.exec(
                "SELECT "
                "id, "
                "productName, "
                "volume, "
                "marketCap, "
                "creditRating, "
                "createdAt, "
                "updatedAt, "
                "savedAt "
                "FROM products "
                "ORDER BY id"
                ))
    {
        qDebug() << "SELECT error:"
                 << query.lastError().text();

        return list;
    }


    while (query.next())
    {
        QVariantMap product;


        product["id"] =
                query.value("id");

        product["productName"] =
                query.value("productName");

        product["volume"] =
                query.value("volume");

        product["marketCapital"] =
                query.value("marketCap");

        product["creditRating"] =
                query.value("creditRating");

        product["createdAt"] =
                query.value("createdAt");

        product["updatedAt"] =
                query.value("updatedAt");

        product["savedAt"] =
                query.value("savedAt");


        list.append(product);
    }


    return list;
}


// ================================================================
// ADD PRODUCT
// ================================================================

int ProductManager::addProduct(
        QString name,
        int volume,
        double mcap,
        double cr)
{
    QSqlDatabase db =
            QSqlDatabase::database(
                "products_connection");


    if (!db.isOpen())
    {
        qDebug() << "Database is not open.";

        return -1;
    }


    QSqlQuery query(db);


    QString currentTime =
            QDateTime::currentDateTime()
            .toString("yyyy-MM-dd HH:mm:ss");


    query.prepare(
                "INSERT INTO products "
                "(productName, volume, marketCap, "
                "creditRating, createdAt, updatedAt, savedAt) "
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
                );


    query.addBindValue(name);
    query.addBindValue(volume);
    query.addBindValue(mcap);
    query.addBindValue(cr);
    query.addBindValue(currentTime);
    query.addBindValue(currentTime);
    query.addBindValue(currentTime);


    if (!query.exec())
    {
        qDebug() << "ADD PRODUCT ERROR:"
                 << query.lastError().text();

        return -1;
    }


    emit productsChanged();


    return query.lastInsertId().toInt();
}


// ================================================================
// UPDATE PRODUCT
// ================================================================

bool ProductManager::updateProduct(
        int id,
        QString name,
        int volume,
        double mcap,
        double cr)
{
    QSqlDatabase db =
            QSqlDatabase::database(
                "products_connection");


    if (!db.isOpen())
    {
        qDebug() << "Database is not open.";

        return false;
    }


    QSqlQuery query(db);


    QString currentTime =
            QDateTime::currentDateTime()
            .toString("yyyy-MM-dd HH:mm:ss");


    query.prepare(
                "UPDATE products "
                "SET productName = ?, "
                "volume = ?, "
                "marketCap = ?, "
                "creditRating = ?, "
                "updatedAt = ? "
                "WHERE id = ?"
                );


    query.addBindValue(name);
    query.addBindValue(volume);
    query.addBindValue(mcap);
    query.addBindValue(cr);
    query.addBindValue(currentTime);
    query.addBindValue(id);


    if (!query.exec())
    {
        qDebug() << "UPDATE PRODUCT ERROR:"
                 << query.lastError().text();

        return false;
    }


    emit productsChanged();


    return true;
}


// ================================================================
// DELETE PRODUCT
// ================================================================

void ProductManager::deleteProduct(int id)
{
    QSqlDatabase db =
            QSqlDatabase::database(
                "products_connection");


    if (!db.isOpen())
    {
        qDebug() << "Database is not open.";

        return;
    }


    QSqlQuery query(db);


    query.prepare(
                "DELETE FROM products "
                "WHERE id = ?"
                );


    query.addBindValue(id);


    if (!query.exec())
    {
        qDebug() << "DELETE PRODUCT ERROR:"
                 << query.lastError().text();

        return;
    }


    emit productsChanged();
}


// ================================================================
// SAVE PRODUCTS
// ================================================================

void ProductManager::saveProducts()
{
    QSqlDatabase db =
            QSqlDatabase::database(
                "products_connection");


    if (!db.isOpen())
    {
        qDebug() << "Database is not open.";

        return;
    }


    QSqlQuery query(db);


    QString currentTime =
            QDateTime::currentDateTime()
            .toString("yyyy-MM-dd HH:mm:ss");


    query.prepare(
                "UPDATE products "
                "SET savedAt = ?"
                );


    query.addBindValue(currentTime);


    if (!query.exec())
    {
        qDebug() << "SAVE PRODUCTS ERROR:"
                 << query.lastError().text();

        return;
    }


    qDebug() << "Products saved successfully.";


    emit productsChanged();
}


// ================================================================
// CONNECT TO SERVER
// ================================================================

void ProductManager::connectToServer()
{
    if (!socket)
        return;


    // Already connected
    if (socket->state() ==
            QAbstractSocket::ConnectedState)
    {
        qDebug() << "Already connected to server.";

        emit statusMessage(
                    "Already connected to server.",
                    false
                    );

        return;
    }


    const QString SERVER_IP =
            "127.0.0.1";

    const quint16 SERVER_PORT =
            12345;


    qDebug() << "";
    qDebug() << "====================================";
    qDebug() << "CONNECTING TO SERVER";
    qDebug() << "SERVER IP   :" << SERVER_IP;
    qDebug() << "SERVER PORT :" << SERVER_PORT;
    qDebug() << "====================================";


    socket->connectToHost(
                SERVER_IP,
                SERVER_PORT
                );
}


// ================================================================
// DISCONNECT FROM SERVER
// ================================================================

void ProductManager::disconnectFromServer()
{
    if (!socket)
        return;


    if (socket->state() !=
            QAbstractSocket::UnconnectedState)
    {
        socket->disconnectFromHost();
    }
}


// ================================================================
// SEND PRODUCTS
// ================================================================

void ProductManager::sendProducts()
{
    qDebug() << "";
    qDebug() << "========================================";
    qDebug() << "SEND PRODUCTS STARTED";
    qDebug() << "========================================";


    // ============================================================
    // CHECK SOCKET
    // ============================================================

    if (!socket)
    {
        qDebug() << "Socket is NULL.";

        emit statusMessage(
                    "Socket is not available.",
                    true
                    );

        return;
    }


    if (socket->state() !=
            QAbstractSocket::ConnectedState)
    {
        qDebug() << "Client is NOT connected.";

        emit statusMessage(
                    "Please connect to server first.",
                    true
                    );

        return;
    }


    qDebug() << "Client is connected.";


    // ============================================================
    // GET PRODUCTS FROM DATABASE
    // ============================================================

    QVariantList products =
            getProducts();


    qDebug() << "Number of products:"
             << products.size();


    if (products.isEmpty())
    {
        qDebug() << "No products available.";

        emit statusMessage(
                    "No products available to send.",
                    true
                    );

        return;
    }


    // ============================================================
    // CREATE JSON ARRAY
    // ============================================================

    QJsonArray productArray;


    for (const QVariant &value : products)
    {
        QVariantMap product =
                value.toMap();


        QJsonObject obj;


        obj["id"] =
                QJsonValue::fromVariant(
                    product.value("id")
                    );


        obj["productName"] =
                QJsonValue::fromVariant(
                    product.value("productName")
                    );


        obj["volume"] =
                QJsonValue::fromVariant(
                    product.value("volume")
                    );


        obj["marketCapital"] =
                QJsonValue::fromVariant(
                    product.value("marketCapital")
                    );


        obj["creditRating"] =
                QJsonValue::fromVariant(
                    product.value("creditRating")
                    );


        obj["createdAt"] =
                QJsonValue::fromVariant(
                    product.value("createdAt")
                    );


        obj["updatedAt"] =
                QJsonValue::fromVariant(
                    product.value("updatedAt")
                    );


        obj["savedAt"] =
                QJsonValue::fromVariant(
                    product.value("savedAt")
                    );


        productArray.append(obj);


        // ========================================================
        // DEBUG OUTPUT
        // ========================================================

        qDebug() << "--------------------------------";
        qDebug() << "Product:";
        qDebug() << "ID:"
                 << obj["id"];

        qDebug() << "Product Name:"
                 << obj["productName"];

        qDebug() << "Volume:"
                 << obj["volume"];

        qDebug() << "Market Capital:"
                 << obj["marketCapital"];

        qDebug() << "Credit Rating:"
                 << obj["creditRating"];

        qDebug() << "Created At:"
                 << obj["createdAt"];

        qDebug() << "Updated At:"
                 << obj["updatedAt"];

        qDebug() << "Saved At:"
                 << obj["savedAt"];
    }


    // ============================================================
    // CONVERT JSON TO BYTE ARRAY
    // ============================================================

    QJsonDocument document(productArray);


    QByteArray data =
            document.toJson(
                QJsonDocument::Compact
                );


    // Server expects newline-terminated JSON.
    data.append('\n');


    qDebug() << "";
    qDebug() << "========================================";
    qDebug() << "JSON DATA TO SERVER";
    qDebug() << "========================================";

    qDebug() << QString::fromUtf8(data);

    qDebug() << "JSON bytes:"
             << data.size();


    // ============================================================
    // SEND DATA
    // ============================================================

    qint64 bytesWritten =
            socket->write(data);


    qDebug() << "socket->write() returned:"
             << bytesWritten;


    // ============================================================
    // CHECK ONLY FOR ACTUAL WRITE FAILURE
    //
    // We DO NOT use waitForBytesWritten().
    // The server is already confirming the transfer.
    // ============================================================

    if (bytesWritten == -1)
    {
        qDebug() << "SEND ERROR:"
                 << socket->errorString();


        emit statusMessage(
                    "Failed to send data to server.",
                    true
                    );


        return;
    }


    // ============================================================
    // FLUSH DATA
    // ============================================================

    socket->flush();


    qDebug() << "Data successfully queued for sending.";


    // ============================================================
    // IMPORTANT
    //
    // DO NOT emit dataSent() here.
    //
    // We wait for:
    //
    // TRANSFER_RESULT:OK:5
    //
    // The readyRead() handler above will receive the server
    // confirmation and emit dataSent().
    // ============================================================

    emit statusMessage(
                QString("%1 product(s) sent. "
                        "Waiting for server confirmation...")
                .arg(productArray.size()),
                false
                );
}


// ================================================================
// TCP CONNECTED
// ================================================================

void ProductManager::onConnected()
{
    qDebug() << "";
    qDebug() << "========================================";
    qDebug() << "CONNECTED TO TCP SERVER";
    qDebug() << "========================================";


    if (socket)
    {
        qDebug() << "Server address:"
                 << socket->peerAddress().toString();

        qDebug() << "Server port:"
                 << socket->peerPort();
    }


    emit connectionChanged(true);


    emit statusMessage(
                "Connected to TCP server.",
                false
                );
}


// ================================================================
// TCP DISCONNECTED
// ================================================================

void ProductManager::onDisconnected()
{
    qDebug() << "";
    qDebug() << "========================================";
    qDebug() << "DISCONNECTED FROM TCP SERVER";
    qDebug() << "========================================";


    emit connectionChanged(false);


    emit statusMessage(
                "Disconnected from TCP server.",
                true
                );
}


// ================================================================
// TCP ERROR
// ================================================================

void ProductManager::onErrorOccurred(
        QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError);


    qDebug() << "";
    qDebug() << "========================================";
    qDebug() << "TCP SOCKET ERROR";
    qDebug() << "========================================";


    if (socket)
    {
        qDebug() << "Error:"
                 << socket->errorString();
    }


    emit connectionChanged(false);


    if (socket)
    {
        emit statusMessage(
                    socket->errorString(),
                    true
                    );
    }
}
