
//Some stuffs borrowed from here https://github.com/armory3d/armory/blob/master/Sources/armory/trait/internal/DebugConsole.hx

package rice2d;

#if rice_debug
	import kha.Window;
	import kha.graphics2.Graphics;
	import zui.Id;
	import kha.Font;
	import zui.Zui;
#end

class Debug {
	#if rice_debug
	var ui: Zui;
	var width: Int = 250;
	var height: Int = 600;
	var hwin = Id.handle();
	var propane = Id.handle();

	var lastTime = 0.0;
	var frameTime = 0.0;
	var totalTime = 0.0;
	var frames = 0;

	var renderTime = 0.0;
	var renderTimeAvg = 0.0;
	var updateTime = 0.0;
	var updateTimeAvg = 0.0;

	static var haxeTrace: Dynamic->haxe.PosInfos->Void = null;
	static var lastTraces: Array<String> = [''];

	public function new(zfont:Font) {
		ui = new Zui({font: zfont});
		if (haxeTrace == null) {
			haxeTrace = haxe.Log.trace;
			haxe.Log.trace = consoleTrace;
		}
	}

	static function consoleTrace(v:Dynamic, ?inf:haxe.PosInfos) {
		lastTraces.unshift(Std.string(v));
		if (lastTraces.length > 10) lastTraces.pop();
		haxeTrace(v, inf);
	}

	public function render(g:Graphics) {
		ui.begin(g);
		hwin.redraws = 1;
		propane.redraws = 2;
		if (ui.window(hwin, Window.get(0).width-width, 0, width, height, true)) {
			var htab = Id.handle({position: 0});

			if (ui.tab(htab, "X")){}

			if(ui.tab(htab, "Outliner")){
				ui.text("Objects: "+ Scene.objects.length);
				ui.text("Image: "+ Assets.totalImages);
				ui.text("Fonts: "+ Assets.totalFonts);
				ui.text("Sounds: "+ Assets.totalSounds);
				ui.text("Blobs: "+ Assets.totalBlobs);

				if(ui.panel(Id.handle(), "Scene")){

					ui.indent();
						for (object in Scene.objects){
							ui.row([8/10, 1/10, 1/10]);
							ui.text(object.name);
							if(ui.button("O")) object.selected = true;
							if(ui.button("X")) object.selected = false;
						}
					ui.unindent();
				}
				if(ui.panel(propane, "Properties")){
					for (object in Scene.objects) if(object.selected){
						var center = object.transform.getCenter();
						var handlex = Id.handle({text: object.props.x+""});
						var handley = Id.handle({text: object.props.y+""});
						var inputx = ui.textInput(handlex, "X");
						var inputy = ui.textInput(handley, "Y");
						if(handlex.changed) object.props.x = Std.parseFloat(inputx);
						if(handley.changed) object.props.y = Std.parseFloat(inputy);
						object.props.width = Std.parseInt(ui.textInput(Id.handle({text:object.props.width+""}), "W"));
						object.props.height = Std.parseInt(ui.textInput(Id.handle({text:object.props.height+""}), "H"));
						object.props.rotation = ui.slider(Id.handle({value: 0.0}), "R", 0, 6.283185, false, Align.Left);
						object.visibile = ui.check(Id.handle({selected: true}), "Visible");
					}
				}

			}

			if(ui.tab(htab, "FPS: "+ App.fps)){
				ui.row([1/3, 2/3]);
				ui.text('FPS');
				ui.text(App.fps+"", Align.Right);
				ui.row([1/3, 2/3]);
				ui.text('Update');
				ui.text(Math.round(updateTimeAvg * 10000) / 10 + " ms", Align.Right);
				ui.row([1/3, 2/3]);
				ui.text('Render');
				ui.text(Math.round(renderTimeAvg * 10000) / 10 + " ms", Align.Right);
			}

			if (ui.tab(htab, lastTraces[0] == '' ? 'Console' : lastTraces[0].substr(0, 20))) {

				if (ui.panel(Id.handle({selected: true}), 'Log')) {
					ui.indent();
					if (ui.button("Clear")) {
						lastTraces[0] = '';
						lastTraces.splice(1, lastTraces.length - 1);
					}
					for (t in lastTraces) ui.text(t);
					ui.unindent();
				}
			}

			if (ui.tab(htab, "Prefs")){
				var hscale = Id.handle({value: 1.0});
				ui.slider(hscale, "UI Scale", 1.0, 1.3, false, Align.Left);
				if (hscale.changed) {
					ui.setScale(hscale.value);
					width = Std.int(240 * hscale.value);
				}
			}
		}

		ui.end();
		totalTime += frameTime;
		renderTime += App.renderTime;
		frames++;
		if(totalTime > 1.0){
			renderTimeAvg = renderTime / frames;
			updateTimeAvg = updateTime / frames;

			totalTime = 0.0;
			renderTime = 0.0;
			updateTime = 0.0;
			frames = 0;
		}
		frameTime = kha.Scheduler.realTime() - lastTime;
		lastTime = kha.Scheduler.realTime();
	}

	public function update() {
		updateTime += App.updateTime;
	}
	#end
}
