import QtQuick
import QtQuick.Dialogs

Item {
    property alias fileOpen: _fileOpen
    property alias about:_about


    FileDialog{
        id:_fileOpen
        title: "Select video file"

        fileMode: FileDialog.OpenFile
        nameFilters: ["Video files (*.mp4 *.avi)"]
    }
    MessageDialog{
        id:_about
        title: "About"
        buttons: MessageDialog.Ok
        text:"Video Player"
        informativeText: "This is a video edit.Powered by Qt"
    }
}

