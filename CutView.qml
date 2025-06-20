//20230501604023 刘金林

import QtQuick
import QtQml.Models//ListModel
import QtQml//Component
import QtQuick.Layouts
import QtQuick.Controls//ToolBar
import "cutViewControl.js" as CutViewControl
import "previewbarrow.js" as PreviewBarRowControl

Rectangle{
    id:root
    property alias thumbnailData:_thumbnailData
    property alias chapterDelegate:_chapterDelegate
    property alias cutList:_cutList

    color:"#333"
    ListModel{
        id:_thumbnailData
    }

    Component{
        id:_chapterDelegate
        Rectangle{
            id:chapter
            visible:true
            width:_cutList.width
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
              onTapped: (event,button)=>{
                  root.cutList.currentIndex = index;
                 if(button===Qt.RightButton) {
                             contextMenu.open();
                        }
                    }
            }

        }
    }
    ColumnLayout{
        id:mainLayout
        anchors.fill:parent
        ListView {
            clip: true
            Layout.fillWidth:true
            Layout.fillHeight:true
            // Layout.preferredHeight: root.height
            // Layout.preferredWidth: root.width
            id:_cutList
            model:root.thumbnailData
            delegate:root.chapterDelegate
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
                        //打开保存文件对话框
                        let saveDialog=videoPlayer.dialogs.saveDialog;
                        saveDialog.defaultSuffix=String(CutViewControl.getFileExtension(thumbnailData.get(cutList.currentIndex).videoUrl));//得到当前modeElement的videoUrl
                        console.log("saveDialog.defaultSuffix: ",saveDialog.defaultSuffix);
                        saveDialog.open();
                    }//执行C++代码
                }
                ToolButton {
                    id:deleteButton
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("操作切片")
                    onClicked: {
                        //显示上下文菜单
                        contextMenu.open();
                    }
                    Menu {
                        id: contextMenu
                        x :deleteButton.x + deleteButton.width - contextMenu.width
                        y :deleteButton.y + deleteButton.height
                        width:toolBar.width
                        MenuItem {
                            text: "删除选中项"
                            onTriggered:{
                                PreviewBarRowControl.deleteOneCutFunction(root.thumbnailData.get(root.cutList.currentIndex).cutId)
                                root.thumbnailData.remove(root.cutList.currentIndex);
                            }
                        }
                        MenuItem { text: "删除所有项"
                            onTriggered:{
                                for(let i=0;i<root.cutList.count;i++){
                                    PreviewBarRowControl.deleteOneCutFunction(root.thumbnailData.get(i).cutId)
                                }

                                root.thumbnailData.clear();
                            }
                        }
                        MenuItem {
                            text: "向上移"
                            visible: cutList.currentIndex === 0 ? false :true
                            onTriggered:CutViewControl.moveClipUp()
                        }
                        MenuItem {
                            visible:cutList.currentIndex === cutList.count -1 ?false :true
                            text: "向下移"
                            onTriggered:CutViewControl.moveClipDown()
                        }
                    }
                }
            }
        }
    }
}

