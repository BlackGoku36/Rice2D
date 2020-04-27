package rice2d.system;

class Console {
    static var haxeTrace: Dynamic->haxe.PosInfos->Void = null;
    static var lastTraces: Array<String> = [''];
    
    public function new() {
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
}