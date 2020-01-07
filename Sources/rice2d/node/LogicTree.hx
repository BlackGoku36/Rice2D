package rice2d.node;

@:keep
class LogicTree extends rice2d.Script {

	public var loopBreak = false; // Trigger break from loop nodes

	public function new() {
		super();
	}

	public function add() {}

	var paused = false;

	public function pause() {
		if (paused) return;
		paused = true;

		if (_update != null) for (f in _update) rice2d.App.removeUpdate(f);
	}

	public function resume() {
		if (!paused) return;
		paused = false;

		if (_update != null) for (f in _update) rice2d.App.notifyOnUpdate(f);
	}
}
