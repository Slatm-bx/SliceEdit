import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 600
    height: 400
    visible: true
    title: qsTr("Hello Bx")
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    //Content Area
    TextArea {
        text: qsTr("Hello Bx")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
