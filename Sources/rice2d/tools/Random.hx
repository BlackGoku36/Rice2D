package rice2d.tools;

import kha.System;
import kha.math.Vector2;
import kha.math.Random;

class Random {

	/**
		* Get random Float from minimum to maximum range
		* @param min minimum value of range
		* @param max maximum value of range
		* @return Float Random Float value
		*/
	public static function randomRangeF(min:Float, max:Float):Float {
		kha.math.Random.init(312323*Std.int(Math.random()*Math.PI*100));
		return kha.math.Random.getFloatIn(min, max);
	}

	/**
		* Get random Int from minimum to maximum range
		* @param min minimum value of range
		* @param max maximum value of range
		* @return Int Random Int value
		*/
	public static function randomRangeI(min:Int, max:Int):Int {
		kha.math.Random.init(312323*Std.int(Math.random()*Math.PI*100));
		return kha.math.Random.getIn(min, max);
	}

	public static function randomPointOnUnitCircle() { // On Circumference
		var theta = (2 * Math.PI) * randomRangeF(0.0, 1.0);
		return new Vector2(Math.cos(theta), Math.sin(theta));
	}

	public static function randomPointInWindow() { // Inside
		return new Vector2(randomRangeF(0, System.windowWidth()), randomRangeF(0, System.windowHeight()));
	}

}
