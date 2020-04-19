package rice2d.data;

//Kha
import rice2d.system.Tween;
import kha.math.Vector2;

typedef TweenData = {
	var start: Vector2;
	var end: Vector2;
	var duration: Float;
	var ease: Null<EaseType>;
	var onDone: Tween->Void;
	var ?rotS: Float;
	var ?rotE: Float;
	var ?colourS: Array<Int>;
	var ?colourE: Array<Int>;
	var ?paused:Bool;
	var ?deltaTime: Float;
	var ?done: Bool;
}

@:enum abstract EaseType(Int) from Int to Int {
	var Linear = 0;
	var SineIn = 1;
	var SineOut = 2;
	var SineInOut = 3;
	var QuadIn = 4;
	var QuadOut = 5;
	var QuadInOut = 6;
	var CubicIn = 7;
	var CubicOut = 8;
	var CubicInOut = 9;
	var QuartIn = 10;
	var QuartOut = 11;
	var QuartInOut = 12;
	var QuintIn = 13;
	var QuintOut = 14;
	var QuintInOut = 15;
	var ExpoIn = 16;
	var ExpoOut = 17;
	var ExpoInOut = 18;
	var CircIn = 19;
	var CircOut = 20;
	var CircInOut = 21;
	var BackIn = 22;
	var BackOut = 23;
	var BackInOut = 24;
}
