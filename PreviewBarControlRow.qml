//对视频预览条部分的操作

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    property alias startCut: _startCut
    property alias endCut: _endCut

    spacing: 5
    id:_lrow
    Button {
        id:_startCut
        text: "▶️"

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
        id:_endCut
        text: "⏹"
        //onClicked: videoPlayer.pause()
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
