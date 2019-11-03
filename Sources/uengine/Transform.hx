package uengine;

class Transform{
    
    public static function getObjectCenter(object: uengine.data.ObjectData) {
        var x = object.x - (object.width / 2);
        var y = object.y - (object.height / 2);
        return { x : x, y : y}
    }

    public static function translateObject(object:uengine.data.ObjectData, x:Float, y:Float, s:Float) {
        object.x += x * s;
        object.y += y * s;
    }
}