package rice2d.system;

import rice2d.data.TweenData;

class Tween {

	public var tween: rice2d.data.TweenData;

	static inline var DEFAULT_OVERSHOOT: Float = 1.70158;

	static var eases: Array<Float->Float> = [easeLinear, easeSineIn, easeSineOut, easeSineInOut, easeQuadIn,
											easeQuadOut, easeQuadInOut, easeCubicIn, easeCubicOut, easeCubicInOut,
											easeQuartIn, easeQuartOut, easeQuartInOut, easeQuintIn, easeQuintOut,
											easeQuintInOut, easeExpoIn, easeExpoOut, easeExpoInOut, easeCircIn,
											easeCircOut, easeCircInOut, easeBackIn, easeBackOut, easeBackInOut];

	/**
	 * Create new tween
	 * @param tweenData Tween's data
	 */
	public function new(tweenData: rice2d.data.TweenData) {
		tween = tweenData;
		tween.deltaTime = 0;
		tween.done = false;
	}

	/**
	 * Update tween
	 */
	public function update(){
		var xy = { x: tween.start.x, y: tween.start.y, rot: tween.rotS, col:tween.colourS};
		if (!tween.done && !tween.paused){
			tween.deltaTime += 1 / 60;
			if (tween.deltaTime >= tween.duration){
				tween.done = true;
				tween.onDone(this);
			} else {
				var t = tween.deltaTime / tween.duration;
				xy.x = tween.start.x + eases[tween.ease](t) * tween.end.x;
				xy.y = tween.start.y + eases[tween.ease](t) * tween.end.y;
				if(tween.rotS != null || tween.rotE != null)
					xy.rot = tween.rotS + eases[tween.ease](t) * tween.rotE;
				if(tween.colourS != null || tween.colourE != null){
					xy.col = [
						Std.int(tween.colourS[0] + eases[tween.ease](t) * tween.colourE[0]),
						Std.int(tween.colourS[1] + eases[tween.ease](t) * tween.colourE[1]),
						Std.int(tween.colourS[2] + eases[tween.ease](t) * tween.colourE[2]),
						Std.int(tween.colourS[3] + eases[tween.ease](t) * tween.colourE[3]),
					];
				}
			}
		}
		if(tween.paused){
			var t = tween.deltaTime / tween.duration;
			xy.x = tween.start.x + eases[tween.ease](t) * tween.end.x;
			xy.y = tween.start.y + eases[tween.ease](t) * tween.end.y;
			if(tween.rotS != null || tween.rotE != null)
				xy.rot = tween.rotS + eases[tween.ease](t) * tween.rotE;
			if(tween.colourS != null || tween.colourE != null){
				xy.col = [
					Std.int(tween.colourS[0] + eases[tween.ease](t) * tween.colourE[0]),
					Std.int(tween.colourS[1] + eases[tween.ease](t) * tween.colourE[1]),
					Std.int(tween.colourS[2] + eases[tween.ease](t) * tween.colourE[2]),
					Std.int(tween.colourS[3] + eases[tween.ease](t) * tween.colourE[3]),
				];
			}
		}
		if(tween.done){
			xy.x = tween.end.x;
			xy.y = tween.end.y;
			xy.rot = tween.rotS;
			xy.col = tween.colourE;
		}
		return xy;
	}

	/**
	 * Restart tween
	 */
	public function restart(?newTween:TweenData) {
		if(newTween != null) tween = newTween;
	  	tween.done = false;
		tween.deltaTime = 0;
	}

	/**
	 * Pause tween
	 * @param pause
	 */
	public function pause(pause:Bool) {
		tween.paused = pause;
	}

	//Borrowed from Iron's tween (https://github.com/armory3d/iron/blob/master/Sources/iron/system/Tween.hx)

	public static function easeLinear(k:Float):Float { return k; }
	public static function easeSineIn(k:Float):Float { if(k == 0){ return 0; } else if(k == 1){ return 1; } else { return 1 - Math.cos(k * Math.PI / 2); } }
	public static function easeSineOut(k:Float):Float { if(k == 0){ return 0; } else if(k == 1){ return 1; } else { return Math.sin(k * (Math.PI * 0.5)); } }
	public static function easeSineInOut(k:Float):Float { if(k == 0){ return 0; } else if(k == 1){ return 1; } else { return -0.5 * (Math.cos(Math.PI * k) - 1); } }
	public static function easeQuadIn(k:Float):Float { return k * k; }
	public static function easeQuadOut(k:Float):Float { return -k * (k - 2); }
	public static function easeQuadInOut(k:Float):Float { return (k < 0.5) ? 2 * k * k : -2 * ((k -= 1) * k) + 1; }
	public static function easeCubicIn(k:Float):Float { return k * k * k; }
	public static function easeCubicOut(k:Float):Float { return (k = k - 1) * k * k + 1; }
	public static function easeCubicInOut(k:Float):Float { return ((k *= 2) < 1) ? 0.5 * k * k * k : 0.5 * ((k -= 2) * k * k + 2); }
	public static function easeQuartIn(k:Float):Float { return (k *= k) * k; }
	public static function easeQuartOut(k:Float):Float { return 1 - (k = (k = k - 1) * k) * k; }
	public static function easeQuartInOut(k:Float):Float { return ((k *= 2) < 1) ? 0.5 * (k *= k) * k : -0.5 * ((k = (k -= 2) * k) * k - 2); }
	public static function easeQuintIn(k:Float):Float { return k * (k *= k) * k; }
	public static function easeQuintOut(k:Float):Float { return (k = k - 1) * (k *= k) * k + 1; }
	public static function easeQuintInOut(k:Float):Float { return ((k *= 2) < 1) ? 0.5 * k * (k *= k) * k : 0.5 * (k -= 2) * (k *= k) * k + 1; }
	public static function easeExpoIn(k:Float):Float { return k == 0 ? 0 : Math.pow(2, 10 * (k - 1)); }
	public static function easeExpoOut(k:Float):Float { return k == 1 ? 1 : (1 - Math.pow(2, -10 * k)); }
	public static function easeExpoInOut(k:Float):Float { if (k == 0) { return 0; } if (k == 1) { return 1; } if ((k /= 1 / 2.0) < 1.0) { return 0.5 * Math.pow(2, 10 * (k - 1)); } return 0.5 * (2 - Math.pow(2, -10 * --k)); }
	public static function easeCircIn(k:Float):Float { return -(Math.sqrt(1 - k * k) - 1); }
	public static function easeCircOut(k:Float):Float { return Math.sqrt(1 - (k - 1) * (k - 1)); }
	public static function easeCircInOut(k:Float):Float { return k <= .5 ? (Math.sqrt(1 - k * k * 4) - 1) / -2 : (Math.sqrt(1 - (k * 2 - 2) * (k * 2 - 2)) + 1) / 2; }
	public static function easeBackIn(k:Float):Float { if (k == 0) { return 0; } else if (k == 1) { return 1; } else { return k * k * ((DEFAULT_OVERSHOOT + 1) * k - DEFAULT_OVERSHOOT); } }
	public static function easeBackOut(k:Float):Float { if (k == 0) { return 0; } else if (k == 1) { return 1; } else { return ((k = k - 1) * k * ((DEFAULT_OVERSHOOT + 1) * k + DEFAULT_OVERSHOOT) + 1); } }
	public static function easeBackInOut(k:Float):Float { if (k == 0) { return 0; } else if (k == 1) { return 1; } else if ((k *= 2) < 1) { return (0.5 * (k * k * (((DEFAULT_OVERSHOOT * 1.525) + 1) * k - DEFAULT_OVERSHOOT * 1.525))); } else { return (0.5 * ((k -= 2) * k * (((DEFAULT_OVERSHOOT * 1.525) + 1) * k + DEFAULT_OVERSHOOT * 1.525) + 2)); } }
}
