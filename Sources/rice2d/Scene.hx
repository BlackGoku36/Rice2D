package rice2d;

//Zui
import zui.Canvas.TCanvas;

//Engine
import rice2d.data.SceneData;
import rice2d.data.ObjectData;
import rice2d.object.Object;

class Scene {
    public static var sceneData: SceneData;

    #if rice_physics
    public static var physics_world: echo.World;
    #end

    public static var objects: Array<Object> = [];

    public static var assets: Array<Map<String,kha.Image>> = [];

    public static var scripts: Array<Script> = [];

    #if rice_ui
        public static var canvases: Array<zui.Canvas.TCanvas> = [];
    #end

    public static function addObject(data:ObjectData):Object {
        var obj = new Object();
        obj.name = data.name;
        obj.props = data;
        if(data.scripts != null) for (script in data.scripts) obj.addScript(script.name, createScriptInstance(script.scriptRef));
        setObjectSprite(data.spriteRef, obj);
        #if rice_physics
        if(data.rigidBodyData != null){
            if(data.rigidBodyData.x == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.y == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.shape.width == null) data.rigidBodyData.shape.width = data.width;
            if(data.rigidBodyData.shape.height == null) data.rigidBodyData.shape.height = data.height;
            obj.body = physics_world.add(new echo.Body(data.rigidBodyData));
        }
        #end
        objects.push(obj);

        return obj;
    }

    public static function getObject(name:String):Object {
        var obj:Object = null;
        for (object in objects) if(object.name == name) obj = object;
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
            if(sceneData.scripts != null) for (script in sceneData.scripts) scripts.push(createScriptInstance(script));
            #if rice_ui
                parseToCanvas(sceneData.canvasRef);
            #end
            #if rice_physics
                physics_world = echo.Echo.start(sceneData.physicsWorld);
                physics_world.listen();
            #end
            done();
        }, function(err: kha.AssetError) {
            trace(err.error+'. Make sure $scene.json exist in "Assets" folder and there is not typo.\n');
        });
    }

    #if rice_ui
        static function parseToCanvas(canvasRef:String) {
            kha.Assets.loadBlobFromPath(canvasRef+".json", function(b){
                var newCanvas:TCanvas = haxe.Json.parse(b.toString());
                canvases.push(newCanvas);
            }, function(err: kha.AssetError) {
                trace(err.error+'. Make sure $canvasRef.json exist in "Assets" folder and there is not typo when referencing from scene.\n');
            });
        }
    #end

    @:access(rice2d.Script)
    public function removeScript(script: Script) {

        if(script._update != null){
            for (update in script._update) App.removeUpdate(update);
            script._update = null;
        }

        if(script._render != null){
            for (render in script._render) App.removeRender(render);
            script._render = null;
        }

        if(script._remove != null){
            for (remove in script._remove) remove();
            script._remove = null;
        }

        scripts.remove(script);

    }

    public static function createScriptInstance(script:String):Dynamic {
        var scr = Type.resolveClass("rice."+script);
        if (scr == null) return null;
        return Type.createInstance(scr, []);
    }
}
