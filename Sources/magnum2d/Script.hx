package magnum2d;

class Script {

    public var object: magnum2d.Object;
    public var name: String = "";

    var _init: Array<Void->Void> = null;
    var _update: Array<Void->Void> = null;
    var _render: Array<kha.graphics2.Graphics->Void> = null;
    var _remove: Array<Void->Void> = null;

    public function new() {}

    public function remove(script: Script) {
        object.removeScript(this);
    }

    public function notifyOnInit(init:Void->Void) {
        if(_init == null) _init = [];
        _init.push(init);
        App.notifyOnInit(init);
    }

    public function notifyOnUpdate(update: Void->Void) {
        if(_update == null) _update = [];
        _update.push(update);
        App.notifyOnUpdate(update);
    }

    public function removeUpdate(update: Void->Void) {
        _update.remove(update);
        App.removeUpdate(update);
    }

    public function notifyOnRender(render: kha.graphics2.Graphics->Void) {
        if(_render == null) _render = [];
        _render.push(render);
        App.notifyOnRender(render);
    }

    public function removeRender(render: kha.graphics2.Graphics->Void) {
        _render.remove(render);
        App.removeRender(render);
    }

    public function notifyOnRemove(remove:Void->Void) {
        if(_remove == null) _remove = [];
        _remove.push(remove);
    }

}
