package rice2d.node;

class SetObjLocNode extends LogicNode{

    public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var name:String = inputs[1].get();
		var x:Float = inputs[2].get();
		var y:Float = inputs[3].get();

        Scene.getObject(name).props.x = x;
        Scene.getObject(name).props.y = y;

		runOutput(0);
	}
}