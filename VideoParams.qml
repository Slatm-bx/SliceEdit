//视频参数区域，用于显示视频的参数

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

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
    Rectangle {
        id: videoProperties
        width: root.width / 5
        height: (2 * root.height) / 3 - _atritext.height
        Layout.fillWidth: true
        Layout.fillHeight: true
        border.color: "#555"
        color: "#333"
        clip: true
        ColumnLayout {
            anchors.margins: 12
            spacing: 16
            width:parent.width
            Layout.fillWidth: true
            // === 最常用的控制 ===
            // 1. 音量控制（置顶，最常用）
            RowLayout {
                width:parent.width
                Layout.fillWidth: true
                spacing: 8
                Label {
                    text: "🔊"
                    color: "white"
                    // opacity: _VP.player.muted ? 0.3 : 1
                }
                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: _VP.player.audioOutput.muted ? 0 : _VP.player.audioOutput.volume
                    onMoved: {
                        _VP.player.audioOutput.volume = value
                        _VP.player.audioOutput.muted = false
                    }
                    enabled: !_VP.player.audioOutput.muted
                }
                Button {
                    text: _VP.player.audioOutput.muted ? "取消静音" : "静音"
                    onClicked: _VP.player.audioOutput.muted = !_VP.player.audioOutput.muted
                    //扁平设计无背景无阴影
                    flat: true
                    Layout.preferredWidth: 80
                }
            }

            // 2. 播放速度（常用功能）
            RowLayout {
                spacing: 8
                Label {
                    text: "速度:"
                    color: "white"
                }
                Button {
                    text: "−"
                    onClicked: _VP.player.playbackRate = Math.max(0.1, _VP.player.playbackRate - 0.1)
                    Layout.preferredWidth: 30
                }
                ProgressBar {
                    value: _VP.player.playbackRate
                    from: 0.1
                    to: 3.0
                    Layout.fillWidth: true
                    background: Rectangle { color: "#444"; radius: 3 }
                }
                Button {
                    text: "+"
                    onClicked: _VP.player.playbackRate = Math.min(3.0, _VP.player.playbackRate + 0.1)
                    Layout.preferredWidth: 30
                }
                Label {
                    text: _VP.player.playbackRate.toFixed(1) + "x"
                    color: "white"
                    Layout.minimumWidth: 40
                }
            }

            // === 视频显示控制 ===
            // 3. 透明度控制
            RowLayout {
                spacing: 8
                Label {
                    text: "透明度:"
                    color: "white"
                }
                Slider {
                    id: opacitySlider
                    Layout.fillWidth: true
                    from: 0.3  // 避免完全透明
                    to: 1
                    value: _VP.videoOutput.opacity
                    onMoved: _VP.videoOutput.opacity = value
                }
                Label {
                    text: Math.round(_VP.videoOutput.opacity * 100) + "%"
                    color: "white"
                    Layout.minimumWidth: 40
                }
            }

            // 4. 视频旋转
            RowLayout {
                spacing: 8
                Label {
                    text: "旋转:"
                    color: "white"
                }
                Button {
                    text: "↺"
                    onClicked: _VP.videoOutput.orientation = (_VP.videoOutput.orientation - 90) % 360
                    ToolTip.text: "逆时针旋转90°"
                }
                Button {
                    text: "↻"
                    onClicked: _VP.videoOutput.orientation = (_VP.videoOutput.orientation + 90) % 360
                    ToolTip.text: "顺时针旋转90°"
                }
                Button {
                    text: "重置"
                    onClicked: _VP.videoOutput.orientation = 0
                    Layout.fillWidth: true
                }
            }

            // === 视频信息 ===
            // 5. 元数据展示
            GridLayout {
                columns: 2
                columnSpacing: 10
                rowSpacing: 4
                Layout.topMargin: 8

                // 第一列
                Label { text: "文件名:"; color: "#aaa" }
                Text {
                    text: _VP.player.source.toString().replace(/^.*[\\\/]/, '') || "未加载"
                    color: "lightblue"
                    // elide: Text.ElideMiddle
                    Layout.maximumWidth: parent.width * 0.6
                }

                // 第二列
                Label { text: "分辨率:"; color: "#aaa" }
                Text { text:_VP.player.metaData.value(MediaMetaData.Resolution) !== undefined ? String(_VP.player.metaData.value(MediaMetaData.Resolution)) : "未知"; color: "white" }
                Label { text: "帧率:"; color: "#aaa" }
                Text { text:_VP.player.metaData.value(MediaMetaData.VideoFrameRate) !== undefined ? String(_VP.player.metaData.value(MediaMetaData.VideoFrameRate).toFixed(2)) : "未知" + " fps"; color: "white" }

                Label { text: "时长:"; color: "#aaa" }
                Text {
                    text: {
                        if (!_VP.player.duration) return "00:00";
                        var sec = Math.floor(_VP.player.duration / 1000);
                        return Math.floor(sec / 60) + ":" + ("0" + (sec % 60)).slice(-2);
                    }
                    color: "white"
                }
            }

            // 底部留白
            Item { Layout.fillHeight: true }
        }
        }
    }
