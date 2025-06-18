import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
    property alias open :_open
    property alias quit :_quit
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
}
