package rice2d.node;

class IsTrueNode extends LogicNode{

    public function new(tree: LogicTree){
		super(tree);
	}

	override function run(from: Int){
		var bool: Bool = inputs[1].get();
		if(bool) runOutput(0);
	}
}