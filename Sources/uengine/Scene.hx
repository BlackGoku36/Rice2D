package uengine;

import zui.Canvas.TCanvas;
import uengine.data.ObjectData;
import uengine.data.SceneData;

class Scene {
    public static var sceneData:SceneData;

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
        setObjectSprite(obj.props.spriteRef, obj);
        objects.push(obj);
        return obj;
    }

    public static function getObject(name:String):Object {
        var obj:Object = null;
        for (object in objects) if(object.name == name) obj = object;
        return obj;
    }

    public static function getImage(ref:String) {
        kha.Assets.loadImageFromPath(ref, true, function (img){
            assets.push([ref => img]);
            trace("a"+assets);
        }, function(err: kha.AssetError) {
            trace(err.error+'. Make sure $ref exist in "Assets" folder and there is not typo.\n');
        });
    }
    public static function setObjectSprite(ref:String, obj:Object) {
        for (i in assets){
            if(i.exists(ref)) obj.image = i.get(ref);
        }
    }

    public static function parseToScene(scene:String) {
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob) {
            sceneData = haxe.Json.parse(b.toString());
            for(asset in sceneData.assets){
                getImage(asset);
                trace(assets);
            }
            for (object in sceneData.objects){
                var obj = addObject(object);
            }
            #if u_ui
                parseToCanvas(sceneData.canvasRef);
            #end

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
