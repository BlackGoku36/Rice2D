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
        App.notifyOnUpdate(
            function (){
                for (object in Scene.objects) {
                    checkCull(object);
                }
            }
        );
    }

    public function set(g:Graphics) {
        g.pushTransformation(transform);
        g.translate(-x, -y);
    }

    public function unset(g:Graphics) {
        g.popTransformation();
    }

    public function checkCull(obj:Object){
        var props = obj.props;
        var a:Bool; var b:Bool;
        if (props.x < x) a = x < props.x + props.width;
		else a = props.x < x + Window.get(0).width;
		if (props.y < y) b = y < props.y + props.height;
		else b = props.y < y + Window.get(0).height;

        props.culled = a && b;
        // if(!props.culled) trace(props.name+" culled");
    }

}