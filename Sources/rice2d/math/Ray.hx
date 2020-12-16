package rice2d.math;

import kha.math.Vector2;

@:structInit
class Ray {

    public var origin: Vector2;
    public var direction: Vector2;

    public inline function new(origin: Vector2, direction: Vector2): Void {
        this.origin = origin;
        this.direction = direction;
    }

    public inline function pointAt(t:Float) {
        return origin.add(direction.mult(t));
    }

    public static function intersectCircle(ray:Ray, t_min:Float, t_max:Float, circleCenter:Vector2, radius:Float) {
        // https://stackoverflow.com/a/1084899
        var d = ray.direction;
        var f = ray.origin.sub(circleCenter);
        var a = d.dot(d);
        var b = 2*f.dot(d);
        var c = f.dot(f) - radius*radius;
        var D = b*b-4*a*c;

        if(D < 0.0) return {r: ray, t:null, didHit: false, hitPoint: null, normal: null}; //No hit

        D = Math.sqrt(D);

        var t1 = (-b - D)/(2*a);
        var t2 = (-b - D)/(2*a);

        if( t1 > t_min && t1 < t_max ){
            var hitPoint = ray.pointAt(t1);
            return {
                r: ray, t:t1, didHit: true, hitPoint: hitPoint, normal: hitPoint.sub(circleCenter).normalized()
            };
        }
        if( t2 > t_min && t2 < t_max ){
            var hitPoint = ray.pointAt(t2);
            return {
                r: ray, t:t2, didHit: true, hitPoint: hitPoint, normal: hitPoint.sub(circleCenter).normalized()
            };
        }

        return {r: ray, t:null, didHit: false, hitPoint: null, normal: null};
    }
}
