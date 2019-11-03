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

class App {

    static var onResets:Array<Void->Void> = null;
	static var onEndFrames:Array<Void->Void> = null;
    static var onUpdate:Array<Void->Void> = [];
    static var onRender:Array<Graphics->Void> = [];

    public function new(scene:String) {
        Window.loadWindow(function (){
            Scene.parseToScene(scene);

            var windowMode:WindowMode = WindowMode.Fullscreen;
            Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

            System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
                Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
                System.notifyOnFrames(function (frames) { render(frames); });
                Scene.createScriptInstance();
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