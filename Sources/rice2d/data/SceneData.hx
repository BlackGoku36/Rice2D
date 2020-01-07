package rice2d.data;

typedef SceneData = {
	var name: String;
	var objects: Array<ObjectData>;
	var assets: Array<AssetData>;
	var ?scripts: Array<ScriptData>;
	var ?canvasRef: String;
}
