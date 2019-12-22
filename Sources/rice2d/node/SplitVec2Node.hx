package rice2d.node;

import kha.math.FastVector2;

class SplitVec2Node extends LogicNode {
    
    public function new(tree:LogicTree) {
		super(tree);
	}

    override function get(from: Int): Dynamic {
		var vec2:FastVector2 = inputs[0].get();

        if(from == 0){
            return vec2.x;
        }else{
            return vec2.y;
        }
	}

}