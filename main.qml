import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {

    id: window

    width: 1100
    height: 650
    visible: true

    title: "PRODUCT MANAGER"

    color: "#f2f5f9"


    // =========================================================
    // PROPERTIES
    // =========================================================

    property int selectedIndex: -1

    // TRUE only when a row is double-clicked
    property bool updateMode: false


    // =========================================================
    // PRODUCT MODEL
    // =========================================================

    ListModel {
        id: productListModel
    }


    // =========================================================
    // CLOCK
    // =========================================================

    Timer {

        id: clockTimer

        interval: 1000

        running: true

        repeat: true

        onTriggered: {

            clockLabel.text =
                    Qt.formatDateTime(
                        new Date(),
                        "dd-MM-yyyy hh:mm:ss AP"
                    )
        }
    }


    // =========================================================
    // MESSAGE DIALOG
    // =========================================================

    Dialog {

        id: messageDialog

        property string dialogTitle: "Message"

        title: dialogTitle

        modal: true

        standardButtons: Dialog.Ok

        anchors.centerIn: parent

        width: 350

        height: 180


        Label {

            id: messageDialogText

            anchors.centerIn: parent

            width: parent.width - 40

            text: ""

            font.pixelSize: 15

            horizontalAlignment:
                    Text.AlignHCenter

            verticalAlignment:
                    Text.AlignVCenter

            wrapMode:
                    Text.WordWrap
        }
    }


    // =========================================================
    // SAVE DIALOG
    // =========================================================

    Dialog {

        id: saveDialog

        title: "Save Status"

        modal: true

        standardButtons: Dialog.Ok

        anchors.centerIn: parent

        width: 350

        height: 180


        Label {

            id: saveDialogText

            anchors.centerIn: parent

            width: parent.width - 40

            text: ""

            font.pixelSize: 15

            horizontalAlignment:
                    Text.AlignHCenter

            verticalAlignment:
                    Text.AlignVCenter

            wrapMode:
                    Text.WordWrap
        }
    }


    // =========================================================
    // MAIN LAYOUT
    // =========================================================

    ColumnLayout {

        anchors.fill: parent

        anchors.margins: 15

        spacing: 8


        // =====================================================
        // HEADER
        // =====================================================

        Rectangle {

            Layout.fillWidth: true

            Layout.preferredHeight: 60

            color: "#263238"

            radius: 8


            Label {

                anchors.left:
                        parent.left

                anchors.leftMargin:
                        20

                anchors.verticalCenter:
                        parent.verticalCenter

                text:
                        "PRODUCT MANAGER"

                color:
                        "white"

                font.pixelSize:
                        22

                font.bold:
                        true
            }


            Label {

                id: clockLabel

                anchors.right:
                        parent.right

                anchors.rightMargin:
                        20

                anchors.verticalCenter:
                        parent.verticalCenter

                color:
                        "white"

                font.pixelSize:
                        15

                text:
                    Qt.formatDateTime(
                        new Date(),
                        "dd-MM-yyyy hh:mm:ss AP"
                    )
            }
        }


        // =====================================================
        // INPUT FIELDS
        // =====================================================

        Rectangle {

            Layout.fillWidth:
                    true

            Layout.preferredHeight:
                    55

            color:
                    "#f2f5f9"


            RowLayout {

                anchors.fill:
                        parent

                spacing:
                        8


                // =================================================
                // PRODUCT NAME
                // =================================================

                TextField {

                    id: productName

                    Layout.fillWidth:
                            true

                    Layout.preferredHeight:
                            42

                    placeholderText:
                            "Product Name"

                    selectByMouse:
                            true

                    enabled:
                            true

                    font.pixelSize:
                            14


                    background: Rectangle {

                        color:
                                "white"

                        border.color:
                                productName.activeFocus
                                ? "#2196F3"
                                : "#90a4ae"

                        border.width:
                                productName.activeFocus
                                ? 2
                                : 1

                        radius:
                                4
                    }
                }


                // =================================================
                // VOLUME
                // =================================================

                TextField {

                    id: volume

                    Layout.preferredWidth:
                            180

                    Layout.preferredHeight:
                            42

                    placeholderText:
                            "Volume"

                    selectByMouse:
                            true

                    enabled:
                            true

                    font.pixelSize:
                            14


                    validator:

                        IntValidator {

                            bottom:
                                    0

                            top:
                                    999999999
                        }


                    background: Rectangle {

                        color:
                                "white"

                        border.color:
                                volume.activeFocus
                                ? "#2196F3"
                                : "#90a4ae"

                        border.width:
                                volume.activeFocus
                                ? 2
                                : 1

                        radius:
                                4
                    }
                }


                // =================================================
                // MARKET CAPITAL
                // =================================================

                TextField {

                    id: marketCapital

                    Layout.preferredWidth:
                            200

                    Layout.preferredHeight:
                            42

                    placeholderText:
                            "Market Capital"

                    selectByMouse:
                            true

                    enabled:
                            true

                    font.pixelSize:
                            14


                    validator:

                        DoubleValidator {

                            bottom:
                                    0

                            top:
                                    999999999999

                            decimals:
                                    2
                        }


                    background: Rectangle {

                        color:
                                "white"

                        border.color:
                                marketCapital.activeFocus
                                ? "#2196F3"
                                : "#90a4ae"

                        border.width:
                                marketCapital.activeFocus
                                ? 2
                                : 1

                        radius:
                                4
                    }
                }


                // =================================================
                // CREDIT RATING
                // =================================================

                TextField {

                    id: creditRating

                    Layout.preferredWidth:
                            180

                    Layout.preferredHeight:
                            42

                    placeholderText:
                            "Credit Rating"

                    selectByMouse:
                            true

                    enabled:
                            true

                    font.pixelSize:
                            14


                    validator:

                        DoubleValidator {

                            bottom:
                                    0

                            top:
                                    999.99

                            decimals:
                                    2
                        }


                    background: Rectangle {

                        color:
                                "white"

                        border.color:
                                creditRating.activeFocus
                                ? "#2196F3"
                                : "#90a4ae"

                        border.width:
                                creditRating.activeFocus
                                ? 2
                                : 1

                        radius:
                                4
                    }
                }
            }
        }


        // =====================================================
        // BUTTONS
        // =====================================================

        RowLayout {

            Layout.fillWidth:
                    true

            Layout.preferredHeight:
                    45

            spacing:
                    8


            // =================================================
            // ADD
            // =================================================

            Button {

                id: addButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Add"

                enabled:
                        !window.updateMode


                onClicked: {

                    // -----------------------------------------
                    // CHECK FIELDS
                    // -----------------------------------------

                    if (
                        productName.text.trim() === "" ||
                        volume.text.trim() === "" ||
                        marketCapital.text.trim() === "" ||
                        creditRating.text.trim() === ""
                    ) {

                        statusLabel.text =
                                "Please fill all fields!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // GET VALUES
                    // -----------------------------------------

                    var nameValue =
                            productName.text.trim()

                    var volumeValue =
                            parseInt(volume.text)

                    var marketValue =
                            parseFloat(
                                marketCapital.text
                            )

                    var ratingValue =
                            parseFloat(
                                creditRating.text
                            )


                    // -----------------------------------------
                    // CHECK VALUES
                    // -----------------------------------------

                    if (
                        isNaN(volumeValue) ||
                        isNaN(marketValue) ||
                        isNaN(ratingValue)
                    ) {

                        statusLabel.text =
                                "Please enter valid numbers!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // ADD TO DATABASE
                    // -----------------------------------------

                    var newId =
                            productManager.addProduct(
                                nameValue,
                                volumeValue,
                                marketValue,
                                ratingValue
                            )


                    if (newId < 0) {

                        statusLabel.text =
                                "Failed to add product"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // TIME
                    // -----------------------------------------

                    var currentTime =
                            Qt.formatDateTime(
                                new Date(),
                                "yyyy-MM-dd HH:mm:ss"
                            )


                    // -----------------------------------------
                    // ADD TO TABLE
                    // -----------------------------------------

                    productListModel.append({

                        id:
                            newId,

                        name:
                            nameValue,

                        volume:
                            volumeValue,

                        mcap:
                            marketValue,

                        cr:
                            ratingValue,

                        createdAt:
                            currentTime,

                        updatedAt:
                            currentTime,

                        savedAt:
                            ""
                    })


                    // -----------------------------------------
                    // CLEAR FIELDS
                    // -----------------------------------------

                    clearInputs()


                    // -----------------------------------------
                    // MESSAGE
                    // -----------------------------------------

                    statusLabel.text =
                            "Product added successfully!"

                    statusLabel.color =
                            "#4CAF50"
                }
            }


            // =================================================
            // UPDATE
            // =================================================

            Button {

                id: updateButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Update"

                enabled:
                        window.updateMode


                onClicked: {

                    // -----------------------------------------
                    // CHECK UPDATE MODE
                    // -----------------------------------------

                    if (!window.updateMode) {

                        statusLabel.text =
                                "Please double-click a row first!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // CHECK SELECTED ROW
                    // -----------------------------------------

                    if (
                        window.selectedIndex < 0 ||
                        window.selectedIndex >=
                        productListModel.count
                    ) {

                        statusLabel.text =
                                "Please double-click a row first!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // CHECK FIELDS
                    // -----------------------------------------

                    if (
                        productName.text.trim() === "" ||
                        volume.text.trim() === "" ||
                        marketCapital.text.trim() === "" ||
                        creditRating.text.trim() === ""
                    ) {

                        statusLabel.text =
                                "Please fill all fields!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // GET SELECTED PRODUCT
                    // -----------------------------------------

                    var selectedProduct =
                            productListModel.get(
                                window.selectedIndex
                            )

                    var id =
                            selectedProduct.id


                    // -----------------------------------------
                    // GET NEW VALUES
                    // -----------------------------------------

                    var nameValue =
                            productName.text.trim()

                    var volumeValue =
                            parseInt(volume.text)

                    var marketValue =
                            parseFloat(
                                marketCapital.text
                            )

                    var ratingValue =
                            parseFloat(
                                creditRating.text
                            )


                    // -----------------------------------------
                    // VALIDATE
                    // -----------------------------------------

                    if (
                        isNaN(volumeValue) ||
                        isNaN(marketValue) ||
                        isNaN(ratingValue)
                    ) {

                        statusLabel.text =
                                "Please enter valid numbers!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // UPDATE DATABASE
                    // -----------------------------------------

                    var success =
                            productManager.updateProduct(
                                id,
                                nameValue,
                                volumeValue,
                                marketValue,
                                ratingValue
                            )


                    if (success === false) {

                        statusLabel.text =
                                "Update failed!"

                        statusLabel.color =
                                "red"

                        return
                    }


                    // -----------------------------------------
                    // UPDATE TIME
                    // -----------------------------------------

                    var updateTime =
                            Qt.formatDateTime(
                                new Date(),
                                "yyyy-MM-dd HH:mm:ss"
                            )


                    // -----------------------------------------
                    // UPDATE TABLE MODEL
                    // -----------------------------------------

                    productListModel.setProperty(
                        window.selectedIndex,
                        "name",
                        nameValue
                    )

                    productListModel.setProperty(
                        window.selectedIndex,
                        "volume",
                        volumeValue
                    )

                    productListModel.setProperty(
                        window.selectedIndex,
                        "mcap",
                        marketValue
                    )

                    productListModel.setProperty(
                        window.selectedIndex,
                        "cr",
                        ratingValue
                    )

                    productListModel.setProperty(
                        window.selectedIndex,
                        "updatedAt",
                        updateTime
                    )


                    // -----------------------------------------
                    // EXIT UPDATE MODE
                    // -----------------------------------------

                    window.updateMode =
                            false


                    // -----------------------------------------
                    // SUCCESS
                    // -----------------------------------------

                    statusLabel.text =
                            "Product updated successfully!"

                    statusLabel.color =
                            "#4CAF50"


                    messageDialog.dialogTitle =
                            "Update Successful"

                    messageDialogText.text =
                            "Product updated successfully!"

                    messageDialog.open()
                }
            }


            // =================================================
            // SHOW
            // =================================================

            Button {

                id: showButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Show"

                enabled:
                        !window.updateMode


                onClicked: {

                    loadDataFromDb()
                }
            }


            // =================================================
            // SAVE
            // =================================================

            Button {

                id: saveButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Save"

                enabled:
                        !window.updateMode


                onClicked: {

                    var data =
                            productManager.getProducts()


                    if (
                        data === undefined ||
                        data === null ||
                        data.length === 0
                    ) {

                        saveDialogText.text =
                                "No products found!"

                        saveDialog.open()

                        return
                    }


                    productManager.saveProducts()


                    loadDataFromDb()


                    saveDialogText.text =
                            "Data saved successfully!"

                    saveDialog.open()


                    statusLabel.text =
                            "Data saved successfully!"

                    statusLabel.color =
                            "#4CAF50"
                }
            }


            // =================================================
            // CONNECT
            // =================================================

            Button {

                id: connectButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Connect"

                enabled:
                        !window.updateMode


                onClicked: {

                    productManager.connectToServer()


                    statusLabel.text =
                            "Connecting..."

                    statusLabel.color =
                            "orange"
                }
            }


            // =================================================
            // SEND
            // =================================================

            Button {

                id: sendButton

                Layout.preferredWidth:
                        100

                Layout.preferredHeight:
                        40

                text:
                        "Send"

                enabled:
                        !window.updateMode


                onClicked: {
                     console.log("========== SEND BUTTON CLICKED ==========")

                    productManager.sendProducts()
                }
            }


            // =================================================
            // STATUS
            // =================================================

            Label {

                id: statusLabel

                Layout.fillWidth:
                        true

                text:
                        "Ready - Enter product details"

                color:
                        "gray"

                font.bold:
                        true

                verticalAlignment:
                        Text.AlignVCenter
            }
        }


        // =====================================================
        // TABLE HEADER
        // =====================================================

        Rectangle {

            Layout.fillWidth:
                    true

            Layout.preferredHeight:
                    40

            color:
                    "#37474f"

            radius:
                    4


            Row {

                anchors.fill:
                        parent


                Text {

                    width:
                            220

                    height:
                            parent.height

                    text:
                            "PRODUCT NAME"

                    color:
                            "white"

                    font.bold:
                            true

                    horizontalAlignment:
                            Text.AlignHCenter

                    verticalAlignment:
                            Text.AlignVCenter
                }


                Text {

                    width:
                            130

                    height:
                            parent.height

                    text:
                            "VOLUME"

                    color:
                            "white"

                    font.bold:
                            true

                    horizontalAlignment:
                            Text.AlignHCenter

                    verticalAlignment:
                            Text.AlignVCenter
                }


                Text {

                    width:
                            170

                    height:
                            parent.height

                    text:
                            "MARKET CAPITAL"

                    color:
                            "white"

                    font.bold:
                            true

                    horizontalAlignment:
                            Text.AlignHCenter

                    verticalAlignment:
                            Text.AlignVCenter
                }


                Text {

                    width:
                            150

                    height:
                            parent.height

                    text:
                            "CREDIT RATING"

                    color:
                            "white"

                    font.bold:
                            true

                    horizontalAlignment:
                            Text.AlignHCenter

                    verticalAlignment:
                            Text.AlignVCenter
                }


                Text {

                    width:
                            250

                    height:
                            parent.height

                    text:
                            "DATE & TIME"

                    color:
                            "white"

                    font.bold:
                            true

                    horizontalAlignment:
                            Text.AlignHCenter

                    verticalAlignment:
                            Text.AlignVCenter
                }
            }
        }


        // =====================================================
        // PRODUCT TABLE
        // =====================================================

        ListView {

            id:
                productList

            Layout.fillWidth:
                    true

            Layout.fillHeight:
                    true

            clip:
                    true

            model:
                    productListModel


            delegate: Rectangle {

                width:
                        productList.width

                height:
                        45


                // =================================================
                // ROW COLOR
                // =================================================

                color:

                    window.selectedIndex === index

                    ? "#bbdefb"

                    : (
                        index % 2 === 0
                        ? "white"
                        : "#e8eaf0"
                    )


                border.color:

                    window.selectedIndex === index

                    ? "#2196F3"

                    : "#dddddd"


                // =================================================
                // ROW DATA
                // =================================================

                Row {

                    anchors.fill:
                            parent


                    // PRODUCT NAME
                    Text {

                        width:
                                220

                        height:
                                parent.height

                        text:

                            model.name !== undefined &&
                            model.name !== null

                            ? String(model.name)

                            : ""

                        horizontalAlignment:
                                Text.AlignHCenter

                        verticalAlignment:
                                Text.AlignVCenter

                        elide:
                                Text.ElideRight
                    }


                    // VOLUME
                    Text {

                        width:
                                130

                        height:
                                parent.height

                        text:

                            model.volume !== undefined &&
                            model.volume !== null

                            ? String(model.volume)

                            : ""

                        horizontalAlignment:
                                Text.AlignHCenter

                        verticalAlignment:
                                Text.AlignVCenter
                    }


                    // MARKET CAPITAL
                    Text {

                        width:
                                170

                        height:
                                parent.height

                        text:

                            model.mcap !== undefined &&
                            model.mcap !== null

                            ? Number(
                                model.mcap
                            ).toFixed(2)

                            : ""

                        horizontalAlignment:
                                Text.AlignHCenter

                        verticalAlignment:
                                Text.AlignVCenter
                    }


                    // CREDIT RATING
                    Text {

                        width:
                                150

                        height:
                                parent.height

                        text:

                            model.cr !== undefined &&
                            model.cr !== null

                            ? Number(
                                model.cr
                            ).toFixed(2)

                            : ""

                        horizontalAlignment:
                                Text.AlignHCenter

                        verticalAlignment:
                                Text.AlignVCenter
                    }


                    // DATE & TIME
                    Text {

                        width:
                                250

                        height:
                                parent.height

                        text:

                            model.savedAt !== undefined &&
                            model.savedAt !== ""

                            ? model.savedAt

                            : (

                                model.updatedAt !== undefined &&
                                model.updatedAt !== ""

                                ? model.updatedAt

                                : model.createdAt
                            )

                        horizontalAlignment:
                                Text.AlignHCenter

                        verticalAlignment:
                                Text.AlignVCenter

                        font.pixelSize:
                                12
                    }
                }


                // =================================================
                // MOUSE AREA
                // =================================================

                MouseArea {

                    anchors.fill:
                            parent

                    acceptedButtons:
                            Qt.LeftButton |
                            Qt.RightButton


                    // =================================================
                    // SINGLE CLICK
                    // =================================================

                    onClicked: {

                        // LEFT CLICK
                        // Do nothing

                        if (
                            mouse.button ===
                            Qt.LeftButton
                        ) {

                            return
                        }


                        // RIGHT CLICK
                        // DELETE FROM TABLE ONLY

                        if (
                            mouse.button ===
                            Qt.RightButton
                        ) {

                            deleteProductFromTable(
                                index
                            )

                            return
                        }
                    }


                    // =================================================
                    // DOUBLE CLICK
                    // =================================================

                    onDoubleClicked: {

                        if (
                            mouse.button !==
                            Qt.LeftButton
                        ) {

                            return
                        }


                        // SELECT ROW

                        window.selectedIndex =
                                index


                        // ENTER UPDATE MODE

                        window.updateMode =
                                true


                        // LOAD VALUES

                        loadSelectedProductToFields(
                            index
                        )


                        // STATUS

                        statusLabel.text =
                                "UPDATE MODE - Edit fields and click Update"

                        statusLabel.color =
                                "#2196F3"


                        // FOCUS

                        productName.forceActiveFocus()

                        productName.selectAll()
                    }
                }
            }
        }
    }


    // =========================================================
    // DELETE FROM TABLE ONLY
    // =========================================================

    function deleteProductFromTable(rowIndex)
    {

        // -----------------------------------------------------
        // CHECK INDEX
        // -----------------------------------------------------

        if (
            rowIndex < 0 ||
            rowIndex >= productListModel.count
        ) {

            return
        }


        // -----------------------------------------------------
        // GET PRODUCT
        // -----------------------------------------------------

        var selectedProduct =
                productListModel.get(
                    rowIndex
                )


        var deleteName =

                selectedProduct.name !== undefined &&
                selectedProduct.name !== null

                ? String(
                    selectedProduct.name
                )

                : "Product"


        // =====================================================
        // IMPORTANT
        // =====================================================
        //
        // DO NOT CALL:
        //
        // productManager.deleteProduct(...)
        //
        // Therefore DATABASE IS NOT MODIFIED.
        //
        // Only the QML ListModel is changed.
        // =====================================================


        productListModel.remove(
            rowIndex
        )


        // -----------------------------------------------------
        // RESET SELECTION
        // -----------------------------------------------------

        window.selectedIndex =
                -1

        window.updateMode =
                false


        // -----------------------------------------------------
        // CLEAR INPUTS
        // -----------------------------------------------------

        productName.clear()

        volume.clear()

        marketCapital.clear()

        creditRating.clear()


        // -----------------------------------------------------
        // STATUS
        // -----------------------------------------------------

        statusLabel.text =
                "'" +
                deleteName +
                "' removed from table only"

        statusLabel.color =
                "#ff9800"


        // -----------------------------------------------------
        // MESSAGE
        // -----------------------------------------------------

        messageDialog.dialogTitle =
                "Removed From Table"


        messageDialogText.text =
                "Product '" +
                deleteName +
                "' was removed from the table.\n\n" +
                "The database was NOT changed."


        messageDialog.open()
    }


    // =========================================================
    // LOAD SELECTED PRODUCT
    // =========================================================

    function loadSelectedProductToFields(rowIndex)
    {

        if (
            rowIndex < 0 ||
            rowIndex >= productListModel.count
        ) {

            return false
        }


        var p =
                productListModel.get(
                    rowIndex
                )


        // PRODUCT NAME

        productName.text =

                p.name !== undefined &&
                p.name !== null

                ? String(p.name)

                : ""


        // VOLUME

        volume.text =

                p.volume !== undefined &&
                p.volume !== null

                ? String(p.volume)

                : ""


        // MARKET CAPITAL

        marketCapital.text =

                p.mcap !== undefined &&
                p.mcap !== null

                ? String(p.mcap)

                : ""


        // CREDIT RATING

        creditRating.text =

                p.cr !== undefined &&
                p.cr !== null

                ? String(p.cr)

                : ""


        return true
    }


    // =========================================================
    // CLEAR INPUTS
    // =========================================================

    function clearInputs()
    {

        productName.clear()

        volume.clear()

        marketCapital.clear()

        creditRating.clear()


        window.selectedIndex =
                -1

        window.updateMode =
                false
    }


    // =========================================================
    // LOAD DATA FROM DATABASE
    // =========================================================

    function loadDataFromDb()
    {

        productListModel.clear()


        var dbData =
                productManager.getProducts()


        if (
            dbData === undefined ||
            dbData === null
        ) {

            statusLabel.text =
                    "No data returned from Database"

            statusLabel.color =
                    "red"

            return
        }


        // -----------------------------------------------------
        // LOAD DATABASE PRODUCTS INTO TABLE
        // -----------------------------------------------------

        for (
            var i = 0;
            i < dbData.length;
            i++
        ) {

            productListModel.append({

                id:
                    dbData[i].id,

                name:
                    dbData[i].productName,

                volume:

                    dbData[i].volume !== undefined &&
                    dbData[i].volume !== null

                    ? Number(
                        dbData[i].volume
                    )

                    : 0,

                mcap:

                    dbData[i].marketCapital !== undefined &&
                    dbData[i].marketCapital !== null

                    ? Number(
                        dbData[i].marketCapital
                    )

                    : 0,

                cr:

                    dbData[i].creditRating !== undefined &&
                    dbData[i].creditRating !== null

                    ? Number(
                        dbData[i].creditRating
                    )

                    : 0,

                createdAt:
                    dbData[i].createdAt,

                updatedAt:
                    dbData[i].updatedAt,

                savedAt:
                    dbData[i].savedAt
            })
        }


        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        window.selectedIndex =
                -1

        window.updateMode =
                false


        statusLabel.text =
                "Loaded " +
                dbData.length +
                " product(s) from Database"

        statusLabel.color =
                "#2196F3"
    }


    // =========================================================
    // APPLICATION START
    // =========================================================

    Component.onCompleted: {

        productListModel.clear()


        window.selectedIndex =
                -1


        window.updateMode =
                false


        statusLabel.text =
                "Ready - Enter product details"

        statusLabel.color =
                "gray"
    }


    // =========================================================
    // C++ SIGNALS
    // =========================================================

    Connections {

        target:
                productManager


        // -----------------------------------------------------
        // CONNECTION
        // -----------------------------------------------------

        function onConnectionChanged(
            connected
        ) {

            if (connected) {

                statusLabel.text =
                        "Connected to Server"

                statusLabel.color =
                        "#4CAF50"

            } else {

                statusLabel.text =
                        "Disconnected"

                statusLabel.color =
                        "red"
            }
        }


        // -----------------------------------------------------
        // DATA SENT
        // -----------------------------------------------------

        function onDataSent()
        {

            statusLabel.text =
                    "Data Sent Successfully!"

            statusLabel.color =
                    "#4CAF50"
        }


        // -----------------------------------------------------
        // STATUS
        // -----------------------------------------------------

        function onStatusMessage(
            message,
            isError
        ) {

            statusLabel.text =
                    message

            statusLabel.color =
                    isError
                    ? "red"
                    : "#4CAF50"
        }


        // -----------------------------------------------------
        // PRODUCTS CHANGED
        // -----------------------------------------------------

        function onProductsChanged()
        {

            // Do not automatically reload.
            //
            // This is important because deleting a row from
            // the table should NOT cause the database data to
            // be reloaded immediately.
        }
    }
}
