package uengine;

import uengine.data.ObjectData;
import uengine.data.SceneData;

class Scene {
    public static var sceneData:SceneData;

    public static function getObject(name:String):ObjectData {
        var obj:ObjectData = null;
        for (object in sceneData.objects) if(object.name == name) obj = object;
        return obj;
    }

    public static function parseToScene(scene:String){
        kha.Assets.loadBlobFromPath(scene, function (b:kha.Blob){
            sceneData = haxe.Json.parse(b.toString());
        });
    }

    public static function createScriptInstance(){
        for (object in sceneData.objects){
            if(object.scripts == null) return;
            for (script in object.scripts){
                var scr = Type.resolveClass("src."+script);
                if (scr == null) return;
                var cls:Script = Type.createInstance(scr, []);
                cls.object = object;
            }
        }   
    }
}