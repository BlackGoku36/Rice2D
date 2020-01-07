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
		* @param script
		*/
	public function remove(script: Script) {
		object.removeScript(this);
	}

	public function notifyOnAdd(add:Void->Void) {
		if (_add == null) _add = [];
		_add.push(add);
	}

	/**
		* Execute funtion 'init' when the Script is initiated.
		* @param init
		*/
	public function notifyOnInit(init:Void->Void) {
		if(_init == null) _init = [];
		_init.push(init);
		App.notifyOnInit(init);
	}

	/**
		* Execute funtion 'update' every frame.
		* @param update
		*/
	public function notifyOnUpdate(update: Void->Void) {
		if(_update == null) _update = [];
		_update.push(update);
		App.notifyOnUpdate(update);
	}

	/**
		* Execute funtion 'update' and remove notifyOnUpdate.
		* @param update
		*/
	public function removeUpdate(update: Void->Void) {
		_update.remove(update);
		App.removeUpdate(update);
	}

	/**
		* Execute function 'render' when frame is rendering.
		* @param render
		*/
	public function notifyOnRender(render: kha.Canvas->Void) {
		if(_render == null) _render = [];
		_render.push(render);
		App.notifyOnRender(render);
	}

	/**
		* Execute function 'render' and remove notifyOnRender
		* @param render
		*/
	public function removeRender(render: kha.Canvas->Void) {
		_render.remove(render);
		App.removeRender(render);
	}

	/**
		* Execute funtion 'remove' when the Script is removed
		* @param remove
		*/
	public function notifyOnRemove(remove:Void->Void) {
		if(_remove == null) _remove = [];
		_remove.push(remove);
	}

}
