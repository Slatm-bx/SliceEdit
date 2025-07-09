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
                // height:(3*root.height)/5
                Layout.preferredHeight:(3*root.height)/5
                Menus{
                    id:_menusrow
                    openMenu.onTriggered: _VP.dialogs.fileOpen.open()
                    helpButt.onClicked: _VP.dialogs.about.open()
                }

                VideoList{
                    id:_VL
                    listrec.width: parent.width
                    // listrec.height:parent.height - _menusrow.implicitHeight - textrec.height
                    listrec.height:parent.height
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
                    saveClipDialog{
                        onAccepted: {
                            let data=videoList.cutView.thumbnailData;
                            let view=videoList.cutView.cutListView;

                            let outName=CutViewControl.removeFileExtension(String(_VP.dialogs.saveClipDialog.selectedFile))+"."+_VP.dialogs.saveClipDialog.defaultSuffix;//_VP.dialogs.saveDialog.saveDialog.
                            let inFileName=String(data.get(view.currentIndex).videoUrl);
                            console.log("outFileName: ",outName,"inFileName: ",inFileName);

                            let stime=data.get(view.currentIndex).startTime/1000
                            let etime=Number(data.get(view.currentIndex).endTime)/1000

                            console.log("stime: ",stime,"etime: ",etime);
                            let outFileName = String(outName.replace("file://", ""));
                            Worker.cutOneVideo(stime,etime,inFileName,outFileName);
                        }
                    }
                    saveAllClipsDialog{
                        onAccepted: {
                            let data=videoList.cutView.thumbnailData;
                            let view=videoList.cutView.cutListView;
                            let outName=CutViewControl.removeFileExtension(String(_VP.dialogs.saveAllClipsDialog.selectedFile))+"."+_VP.dialogs.saveAllClipsDialog.defaultSuffix;//_VP.dialogs.saveDialog.saveDialog.
                            console.log(outName);
                            let inFileName=String(data.get(view.currentIndex).videoUrl);
                            console.log("saveDialog.defaultSuffix: ",videoPlayer.dialogs.saveAllClipsDialog.defaultSuffix);
                            let dcount = data.count;
                            let stimes = [];
                            let etimes = [];
                            let inFileNames = [];
                            for(let i =0;i<data.count;i++){
                                stimes.push(data.get(i).startTime/1000);
                                etimes.push(data.get(i).endTime/1000);
                                inFileNames.push(data.get(i).videoUrl);
                            }
                            let outFileName = String(outName.replace("file://", ""));
                            Worker.saveAllVideos(stimes,etimes,inFileNames,outFileName);
                        }
                    }
                }
            }

            VideoParams{
            }

        }
        PreviewBarControlRow{
            id:_lrow
            Layout.preferredHeight:70
            // height: 70
            // height:(1*parent.height)/5
            //width不能写root.width,不然会导致spacing不是固定值
            width:parent.width
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
            Layout.preferredHeight:(2*root.height)/5 - parent.spacing - _lrow.height
            // height: (2*root.height)/5 - parent.spacing - _lrow.height
            width:parent.width
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
