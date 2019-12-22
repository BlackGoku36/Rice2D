package rice2d.node;

class MouseCoordNode extends LogicNode{

	var coords = new kha.math.FastVector2();

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function get(from: Int): Dynamic {

		var mouse = rice2d.system.Input.getMouse();

		if (from == 0) {
			coords.x = mouse.x;
			coords.y = mouse.y;
			return coords;
		}
        else if (from == 1) {
			coords.x = mouse.movementX;
			coords.y = mouse.movementY;
			return coords;
		}
		else {
			return mouse.wheelDelta;
		}
	}
}