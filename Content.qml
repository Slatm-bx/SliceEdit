import QtQuick
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls
import "previewbarrow.js" as PreviewBarRowControl

Item {
    property alias videoPlayer: _VP
    // 主布局
    id:content
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
                Menus{
                    id:_menusrow
                    openMenu.onTriggered: _VP.dialogs.fileOpen.open()
                    helpButt.onClicked: _VP.dialogs.about.open()
                }

                VideoList{
                    listrec.width: parent.width
                    listrec.height:parent.height - _menusrow.implicitHeight - textrec.height
                }
            }

            VideoPlayer{
                id:_VP
                dialogs{
                    fileOpen{
                        onAccepted: {
                            _VP.player.stop()

                            timeline.playerSlider.source=dialogs.fileOpen.selectedFile
                        }
                    }
                }

            }

            VideoParams{

            }

        }

        PreviewBarControlRow{
            id:_lrow
            startCut{
                onClicked:PreviewBarRowControl.startCutFunction()
            }
            endCut{
                onClicked: PreviewBarRowControl.endCutFunction()
            }
        }

        PreviewBarRow{
            id: timeline
            height: (1*root.height)/3 - _lrow.implicitHeight
            width:root.width
            playerSlider{
                videoshot{
                    onShotFinished: {//截图后再加载视频 反过来不好处理
                        _VP.player.source=playerSlider.source
                        _VP.player.play()
                    }
                }
                to:_VP.player.duration
                value: _VP.player.position
                onMoved: {
                    _VP.player.position=playerSlider.value
                    if(timeline.playerSlider.tmpCut.startTime>playerSlider.value)PreviewBarRowControl.endCutFunction()
                }
                enabled: _VP.player.source!=""
                onSourceChanged: {
                    PreviewBarRowControl.clearCutFunction()
                }

            }
        }
    }
}
