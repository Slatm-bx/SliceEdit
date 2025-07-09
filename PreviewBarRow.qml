//多视频预览条部分

import QtQuick
import QtQuick.Layouts
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
    //property int cerrentVideoIndex:-1
    ListView{
        focus: true
        id:_playerSliderView
        anchors.fill: parent
        model: ListModel{
            id:_playerSliderModel
        }
    }
}
