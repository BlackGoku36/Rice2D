package rice2d;

import rice2d.tools.Debug;
import kha.Assets;
import kha.Font;
import kha.Image;
import haxe.ds.Option;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;
import kha.Color;

class App {

    public static var backbuffer:kha.Image;
    static var onUpdate: Array<Void->Void> = [];
    static var onRender: Array<kha.Canvas->Void> = [];
    static var onEndFrames: Array<Void->Void> = null;


    static var startTime:Float;
    public static var renderTime:Float = 0.0;
    public static var updateTime:Float = 0.0;
    public static var deltaTime: Float = 0.0;
    static var totalFrames: Int = 0;
    static var elapsedTime: Float = 0.0;
    static var previousTime: Float = 0.0;
    public static var fps: Int = 0;
    public static var font:Font;

    public static function init(title:String = "Rice2D", width:Int = 1280, height:Int=720, clearColor:Color = Color.White, window_mode:WindowMode = Windowed) {
        System.start({title: title, width: width, height: height, window: {mode: window_mode}}, (window) -> {
            Assets.loadFont("OpenSans_Regular", (fnt)->{font = fnt;});
            Scheduler.addTimeTask(() -> { update(); }, 0, 1 / 60);
            System.notifyOnFrames((frames) -> { render(frames[0], clearColor); });
        });
    }

    static function update() {
        startTime = kha.Scheduler.realTime();

        for (f in onUpdate) f();

        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();

        updateTime = kha.Scheduler.realTime() - startTime;
    }

    static function render(canvas: kha.Canvas, clearColor:Color) {

        startTime = kha.Scheduler.realTime();
        var currentTime:Float = Scheduler.realTime();
        deltaTime = (currentTime - previousTime);

        elapsedTime += deltaTime;
        if (elapsedTime >= 1.0) {
            fps = totalFrames;
            totalFrames = 0;
            elapsedTime = 0;
        }
        totalFrames++;

        var windowSize = Window.getWindowSize();

        backbuffer = Image.createRenderTarget(windowSize.width, windowSize.height);

        var bg2 = backbuffer.g2;
        bg2.begin();
        var col = bg2.color;
        bg2.color = clearColor;
        bg2.fillRect(0, 0, windowSize.width, windowSize.height);
        bg2.color = col;
        for(f in onRender) f(backbuffer);
        @:privateAccess Debug.render(backbuffer);
        bg2.end();

        var g2 = canvas.g2;
        g2.begin();
        g2.drawImage(backbuffer, 0, 0);
        g2.end();

        backbuffer.unload();

        previousTime = currentTime;
        renderTime = kha.Scheduler.realTime() - startTime;
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

    public static function notifyOnEndFrame(func:Void->Void) {
        if (onEndFrames == null) onEndFrames = [];
        onEndFrames.push(func);
    }

}
