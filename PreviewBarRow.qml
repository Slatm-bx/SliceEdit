//视频预览条部分

import QtQuick
import QtQuick.Layouts
import "previewbarrow.js" as PreviewBarRowControl


Rectangle {
    property alias playerSlider: _playerslider
    id: timeline
    Layout.fillHeight:true
    Layout.fillWidth: true
    color: "#333"
    PlayerSlider{
        id:_playerslider
    }
    // ListView{
    //     id:_playersliderList
    //     anchors.fill: parent
    //     model:_playersliderModel
    //     delegate: PlayerSlider{
    //     }
    // }
    // ListModel{
    //     id:_playersliderModel
    // }

    // Component.onCompleted: {
    //     _playersliderModel.append({"source":""})
    // }
}
