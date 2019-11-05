package uengine;

import uengine.data.ObjectData;

class Object {

    public var name = "";
    public var props:ObjectData = null;
    public var transform:Transform = null;
    public var rotation = 0.0;
    public var image:kha.Image = null;
    public var animation:Animation = Animation.create(0);

    public function new() {
        transform = new Transform();
        transform.object = this;
    }

    public function addScript(className:String) {
        if(this.props.scripts == null) this.props.scripts = [];

        var scr = Type.resolveClass("scripts."+className);
        if (scr == null) return;
        var cls:Script = Type.createInstance(scr, []);
        cls.object = this;
        this.props.scripts.push(className);
    }

    public function setAnimation(animationn: Animation): Void {
        animation.take(animationn);
    }
}
