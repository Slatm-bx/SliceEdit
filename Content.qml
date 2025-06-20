import QtQuick
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls
import "cutViewControl.js" as CutViewControl

Item {
    property alias videoPlayer: _VP
    property alias videoList: _VL

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
                    id:_VL
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
                            timeline.playerslider.source=dialogs.fileOpen.selectedFile
                        }
                    }
                    saveDialog{
                        onAccepted: {
                            //读取thumbnailData，进行剪切
                            let data=videoList.cutView.thumbnailData;
                            let view=videoList.cutView;

                            let outFileName=CutViewControl.removeFileExtension(String(_VP.dialogs.saveDialog.selectedFile))+"."+_VP.dialogs.saveDialog.defaultSuffix;//_VP.dialogs.saveDialog.saveDialog.
                            let inFileName=String(data.get(view.currentIndex).videoUrl);
                            console.log("outFileName: ",outFileName,"inFileName: ",inFileName);

                            let stime=data.get(view.currentIndex).startTime/1000
                            let etime=Number(data.get(view.currentIndex).endTime)/1000

                            console.log("stime: ",stime,"etime: ",etime);
                            Worker.cutOneVideo(stime,etime,inFileName,outFileName);
                        }
                    }
                }
            }

            VideoParams{

            }

        }

        PreviewBarControlRow{
            id:_lrow
        }

        PreviewBarRow{
            id: timeline
            height: (1*root.height)/3 - _lrow.implicitHeight
            width:root.width
            playerslider{
                videoshot{
                    onShotFinished: {//截图后再加载视频 反过来不好处理
                        _VP.player.source=playerslider.source
                        _VP.player.play()
                    }
                }
                to:_VP.player.duration
                value: _VP.player.position
                onMoved: {
                    _VP.player.position=playerslider.value
                }
                enabled: _VP.player.source!=""
            }
        }
    }
}
