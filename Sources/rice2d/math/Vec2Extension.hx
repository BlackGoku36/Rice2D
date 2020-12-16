package rice2d.math;

import kha.math.Vector2;
using rice2d.math.MathExtension;

class Vec2Extension {

    public static function getLengthSq(_: Class<Vector2>, a:Vector2) {
        return a.x * a.x + a.y * a.y;
    }

    public static function getCenter(_: Class<Vector2>, pos:Vector2, width:Float, height:Float) {
        return new Vector2(pos.x - (width/2), pos.y - (height/2));
    }

    // public static function setCenter(_: Class<Vector2>, center:Vector2, width:Float, height:Float) {
    //     return new Vector2(center.x + (width/2), center.y + (height/2));
    // }

    public static function lookAt(_:Class<Vector2>, from:Vector2, to:Vector2) {
        return from.sub(to).normalized();
    }

    public static function clamp(_:Class<Vector2>, value:Vector2, min:Vector2, max:Vector2) {
        value.x = Math.clamp(value.x, min.x, max.x);
        value.y = Math.clamp(value.y, min.y, max.y);
        return value;
    }

    public static function lerp(_:Class<Vector2>, start:Vector2, end:Vector2, dt:Float) {
        return new Vector2(Math.lerp(start.x, end.x, dt), Math.lerp(start.y, end.y, dt));
    }

}
