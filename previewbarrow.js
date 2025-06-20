//预览条的截视频显示

function startCutFunction() {
    let _tmpCut=timeline.playerSlider.tmpCut
    _tmpCut.startTime=videoPlayer.player.position
    _tmpCut.x=timeline.playerSlider.visualPosition * timeline.playerSlider.width
    _tmpCut.visible=true
}

//别动代码极易报错
function endCutFunction(){
    let _tmpCut=timeline.playerSlider.tmpCut
    let playerSlider=timeline.playerSlider
    _tmpCut.visible=false

    let startTime=_tmpCut.startTime,endTime=videoPlayer.player.position
    if(endTime<startTime)return
    let str=`import QtQuick

    Rectangle {
            z:-1
            property int startTime:`+_tmpCut.startTime+`
            property int endTime:`+videoPlayer.player.position+`
            property int cutId:`+(playerSlider.cutList.cutNum)+`
            height: `+playerSlider.height+`
            x:parent.sliderWidth*`+startTime/playerSlider.to+`
            width: parent.sliderWidth*`+(endTime-startTime)/playerSlider.to+`
            color: "red"
            opacity : 0.3
    }`
    timeline.playerSlider.cutList.cuts[playerSlider.cutList.cutNum]=Qt.createQmlObject(str,timeline.playerSlider.cutList
                 )
    playerSlider.cutList.cutNum++
}

// function clearCutFunction(){
//     let cutList=timeline.playerSlider.cutList
//     console.log("删除!")
//     for(let i=0;i!=timeline.playerSlider.cutList.cutNum;i++){
//         console.log("删除:"+i)
//         cutList.cuts[i].destroy()
//     }
// }

function deleteOneCutFunction(cutId){
    let cutList=timeline.playerSlider.cutList
    console.log("删除:"+cutId)
    if(cutId<cutList.cutNum && cutId>=0)cutList.cuts[cutId].destroy()
}
