package uengine;

class Script {

    public var object: uengine.Object;
    public var name:String = "";

    public function new() {}

    public function notifyOnInit(init:Void->Void) {
        App.notifyOnInit(init);
    }

    public function notifyOnUpdate(update: Void->Void) {
        App.notifyOnUpdate(update);
    }

    public function notifyOnRender(render: kha.graphics2.Graphics->Void) {
        App.notifyOnRender(render);
    }

}
