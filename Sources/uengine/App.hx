package uengine;

import uengine.system.Camera;
#if u_ui
    import zui.Themes;
    import zui.Zui;
    import zui.Canvas;
#end

import kha.math.FastMatrix3;
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
    private var font:kha.Font;
    public static var camera:uengine.system.Camera;

    #if fps
        private var deltaTime:Float = 0.0;
        private var totalFrames:Int = 0;
        private var elapsedTime:Float = 0.0;
        private var previousTime:Float = 0.0;
        private var fps:Int = 0;
    #end

    #if u_ui
        var ui: Zui;
    #end

    public function new(scene:String) {
        Window.loadWindow(function () {

            kha.Assets.loadFontFromPath("mainfont.ttf", function (f) {
                font = f;
            });

            var windowMode:WindowMode = WindowMode.Fullscreen;
            Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

            System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
                Scene.parseToScene(scene);
                #if u_ui
                    ui = new Zui({font: font, theme: Themes.light});
                #end
                camera = new Camera();
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

        #if fps
            var currentTime:Float = Scheduler.realTime();
            deltaTime = (currentTime - previousTime);

            elapsedTime += deltaTime;
            if (elapsedTime >= 1.0) {
                fps = totalFrames;
                totalFrames = 0;
                elapsedTime = 0;
            }
            totalFrames++;
        #end

        var g = frames[0].g2;
        var col = g.color;
        g.begin(true, Color.fromFloats(0.6, 0.6, 0.6));
        camera.set(g);
        for (object in Scene.objects){
            if (object.rotation != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(object.props.x, object.props.y)).multmat(FastMatrix3.rotation(object.rotation)).multmat(FastMatrix3.translation(-object.props.x, -object.props.y)));
            if (object.props.color == null){
                g.color = Color.Black;
            }else{
                g.color = Color.fromBytes(object.props.color[0], object.props.color[1], object.props.color[2], object.props.color[3]);
            }
            var center = object.transform.getCenter();
            switch (object.props.type){
                case Rect: g.drawRect(center.x, center.y, object.props.width, object.props.height, 3);
                case FillRect: g.fillRect(center.x, center.y, object.props.width, object.props.height);
                case Circle: g.drawCircle(object.props.x, object.props.y, object.props.width/2);
                case FillCircle: g.fillCircle(object.props.x, object.props.y, object.props.width/2);
                case Sprite:
                    g.color = col;
                    if(object.image != null){
                        g.drawScaledSubImage(object.image, Std.int(object.animation.get() * object.props.width) % object.image.width, Math.floor(object.animation.get() * object.props.width / object.image.width) * object.props.height, object.props.width, object.props.height, Math.round(center.x), Math.round(center.y), object.props.width, object.props.height);
                    }
                    g.color = Color.fromBytes(object.props.color[0], object.props.color[1], object.props.color[2], object.props.color[3]);
                case _:
            }
            if (object.rotation != 0) g.popTransformation();
            #if u_debug
                g.drawRect(center.x, center.y, object.props.width, object.props.height, 3);
            #end
        }
        camera.unset(g);
        #if u_ui
            if (Scene.canvases != null){
                for (canvas in Scene.canvases){
                    var events = Canvas.draw(ui, canvas, g);
                    for (e in events) {
                        var all = uengine.system.Event.get(e);
                        if (all != null) for (entry in all) entry.onEvent();
                    }
                }
            }
        #end
        g.color = col;
        #if fps
            g.font = font;
            g.fontSize = 16;
            g.color = Color.fromFloats(0.2, 0.2, 0.2);
            g.fillRect(0, 0, Window.window.width, 20);
            g.color = Color.White;
            g.drawString("fps: " + fps, 10, 2);
        #end
        g.end();
        #if fps
            previousTime = currentTime;
        #end
    }

    public static function notifyOnReset(func:Void->Void) {
        if (onResets == null) onResets = [];
        onResets.push(func);
    }

    public static function notifyOnEndFrame(func:Void->Void) {
        if (onEndFrames == null) onEndFrames = [];
        onEndFrames.push(func);
    }

    public static function notifyOnUpdate(func:Void->Void) {
        onUpdate.push(func);
    }

}
