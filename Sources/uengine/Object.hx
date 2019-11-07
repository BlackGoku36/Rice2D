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

    public function addScript(script:Script) {
        script.object = this;
    }

    public function setAnimation(animationn: Animation): Void {
        animation.take(animationn);
    }
}
