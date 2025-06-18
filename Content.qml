import QtQuick
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls
import Videoedit

Item {
    id:content
    anchors.fill: parent

    property alias player:_player
    property alias dialogs: _dialogs


    Player{
        id:_player
        videoOutput: videoOutput
    }


    VideoOutput{
        id:videoOutput
        anchors.bottom: rec.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top:parent.top
    }

    Dialogs{
        id:_dialogs
        fileOpen{
            onAccepted: {
                player.source=fileOpen.selectedFile
                videoshot.source=fileOpen.selectedFile
                videoshot.shot(10)
            }
            onRejected: {
                console.log("Error:read video file")
                return;
            }
        }
    }

    Rectangle{
        id:rec
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "grey"
        border.color: "black"
        border.width: 2
        Item{
            anchors.fill: parent
            anchors.margins: 2
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: 100
                id: progress
                text: {
                    let totals=Math.floor(player.position/1000)
                    let s=Math.floor(totals%60)
                    let m=Math.floor((totals/60)%60)
                    let h=Math.floor(totals/3600)
                    if(h<10)h="0"+h
                    if(m<10)m="0"+m
                    if(s<10)s="0"+s

                    let time=h+":"+m+":"+s
                    return time
                }
            }
            Slider{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: progress.right
                anchors.right: parent.right

                to:player.duration
                value: player.position

                onMoved: {//仅在拖动时触发
                    player.position=value
                }
                enabled: content.player.source!=""
            }
        }
    }

    VideoShot{
        id:videoshot

    }


}
