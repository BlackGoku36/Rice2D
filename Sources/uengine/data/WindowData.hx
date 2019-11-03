package uengine.data;

typedef WindowData = {
    var width:Int;
    var height:Int;
}

class Window {

    public static var window:WindowData;
    
    public static function parseWindow(func: Void->Void){
        kha.Assets.loadBlobFromPath("window.json", function (b:kha.Blob){
            window = haxe.Json.parse(b.toString());
            func();
        });
    }
}