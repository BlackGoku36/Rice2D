package rice2d.data;

typedef WindowData = {
    var name: String;
    var width: Int;
    var height: Int;
    var windowMode: Int;
    var clearColor: Array<Int>;
}

class Window {
    public static var window:WindowData;

    public static function loadWindow(done: Void->Void) {
        kha.Assets.loadBlobFromPath("window.json", function (b:kha.Blob) {
            window = haxe.Json.parse(b.toString());
            if(window.width == null || window.height == null) trace("Warning: All windows field aren't initialised, it will default to value given by kha.\n");
            done();
        }, function(err: kha.AssetError){
            trace(err.error+". Make sure 'window.json' exist in 'Assets' folder.\n");
        });
    }
}
