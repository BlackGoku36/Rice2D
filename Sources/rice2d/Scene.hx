package rice2d;

//Zui
import rice2d.ui.UI;
#if rice_ui
import zui.Canvas.TCanvas;
#end
import rice2d.data.NodeData;

//Engine
import rice2d.node.Logic;
import rice2d.object.Object;
import rice2d.data.SceneData;
import rice2d.data.ObjectData;
import rice2d.data.ScriptData;

class Scene {
	public static var sceneData: SceneData;

	public static var objects: Array<Object> = [];

	public static var scripts: Array<Script> = [];

	public static var uis: Array<UI> = [];

	#if rice_ui
		public static var canvases: Array<zui.Canvas.TCanvas> = [];
	#end

	/**
	 * Adds object to scene
	 * @param data Object's data
	 * @param done Callback function when object is added.
	 * @return Object
	 */
	public static function addObject(data:ObjectData, done:Object->Void = null):Object {
		var obj = new Object();
		obj.name = data.name;
		obj.props = data;

		if(data.scripts != null) for (script in data.scripts) obj.addScript(script);

		obj.sprite = Assets.getAsset(data.spriteRef, Image);

		if(obj.props.rotation == null) obj.props.rotation = 0.0;

		objects.push(obj);
		if(done != null) done(obj);

		return obj;
	}

	/**
	 * Add haxe or node script to scene
	 */
	@:access(rice2d.Script)
	public static function addScript(scriptData: ScriptData) {
		if(StringTools.endsWith(scriptData.scriptRef, ".json")){
			kha.Assets.loadBlobFromPath(scriptData.scriptRef, (blb) -> {
				var nodes:TNodeCanvas = haxe.Json.parse(blb.toString());
				Logic.parse(nodes);
			});
		}else{
			var script = createScriptInstance(scriptData.scriptRef);
			scripts.push(script);
			script.object = null;
			script.name = scriptData.name;
			if(script._add!=null){
				for (add in script._add) add();
				script._add = null;
			}
		}
	}

	/**
		* Get object of name from scene
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
	@:access(rice2d.Script)
	public static function parseToScene(scene:String, done:Void->Void) {
		kha.Assets.loadBlobFromPath(scene+".json", (b) -> {
			sceneData = haxe.Json.parse(b.toString());
			loadAllAssets(sceneData, () -> {
				addAllObjects(sceneData, () -> {
					if(sceneData.scripts.length != 0) for (script in sceneData.scripts){
						if(StringTools.endsWith(script.scriptRef, ".json")){
							kha.Assets.loadBlobFromPath(script.scriptRef, (blb) -> {
								var nodes:TNodeCanvas = haxe.Json.parse(blb.toString());
								Logic.parse(nodes);
							});
						}else{
							var newScript:Script = createScriptInstance(script.scriptRef);
							newScript.object = null;
							newScript.name = script.name;
							if(newScript._add!=null){
								for (add in newScript._add) add();
								newScript._add = null;
							}
							scripts.push(newScript);
						}
					}
					// #if rice_ui
					// if(sceneData.canvasRef != null && sceneData.canvasRef != "") parseToCanvas(sceneData.canvasRef);
					// else trace("Warning! Canvas ref is not set in scene's json");
					// #end
					done();
				});
			});

		}, (err) -> {
			trace(err.error+'. Make sure $scene.json (Scene) exist in "Assets" folder and there is not typo.\n');
		});
	}

	// #if rice_ui
	// 	static function parseToCanvas(canvasRef:String) {
	// 		kha.Assets.loadBlobFromPath(canvasRef+".json", function(b){
	// 			var newCanvas:TCanvas = haxe.Json.parse(b.toString());
	// 			canvases.push(newCanvas);
	// 		}, (err) -> {
	// 			trace(err.error+'. Make sure $canvasRef.json (Canvas) exist in "Assets" folder and there is not typo when referencing from scene.\n');
	// 		});
	// 	}
	// #end

	/**
		* Remove script from scene
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

	static function loadAllAssets(sceneData:SceneData, done:Void->Void) {
		if(sceneData.assets == null || sceneData.assets.length == 0){
			done();
			return;
		}
		for(asset in sceneData.assets){
			Assets.loadAssets(asset, (_) -> {
				trace('Asset ${sceneData.assets.indexOf(asset)+1} of ${sceneData.assets.length} loaded: ${asset.name} (${asset.type})');
				if(sceneData.assets.length == Assets.totalAssets){
					done();
				}
			});
		}
	}

	static function addAllObjects(sceneData:SceneData, done:Void->Void) {
		for (object in sceneData.objects){
			addObject(object, (_) -> {
				if(sceneData.objects.length == objects.length){
					done();
				}
			});
		}
	}
}
