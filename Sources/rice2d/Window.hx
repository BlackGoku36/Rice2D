package rice2d;

class Window {
    public static var window:rice2d.data.WindowData;

    public static function loadWindow(done: Void->Void) {
        kha.Assets.loadBlobFromPath("window.json", function (b:kha.Blob) {
            window = haxe.Json.parse(b.toString());
            if(window.width == null || window.height == null || window.windowMode == null || window.clearColor == null){ 
                trace("Warning: All windows field aren't initialised, it will default to value given by kha.\n");
            }
            done();
        }, function(err: kha.AssetError){
            trace(err.error+". Make sure 'window.json' exist in 'Assets' folder.\n");
        });
    }
}