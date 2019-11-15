package magnum2d.data;

typedef ObjectData = {
    public var name: String;
    public var x: Float;
    public var y: Float;
    public var height: Int;
    public var width: Int;
    @:optional public var rigidBodyData: echo.data.Options.BodyOptions;
    @:optional public var culled: Bool;
    @:optional public var spriteRef: String;
    @:optional public var color: Array<Int>;
    @:optional public var scripts: Array<ScriptData>;
}
