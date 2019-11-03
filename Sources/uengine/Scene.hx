package uengine;

import uengine.data.ObjectData;
import uengine.data.SceneData;

class Scene {
    public static var sceneData:SceneData;

    public static var objects:Array<Object> = [];

    public static function getObject(name:String):Object {
        var obj:Object = null;
        for (object in objects) if(object.name == name) obj = object;
        return obj;
    }

    public static function parseToScene(scene:String){
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob){
            sceneData = haxe.Json.parse(b.toString());
            for (object in sceneData.objects){
                var obj = new Object();
                obj.name = object.name;
                obj.raw = object;
                createScriptInstance(obj, object);
                objects.push(
                    obj
                );
            }
        }, function(err: kha.AssetError){
            trace(err.error+'. Make sure $scene.json exist in "Assets" folder and there is not typo.\n');
        });
    }

    public static function createScriptInstance(object:Object, objectData:ObjectData){
        if(objectData.scripts == null) return;
        for (script in objectData.scripts){
            var scr = Type.resolveClass("scripts."+script);
            if (scr == null) return;
            var cls:Script = Type.createInstance(scr, []);
            cls.object = object;
        }
    }
}
