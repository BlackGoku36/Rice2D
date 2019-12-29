package rice2d.data;

typedef SceneData = {
    public var name: String;
    public var objects: Array<ObjectData>;
    public var assets: AssetData;
    var ?scripts: Array<ScriptData>;
    public var ?canvasRef: String;
}
