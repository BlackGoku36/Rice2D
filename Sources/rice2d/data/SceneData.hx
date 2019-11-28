package rice2d.data;

typedef SceneData = {
    public var name: String;
    public var objects: Array<ObjectData>;
    public var assets: AssetData;
    public var ?scripts: Array<String>;
    public var ?physicsWorld: echo.data.Options.WorldOptions;
    public var ?canvasRef: String;
}
