//20230501604023 刘金林

import QtQuick
import QtQml.Models//ListModel
import QtQml//Component
import QtQuick.Layouts
import QtQuick.Controls//ToolBar
import "cutViewControl.js" as CutViewControl
import "previewbarrow.js" as PreviewBarRowControl

Rectangle{
    //id:root
    property alias thumbnailData:_thumbnailData
    property alias chapterDelegate:_chapterDelegate
    property alias cutListView:_cutListView

    color:"#333"
    ListModel{
        id:_thumbnailData
    }

    Component{
        id:_chapterDelegate
        Rectangle{
            id:chapter
            visible:true
            width:_cutListView.width
            height:100
            color: ListView.isCurrentItem?"#e0ffff":"white"
            property int cutId:model.cutId

            RowLayout{
                anchors.fill:parent
                // spacing:0
                ColumnLayout{
                    Layout.leftMargin: 10
                    Text{
                        id:title
                        text:"Chapter "+(index+1)
                        font.pixelSize:10
                        color:"black"
                    }
                    Image {
                        Layout.preferredHeight:60
                        Layout.preferredWidth:80
                        fillMode:Image.Stretch
                        id: thumbnail
                        source: model.thumUrl
                    }
                }

                ColumnLayout{
                    Layout.rightMargin: 40
                    Layout.leftMargin: 20
                    Text{
                        id:start
                        text:"START"
                        font.pixelSize:10
                        color:"red"
                    }
                    Text{
                        id:stime
                        text:CutViewControl.formatTime(model.startTime)
                    }
                    Text{
                        id:end
                        text:"END"
                        font.pixelSize:10
                    }
                    Text{
                        id:etime
                        text:CutViewControl.formatTime(model.endTime)
                        visible: model.endTime===-1 ? false:true
                    }
                }
            }
            TapHandler{
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onTapped: (eventPoint,button)=>{
                              cutListView.currentIndex = index;
                              //更新播放位置

                              if(videoPlayer.player.source!==model.videoUrl){
                                  videoPlayer.player.source=model.videoUrl
                                  PreviewBarRowControl.changePreviewBarListIndex(model.videoUrl,model.startTime)
                              }
                              else videoPlayer.player.position=model.startTime;
                          }

            }
            ContextMenu.menu: cMenu
        }
    }
    Menu {
        id: cMenu
        width:toolBar.width
        MenuItem {
            text: "删除选中项"
            onTriggered:{
                let data=thumbnailData.get(cutListView.currentIndex);
                if(data.endTime===-1){//当删除缺少时间的切片时
                    //关闭蓝色矩形
                    timeline.playerSlider.tmpCut.visible=false;
                    //恢复未切片状态
                    lrow.stratCutButton.enabled=true;
                    lrow.endCutButton.enabled=false;
                    thumbnailData.remove(cutListView.currentIndex);
                    timeline.playerSlider.tmpCut.startTime=0;
                }else{
                    PreviewBarRowControl.deleteOneCutFunction(data.videoUrl,data.cutId)
                    thumbnailData.remove(cutListView.currentIndex);

                }
            }
        }
        MenuItem { text: "删除所有项"
            onTriggered:{
                let data;
                for(let i=0;i<cutListView.count;i++){
                    data=thumbnailData.get(i);
                    //如果红色矩形存在
                    if(data.endTime!==-1)PreviewBarRowControl.deleteOneCutFunction(data.cutId);
                    else {
                        timeline.playerSlider.tmpCut.visible=false;
                        //恢复未切片状态
                        lrow.stratCutButton.enabled=true;
                        lrow.endCutButton.enabled=false;
                        //更新
                        timeline.playerSlider.tmpCut.startTime=0;
                    }
                }
                thumbnailData.clear();
            }
        }
        MenuItem{
            text:"保存当前切片"
            onTriggered:{
                let saveDialog=videoPlayer.dialogs.saveClipDialog;
                saveDialog.defaultSuffix=String(CutViewControl.getFileExtension(thumbnailData.get(cutListView.currentIndex).videoUrl));//得到当前modeElement的videoUrl
                console.log("saveDialog.defaultSuffix: ",saveDialog.defaultSuffix);
                saveDialog.open();
            }
        }
        MenuItem {
            text: "向上移"
            visible: cutListView.currentIndex === 0 ? false :true
            onTriggered:CutViewControl.moveClipUp()
        }
        MenuItem {
            visible:cutListView.currentIndex === cutListView.count -1 ?false :true
            text: "向下移"
            onTriggered:CutViewControl.moveClipDown()
        }

    }

    ColumnLayout{
        id:mainLayout
        anchors.fill:parent
        ListView {
            clip: true
            Layout.fillWidth:true
            Layout.fillHeight:true
            // Layout.preferredHeight: height
            // Layout.preferredWidth: width
            id:_cutListView
            model:thumbnailData
            delegate:chapterDelegate
            moveDisplaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 1000 }
            }
        }
        ToolBar{
            id:toolBar
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth:true
            RowLayout{
                anchors.fill:parent
                ToolButton {
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("导出")
                    onClicked: {
                        //得到拓展名
                        let saveDialog=videoPlayer.dialogs.saveAllClipsDialog;
                        saveDialog.defaultSuffix=String(CutViewControl.getFileExtension(thumbnailData.get(cutListView.currentIndex).videoUrl));
                        //打开对话框
                        saveDialog.open();
                    }//执行C++代码
                }
                ToolButton {
                    id:deleteButton
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("操作切片")
                    onClicked: {
                        //显示上下文菜单
                        contextMenu.popup(pressX,pressY);
                    }
                    Menu {
                        id: contextMenu
                        width:toolBar.width//
                        MenuItem {
                            text: "删除选中项"
                            onTriggered:{
                                let data=thumbnailData.get(cutListView.currentIndex);
                                if(data.endTime===-1){//当删除缺少时间的切片时
                                    //关闭蓝色矩形
                                    timeline.playerSlider.tmpCut.visible=false;
                                    //恢复未切片状态
                                    lrow.stratCutButton.enabled=true;
                                    lrow.endCutButton.enabled=false;
                                    thumbnailData.remove(cutListView.currentIndex);
                                    timeline.playerSlider.tmpCut.startTime=0;
                                }else{
                                    PreviewBarRowControl.deleteOneCutFunction(data.videoUrl,data.cutId)
                                    thumbnailData.remove(cutListView.currentIndex);
                                }
                            }
                        }
                        MenuItem { text: "删除所有项"
                            onTriggered:{
                                let data;
                                for(let i=0;i<cutListView.count;i++){
                                    data=thumbnailData.get(i);
                                    //如果红色矩形存在
                                    if(data.endTime!==-1)PreviewBarRowControl.deleteOneCutFunction(data.videoUrl,data.cutId);
                                    else {
                                        timeline.playerSlider.tmpCut.visible=false;
                                        //恢复未切片状态
                                        lrow.stratCutButton.enabled=true;
                                        lrow.endCutButton.enabled=false;
                                        //更新
                                        timeline.playerSlider.tmpCut.startTime=0;
                                    }
                                }
                                thumbnailData.clear();
                            }
                        }
                        MenuItem{
                            text:"保存当前切片"
                            onTriggered:{
                                let saveDialog=videoPlayer.dialogs.saveClipDialog;
                                saveDialog.defaultSuffix=String(CutViewControl.getFileExtension(thumbnailData.get(cutListView.currentIndex).videoUrl));//得到当前modeElement的videoUrl
                                console.log("saveDialog.defaultSuffix: ",saveDialog.defaultSuffix);
                                saveDialog.open();
                            }
                        }
                        MenuItem {
                            text: "向上移"
                            visible: cutListView.currentIndex === 0 ? false :true
                            onTriggered:CutViewControl.moveClipUp()
                        }
                        MenuItem {
                            visible:cutListView.currentIndex === cutListView.count -1 ?false :true
                            text: "向下移"
                            onTriggered:CutViewControl.moveClipDown()
                        }

                    }
                }
            }
        }
    }
}

