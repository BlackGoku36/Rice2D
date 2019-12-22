package rice2d.node;

@:keep
@:access(rice2d.Script)
class UpdateNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
        tree.notifyOnUpdate(update);
	}

	function update() {
		runOutput(0);
	}
}
