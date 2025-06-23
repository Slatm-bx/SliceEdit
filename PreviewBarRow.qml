//视频预览条部分

import QtQuick
import QtQuick.Layouts
import "previewbarrow.js" as PreviewBarRowControl


Rectangle {
    // property alias playerSlider: _playerslider

    id: timeline
    Layout.fillHeight:true
    Layout.fillWidth: true
    clip: true
    color: "#333"
    property alias playerSlider: _playerSliderView.currentItem
    property alias playerSliderView: _playerSliderView
    property alias playerSliderModel: _playerSliderModel
    property int cerrentVideoIndex:-1
    ListView{
        focus: true
        id:_playerSliderView
        anchors.fill: parent
        // anchors.top:parent.top
        // anchors.bottom: parent.bottom
        // anchors.right: parent.right
        // width: {
        //     Math.floor(parent.width/200)*200
        // }
        // delegate: PlayerSlider{// 改到content内
        //     source: model.source
        //     TapHandler{
        //         onTapped: {
        //             timeline.playerSlider.value=timeline.playerSlider.value
        //             timeline.playerSlider.to=timeline.playerSlider.to
        //             _playerSliderView.currentIndex=index
        //         }
        //     }
        // }
        model: ListModel{
            id:_playerSliderModel
        }
    }
}
