package rice2d.node;

class DegToRadNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var degree: Float = inputs[0].get();

		return degree * Math.PI / 180;
	}
}
