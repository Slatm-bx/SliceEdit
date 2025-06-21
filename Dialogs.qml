import QtQuick
import QtQuick.Dialogs

Item {
    property alias fileOpen: _fileOpen
    property alias about:_about
    property alias saveDialog:_saveDialog
    property alias cutErrorDialog:_cutError
    property alias deleteInMiddleDialog:_deleteInMiddle

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

    FileDialog{
        id:_saveDialog
        title:"save video"
        currentFolder: "./"
        fileMode:FileDialog.SaveFile
        nameFilters: ["Vidoe File(*.mp4 *avi *mkv)"]
    }

    MessageDialog{
        id:_cutError
        title: "CutError"
        buttons: MessageDialog.Ok
        text:"Video Player"
        informativeText: "The selected time is incorrect."
    }

    MessageDialog{
        id:_deleteInMiddle
        title: "delete In Middle"
        buttons: MessageDialog.Ok
        text:"Video Player"
        informativeText: "The chapter is deleted."
    }
}

