package rice2d.object;

class Transform{

    public var object: Object;

    public function new() {}

    /**
     * Get object center
     */
    public function getCenter() {
        var x: Float;
        var y: Float;
        #if rice_physics
        if(object.body.mass != 0){
            x = object.body.x - (object.props.rigidBodyData.shape.width / 2);
            y = object.body.y - (object.props.rigidBodyData.shape.height / 2);
        }else{
            x = object.props.x - (object.props.width / 2);
            y = object.props.y - (object.props.height / 2);
        }
        #else
            x = object.props.x - (object.props.width / 2);
            y = object.props.y - (object.props.height / 2);
        #end
        return { x : x, y : y}
    }

    /**
     * Translate object
     * @param x 
     * @param y 
     * @param s 
     */
    public function translate(x:Float, y:Float, s:Float) {
        object.props.x += x * s;
        object.props.y += y * s;
    }
}
