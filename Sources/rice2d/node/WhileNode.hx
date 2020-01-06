package rice2d.node;

class WhileNode extends LogicNode{

    public function new(tree: LogicTree){
		super(tree);
	}

	override function run(from: Int){
        var bool: Bool = inputs[1].get();

        while(bool){
			runOutput(0);

			if(tree.loopBreak){
				tree.loopBreak = false;
				break;
			}
        }

		runOutput(1);
	}
}