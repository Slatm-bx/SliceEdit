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
        // x: playerSlider.leftPadding
        // y: playerSlider.topPadding + playerSlider.availableHeight / 2 - height / 2
        z:-3
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

    // Rectangle {
    //     id:progress
    //     opacity : 0.3
    //     width: playerSlider.visualPosition * parent.width
    //     height: parent.height
    //     color:"red"
    //     radius: 2
    // }
    property alias playhead:_playhead
    handle: Rectangle {
        id: _playhead
        width: 2; height: parent.height
        x: playerSlider.visualPosition*playerSlider.width  // 绑定位置
        color: playerSlider.pressed ? "#6495ed" : "#00ffff"
    }
    property alias imageList:_imageList
    property alias dataModel:_dataModel

    ListView{
        id:_imageList
        z:-2
        anchors.fill:parent
        model:ListModel {
            id:_dataModel
        }
        delegate:Component {
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
        orientation:ListView.Horizontal
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
            if(source!="")_videoshot.shotThread(source,imageNum,outputPath)
        }
    }

    property alias videoshot: _videoshot
    VideoShot{//视频预览图
        id:_videoshot
        Component.onCompleted: {
            outputPath=tmpPath()+"/VideoShot/";
        }


        onShotFinished: {
            dataModel.clear()
            for(let i=0;i<imageNum;i++){
                dataModel.append({"pictureUrl":"file://"+outputPath+"frame"+i+".jpg"});
            }
        }
    }

    onSourceChanged: {
        if(imageNum>0){
            _videoshot.shotThread(source,imageNum,outputPath)
        }
    }

    //开始裁剪时的蓝色矩形
    property alias tmpCut: _tmpCut
    Rectangle{
        property int startTime:0//meadiaPlayer的一次position
        anchors.top: parent.top
        id:_tmpCut
        color: "#00ffff"
        opacity : 0.3
        visible: false
        x:0
        width:playerSlider.visualPosition * playerSlider.width-x//<0 ? 0:playerSlider.visualPosition * playerSlider.width-x
        // {
        //     let w=playerSlider.visualPosition * playerSlider.width-x
        //     if(w<0) return 0; else return w;
        // }
        height: parent.height
    }

    property alias cutList: _cutList

    Item{
        id:_cutList
        property int sliderWidth: playerSlider.width
        //property int cutNum: 0//让他绑定到_stratCutButton的count属性。
        property int cutNum: lrow.stratCutButton.count
        property var cuts:({})
    }
}
