package uengine.system;

//Kha
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
    public var x: Float;
    public var y: Float;
    public var active = false;
    public var transform: FastMatrix3;

    public function new() {
        transform = FastMatrix3.identity();
    }

    public function set(g:Graphics) {
        active = true;
        g.pushTransformation(transform);
        g.translate(-x, -y);
    }

    public function unset(g:Graphics) {
        g.popTransformation();
        active = false;
    }

}
