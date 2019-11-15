package rice2d;

class Object {

    public var name = "";
    public var props: rice2d.data.ObjectData = null;
    public var transform: Transform = null;
    public var rotation = 0.0;
    public var sprite: kha.Image;
    public var animation: Animation = Animation.create(0);
    public var scripts: Array<Script> = [];
    public var visibile = true;
    public var selected = false;

    #if rice_physics
    public var body: echo.Body;
    #end

    public function new() {
        transform = new Transform();
        transform.object = this;
    }

    public function remove() {
        if(scripts != null) for(script in scripts) removeScript(script);
        Scene.objects.splice(Scene.objects.indexOf(this), 1);
    }

    public function addScript(scriptRef:String, script:Script) {
        scripts.push(script);
        script.object = this;
        script.name = scriptRef;
    }

    public function getScript(scriptRef: String): Script {
        var scr:Script = null;
        for (script in scripts) if (script.name == scriptRef) scr = script;
        return scr;
    }

    public function setAnimation(animationn: Animation): Void {
        animation.take(animationn);
    }

    public function setSprite(sprite: kha.Image) {
        this.sprite = sprite;
    }

    @:access(rice2d.Script)
    public function removeScript(script: Script) {

        if(script._update != null){
            for (update in script._update) App.removeUpdate(update);
            script._update = null;
        }

        if(script._render != null){
            for (render in script._render) App.removeRender(render);
            script._render = null;
        }

        if(script._remove != null){
            for (remove in script._remove) remove();
            script._remove = null;
        }

        scripts.remove(script);

    }

}
