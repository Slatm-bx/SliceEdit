import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia
ApplicationWindow {
    id: root
    visible: true
    title: "视频剪辑软件"
    minimumWidth: 1000  // 直接约束窗口最小尺寸
    minimumHeight: 600
    color:"#222"

    Actions{
        id:actions
    }

    // Content{
    //     id:content
    // }

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        spacing: 5
        //顶部操作栏
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight:true
            spacing: 5
            ColumnLayout{
                spacing: 0
                width:(root.width)/5
                height:(2*root.height)/3
                RowLayout{
                    id:_mainrow
                    // width:parent.width
                    spacing:5
                    Button {
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
                                    // implicitWidth: parent.width
                                    // implicitHeight: parent.height
                                    color: "#222"
                                }
                        Menu {
                               id: videoMenu
                               MenuItem { text: "打开";action:actions.open; onTriggered:_dialogs.fileOpen.open() }
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
                        onClicked:_dialogs.about.open()
                    }
                }
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
                Rectangle{
                    // width:(root.width)/5
                     // radius: 10
                    width: parent.width
                    height:parent.height - _mainrow.implicitHeight - _listtext.height
                    id: _videolist
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    border.color: "black"
                    color:"#333"

                    Text{
                        anchors.centerIn :parent
                        text:"视频切片的列表"
                        color:"white"
                    }
                }
            }

            ColumnLayout{
                spacing:0
                width:(3*root.width/5)
                height:(2*root.height)/3
            // 视频预览区域
                Layout.fillWidth: true
                Layout.fillHeight: true

                Player{
                    id:_player
                    videoOutput: _videoOutput
                    onErrorChanged: {
                        console.error("MediaPlayer 错误:", errorString)  // 打印具体错误
                    }
                    }

                Dialogs{
                    id:_dialogs
                    fileOpen{
                        onAccepted: {
                            _player.source=fileOpen.selectedFile
                            _player.play()
                        }
                        onRejected: {
                            console.log("Error:read video file")
                            return;
                        }
                    }
                }
                Rectangle{
                    Layout.fillWidth: true
                    id:_vtext
                    width:parent.width
                    height: 20
                    color: "#555"
                    Text{
                        anchors.left: parent.left
                        color:"white"
                        text:"播放器"
                    }
                }

                Rectangle {
                    id:_playrc
                    // radius: 10
                    width:parent.width
                    height:parent.height - _vrow.implicitHeight - _vtext.height
                    Layout.topMargin: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    // border.color: "black"
                    color: "#333"

                    VideoOutput{
                        id:_videoOutput
                        anchors.fill:parent
                        fillMode: VideoOutput.PreserveAspectFit  // 保持比例，适应容器（可能留黑边）
                        MouseArea {
                            anchors.fill: parent
                            onDoubleClicked: {
                                if (root.visibility === Window.FullScreen)
                                    root.visibility = Window.Windowed
                                else
                                    root.showFullScreen()
                            }

                            onClicked: {
                                if (_player.playing) _player.pause()
                                else _player.play()
                            }
                        }
                    }
                    // 这里应该是实际的视频播放组件
                    Text {
                        visible:!_player.playing
                        anchors.centerIn: parent
                        text: "视频预览区域"
                        color: "white"
                    }
                }

                RowLayout{
                    id:_vrow
                    // anchors.bottom: parent.bottom
                    Label {
                                text: formatTime(_player.position) + " / " + formatTime(_player.duration)
                                color:"white"
                                function formatTime(ms) {
                                       if (!ms) return "00:00";
                                       var seconds = Math.floor(ms / 1000);
                                       var minutes = Math.floor(seconds / 60);
                                       seconds = seconds % 60;
                                       return (minutes < 10 ? "0" + minutes : minutes) + ":" +
                                              (seconds < 10 ? "0" + seconds : seconds);
                                   }
                            }

                        // 中间：进度条滑块
                    Slider {
                        id: progressSlider
                        Layout.fillWidth: true
                        // Layout.alignment: Qt.AlignVCenter
                        to:_player.duration
                        value: _player.position

                        onMoved: {//仅在拖动时触发
                            _player.position=value
                        }
                    }
                    RowLayout {
                                spacing: 5

                                Button {
                                    text: "▶️"  // 开始按钮
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    Layout.minimumWidth: 30
                                    Layout.minimumHeight: 30

                                    background: Rectangle {
                                        // implicitWidth: parent.width
                                        // implicitHeight: parent.height
                                        radius: width / 2
                                        color: "#333"
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: _player.play()
                                }

                                Button {
                                    text: "⏸"  // 暂停按钮
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    Layout.minimumWidth: 30
                                    Layout.minimumHeight: 30

                                    background: Rectangle {
                                        // implicitWidth: parent.width
                                        // implicitHeight: parent.height
                                        radius: width / 2
                                        color: "#333"  // 黄色背景
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: _player.pause()
                                }

                                Button {
                                    text: "⤢"  // 全屏按钮
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    Layout.minimumWidth: 30
                                    Layout.minimumHeight: 30
                                    onClicked: {
                                                // 全屏切换功能
                                                if (root.visibility === Window.FullScreen)
                                                   root.visibility = Window.Windowed
                                                else
                                                    // visibility = Window.FullScreen
                                                    showFullScreen()
                                            }
                                    background: Rectangle {
                                        // implicitWidth: parent.width
                                        // implicitHeight: parent.height
                                        radius: width / 2
                                        color: "#333"  // 蓝色背景
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                    }
                }

            }
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
        }

        RowLayout {
            spacing: 5
            id:_lrow
            // Layout.fillHeight:true
            // Layout.fillWidth: true
            Button {
                text: "▶️"
                onClicked: console.log("隐式宽度:", implicitWidth, "隐式高度:", implicitHeight)
                // 设置按钮的宽度和高度为 RowLayout 的高度
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        // Layout.minimumWidth: _lrow.height
                        Layout.minimumHeight: 30
                        Layout.minimumWidth: 30

                        // 设置圆形背景
                        background: Rectangle {
                            // implicitWidth: parent.width
                            // implicitHeight: parent.height
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
                            // implicitWidth: parent.width
                            // implicitHeight: parent.height
                            radius: width / 2  // 圆角半径为宽度的一半，形成圆形
                            color: "white"  // 背景颜色
                        }
            }
        }

        // 视频预览条（时间轴）
        Rectangle {
             // radius: 10
            id: timeline
            Layout.fillHeight:true
            Layout.fillWidth: true
            height: (1*root.height)/3 - _lrow.implicitHeight
            width:root.width
            color: "#333"
        }
    }
}
