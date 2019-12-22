package rice2d.node;

class VectorNode extends LogicNode {

	var value = new kha.math.FastVector2();

	public function new(tree: LogicTree, x: Null<Float> = null, y: Null<Float> = null) {
		super(tree);

		if (x != null) {
			addInput(new FloatNode(tree, x), 0);
			addInput(new FloatNode(tree, y), 0);
		}
	}

	override function get(from: Int): Dynamic {
		value.x = inputs[0].get();
		value.y = inputs[1].get();
		return value;
	}

	override function set(value: Dynamic) {
		inputs[0].set(value.x);
		inputs[1].set(value.y);
	}
}