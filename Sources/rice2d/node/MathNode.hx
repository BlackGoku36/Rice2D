package rice2d.node;

@:keep
class MathNode extends LogicNode {

	public var operations: String;

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var v1: Float = inputs[0].get();
		var v2: Float = inputs[1].get();
		var f = 0.0;

		switch (operations) {
			case "Add": f = v1 + v2;
			case "Subtract": f = v1 - v2;
			case "Multiply": f = v1 * v2;
			case "Divide": f = v1 / v2;
		}

		return f;
	}
}
