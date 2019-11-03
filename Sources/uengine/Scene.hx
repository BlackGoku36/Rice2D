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
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob){
            sceneData = haxe.Json.parse(b.toString());
        }, function(err: kha.AssetError){
            trace(err.error+'. Make sure $scene.json exist in "Assets" folder and there is not typo.\n');
        });
    }

    public static function createScriptInstance(){
        if(Scene.sceneData == null) return;

        for (object in sceneData.objects){
            if(object.scripts == null) return;
            for (script in object.scripts){
                var scr = Type.resolveClass("scripts."+script);
                if (scr == null) return;
                var cls:Script = Type.createInstance(scr, []);
                cls.object = object;
            }
        }   
    }
}