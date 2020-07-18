package rice2d;

//Kha
import haxe.Timer;
import kha.Color;
import kha.Scheduler;
import kha.System;
import kha.WindowMode;

#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end


//Engine
import rice2d.system.Camera;
import rice2d.Debug;

class App {

	static var version = "2020.5.0";

	public static var backbuffer:kha.Image;
	public var clearColor:kha.Color;

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

	/**
	 * Create new Rice2D game.
	 * @param name Name of the window.
	 * @param width Width of window.
	 * @param height Height of window.
	 * @param clearColor Background color of window, defaults to white.
	 * @param windowMode Mode of window, defaults to windowed. (Fullscreen, windowed)
	 * @param scene Name of json file that have scene data.
	 */
	public function new(name: String, width:Int, height:Int, clearColor: kha.Color = Color.White, windowMode:WindowMode = Windowed, scene:String) {
		this.clearColor = clearColor;

		html();

		// Krom and native target it dpi-aware, so tempo fix rn.
		#if kha_html5
		var w = width;
		var h = height;
		#else
		var w = width * 2;
		var h = height * 2;
		#end

		System.start({title: name, width: w, height: h, window: {mode: windowMode}}, (window) -> {
			Log.print('${Log.green} ~~~~~ Using Rice2D $version ~~~~~ ${Log.reset}');
			backbuffer = kha.Image.createRenderTarget(w, h);

			#if rice_postprocess
				postprocess = new rice2d.shaders.Postprocess();
			#end

			Scene.parseToScene(scene, () -> {

				#if rice_debug
				kha.Assets.loadFont("OpenSans_Regular", (font) -> {
					debug = new Debug(font);
				}, (err)->{
					Log.error(err, "Default font for debug failed to load (OpenSans-Regular.ttf)");
				});
				#end

				Scheduler.addTimeTask(() -> { update(); }, 0, 1 / 60);
				System.notifyOnFrames((frames) -> { render(frames[0]); });
				camera = new Camera();
			});
		});
	}

	function update() {
		#if rice_debug
			startTime = kha.Scheduler.realTime();
		#end
		if(Scene.sceneData == null) return;

		if(onInit.length > 0){
			for (init in onInit) init();
			onInit.splice(0, onInit.length);
		}
		if(onUpdate.length > 0){
			for (update in onUpdate) update();
		}

		#if rice_ui
			for(ui in Scene.uis) ui.update();
		#end

		if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();

		#if rice_debug
			debug.update();
			updateTime = kha.Scheduler.realTime() - startTime;
		#end
	}

	function render(canvas: kha.Canvas):Void {
		if(Scene.sceneData == null) return;
		var ww = System.windowWidth();
		var wh = System.windowHeight();

		backbuffer = kha.Image.createRenderTarget(ww, wh);

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

		var g = backbuffer.g2;
		g.begin();
		var col = g.color;
		g.color = clearColor;
		g.fillRect(0, 0, ww, wh);
		g.color = col;

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
			for(ui in Scene.uis)ui.render(backbuffer);
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
