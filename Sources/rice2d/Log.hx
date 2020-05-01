package rice2d;

class Log {

    public static var allTraces: String = "";
    public static var lastTraces: Array<String> = [""];
    static var haxeTrace: Dynamic->haxe.PosInfos->Void = null;

    public static final red = "\033[31m";
    public static final green = "\033[32m";
    public static final yellow = "\033[33m";
    public static final reset = "\033[0m";

    public static function init() {
        if (haxeTrace == null) {
			haxeTrace = haxe.Log.trace;
			haxe.Log.trace = consoleTrace;
		}
    }

    static function consoleTrace(v: Dynamic, ?inf: haxe.PosInfos) {
        allTraces += Std.string(v);
		lastTraces.unshift(Std.string(v));
		// if (lastTraces.length > 10) lastTraces.pop();
		haxeTrace(v, inf);
	}
    
    public static function print(v:Dynamic) {
        trace("\033[2m " + v + reset);
    }

    public static function warn(v:Dynamic) {
        trace('$yellow Warning: $v $reset');
    }

    public static function success(v:Dynamic) {
        trace('$green Success: $v $reset');
    }

    public static function error(err:Dynamic, v:Dynamic) {
        trace('$red Error: $v $reset');
    }
    
    public static function panic(v:Dynamic) {
        throw v;
    }

}