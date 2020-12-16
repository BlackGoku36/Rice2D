package rice2d.math;

class MathExtension {

    public static function clamp(_: Class<Math>, value:Float, min:Float, max:Float) {
        if (value < min) return min;
        else if (value > max) return max;
        else return value;
    }

    /**
        * Linearly interpolate (lerp)
        * @param start start value of lerp
        * @param end end value of lerp
        * @param dt attribute of lerp
        * @return Float lerp's value
        */
    public static function lerp(_: Class<Math>, start:Float, end:Float, dt:Float):Float{
        return (1 - dt) * start + dt * end;
    }

}
