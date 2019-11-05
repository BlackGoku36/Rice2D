package uengine;

class Script {

    public var object: uengine.Object;
    public var name:String = "";

    var _update:Array<Void->Void> = null;

    public function new() {}

    public function notifyOnUpdate(func: Void->Void) {
        if (_update == null) _update = [];
		_update.push(func);
        App.notifyOnUpdate(func);
    }

}
