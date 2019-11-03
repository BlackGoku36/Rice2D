package uengine;

import uengine.data.ObjectData.ObjectType;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;
import kha.Color;
import kha.System;
import kha.Scheduler;
import kha.Framebuffer;

// import uengine.Script;

class App {

    static var onResets:Array<Void->Void> = null;
	static var onEndFrames:Array<Void->Void> = null;
    static var onUpdate:Array<Void->Void> = [];
    static var onRender:Array<Graphics->Void> = [];

    public function new(scene:String) {
        Scene.parseToScene(scene);
        System.start({title: Main.name, width: Main.width, height: Main.height}, function (_) {
            Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
            System.notifyOnFrames(function (frames) { render(frames); });
            Scene.createScriptInstance();
        });
    }

    function update() {
        for (update in onUpdate) update();

        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();
    }

    function render(frames: Array<Framebuffer>):Void {
        var g = frames[0].g2;
        var col = g.color;
        g.begin(true, Color.Red);
        for (object in Scene.sceneData.objects){
            g.color = Color.fromBytes(object.color[0], object.color[1], object.color[2], object.color[3]);
            switch (object.type){
                case Rect: g.drawRect(object.x-(object.width/2), object.y-(object.height/2), object.width, object.height, 3);
                case FillRect: g.fillRect(object.x-(object.width/2), object.y-(object.height/2), object.width, object.height);
                case Circle: g.drawCircle(object.x, object.y, 10);
                case FillCircle: g.fillCircle(object.x, object.y, 10);
                case _:
            }
        }
        g.color = col;
        for (render in onRender){
            render(g);
        }
        g.end();
    }

    public static function notifyOnReset(func:Void->Void) {
        if (onResets == null) onResets = [];
        onResets.push(func);
    }

    public static function notifyOnEndFrame(func:Void->Void){
        if (onEndFrames == null) onEndFrames = [];
        onEndFrames.push(func);
    }
    
    public static function notifyOnUpdate(func:Void->Void) {
        onUpdate.push(func);
    }

    public static function notifyOnRender(func:Graphics->Void){
        onRender.push(func);
    }
}