package uengine;

import uengine.data.ObjectData;
import uengine.data.SceneData;

class Scene {
    public static var sceneData:SceneData;

    public static var objects:Array<Object> = [];

    public static function addObject(data:ObjectData/*, done: Object->Void*/):Object {
        var obj = new Object();
        obj.name = data.name;
        obj.props = data;  
        // if(data.scripts != null) for (script in data.scripts) obj.addScript(createScriptInstance(script));
        if(obj.props.type == Sprite) setObjectSprite(obj.props.spriteRef, obj);
        objects.push(obj);
        return obj;
        // done(obj);
    }

    public static function getObject(name:String):Object {
        var obj:Object = null;
        for (object in objects) if(object.name == name) obj = object;
        return obj;
    }

    public static function setObjectSprite(ref:String, obj:Object) {
        kha.Assets.loadImageFromPath(ref, true, function (img){
            obj.image = img;
        });
    }

    public static function parseToScene(scene:String){
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob){
            sceneData = haxe.Json.parse(b.toString());
            for (object in sceneData.objects){
                var obj = addObject(object/*, function (obj){}*/);
                if(object.scripts != null) for (script in object.scripts){
                    obj.addScript(createScriptInstance(script));
                }
            }
        }, function(err: kha.AssetError){
            trace(err.error+'. Make sure $scene.json exist in "Assets" folder and there is not typo.\n');
        });
    }

    public static function createScriptInstance(script:String/*, objectData:ObjectData*/):Dynamic{
        // if(objectData.scripts == null) return;
        // for (script in objectData.scripts){
            var scr = Type.resolveClass("scripts."+script);
            if (scr == null) return null;
            // var cls:Script = Type.createInstance(scr, []);
        // }
        return Type.createInstance(scr, []);
    }
}
