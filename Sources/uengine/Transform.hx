package uengine;

class Transform{

    public var object:Object;

    public function new() {

    }

    public function getCenter() {
        var x = object.raw.x - (object.raw.width / 2);
        var y = object.raw.y - (object.raw.height / 2);
        return { x : x, y : y}
    }

    public function translate(x:Float, y:Float, s:Float) {
        object.raw.x += x * s;
        object.raw.y += y * s;
    }
}
