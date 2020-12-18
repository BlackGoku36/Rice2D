package rice2d;

import kha.Canvas;
import rice2d.tools.Debug;
import kha.Font;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;
import kha.Color;

#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end

class App {

    // public static var backbuffer:kha.Image;
    static var onInit: Array<Void->Void> = [];
    static var onUpdate: Array<Void->Void> = [];
    static var onRenderG2: Array<kha.Canvas->Void> = [];
    static var onRenderG4: Array<kha.Canvas->Void> = [];
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
    public static var ready = false;

    public static function init(title:String = "Rice2D", width:Int = 1280, height:Int=720, clearColor:Color = Color.White, window_mode:WindowMode = Windowed, done:Void->Void) {
        if(window_mode == Fullscreen) html();
        System.start({title: title, width: width, height: height, window: {mode: window_mode}}, (window) -> {
            Assets.loadFont("OpenSans_Regular", ()->{
                font = Assets.assets[0].value;
                Assets.loadImage("logo", ()->{
                    LoadingScreen.logo = Assets.assets[1].value;
                    Scheduler.addTimeTask(() -> { update(); }, 0, 1 / 60);
                    System.notifyOnFrames((frames) -> { render(frames[0], clearColor); });
                    done();
                });
            });
        });
    }

    static function update() {
        if(!ready){
            if(rice2d.Assets.preloadAssetsLoaded == rice2d.Assets.preloadTotalAssets){
                for (f in onInit) f();
                ready = true;
            }
            else return;
        }

        startTime = kha.Scheduler.realTime();

        for (f in onUpdate) f();

        if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();

        updateTime = kha.Scheduler.realTime() - startTime;
    }

    static function render(canvas: kha.Canvas, clearColor:Color) {
        if(!ready){
            LoadingScreen.render(canvas.g2, rice2d.Assets.preloadAssetsLoaded,rice2d.Assets.preloadTotalAssets);
            return;
        }

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

        // backbuffer = Image.createRenderTarget(windowSize.width, windowSize.height);

        var g2 = canvas.g2;
        var g4 = canvas.g4;

        g2.begin();
            var col = g2.color;
            g2.color = clearColor;
            g2.fillRect(0, 0, windowSize.width, windowSize.height);
            g2.color = col;
        g2.end();

        g4.begin();
            for(f in onRenderG4) f(canvas);
        g4.end();
        
        g2.begin(false);
            for(f in onRenderG2) f(canvas);
            @:privateAccess Debug.render(canvas);
        g2.end();

        // backbuffer.unload();

        previousTime = currentTime;
        renderTime = kha.Scheduler.realTime() - startTime;
    }

    static function html(){
		#if kha_html5
		document.documentElement.style.padding = '0';
		document.documentElement.style.margin = '0';
		document.body.style.padding = '0';
		document.body.style.margin = '0';

		var canvas = cast(document.getElementById('khanvas'), CanvasElement);
		canvas.style.display = 'block';

		var resize = function(){
		canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
		canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
		canvas.style.width = document.documentElement.clientWidth + 'px';
		canvas.style.height = document.documentElement.clientHeight + 'px';
		}
		window.onresize = resize;
		resize();
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

    public static function notifyOnRenderG2(render:kha.Canvas->Void) {
        onRenderG2.push(render);
    }

    public static function notifyOnRenderG4(render:kha.Canvas->Void) {
        onRenderG4.push(render);
    }

    public static function removeRenderG2(render:kha.Canvas->Void) {
        onRenderG2.remove(render);
    }

    public static function removeRenderG4(render:kha.Canvas->Void) {
        onRenderG4.remove(render);
    }

    public static function notifyOnEndFrame(func:Void->Void) {
        if (onEndFrames == null) onEndFrames = [];
        onEndFrames.push(func);
    }

}
