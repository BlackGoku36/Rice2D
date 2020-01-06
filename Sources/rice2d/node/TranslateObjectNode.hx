package rice2d.node;

import kha.math.FastVector2;

class TranslateObjectNode extends LogicNode {
    
    public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
        var name:String = inputs[1].get();
        var vec2:FastVector2 = inputs[2].get();
        var speed:Float = inputs[3].get();
        
        Scene.getObject(name).transform.translate(vec2.x, vec2.y, speed);

		runOutput(0);
	}
}