package rice2d.node;

class ParseIntNode extends LogicNode {

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var string: String = inputs[0].get();

		return Std.parseInt(string);
	}
}
