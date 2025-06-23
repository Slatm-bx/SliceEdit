//预览条的截视频显示

function startCutFunction() {
    let _tmpCut=timeline.playerSlider.tmpCut
    _tmpCut.startTime=videoPlayer.player.position
    _tmpCut.x=timeline.playerSlider.visualPosition * timeline.playerSlider.width
    _tmpCut.visible=true
}

//预览条上的切片显示
function endCutFunction(){
    let _tmpCut=timeline.playerSlider.tmpCut
    let playerSlider=timeline.playerSlider

    let startTime=_tmpCut.startTime,endTime=videoPlayer.player.position
    if(endTime<startTime)return
    _tmpCut.visible=false

    //用字符串导入qml对象并绑定
    let str=`import QtQuick

    Rectangle {
            z:-1
            property int startTime:`+_tmpCut.startTime+`
            property int endTime:`+videoPlayer.player.position+`
            property int cutId:`+(playerSlider.cutList.cutNum-1)+`//-1
            height: `+playerSlider.height+`
            x:parent.sliderWidth*`+startTime/playerSlider.to+`
            width: parent.sliderWidth*`+(endTime-startTime)/playerSlider.to+`
            color: "red"
            opacity : 0.3
    }`
    timeline.playerSlider.cutList.cuts[playerSlider.cutList.cutNum-1]=Qt.createQmlObject(str,timeline.playerSlider.cutList
                 )
    timeline.playerSlider.tmpCut.startTime=0;
    //使用 property var cuts: ({}) 定义一个属性时，实际上创建的是一个空对象（Object），而不是数组。
}

// function clearCutFunction(){
//     // let cutList=timeline.playerSlider.cutList
//     // console.log("删除!")
//     // for(let i=0;i!=timeline.playerSlider.cutList.cutNum;i++){
//     //     console.log("删除:"+i)
//     //     cutList.cuts[i].destroy()
//     // }
// }

function deleteOneCutFunction(cutId){
    //如果是有结束时间的切片
    let cutList=timeline.playerSlider.cutList//用于存储红色矩形的对象
    console.log("删除:"+cutId)
    if(cutId<cutList.cutNum && cutId>=0 && cutList.cuts.hasOwnProperty(cutId))cutList.cuts[cutId].destroy()
}
