package rice2d.node;

class FloatToIntNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var float: Float = inputs[0].get();

		return Math.round(float);
	}
}
