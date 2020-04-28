package rice2d;

@:keep
class Script {

	public var object: rice2d.object.Object;
	public var name: String = "";

	var _add: Array<Void->Void> = null;
	var _init: Array<Void->Void> = null;
	var _update: Array<Void->Void> = null;
	var _render: Array<kha.Canvas->Void> = null;
	var _remove: Array<Void->Void> = null;

	public function new() {}

	/**
		* Remove script from this object.
		*/
	public function remove(script: Script) {
		object.removeScript(this);
	}

	/**
	 * Callback function when the script is added.
	 */
	public function notifyOnAdd(add:Void->Void) {
		if (_add == null) _add = [];
		_add.push(add);
	}

	/**
		* Callback function when the script is first initiated in update loop.
		*/
	public function notifyOnInit(init:Void->Void) {
		if(_init == null) _init = [];
		_init.push(init);
		App.notifyOnInit(init);
	}

	/**
		* Callback function during the update loop.
		*/
	public function notifyOnUpdate(update: Void->Void) {
		if(_update == null) _update = [];
		_update.push(update);
		App.notifyOnUpdate(update);
	}

	/**
		* Callback function to remove script from update loop.
		*/
	public function removeUpdate(update: Void->Void) {
		_update.remove(update);
		App.removeUpdate(update);
	}

	/**
		* Callback function during each frame for rendering.
		*/
	public function notifyOnRender(render: kha.Canvas->Void) {
		if(_render == null) _render = [];
		_render.push(render);
		App.notifyOnRender(render);
	}

	/**
		* Callback function to remove script from rendering.
		*/
	public function removeRender(render: kha.Canvas->Void) {
		_render.remove(render);
		App.removeRender(render);
	}

	/**
		* Callback function when the script is removed.
		*/
	public function notifyOnRemove(remove:Void->Void) {
		if(_remove == null) _remove = [];
		_remove.push(remove);
	}

}
