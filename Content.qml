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
                            // _VP.player.stop()
                            // _timeline.playerSlider.source=dialogs.fileOpen.selectedFile
                            timeline.playerSliderModel.append({"source":dialogs.fileOpen.selectedFile});
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
                            // let stimes = new Array();
                            // let etimes = new Array();
                            let stimes = [];
                            let etimes = [];
                            for(let i =0;i<data.count;i++){
                                stimes.push(data.get(i).startTime/1000);
                                etimes.push(data.get(i).endTime/1000);
                            }
                            let outFileName = String(outName.replace("file://", ""));
                            Worker.saveAllVideos(stimes,etimes,inFileName,outFileName);
                        }
                    }
                }
                progressSlider{
                    value:_VP.player.position //Math.max(_VP.player.position,timeline.playerSlider.tmpCut.startTime)
                    // onMoved: {
                    //     console.log("测试",timeline.playerSlider.source)
                    //     if(progressSlider.value<timeline.playerSlider.tmpCut.startTime){
                    //         _VP.player.position=timeline.playerSlider.tmpCut.startTime;
                    //     }else{
                    //         _VP.player.position=progressSlider.value;
                    //     }

                    // }
                    onMoved: {
                        _VP.player.position=progressSlider.value;
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

            playerSliderView{
                delegate: PlayerSlider{// 改到content内
                    source: model.source
                    onMoved: {
                        if(_VP.player.source===source)_VP.player.position=timeline.playerSlider.value;
                        else{
                            _VP.player.play()
                            timeline.playerSlider.value=timeline.playerSlider.value
                            timeline.playerSlider.to=timeline.playerSlider.to
                            timeline.playerSliderView.currentIndex=index
                        }
                    }
                }
                onCurrentIndexChanged: {
                    if(timeline.playerSliderView.count>=1){
                        _VP.player.play()
                        _VP.player.position=timeline.playerSlider.value
                        timeline.playerSlider.value=Qt.binding(function(){return _VP.player.position})
                        timeline.playerSlider.to=Qt.binding(function(){return _VP.player.duration})
                        _VP.player.source=Qt.binding(function(){return timeline.playerSlider.source})
                        console.log(timeline.playerSlider.source);
                    }
                }
            }


            // playerSlider{
            //     videoshot{
            //         onShotFinished: {//截图后再加载视频 反过来不好处理
            //             _VP.player.source=playerSlider.source
            //             _VP.player.play()
            //         }
            //     }
            //     to:_VP.player.duration

            //     value: Math.max(_VP.player.position,playerSlider.tmpCut.startTime)//? _VP.player.position:playerSlider.tmpCut.startTime

            //     onMoved: {
            //         if(playerSlider.value<playerSlider.tmpCut.startTime){
            //             _VP.player.position=playerSlider.tmpCut.startTime;

            //         }else{
            //             _VP.player.position=playerSlider.value;
            //         }
            //     }
            //     enabled: _VP.player.source!=""
            //     onSourceChanged: {
            //         PreviewBarRowControl.clearCutFunction()
            //     }
            // }

        }
    }

}
