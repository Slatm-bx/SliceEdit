import QtQuick
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls
import "cutViewControl.js" as CutViewControl
import "previewbarrow.js" as PreviewBarRowControl

Item {
    property alias videoPlayer: _VP
    property alias videoList: _VL
    property alias timeline: _timeline
    property alias lrow:_lrow

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
                            _timeline.playerSlider.source=dialogs.fileOpen.selectedFile
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
                progressSlider{
                    value: Math.max(_VP.player.position,timeline.playerSlider.tmpCut.startTime)
                    onMoved: {
                        if(progressSlider.value<timeline.playerSlider.tmpCut.startTime){
                            _VP.player.position=timeline.playerSlider.tmpCut.startTime;
                            //progressSlider.value=timeline.playerSlider.tmpCut.startTime;
                            //playerSlider.value=playerSlider.tmpCut.startTime;
                            //_VP.player.position=playerSlider.tmpCut.startTime;
                        }else{
                            _VP.player.position=progressSlider.value;
                        }

                    }
                }
            }

            VideoParams{

            }

        }

        PreviewBarControlRow{
            id:_lrow
            //两个button的onClicked:在不同文件中拓充了函数，但二者函数涉及的数据没有重叠，执行顺序不会影响结果
            stratCutButton{
                onClicked:PreviewBarRowControl.startCutFunction()
            }
            endCutButton{
                onClicked: PreviewBarRowControl.endCutFunction()
            }
        }

        PreviewBarRow{
            id: _timeline
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
                //value:_VP.player.position
                value: Math.max(_VP.player.position,playerSlider.tmpCut.startTime)//? _VP.player.position:playerSlider.tmpCut.startTime
                //property real vl:playerSlider.value
                // value:{
                //     if(_VP.player.position<playerSlider.tmpCut.startTime){
                //         return playerSlider.tmpCut.startTime
                //     }else{
                //         return _VP.player.position
                //     }
                // }

                // onValueChanged: {
                //     if(playerSlider.value<playerSlider.tmpCut.startTime){
                //         playerSlider.value=playerSlider.tmpCut.startTime
                //     }else{
                //         playerSlider.value=_VP.player.position
                //     }
                // }
                onMoved: {
                    if(playerSlider.value<playerSlider.tmpCut.startTime){
                        _VP.player.position=playerSlider.tmpCut.startTime;
                        //playerSlider.value=playerSlider.tmpCut.startTime;
                        //_VP.player.position=playerSlider.tmpCut.startTime;
                    }else{
                        _VP.player.position=playerSlider.value;
                    }
                    //if(timeline.playerSlider.tmpCut.startTime>playerSlider.value)PreviewBarRowControl.endCutFunction()
                }
                enabled: _VP.player.source!=""
                // onSourceChanged: {
                //     PreviewBarRowControl.clearCutFunction()
                // }
            }
        }
    }
}
