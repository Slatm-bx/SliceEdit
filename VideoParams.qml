//视频参数区域，用于显示视频的参数

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout{
    spacing:0
    Rectangle{
        id:_atritext
        Layout.fillWidth: true
        width:parent.width
        height: 20
        color: "#555"
        Text{
            anchors.left: parent.left
            color:"white"
            text:"视频参数"
        }
    }
    Rectangle{
         // radius: 10
        width:root.width/5
        height:(2*root.height)/3- _atritext.height
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: "black"
        color:"#333"
        Text{
            text:"视频属性"
            anchors.centerIn: parent
            color:"white"
        }
    }
}
