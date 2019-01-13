import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: window
    visible: true
    title: "Decred Wallet"
    minimumWidth: 600
    minimumHeight: 400

    Column {
        anchors.left: parent
        topPadding: 35
        leftPadding: 15
        Row {
            spacing: 40
            Button {
                text: "Check Balance"
                /*onClicked: fileDialog.open()*/
            }
            /*TextField {
                id: inputFile
                width: 270
                placeholderText: "Choose file"
                selectByMouse: true
            }*/
        }
        Row {
            spacing: 25
            Button {
                text: "Receive"
               /* onClicked: dirDialog.open()*/
            }
            /*TextField {
                id: outputDirectory
                width: 200
                placeholderText: "Current folder"
                selectByMouse: true
            }*/
        }
        Row {
            spacing: 25
            Button {
                text: "Send"
                /*onClicked: {
                    qmlBridge.sendToGo(inputFile.text, outputDirectory.text)
                }*/
                }
                TextField {
                id: outputDirectory
                width: 200
                placeholderText: "Enter Amount"
                selectByMouse: false
                validator: DoubleValidator{bottom: 0; top: 200000;}
                
            
            }
        }

        Row { 
                spacing: 25
                topPadding: 45
            Text {
                    id: configurationText
                    text: "godcr configuration file location:"
                    font.family: "DejaVuSans"
                    font.pixelSize: 16
                    /*width: flick.width
                    height: flick.height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.fill: parent*/
                    textFormat: Qt.RichText
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignVCenter
                    /*leftPadding: 10
                    topPadding: 15
                    bottomPadding: 10*/
                    onTextChanged: {
                        popup.contentWidth = implicitWidth
                        popup.contentHeight = implicitHeight>49+okBut.width?implicitHeight:50+okBut.width
                    }
                 }
                Text {
                    id: statuText
                    text: qmlBridge.config.name
                    font.family: "DejaVuSans"
                    font.pixelSize: 16
                    /*width: flick.width
                    height: flick.height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.fill: parent*/
                    textFormat: Qt.RichText
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignVCenter
                    /*leftPadding: 10
                    topPadding: 15
                    bottomPadding: 10*/
                    onTextChanged: {
                        popup.contentWidth = implicitWidth
                        popup.contentHeight = implicitHeight>49+okBut.width?implicitHeight:50+okBut.width
                    }

                }
    }

    /*FileDialog {
        id: fileDialog
        visible : false
        title: "Please, choose a file"
        folder: shortcuts.home
        nameFilters: [ "Excel files (*.xlsx)" ]
        onAccepted: {
            var path = fileDialog.fileUrl.toString();
            if(Qt.platform.os === "linux"){
                path= path.replace(/^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,"");
            } else if (Qt.platform.os === "windows"){
                path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            }
            var cleanPath = decodeURIComponent(path)
            inputFile.text = cleanPath

        }
        onRejected: {
            console.log("Canceled")
        }
    }*/

    /*FileDialog {
        id: dirDialog
        visible : false
        selectFolder: true
        selectMultiple: false
        selectExisting: true
        title: "Please choose a folder"
        folder: shortcuts.home
        onAccepted: {
            var path = dirDialog.fileUrl.toString();
            if(Qt.platform.os === "linux"){
                path= path.replace(/^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,"");
            } else if (Qt.platform.os === "windows"){
                path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            }
            var cleanPath = decodeURIComponent(path);
            outputDirectory.text = cleanPath+"/"
        }
    }*/
   /* Popup {
        id: popup
        x: window.width/2 - width/2
        y: window.height/2 - height/2
        rightMargin: 5
        leftMargin: 5
        bottomMargin: 10
        topMargin: 10
        font.capitalization: Font.MixedCase
        font.family: "DejaVuSans"
        visible: false
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        contentWidth: statusText.implicitWidth
        contentHeight: statusText.implicitHeight

        background: Rectangle {
            radius: 8
            anchors.fill: parent
            color: "#d6d6d6"
            border.width: 1
            Layout.alignment: Qt.AlignCenter
        }
        contentItem: ColumnLayout {
            anchors.fill: parent
            Layout.alignment: Qt.AlignCenter
            Flickable {
                id: flick
                maximumFlickVelocity: 500
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 50
                Layout.minimumWidth: 100
                Layout.alignment: Qt.AlignCenter
                contentWidth: statusText.paintedWidth
                contentHeight: statusText.paintedHeight
                clip: true
                ScrollBar.vertical: ScrollBar { id: vbar; active: false }

                Text {
                    id: statusText
                    font.family: "DejaVuSans"
                    font.pixelSize: 16
                    width: flick.width
                    height: flick.height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.fill: parent
                    textFormat: Qt.RichText
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                    topPadding: 15
                    bottomPadding: 10
                    onTextChanged: {
                        popup.contentWidth = implicitWidth
                        popup.contentHeight = implicitHeight>49+okBut.width?implicitHeight:50+okBut.width
                    }
                }
            }
            Button {
                id: okBut
                width: 120
                Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                text: "OK"
                font.pixelSize: 16
                onClicked: {
                    popup.close()
                }
            }
        }
    }*/

    Connections {
        target: qmlBridge
        onSendToQml: {
            statusText.text = detText
            popup.open()
        }
    }

    Component.onCompleted: {
        window.x = Screen.width / 2 -window.width / 2
        window.y = Screen.height / 2 - window.height / 2
    }
 }
}
