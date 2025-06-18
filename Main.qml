import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia

ApplicationWindow {
    id: root
    visible: true
    //动态更新标题并用正则表达式去除路径名，直接显示打开的文件名
    title: "视频剪辑软件-" + String(_VP.player.source).replace(/^.*[\\\/]/, '');
    minimumWidth: 1000  // 直接约束窗口最小尺寸
    minimumHeight: 600
    color:"#222"
    Actions{
        id:actions
    }
    // 主布局
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
                    listrec.width: parent.width
                    listrec.height:parent.height - _menusrow.implicitHeight - textrec.height
                }
            }

            VideoPlayer{
                id:_VP

            }

            VideoParams{

            }

        }

        PreviewBarControlRow{
            id:_lrow
        }

        PreviewBarRow{
            id: timeline
            height: (1*root.height)/3 - _lrow.implicitHeight
            width:root.width
        }
    }
}
