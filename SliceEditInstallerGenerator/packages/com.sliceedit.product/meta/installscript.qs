function Component(component) {
    // 构造函数 (官方文档咋没写)
}

Component.prototype.createOperations = function(){
    component.createOperations();

    //https://doc.qt.io/qtinstallerframework/operations.html所有操作
    component.addOperation("Move","@TargetDir@/SliceEdit.png","/usr/local/share/icons/SliceEdit.png")

    component.addOperation("CreateDesktopEntry","SliceEdit.desktop","\nName=SliceEdit\n Exec=@TargetDir@/SliceEdit\n Terminal=false\n Icon=SliceEdit\nType=Application\n Categories=Qt;Video;AudioVideo;AudioVideoEditing\n")

}
