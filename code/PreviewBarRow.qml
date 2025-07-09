//多视频预览条部分

import QtQuick
import QtQuick.Layouts

import QtQuick.Controls
import Videoedit
import QtMultimedia

import "previewbarrow.js" as PreviewBarRowControl


Rectangle {
    id: timeline
    Layout.fillHeight:true
    Layout.fillWidth: true
    clip: true
    color: "#333"
    property alias playerSlider: _playerSliderView.currentItem//方便查找
    property alias playerSliderView: _playerSliderView
    property alias playerSliderModel: _playerSliderModel
    property alias pMenu: _pMenu
    property int cerrentVideoIndex:-1

    ListView{
        focus: true
        id:_playerSliderView
        anchors.fill: parent
        model: ListModel{
            id:_playerSliderModel
        }
        moveDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 1000 }
        }
    }

    SourceManager{

    }


    //上下文菜单（删除移动操作）
    Menu {
        id: _pMenu
        width:150
        MenuItem {
            text: "删除该预览条"
            onTriggered:{
                PreviewBarRowControl.deleteOneSlider(playerSliderView,playerSliderModel);
                if(playerSliderModel.count==0){
                    videoPlayer.player.source=""
                }
            }
        }
        MenuItem { text: "删除所有预览条"
            onTriggered:{
                playerSliderModel.clear();
                videoList.cutView.thumbnailData.clear();
                videoPlayer.player.source=""
            }
        }
        MenuItem {
            text: "向上移"
            visible: playerSliderView.currentIndex === 0 ? false :true
            onTriggered:{
                let cI = playerSliderView.currentIndex;
                if (cI >= 0) {
                        // 交换当前元素和前一个元素
                        playerSliderModel.move(cI, cI - 1, 1);
                        // 更新 currentIndex 以保持选中状态
                        playerSliderView.currentIndex = cI - 1;
                }
            }
        }
        MenuItem {
            visible:playerSliderView.currentIndex === playerSliderModel.count -1 ?false :true
            text: "向下移"
            onTriggered:{
                let cI = playerSliderView.currentIndex;
                if (cI >= 0) {
                        // 交换当前元素和前一个元素
                        playerSliderModel.move(cI +1, cI, 1);
                        // 更新 currentIndex 以保持选中状态
                        playerSliderView.currentIndex = cI + 1;
                }
            }
        }

    }
}
