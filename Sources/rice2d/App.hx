package rice2d;

//Kha
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end


//Engine
import rice2d.data.WindowData;
import rice2d.system.Camera;
import rice2d.Debug;

class App {

	static var version = "2020.2.0";

	public static var backbuffer:kha.Image;
	static var background:kha.Image;

	static var onInit: Array<Void->Void> = [];
	static var onUpdate: Array<Void->Void> = [];
	static var onRender: Array<kha.Canvas->Void> = [];
	static var onResets: Array<Void->Void> = null;
	static var onEndFrames: Array<Void->Void> = null;

	var font: kha.Font;

	public static var camera: rice2d.system.Camera;

	#if rice_postprocess
	var postprocess: rice2d.shaders.Postprocess;
	#end

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

			#if (rice_debug || rice_ui)
			kha.Assets.loadFontFromPath("mainfont.ttf", function (f) {
				font = f;
			});
			#end

			var windowMode:WindowMode = WindowMode.Fullscreen;
			Window.window.windowMode == 0 ? windowMode = WindowMode.Windowed : windowMode = WindowMode.Fullscreen;

			html();

			System.start({title: Window.window.name, width: Window.window.width, height: Window.window.height, window: {mode: windowMode}}, function (window:kha.Window) {
				backbuffer = kha.Image.createRenderTarget(Window.window.width, Window.window.height);
				background = kha.Image.createRenderTarget(Window.window.width, Window.window.height);
				#if rice_postprocess
				postprocess = new rice2d.shaders.Postprocess();
				#end
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

		backbuffer = kha.Image.createRenderTarget(System.windowWidth(), System.windowHeight());
		background = kha.Image.createRenderTarget(System.windowWidth(), System.windowHeight());

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

		background.g2.begin();
		background.g2.color = Color.fromBytes(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
		background.g2.fillRect(0, 0, background.width, background.height);
		background.g2.end();

		var g = backbuffer.g2;
		g.begin();
		g.drawImage(background, 0, 0);

		camera.set(g);

		for (object in Scene.objects){
			if(object.shader != null) object.shader.begin(backbuffer);
			var center = object.transform.getCenter();
			if (object.props.rotation != 0){
				g.pushRotation(object.props.rotation, center.x, center.y);
			}

			if(object.sprite != null){
				if(object.visibile){
					if(object.props.animate) g.drawScaledSubImage(object.sprite, Std.int(object.animation.get() * object.props.width) % object.sprite.width, Math.floor(object.animation.get() * object.props.width / object.sprite.width) * object.props.height, object.props.width, object.props.height, object.props.x, object.props.y, object.props.width, object.props.height);
					else g.drawScaledImage(object.sprite, object.props.x, object.props.y, object.props.width, object.props.height);
				}
			}

			if(object.shader!=null) object.shader.end(backbuffer);
			#if rice_debug
				if(object.selected){
					g.font = font;
					g.fontSize = 16;
					g.color = Color.fromFloats(0.2, 0.2, 0.2);
					g.fillRect(object.props.x, object.props.y, object.props.width, 20);
					g.color = Color.White;
					g.drawString(" X: " + Std.int(object.props.x)+", Y: "+Std.int(object.props.y)+", W: "+object.props.width+", H: "+object.props.height+", R: "+Math.round(object.props.rotation*180/Math.PI)+" Deg", object.props.x, object.props.y+3);
					g.drawRect(object.props.x, object.props.y, object.props.width, object.props.height, 3);
				}
			#end

			if (object.props.rotation != 0) g.popTransformation();
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
		#if rice_postprocess
		postprocess.start(canvas);
		#end
		canvas.g2.color = 0xffffffff;
		canvas.g2.drawImage(backbuffer, 0, 0);
		#if rice_postprocess
		postprocess.end(canvas);
		#end
		canvas.g2.end();

		#if rice_debug
			debug.render(canvas.g2);
			previousTime = currentTime;
			renderTime = kha.Scheduler.realTime() - startTime;
		#end
		background.unload();
		backbuffer.unload();
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
