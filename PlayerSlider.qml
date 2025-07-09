//单个视频预览条

import QtQuick
import QtQuick.Controls
import QtQml
import Videoedit

Slider {
    property url source
    property int imageNum
    property int videotime
    property string outputPath
    property string outputName

    id: playerSlider
    width: Math.floor(parent.width/200)*200

    height:150
    value: 0
    background: Rectangle {
        id:overallProgress
        z:-3
        width: playerSlider.width
        height: playerSlider.height
        radius: 2
        color: "#444"
        opacity : 1

        Text {
            visible: _dataModel.count===0
            anchors.centerIn: parent
            id: emptyText
            color: "white"
            text: {
                if(source=="")return "无视频"
                else return "正在加载";
            }
        }
    }
    Rectangle{
        z: 3
        anchors.fill: parent
        color: "transparent"
        border.color: timeline.playerSliderView.currentIndex===index?"#1df":"black"
        border.width: 4
    }

    Text{
        z:4
        anchors.top:parent.top
        anchors.left: parent.left
        anchors.margins: 4
        text: {
            return "视频:"+source.toString().substring(7)
        }
        color: "white"
        style: Text.Outline
        styleColor: "black"
        font.pixelSize:20
    }
    property alias playhead:_playhead
    handle: Rectangle {
        id: _playhead
        width: 2; height: parent.height
        x: playerSlider.visualPosition*playerSlider.width  // 绑定位置
        color: playerSlider.pressed ? "#6495ed" : "#00ffff"
    }
    property alias imageList:_imageList
    property alias dataModel:_dataModel

    function timeToTime(num){//时间转换字符串
        let totals=videotime*(num+1)/2/imageNum
        let s=Math.floor(totals%60)
        let m=Math.floor((totals/60)%60)
        let h=Math.floor(totals/3600)
        if(h<10)h="0"+h
        if(m<10)m="0"+m
        if(s<10)s="0"+s

        return h+":"+m+":"+s
    }

    ListView{
        id:_imageList
        z:-2
        anchors.fill:parent
        model:ListModel {
            id:_dataModel
        }
        delegate:Component {
            id: segment
            Item{
                width: 200
                height: 150
                Image {
                    width:200
                    height:150
                    id:thumbnail
                    cache: false
                    fillMode : Image.PreserveAspectFit
                    source:model.pictureUrl
                    clip: true
                    Text {
                        id: stamptime1
                        color: "white"
                        style: Text.Outline
                        styleColor: "black"


                        text: timeToTime(index*2)
                        anchors.bottom: parent.bottom
                        anchors.right: stamp1.left
                    }
                    Rectangle{
                        id:stamp1
                        height: 15
                        width: 2
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom

                    }
                    Text {
                        id: stamptime2
                        color: "white"
                        style: Text.Outline
                        styleColor: "black"

                        text: timeToTime(index*2+1)
                        anchors.bottom: parent.bottom
                        anchors.right: stamp2.left
                    }
                    Rectangle{
                        id:stamp2
                        height: 20
                        width: 2
                        color: "white"
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                    }
                }
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
            console.log(source,imageNum,outputName)
            if(source!="")_videoshot.shotThread(source,imageNum,outputName)
        }
    }

    property alias videoshot: _videoshot
    VideoShot{//视频预览图
        id:_videoshot
        Component.onCompleted: {
            let lastIndex=source.toString().lastIndexOf("/")
            let fileName=source.toString().substring(lastIndex+1);
            lastIndex=fileName.lastIndexOf(".")
            outputPath=tmpPath()+"/SliceEdit/";
            outputName=outputPath+fileName.substring(0,lastIndex-1)+fileName.substring(lastIndex+1)+"_"
        }


        onShotFinished: function(time){//接收信号数据
            videotime=time
            console.log("qml中时间:",videotime)
            dataModel.clear()
            for(let i=0;i<imageNum;i++){
                dataModel.append({"pictureUrl":"file://"+outputName+"frame"+i+".jpg"});
            }

        }
    }

    onSourceChanged: {
        if(imageNum>0){
            console.log(source,imageNum,outputName)
            _videoshot.shotThread(source,imageNum,outputName)
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

    Component.onCompleted: {
        console.log("width:",width," height:",height)
    }
}
