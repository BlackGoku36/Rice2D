package rice2d.node;

@:keep
class RandFNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {
		var min: Float = inputs[0].get();
		var max: Float = inputs[1].get();
		return Math.random() * (max - min) + min;
	}
}
