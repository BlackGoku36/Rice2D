package uengine.system;

#if u_debug
    import kha.Window;
    import kha.graphics2.Graphics;
    import zui.Id;
    import kha.Font;
    import zui.Zui;
#end

class Debug {
    #if u_debug
    var ui: Zui;
    var width:Int = 250;
    var height:Int = 600;
    var hwin = Id.handle();


	static var haxeTrace:Dynamic->haxe.PosInfos->Void = null;
	static var lastTraces:Array<String> = [''];

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
        if (ui.window(hwin, Window.get(0).width-width, 0, width, height, true)) {
            var htab = Id.handle({position: 0});

            if (ui.tab(htab, "X")){}

            if(ui.tab(htab, "Outliner")){
                ui.text("Objects: "+ Scene.objects.length);
                ui.text("Assets: "+Scene.assets.length);

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
                if(ui.panel(Id.handle(), "Properties")){
                    for (object in Scene.objects){
                        if(object.selected){
                            object.props.x = Std.parseFloat(ui.textInput(Id.handle({text:object.props.x+""}), "X"));
                            object.props.y = Std.parseFloat(ui.textInput(Id.handle({text:object.props.y+""}), "Y"));
                            object.props.width = Std.parseInt(ui.textInput(Id.handle({text:object.props.width+""}), "W"));
                            object.props.height = Std.parseInt(ui.textInput(Id.handle({text:object.props.height+""}), "H"));
                            object.rotation = ui.slider(Id.handle({value: 0.0}), "R", 0, 6.283185, false, Align.Left);
                        }
                    }
                }
            }

            if(ui.tab(htab, "FPS: "+ App.fps)){
                ui.text("FPS: "+ App.fps);
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
    }
    #end
}