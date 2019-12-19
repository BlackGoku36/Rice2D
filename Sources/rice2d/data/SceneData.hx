package rice2d.data;

typedef SceneData = {
    public var name: String;
    public var objects: Array<ObjectData>;
    public var assets: AssetData;
    public var ?scripts: Array<String>;
    public var ?canvasRef: String;
}
