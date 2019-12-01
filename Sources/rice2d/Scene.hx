package rice2d;

//Zui
#if rice_ui
import zui.Canvas.TCanvas;
#end

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

    public static var scripts: Array<Script> = [];

    #if rice_ui
        public static var canvases: Array<zui.Canvas.TCanvas> = [];
    #end

    /**
     * Add object to scene
     * @param data Object's data
     * @return Object
     */
    public static function addObject(data:ObjectData):Object {
        var obj = new Object();
        obj.name = data.name;
        obj.props = data;
        if(data.scripts != null) for (script in data.scripts) obj.addScript(script.name, createScriptInstance(script.scriptRef));
        obj.sprite = Assets.getImage(data.spriteRef);
        #if rice_physics
        if(data.rigidBodyData != null){
            if(data.rigidBodyData.x == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.y == null) data.rigidBodyData.x = data.x;
            if(data.rigidBodyData.shape.width == null) data.rigidBodyData.shape.width = data.width;
            if(data.rigidBodyData.shape.height == null) data.rigidBodyData.shape.height = data.height;
            obj.body = physics_world.add(new echo.Body(data.rigidBodyData));
        }
        #end
        if(data.shaderData!=null) obj.shader = new Shader(data.shaderData);
        objects.push(obj);

        return obj;
    }

    /**
     * Get object from scene
     * @param name Name of object
     * @return Object
     */
    public static function getObject(name:String):Object {
        var obj:Object = null;
        for (object in objects) if(object.name == name) obj = object;
        return obj;
    }

    /**
     * Parse scene from scene's json.
     * @param scene File name of scene's json.
     * @param done To execute when done parsing.
     */
    public static function parseToScene(scene:String, done:Void->Void) {
        kha.Assets.loadBlobFromPath(scene+".json", function (b:kha.Blob) {
            sceneData = haxe.Json.parse(b.toString());
            //TODO: Improve Asset loading
            #if rice_physics
                physics_world = echo.Echo.start(sceneData.physicsWorld);
                physics_world.listen();
            #end
            Assets.loadImagesFromScene(sceneData.assets.images, function(){
                for (object in sceneData.objects) addObject(object);
            });
            Assets.loadFontsFromScene(sceneData.assets.fonts, function (){});
            Assets.loadSoundsFromScene(sceneData.assets.sounds, function (){});
            Assets.loadBlobsFromScene(sceneData.assets.blobs, function (){});

            if(sceneData.scripts != null) for (script in sceneData.scripts) scripts.push(createScriptInstance(script));
            #if rice_ui
                parseToCanvas(sceneData.canvasRef);
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

    /**
     * Remove script from scene
     * @param script
     */
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

    static function createScriptInstance(script:String):Dynamic {
        var scr = Type.resolveClass("scripts."+script);
        if (scr == null) return null;
        return Type.createInstance(scr, []);
    }
}
