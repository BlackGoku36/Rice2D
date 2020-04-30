package rice2d.tools;

import kha.math.Random;

class Util {

	/**
		* Get center
		* @param x position on x-axis
		* @param y position on y-axis
		* @param width
		* @param height
		*/
	public static function getCenter(x:Float, y:Float, width:Float, height:Float) {
		return { x: x - (width / 2), y: y - (height / 2) }
	}

	/**
		* Get random Float from minimum to maximum range
		* @param min minimum value of range
		* @param max maximum value of range
		* @return Float Random Float value
		*/
	public static function randomRangeF(min:Float, max:Float):Float {
		Random.init(324325);
		return Random.getFloatIn(min, max);
	}

	/**
		* Get random Int from minimum to maximum range
		* @param min minimum value of range
		* @param max maximum value of range
		* @return Int Random Int value
		*/
	public static function randomRangeI(min:Int, max:Int):Int {
		Random.init(836204);
		return Random.getIn(min, max);
	}

	/**
		* Linearly interpolate (lerp)
		* @param start start value of lerp
		* @param end end value of lerp
		* @param dt attribute of lerp
		* @return Float lerp's value
		*/
	public static function lerp(start:Float, end:Float, dt:Float):Float{
		return (1 - dt) * start + dt * end;
	}
}
