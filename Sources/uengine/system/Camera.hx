package uengine.system;

import kha.Window;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
    public var x:Float;
    public var y:Float;
    public var transform:FastMatrix3;

    public function new() {
        transform = FastMatrix3.identity();
    }

    public function set(g:Graphics) {
        g.pushTransformation(transform);
        g.translate(-x, -y);
    }

    public function unset(g:Graphics) {
        g.popTransformation();
    }

}