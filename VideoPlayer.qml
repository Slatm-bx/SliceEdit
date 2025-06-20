//视频播放区域用于显示播放的视频

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "cutViewControl.js" as CutViewControl

ColumnLayout{
    property alias player :_player
    property alias dialogs : _dialogs
    property alias videoOutput:_videoOutput
    spacing:0
    Layout.fillWidth: true
    Layout.fillHeight: true
    width:(3*root.width/5)
    height:(2*root.height)/3
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
            TapHandler {
                onDoubleTapped: {
                    if (root.visibility === Window.FullScreen)
                        root.visibility = Window.Windowed
                    else
                        root.showFullScreen()
                }
                exclusiveSignals:TapHandler.SingleTap |TapHandler. DoubleTap
                onSingleTapped:{
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
            Label{
                text: CutViewControl.formatTime(_player.position) + " / " + CutViewControl.formatTime(_player.duration)
                color:"white"
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
                            radius: width / 2
                            color: "#333"  // 黄色背景
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            if(_player.playing)
                            _player.pause()
                            else _player.play()
                        }
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
                                        showFullScreen()
                                }
                        background: Rectangle {
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
