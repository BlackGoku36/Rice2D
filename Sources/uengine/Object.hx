package uengine;

import kha.math.Vector2;
import uengine.data.ObjectData;

class Object {

    public var name = "";
    public var raw:ObjectData = null;
    public var transform:Transform = null;
    public var rotation = 0.0;
    public var image:kha.Image;
    public var animation:Animation;

    public function new() {
        transform = new Transform();
        transform.object = this;
    }

    public function addScript(className:String) {
        if(this.raw.scripts == null) this.raw.scripts = [];

        var scr = Type.resolveClass("scripts."+className);
        if (scr == null) return;
        var cls:Script = Type.createInstance(scr, []);
        cls.object = this;
        this.raw.scripts.push(className);

    }
}
