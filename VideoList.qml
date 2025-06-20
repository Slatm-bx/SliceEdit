//打开的视频列表

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "cutViewControl.js" as CutViewControl

ColumnLayout{
    property alias textrec:_listtext
    property alias listrec:_listrec
    property alias cutView:_cutView

    spacing:0
    Rectangle{
        id:_listtext
        Layout.fillWidth: true
        width:parent.width
        height: 20
        color: "#555"
        Text{
            anchors.left: parent.left
            color:"white"
            text:"Videolist"
        }
    }
//这个Rectangle是真正意义上的VideoList,生成的VideoList都应该在这个Rectangle上显示
    Rectangle{
        id: _listrec
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: "black"
        color:"#333"

        CutView{
            id:_cutView
            anchors.fill:parent
        }

        Text{
            anchors.centerIn :parent
            text:"视频切片的列表"
            color:"white"
            visible: cutView.thumbnailData.count>0? false:true
        }
    }
}
