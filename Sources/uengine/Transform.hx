package uengine;

class Transform{

    public var object:Object;

    public function new() {

    }

    public function getCenter() {
        var x = object.props.x - (object.props.width / 2);
        var y = object.props.y - (object.props.height / 2);
        return { x : x, y : y}
    }

    public function translate(x:Float, y:Float, s:Float) {
        object.props.x += x * s;
        object.props.y += y * s;
    }
}
