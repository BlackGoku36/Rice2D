package rice2d.node;

import kha.math.FastVector2;

class SetObjLocNode extends LogicNode{

    public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var name:String = inputs[1].get();
		var vec2:FastVector2 = inputs[2].get();

        Scene.getObject(name).props.x = vec2.x;
        Scene.getObject(name).props.y = vec2.y;

		runOutput(0);
	}
}