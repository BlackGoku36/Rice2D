package uengine.data;

typedef ObjectData = {
    public var name:String;
    public var x: Int;
    public var y: Int;
    public var height: Int;
    public var width: Int;
    public var type: ObjectType;
    public var color: Array<Int>;
    @:optional public var scripts: Array<String>;
}

@:enum abstract ObjectType(Int) from Int to Int {
    var Rect = 0;
    var FillRect = 1;
    var Circle = 2;
    var FillCircle = 3;
    var Triangle = 4;//TODO: Add triangel support
    var FillTriangle = 5;//TODO: Add triangel support
    var Sprite = 6;//TODO: Add sprite support
}