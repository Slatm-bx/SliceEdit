//菜单栏

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout{
    property alias openMenu: _openMenu
    property alias helpButt:_helpButt
    spacing:5
    Button {
        id: _material
        // Layout.fillWidth: true  // 自动填充剩余空间
        // Layout.preferredWidth: parent.width / 4
        Layout.preferredHeight: 28
        Layout.preferredWidth: 41
        Layout.minimumWidth: implicitWidth
        text: "素材"
        contentItem: Text {
                text: parent.text
                color: "white"  // 设置文本颜色为白色
            }
        background: Rectangle {
                    color: "#222"
                }
        Menu {
               id: videoMenu
               MenuItem {
                   id:_openMenu
                   // text: "打开";action:actions.open; onTriggered:_dialogs.fileOpen.open()
                   text: "打开";action:actions.open;
               }
               MenuItem { text: "退出";action:actions.quit; onTriggered: Qt.quit() }
           }
        onClicked: {
            videoMenu.popup()
            console.log("隐式宽度:", implicitWidth, "隐式高度:", implicitHeight)
        }
    }

    Button {
        // Layout.fillWidth: true  // 自动填充剩余空间
        Layout.preferredWidth: 41
        Layout.preferredHeight: 28
        Layout.minimumWidth: implicitWidth
        contentItem: Text {
                text: parent.text
                color: "white"  // 设置文本颜色为白色
            }
        background: Rectangle {
                    // implicitWidth: parent.width
                    // implicitHeight: parent.height
                    color: "#222"
                }
        text: "音频"
        // onClicked: videoProcessor.removeCurrentClip()
    }

    Button {
        // Layout.fillWidth: true  // 自动填充剩余空间
        Layout.preferredWidth: 41
        // Layout.preferredHeight: parent.height
        Layout.minimumWidth: 28
        contentItem: Text {
                text: parent.text
                color: "white"  // 设置文本颜色为白色
            }
        background: Rectangle {
                    // implicitWidth: parent.width
                    // implicitHeight: parent.height
                    color: "#222"
                }
        text:"文本"
    }
    Button {
        id:_helpButt
        Layout.preferredWidth: 41
        Layout.minimumWidth: 28
        contentItem: Text {
                text: parent.text
                color: "white"  // 设置文本颜色为白色
            }
        background: Rectangle {
                    color: "#222"
                }
        text:"帮助"
        // onClicked:_dialogs.about.open()
    }
}

