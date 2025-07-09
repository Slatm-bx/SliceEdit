//对视频预览条部分的操作

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "cutViewControl.js" as CutViewControl


RowLayout {
    property alias stratCutButton:_stratCutButton
    property alias endCutButton:_endCutButton
    Layout.alignment: Qt.AlignCenter // 正确写法
    // Layout.fillWidth: true // 默认值（按钮不扩展）
    // spacing: Math.min(30, (width - childrenRect.width) / (children.length - 1) + 30)

    spacing:30
    id:_lrow

    ColumnLayout{
        Button {
            id:_openButton
            text: "📂"
            property  int  count: 0
            onClicked:{
                _VP.dialogs.fileOpen.open()
            }
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumHeight: 50
            Layout.minimumWidth: 50

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: parent.text
                font.pixelSize: 30
            }
            // 设置圆形背景
            background: Rectangle {
                radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                color: "#333"  // 背景颜色
            }

        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "打开视频"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            id:_stratCutButton
            text: "✂️"
            property  int  count: 0
            onClicked:{
                console.log("loadStartTime");
                CutViewControl.loadStartTime();
            }
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumHeight: 50
            Layout.minimumWidth: 50

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: parent.text
                font.pixelSize: 30
            }
            // 设置圆形背景
            background: Rectangle {
                radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                color: "#333"  // 背景颜色
            }

        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "开始剪辑"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            id:_endCutButton
            text: "🏁"
            enabled: false
            onClicked: {
                CutViewControl.loadEndTime();
            }


            //设置按钮的宽度和高度为 RowLayout 的高度
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumWidth: 50
            Layout.minimumHeight: 50

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: parent.text
                font.pixelSize: 30
            }
            //设置圆形背景
            background: Rectangle {
                radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                color: "#333"  // 背景颜色
            }
        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "结束剪辑"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            text: "▶️"  // 开始按钮
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumWidth: 50
            Layout.minimumHeight: 50

            contentItem: Text {
                text: parent.text
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                radius: width / 2
                color: "#333"
            }
            onClicked: _VP.player.play()
        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "播放视频"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            text: "⏸️"  // 暂停按钮
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumWidth: 50
            Layout.minimumHeight: 50

            background: Rectangle {
                radius: width / 2
                color: "#333"  // 黄色背景
            }

            contentItem: Text {
                text: parent.text
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                if(_VP.player.playing)
                _VP.player.pause()
                else _VP.player.play()
            }
        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "暂停视频"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            text: "🔍"  // 全屏按钮
            font.pixelSize: 30
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumWidth: 50
            Layout.minimumHeight: 50
            onClicked: {
                        // 全屏切换功能
                        if (root.visibility === Window.FullScreen)
                           root.visibility = Window.Windowed
                        else
                            showFullScreen()
                    }
            background: Rectangle {
                radius: width / 2
                color: "#333"
            }

        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "全屏播放"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }

    ColumnLayout{
        Button {
            id:_saveButton
            text: "📥"
            font.pixelSize: 30
            property  int  count: 0
            onClicked:{
                //得到拓展名
                let saveDialog=videoPlayer.dialogs.saveAllClipsDialog;
                saveDialog.defaultSuffix=String(CutViewControl.getFileExtension(_VL.cutView.thumbnailData.get(_VL.cutView.cutListView.currentIndex).videoUrl));
                //打开对话框
                saveDialog.open();
            }
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.minimumHeight: 50
            Layout.minimumWidth: 50

            // 设置圆形背景
            background: Rectangle {
                radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                color: "#333"  // 背景颜色
            }

        }
        Text {
                width: 25  // 限制宽度确保换行
                color:"white"
                text: "导出视频"  // 显式换行
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 16
        }
    }
}
