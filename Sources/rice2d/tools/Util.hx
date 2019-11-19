package rice2d.tools;

class Util {

    public static function getCenter(x:Float, y:Float, width:Float, height:Float) {
        return { x: x - (width / 2), y: y - (height / 2) }
    }

    public static function randomRangeF(min:Float, max:Float):Float {
        return Math.random() * (max - min) + min;
    }

    public static function randomRangeI(min:Float, max:Float):Int {
        return Math.round( Math.random() * (max - min) + min);
    }
}
