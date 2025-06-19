import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia

ApplicationWindow {
    id: root
    visible: true
    //动态更新标题并用正则表达式去除路径名，直接显示打开的文件名
    title: "视频剪辑软件-" + String(content.videoPlayer.player.source).replace(/^.*[\\\/]/, '');
    minimumWidth: 1200  // 直接约束窗口最小尺寸
    minimumHeight: 600
    color:"#222"
    Actions{
        id:actions
    }
    // 主布局
    Content{
        id:content
        anchors.fill: parent
    }

}
