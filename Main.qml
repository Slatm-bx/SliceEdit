import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id:app
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello Bx")
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem{
                action:actions.open
            }
            MenuItem{
                action:actions.quit
            }
        }
        Menu{
            title: qsTr("Media")
            MenuItem{
                action: actions.play
            }
            MenuItem{
                action: actions.pause
            }
            MenuItem{
                action: actions.stop
            }

        }
        Menu{
            title: qsTr("Help")
            MenuItem{
                action:actions.about
            }
        }
    }

    //Content Area
    Content{
        id:content
    }

    Actions{
        id:actions
        play.enabled:(!content.player.playing)&&content.player.source!=""
        pause.enabled:content.player.playing
        stop.enabled:content.player.playing
        open.onTriggered: content.dialogs.fileOpen.open()
        about.onTriggered: content.dialogs.about.open()
        play.onTriggered: content.player.play()
        pause.onTriggered: content.player.pause()
        stop.onTriggered: content.player.stop()
    }
}
