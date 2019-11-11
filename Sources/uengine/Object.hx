package uengine;

class Object {

    public var name = "";
    public var props: uengine.data.ObjectData = null;
    public var transform:Transform = null;
    public var rotation = 0.0;
    public var sprite:kha.Image;
    public var animation:Animation = Animation.create(0);
    public var visibile = true;
    public var selected = false;

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

    public function setSprite(sprite: kha.Image) {
        this.sprite = sprite;
    }

}
