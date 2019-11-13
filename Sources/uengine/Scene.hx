package uengine;

//Engine
import uengine.data.SceneData;
import uengine.data.ObjectData;

class Scene {
    public static var sceneData:SceneData;

    #if u_physics
    public static var world: echo.World;
    #end

    public static var objects:Array<Object> = [];

    public static var assets:Array<Map<String,kha.Image>> = [];

    #if u_ui
        public static var canvases: Array<zui.Canvas.TCanvas> = [];
    #end

    public static function addObject(data:ObjectData):Object {
        var obj = new Object();
        obj.name = data.name;
        obj.props = data;
        if(data.scripts != null) for (script in data.scripts) obj.addScript(createScriptInstance(script));
        setObjectSprite(data.spriteRef, obj);
        #if u_physics
        if(data.rigidBodyData != null){
            if(data.rigidBodyData.x == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.y == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.shape.width == null) data.rigidBodyData.shape.width = data.width;
            if(data.rigidBodyData.shape.height == null) data.rigidBodyData.shape.height = data.height;
            obj.body = world.add(new echo.Body(data.rigidBodyData));
        }
        #end
        objects.push(obj);

        return obj;
    }

    public static function getObject(name:String, layer:Array<Object>):Object {
        var obj:Object = null;
        for (object in layer) if(object.name == name) obj = object;
        return obj;
    }

    public static function setObjectSprite(ref:String, obj:Object) {
        for (i in assets){
            if(i.exists(ref)) obj.sprite = i.get(ref);
        }
    }

    public static function loadAssets(sceneData: SceneData, done:Void->Void) {
        for (asset in sceneData.assets){
            kha.Assets.loadImageFromPath(asset, true, function (img){
                assets.push([asset => img]);
                if(assets.length == sceneData.assets.length) done();
            }, function(err: kha.AssetError) {
                trace(err.error+'. Make sure $asset exist in "Assets" folder and there is not typo.\n');
            });
        }
    }

    public static function parseToScene(scene:String, done:Void->Void) {
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob) {
            sceneData = haxe.Json.parse(b.toString());
            loadAssets(sceneData, function (){
                for (object in sceneData.objects) addObject(object);
            });
            #if u_ui
                parseToCanvas(sceneData.canvasRef);
            #end
            #if u_physics
                world = echo.Echo.start(sceneData.physicsWorld);
                world.listen();
            #end
            done();
        }, function(err: kha.AssetError) {
            trace(err.error+'. Make sure $scene.json exist in "Assets" folder and there is not typo.\n');
        });
    }

    #if u_ui
        static function parseToCanvas(canvasRef:String) {
            kha.Assets.loadBlobFromPath(canvasRef+".json", function(b){
                var newCanvas:TCanvas = haxe.Json.parse(b.toString());
                canvases.push(newCanvas);
            }, function(err: kha.AssetError) {
                trace(err.error+'. Make sure $canvasRef.json exist in "Assets" folder and there is not typo when referencing from scene.\n');
            });
        }
    #end

    public static function createScriptInstance(script:String):Dynamic {
        var scr = Type.resolveClass("scripts."+script);
        if (scr == null) return null;
        return Type.createInstance(scr, []);
    }
}
