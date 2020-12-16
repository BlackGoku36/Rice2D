package rice2d;

//Kha
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Camera {
    public var x: Float;
    public var y: Float;
    public var active = false;
    public var transform: FastMatrix3;

    /**
     * Create new camera object
     */
    public function new() {
        transform = FastMatrix3.identity();
    }

    /**
     * Set camera
     * @param g
     */
    public function set(g:Graphics) {
        active = true;
        g.pushTransformation(transform);
        g.translate(-x, -y);
    }

    /**
     * Unset camera
     * @param g
     */
    public function unset(g:Graphics) {
        g.popTransformation();
        active = false;
    }

}
