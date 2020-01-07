package rice2d.node;

class BranchNode extends LogicNode{

    public function new(tree: LogicTree){
		super(tree);
	}

	override function run(from: Int){
		var bool: Bool = inputs[1].get();
		bool ? runOutput(0) : runOutput(1);
	}
    
}