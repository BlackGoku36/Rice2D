package rice2d.node;

class RadToDegNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var radian: Float = inputs[0].get();

		return radian * 180 / Math.PI;
	}
}
