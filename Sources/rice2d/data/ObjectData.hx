package rice2d.data;

typedef ObjectData = {
    public var ?id: Int;
    public var name: String;
    public var x: Float;
    public var y: Float;
    public var height: Float;
    public var width: Float;
    public var rotation:Float;
    public var animate:Bool;
    #if rice_physics
    public var ?rigidBodyData: echo.data.Options.BodyOptions;
    #end
    public var ?culled: Bool;
    public var ?spriteRef: String;
    public var ?color: Array<Int>;
    public var ?scripts: Array<ScriptData>;
}
