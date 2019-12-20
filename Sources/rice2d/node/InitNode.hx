package rice2d.node;

@:access(rice2d.Script)
class InitNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnInit(init);
	}

	function init() {
		runOutput(0);
	}
}