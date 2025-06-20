//视频预览条部分

import QtQuick
import QtQuick.Layouts

Rectangle {
    property alias playerslider: _playerslider

    id: timeline
    Layout.fillHeight:true
    Layout.fillWidth: true
    color: "#333"
    PlayerSlider{
        id:_playerslider
    }
}
