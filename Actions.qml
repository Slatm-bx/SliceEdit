import QtQuick
import QtQuick.Controls

Item {
    property alias open: _open
    property alias quit: _quit
    property alias about: _about
    property alias play:_play
    property alias pause:_pause
    property alias stop:_stop


    //File
    Action{
        id:_open
        text:qsTr("Open")
        icon.name:"document-open"
        shortcut: StandardKey.Open
    }

    Action{
        id:_quit
        text:qsTr("Quit")
        icon.name:"application-exit"
        shortcut: StandardKey.Quit
        onTriggered: Qt.quit()
    }

    //Help
    Action{
        id:_about
        text: qsTr("About")
        icon.name:"help-about"
    }

    //Media
    Action{
        id:_play
        text:qsTr("Play")
        icon.name:"media-playback-start"

    }
    Action{
        id:_pause
        text: qsTr("Pause")
        icon.name: "media-playback-pause"
    }

    Action{
        id:_stop
        text:qsTr("Stop")
        icon.name:"media-playback-stop"

    }



}
