package uengine;

class Script {

    public var object: uengine.Object;
    public var name:String = "";

    public function new() {}

    public function notifyOnUpdate(func: Void->Void) {
        App.notifyOnUpdate(func);
    }

}
