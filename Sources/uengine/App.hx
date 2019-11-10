package uengine;

//Kha
import uengine.system.Debug;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

//Engine
import uengine.data.WindowData;
import uengine.system.Camera;

class App {

    static var onInit:Array<Void->Void> = [];
    static var onUpdate:Array<Void->Void> = [];
    static var onRender:Array<Graphics->Void> = [];
    static var onResets:Array<Void->Void> = null;
    static var onEndFrames:Array<Void->Void> = null;

    var font:kha.Font;

    public static var camera:uengine.system.Camera;


    #if u_debug
        static var debug:uengine.system.Debug;
        var deltaTime:Float = 0.0;
        var totalFrames:Int = 0;
        var elapsedTime:Float = 0.0;
        var previousTime:Float = 0.0;
        public static var fps:Int = 0;
    #end

    public function new(scene:String) {
        Window.loadWindow(function () {

            kha.Assets.loadFontFromPath("mainfont.ttf", function (f) {
                font = f;
            });

            var windowMode:WindowMode = WindowMode.Fullscreen;
            Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

            System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
                Scene.parseToScene(scene, function (){
                    #if u_debug
                        debug = new Debug(font);
                    #end
                    Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
                    System.notifyOnFrames(function (frames) { render(frames); });
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

        for (update in onUpdate) update();
        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();
    }

    function render(frames: Array<Framebuffer>):Void {
        if(Scene.sceneData == null) return;

        #if u_debug
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

        for (render in onRender) render(g);

        for (object in Scene.objects){
            var center = object.transform.getCenter();
            if (object.rotation != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(object.props.x, object.props.y)).multmat(FastMatrix3.rotation(object.rotation)).multmat(FastMatrix3.translation(-object.props.x, -object.props.y)));

            if(object.sprite != null){
                g.drawScaledSubImage(object.sprite, Std.int(object.animation.get() * object.props.width) % object.sprite.width, Math.floor(object.animation.get() * object.props.width / object.sprite.width) * object.props.height, object.props.width, object.props.height, Math.round(center.x), Math.round(center.y), object.props.width, object.props.height);
            }
            #if u_debug
                if(object.selected){
                    g.font = font;
                    g.fontSize = 16;
                    g.color = Color.fromFloats(0.2, 0.2, 0.2);
                    g.fillRect(center.x, center.y, object.props.width, 20);
                    g.color = Color.White;
                    g.drawString(" X: " + object.props.x+", Y: "+object.props.y+", W: "+object.props.width+", H: "+object.props.height+", R: "+Math.round(object.rotation*180/Math.PI)+" Deg", center.x, center.y+3);
                    g.drawRect(center.x, center.y, object.props.width, object.props.height, 3);
                }
            #end

            if (object.rotation != 0) g.popTransformation();
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
        g.end();

        #if u_debug
            debug.render(g);
            previousTime = currentTime;
        #end
    }

    public static function notifyOnInit(init:Void->Void) {
        onInit.push(init);
    }

    public static function notifyOnUpdate(update:Void->Void) {
        onUpdate.push(update);
    }

    public static function notifyOnRender(render:Graphics->Void) {
        onRender.push(render);
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
