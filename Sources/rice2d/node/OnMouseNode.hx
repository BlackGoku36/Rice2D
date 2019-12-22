package rice2d.node;

class OnMouseNode extends LogicNode {

	public var operations1: String;
	public var operations2: String;

	public function new(tree: LogicTree) {
		super(tree);
		tree.notifyOnUpdate(update);
	}

	function update() {
		var mouse = rice2d.system.Input.getMouse();
		var b = false;
		switch (operations1) {
            case "Down":
                b = mouse.down(getMouseButton(operations2));
            case "Started":
                b = mouse.started(getMouseButton(operations2));
            case "Released":
                b = mouse.released(getMouseButton(operations2));
            case "Moved":
                b = mouse.moved;
		}
		if (b) runOutput(0);
	}

    function getMouseButton(string:String):Int {
        var btn: Int = 0;
        switch (string){
            case "Left": btn = 0;
            case "Right": btn = 1;
            case "Middle": btn = 2;
        }
        return btn;
    }
}