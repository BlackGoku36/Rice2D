package rice2d.data;

typedef ObjectData = {
	var ?id: Int;
	var name: String;
	var x: Float;
	var y: Float;
	var height: Float;
	var width: Float;
	var ?rotation: Float;
	var animate:Bool;
	var ?labels: Array<String>;
	var ?spriteRef: String;
	var ?color: Array<Int>;
	var ?scripts: Array<ScriptData>;
}
