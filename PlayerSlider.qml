import QtQuick
import QtQuick.Controls
import QtQml
import Videoedit

Slider {
    property url source
    property int imageNum
    property string outputPath

    id: playerSlider
    width: {
        Math.floor(parent.width/200)*200
    }

    height:150
    value: 0.5
    background: Rectangle {
        id:overallProgress
        x: playerSlider.leftPadding
        y: playerSlider.topPadding + playerSlider.availableHeight / 2 - height / 2
        z:0
        width: playerSlider.width
        height: playerSlider.height
        radius: 2
        color: "white"
        opacity : 1
        Text {
            anchors.centerIn: parent
            id: emptyText
            color: "black"
            text: {
                if(source=="")return "无视频"
                else return "正在加载";
            }
        }

    }


    Rectangle {
        id:progress
        opacity : 0.3
        width: playerSlider.visualPosition * parent.width
        height: parent.height
        color:"red"
        radius: 2
    }
    handle: Rectangle {
        id: playhead
        width: 2; height: parent.height
        x: playerSlider.visualPosition*playerSlider.width // 绑定位置
        color: playerSlider.pressed ? "#6495ed" : "#00ffff"
    }

    property alias imageList:_imageList
    property alias dataModel:_dataModel

    ListView{
        id:_imageList
        z:-1
        anchors.fill:parent
        model:playerSlider.dataModel
        delegate:segment
        orientation:ListView.Horizontal
    }

    ListModel {
        //包含图片url,起始时间，终止时间
        id:_dataModel
    }
    Component {
        id: segment
        Image {
            width:200
            height:150
            id:thumbnail
            cache: false
            fillMode : Image.PreserveAspectFit
            source:model.pictureUrl
        }
    }

    onWidthChanged: {
        dataModel.clear()
        imageNum=Math.floor(width/200)
        resizeTimer.restart()
    }

    Timer {//防止大量截图请求
        id: resizeTimer
        interval: 1000
        repeat: false
        onTriggered: {
            console.log("Width stabilized at:"+parent.width)
            if(source!="")_videoshot.shotThread(source,imageNum,outputPath)
        }
    }

    property alias videoshot: _videoshot
    VideoShot{
        id:_videoshot
        property string tmppath
        Component.onCompleted: {
            outputPath=tmpPath()+"/VideoShot/";

        }


        onShotFinished: {
            dataModel.clear()
            for(let i=0;i<imageNum;i++){
                dataModel.append({"pictureUrl":"file://"+outputPath+"frame"+i+".jpg"});
                console.log("读取:","file://"+outputPath+"frame"+i+".jpg")
            }
        }
    }

    onSourceChanged: {
        if(imageNum>0){
            _videoshot.shotThread(source,imageNum,outputPath)
        }
    }

}
