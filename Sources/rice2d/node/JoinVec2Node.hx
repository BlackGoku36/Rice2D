package rice2d.node;

class JoinVec2Node extends LogicNode {

    public function new(tree:LogicTree) {
		super(tree);
	}

    override function get(from: Int): Dynamic {
		var x:Float = inputs[0].get();
        var y:Float = inputs[1].get();
        
        return new kha.math.FastVector2(x, y);
	}
}