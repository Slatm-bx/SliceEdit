//对视频预览条部分的操作

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    spacing: 5
    id:_lrow
    Button {
        text: "▶️"
        onClicked: console.log("隐式宽度:", implicitWidth, "隐式高度:", implicitHeight)
        // 设置按钮的宽度和高度为 RowLayout 的高度
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.minimumHeight: 30
                Layout.minimumWidth: 30

                // 设置圆形背景
                background: Rectangle {
                    radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                    color: "white"  // 背景颜色
                }

    }

    Button {
        text: "⏹"
        onClicked: videoPlayer.pause()
        //设置按钮的宽度和高度为 RowLayout 的高度
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.minimumWidth: 30
                Layout.minimumHeight: 30

                //设置圆形背景
                background: Rectangle {
                    radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                    color: "white"  // 背景颜色
                }
    }
}
