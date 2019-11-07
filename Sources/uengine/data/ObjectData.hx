package uengine.data;

typedef ObjectData = {
    public var name: String;
    public var x: Float;
    public var y: Float;
    public var height: Int;
    public var width: Int;
    public var type: ObjectType;
    @:optional public var spriteRef: String;
    @:optional public var color: Array<Int>;
    @:optional public var scripts: Array<String>;
}

@:enum abstract ObjectType(Int) from Int to Int {
    var Rect = 0;
    var FillRect = 1;
    var Circle = 2;
    var FillCircle = 3;
    var Triangle = 4;//TODO: Add triangel support
    var FillTriangle = 5;//TODO: Add triangel support
    var Sprite = 6;
}
