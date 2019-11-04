package uengine;

import kha.WindowOptions.WindowFeatures;
import kha.WindowMode;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;
import kha.Color;
import kha.System;
import kha.Scheduler;
import kha.Framebuffer;

import uengine.data.WindowData;
import uengine.Transform;

class App {

    static var onResets:Array<Void->Void> = null;
    static var onEndFrames:Array<Void->Void> = null;
    static var onUpdate:Array<Void->Void> = [];
    static var onRender:Array<Graphics->Void> = [];

    public function new(scene:String) {
        Window.loadWindow(function (){

            var windowMode:WindowMode = WindowMode.Fullscreen;
            Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

            System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
                Scene.parseToScene(scene);
                Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
                System.notifyOnFrames(function (frames) { render(frames); });
            });
        });
    }

    function update() {
        if(Scene.sceneData == null) return;

        for (update in onUpdate) update();
        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();
    }

    function render(frames: Array<Framebuffer>):Void {
        if(Scene.sceneData == null) return;

        var g = frames[0].g2;
        var col = g.color;
        g.begin(true, Color.Red);
        for (object in Scene.objects){
            if (object.raw.color == null){
                g.color = Color.Black;
            }else{
                g.color = Color.fromBytes(object.raw.color[0], object.raw.color[1], object.raw.color[2], object.raw.color[3]);
            }
            var center = object.transform.getCenter();
            switch (object.raw.type){
                case Rect: g.drawRect(center.x, center.y, object.raw.width, object.raw.height, 3);
                case FillRect: g.fillRect(center.x, center.y, object.raw.width, object.raw.height);
                case Circle: g.drawCircle(object.raw.x, object.raw.y, object.raw.width/2);
                case FillCircle: g.fillCircle(object.raw.x, object.raw.y, object.raw.width/2);
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
