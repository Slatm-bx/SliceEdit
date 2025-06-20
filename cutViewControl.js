function getFileExtension(url) {
    // 正则表达式匹配最后一个点后的非空字符（排除查询参数）//正则表达式末尾的 i 标志使匹配不区分大小写
    const match = /\.([a-z0-9]+)(?:[?#]|$)/i.exec(url);
    // 如果匹配成功则返回小写扩展名，否则返回空字符串
    return match ? match[1].toLowerCase() : "";
}
function removeFileExtension(filePath) {
        // 找到最后一个斜杠的位置（分割路径与文件名）
        const lastSlashIndex = filePath.lastIndexOf('/');
        // 找到最后一个点的位置（分割文件名与后缀）
        const lastDotIndex = filePath.lastIndexOf('.');
        // 如果存在点且在最后一个斜杠之后（确保不是路径中的点）
        if (lastDotIndex > lastSlashIndex) {
            // 截取从开始到点的位置的字符串（不含后缀）
            return filePath.substring(0, lastDotIndex);
        }
        // 没有后缀时返回原路径
        return filePath;
}

function loadStartTime(){
    console.log("开始时间"+videoPlayer.player.position);
    console.log("path:",timeline.playerSlider.outputPath);
    //let _stratCutButton=
    //缩略图路径
    videoPlayer.videoOutput.grabToImage(function(result) {
        let path=timeline.playerSlider.outputPath+_stratCutButton.count+".jpg";//

        result.saveToFile(path);
        videoList.cutView.thumbnailData.append({"videoUrl":videoPlayer.player.source,
                                                "thumUrl":"file://"+path,"startTime":videoPlayer.player.position,"endTime":-1,"cutId":_stratCutButton.count});
        _stratCutButton.count++;
        _stratCutButton.enabled=false;
        _endCutButton.enabled=true;
        //需要禁用拖放功能
    })
}
function loadEndTime(){
    //更新当前视图项
    let model=videoList.cutView.thumbnailData
    model.set(model.count-1,{"endTime":videoPlayer.player.position});//当没有设置endtime时，会对拖放操作造成影响
    if(model.get(model.count-1).startTime>model.get(model.count-1).endTime) {
        let cutErrorDialog=videoPlayer.dialogs.cutErrorDialog;
        cutErrorDialog.open();
        return;
    }
    //model.get(model.count-1).endTime=videoPlayer.player.position;
    //将stratCut设置为true
    _stratCutButton.enabled=true;
    _endCutButton.enabled=false;
}

function formatTime(ms) {
       if (!ms) return "00:00";
       var seconds = Math.floor(ms / 1000);
       var minutes = Math.floor(seconds / 60);
       seconds = seconds % 60;
       return (minutes < 10 ? "0" + minutes : minutes) + ":" +
              (seconds < 10 ? "0" + seconds : seconds);
}
