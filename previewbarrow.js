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
    _tmpCut.visible=false
    _tmpCut.startTime=0
    if(endTime<startTime)return

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
    console.log("添加:"+playerSlider.source+" "+(playerSlider.cutList.cutNum-1))
    timeline.playerSlider.tmpCut.startTime=0;
    //使用 property var cuts: ({}) 定义一个属性时，实际上创建的是一个空对象（Object），而不是数组。
}

function deleteOneCutFunction(path,cutId){
    //如果是有结束时间的切片
    for(let i=0;i!==timeline.playerSliderView.count;i++){
        let item=timeline.playerSliderView.itemAtIndex(i)
        if(item.source===path){
            let cutList=item.cutList//用于存储红色矩形的对象
            console.log("删除:"+path+" "+cutId)
            if(cutId<cutList.cutNum && cutId>=0 && cutList.cuts.hasOwnProperty(cutId))cutList.cuts[cutId].destroy()
        }
    }
}

function changePreviewBarListIndex(path,position){//采用遍历防止动态修改导致不对应
    for(let i=0;i!==timeline.playerSliderModel.count;i++){
        let item=timeline.playerSliderModel.get(i)

        //切换轨道和改变视频播放位置
        if(item.source===path){

            //解除旧绑定
            timeline.playerSlider.value=timeline.playerSlider.value
            timeline.playerSlider.to=timeline.playerSlider.to

            _VP.player.position=position
            timeline.playerSliderView.currentIndex=i
            console.log("切换到轨道:",i,"  时间设为:",position)

            //_VP.player.source=timeline.playerSlider.source
            // timeline.playerSlider.value=Qt.binding(function(){return _VP.player.position})
            // timeline.playerSlider.to=Qt.binding(function(){return _VP.player.duration})
            // _VP.player.play()
            //_VP.player.position=position

            return
        }
    }
}

function sameFile(path){
    for(let i=0;i!==timeline.playerSliderModel.count;i++){
        let item=timeline.playerSliderModel.get(i)
        if(item.source===path)return true
    }
    return false
}
