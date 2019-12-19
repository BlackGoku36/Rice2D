package rice2d;

//Kha
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;


//Engine
import rice2d.data.WindowData;
import rice2d.system.Camera;
import rice2d.Debug;

class App {

    static var version = "2019.12.0";

    public static var backbuffer:kha.Image;

    static var onInit: Array<Void->Void> = [];
    static var onUpdate: Array<Void->Void> = [];
    static var onRender: Array<kha.Canvas->Void> = [];
    static var onResets: Array<Void->Void> = null;
    static var onEndFrames: Array<Void->Void> = null;

    var font: kha.Font;

    public static var camera: rice2d.system.Camera;

    #if rice_debug
        static var debug: Debug;
        static var startTime:Float;
        public static var renderTime:Float;
        public static var updateTime:Float;
        var deltaTime: Float = 0.0;
        var totalFrames: Int = 0;
        var elapsedTime: Float = 0.0;
        var previousTime: Float = 0.0;
        public static var fps: Int = 0;
    #end

    public function new(scene:String) {
        Window.loadWindow(function () {

            kha.Assets.loadFontFromPath("mainfont.ttf", function (f) {
                font = f;
            });

            var windowMode:WindowMode = WindowMode.Fullscreen;
            Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

            System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
                backbuffer = kha.Image.createRenderTarget(Window.window.width, Window.window.height);
                Scene.parseToScene(scene, function (){
                    #if rice_debug
                        debug = new Debug(font);
                    #end
                    Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
                    System.notifyOnFrames(function (frames) { render(frames[0]); });
                    camera = new Camera();
                });
            });
        });
    }

    function update() {
        if(Scene.sceneData == null) return;

        if(onInit.length > 0){
            for (init in onInit) init();
            onInit.splice(0, onInit.length);
        }
        if(onUpdate.length > 0){
            for (update in onUpdate) update();
        }
        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();

        #if rice_debug
        debug.update();
        updateTime = kha.Scheduler.realTime() - startTime;
        #end
    }

    function render(canvas: kha.Canvas):Void {
        if(Scene.sceneData == null) return;

        #if rice_debug
        startTime = kha.Scheduler.realTime();
        #end

        #if rice_debug
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

        var clearColor = Window.window.clearColor;
        var g = backbuffer.g2;
        g.begin();

        canvas.g2.color = Color.fromBytes(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
        canvas.g2.fillRect(0, 0, backbuffer.width, backbuffer.height);

        camera.set(g);

        for (object in Scene.objects){
            if(object.shader!=null) object.shader.begin(backbuffer);
            var center = object.transform.getCenter();
            if (object.props.rotation != null && object.props.rotation!=0){
                g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(object.props.x, object.props.y)).multmat(FastMatrix3.rotation(object.props.rotation)).multmat(FastMatrix3.translation(-object.props.x, -object.props.y)));
            }

            if(object.sprite != null){
                if(object.visibile){
                    if(object.props.animate) g.drawScaledSubImage(object.sprite, Std.int(object.animation.get() * object.props.width) % object.sprite.width, Math.floor(object.animation.get() * object.props.width / object.sprite.width) * object.props.height, object.props.width, object.props.height, Math.round(center.x), Math.round(center.y), object.props.width, object.props.height);
                    else g.drawScaledImage(object.sprite, object.props.x, object.props.y, object.props.width, object.props.height);
                }
            }
            if(object.shader!=null) object.shader.end(backbuffer);
            #if rice_debug
                if(object.selected){
                    g.font = font;
                    g.fontSize = 16;
                    g.color = Color.fromFloats(0.2, 0.2, 0.2);
                    g.fillRect(center.x, center.y, object.props.width, 20);
                    g.color = Color.White;
                    g.drawString(" X: " + Std.int(center.x)+", Y: "+Std.int(center.y)+", W: "+object.props.width+", H: "+object.props.height+", R: "+Math.round(object.rotation*180/Math.PI)+" Deg", center.x, center.y+3);
                    g.drawRect(center.x, center.y, object.props.width, object.props.height, 3);
                }
            #end

            if (object.props.rotation != null && object.props.rotation!=0) g.popTransformation();
        }


        for (render in onRender) render(backbuffer);
        camera.unset(g);
        #if rice_ui
            var ui: zui.Zui = new zui.Zui({font: font});
            if (Scene.canvases != null){
                for (canvas in Scene.canvases){
                    var events = zui.Canvas.draw(ui, canvas, g);
                    for (e in events) {
                        var all = rice2d.system.Event.get(e);
                        if (all != null) for (entry in all) entry.onEvent();
                    }
                }
            }
        #end
        g.end();

        canvas.g2.begin();
        canvas.g2.color = 0xffffffff;
        canvas.g2.drawScaledImage(backbuffer, 0, 0, kha.System.windowWidth(), kha.System.windowHeight());
        canvas.g2.end();

        #if rice_debug
            debug.render(canvas.g2);
            previousTime = currentTime;
            renderTime = kha.Scheduler.realTime() - startTime;
        #end
    }

    public static function notifyOnInit(init:Void->Void) {
        onInit.push(init);
    }

    public static function notifyOnUpdate(update:Void->Void) {
        onUpdate.push(update);
    }

    public static function removeUpdate(update:Void->Void) {
        onUpdate.remove(update);
    }

    public static function notifyOnRender(render:kha.Canvas->Void) {
        onRender.push(render);
    }

    public static function removeRender(render:kha.Canvas->Void) {
        onRender.remove(render);
    }

    public static function notifyOnReset(func:Void->Void) {
        if (onResets == null) onResets = [];
        onResets.push(func);
    }

    public static function notifyOnEndFrame(func:Void->Void) {
        if (onEndFrames == null) onEndFrames = [];
        onEndFrames.push(func);
    }


}
