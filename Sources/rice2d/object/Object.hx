package rice2d.object;

// Engine
import rice2d.node.Logic;
import rice2d.data.NodeData;
import rice2d.data.ScriptData;

class Object {

	public var name = "";
	public var props: rice2d.data.ObjectData = null;
	public var transform: Transform = null;
	public var sprite: kha.Image;
	public var animation: Animation = Animation.create(0);
	public var scripts: Array<Script> = [];
	public var visibile = true;
	public var selected = false;
	public var shader: rice2d.shaders.Shader;

	/**
		* Create new object
		*/
	public function new() {
		transform = new Transform();
		transform.object = this;
	}

	/**
		* Remove itself
		*/
	public function remove() {
		if(scripts != null) for(script in scripts) removeScript(script);
		Scene.objects.splice(Scene.objects.indexOf(this), 1);
	}

	/**
	 * Add haxe or node script to object
	 * @param scriptData Script's data
	 */
	@:access(rice2d.Script)
	public function addScript(scriptData: ScriptData) {
		if(StringTools.endsWith(scriptData.scriptRef, ".json")){
			kha.Assets.loadBlobFromPath(scriptData.scriptRef, function (blb){
				var nodes:TNodeCanvas = haxe.Json.parse(blb.toString());
				Logic.parse(nodes);
			});
		}else{
			var script = createScriptInstance(scriptData.scriptRef);
			scripts.push(script);
			script.object = this;
			script.name = scriptData.name;
			if(script._add!=null){
				for (add in script._add) add();
				script._add = null;
			}
		}
	}

	/**
		* Get script
		* @param name Name of script
		* @return Script
		*/
	public function getScript(name: String): Script {
		var scr:Script = null;
		for (script in scripts) if (script.name == name) scr = script;
		return scr;
	}

	/**
		* Set object's animation
		* @param anim
		*/
	public function setAnimation(anim: Animation): Void {
		animation.take(anim);
	}

	/**
		* Set object's sprite
		* @param sprite
		*/
	public function setSprite(sprite: kha.Image) {
		this.sprite = sprite;
	}

	/**
		* Remove script from object
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
