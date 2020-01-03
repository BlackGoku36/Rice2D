
//Borrowed from https://github.com/armory3d/iron/blob/master/Sources/iron/system/Input.hx

package rice2d.system;

import kha.System;
import kha.ScreenCanvas;
import kha.Scaler;
import kha.input.KeyCode;

class Input {
	public static var occupied = false;
	static var registered = false;
	static var mouse: Mouse;
	static var keyboard: Keyboard;

	public static function reset() {
		occupied = false;
		if (mouse != null) mouse.reset();
		if (keyboard != null) keyboard.reset();
	}

	public static function endFrame() {
		if (mouse != null) mouse.endFrame();
		if (keyboard != null) keyboard.endFrame();
	}

	public static function getMouse():Mouse{
		if (!registered) register();
		if (mouse == null) mouse = new Mouse();
		return mouse;
	}

	public static function getKeyboard():Keyboard {
		if (!registered) register();
		if (keyboard == null) keyboard = new Keyboard();
		return keyboard;
	}

	static inline function register() {
		registered = true;
		App.notifyOnEndFrame(endFrame);
		App.notifyOnReset(reset);
	}

}

class Mouse {

	var buttons = ['left', 'right', 'middle'];
	var buttonDown = new Map<String, Bool>();
	var buttonStarted = new Map<String, Bool>();
	var buttonReleased = new Map<String, Bool>();

	public var x(default, null) = 0.0;
	public var y(default, null) = 0.0;
	public var moved(default, null) = false;
	public var movementX(default, null) = 0.0;
	public var movementY(default, null) = 0.0;
	public var wheelDelta(default, null) = 0;
	public var lastX = -1.0;
	public var lastY = -1.0;

	public function new() {
		reset();
		kha.input.Mouse.get().notify(downListener, upListener, moveListner, wheelListener);
	}

	public function endFrame() {
		buttonStarted.set("left", false);
		buttonStarted.set("right", false);
		buttonStarted.set("middle", false);
		buttonReleased.set("left", false);
		buttonReleased.set("right", false);
		buttonReleased.set("middle", false);
		moved = false;
		movementX = 0;
		movementY = 0;
		wheelDelta = 0;
	}

	public function reset() {
		buttonDown.set("left", false);
		buttonDown.set("right", false);
		buttonDown.set("middle", false);
		endFrame();
	}

	public function down(button: Int = 0){
		return buttonDown.get(buttonCode(button));
	}

	public function started(button: Int = 0){
		return buttonStarted.get(buttonCode(button));
	}

	public function released(button: Int = 0){
		return buttonReleased.get(buttonCode(button));
	}

	function buttonCode(button: Int): String{
		switch(button){
			case 0: return "left";
			case 1: return "right";
			case _: return "middle";
		}
	}

	function downListener(button:Int, x: Int, y:Int):Void {
		var b = buttonCode(button);
		buttonDown.set(b, true);
		buttonStarted.set(b, true);
		// var mouseX = Scaler.transformX(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		// var mouseY = Scaler.transformY(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		this.x = x;
		this.y = y;
	}

	function upListener(button: Int, x: Int, y: Int):Void{
		var b = buttonCode(button);
		buttonDown.set(b, false);
		buttonReleased.set(b, true);
		// var mouseX = Scaler.transformX(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		// var mouseY = Scaler.transformY(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		this.x = x;
		this.y = y;
	}

	function moveListner(x: Int, y: Int, movementX: Int, movementY: Int): Void{
		if (lastX == -1.0 && lastY == -1.0){
			lastX = x;
			lastY = y;
		}
		this.movementX += x-lastX;
		this.movementY += y-lastY;

		lastX = x;
		lastY = y;
		// var mouseX = Scaler.transformX(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		// var mouseY = Scaler.transformY(Std.int(x+App.camera.x), Std.int(y+App.camera.y), App.backbuffer, ScreenCanvas.the, System.screenRotation);
		this.x = x;
		this.y = y;

		moved = true;
	}

	function wheelListener(delta: Int){
		wheelDelta = delta;
	}
}

class Keyboard {
	var keys:Array<KeyCode> = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,Up,Down,Left,Right,Space,Return,Shift,Tab];
	var keyDown = new Map<KeyCode, Bool>();
	var keyStarted = new Map<KeyCode, Bool>();
	var keyReleased = new Map<KeyCode, Bool>();

	var keyFrame = [];

	public function new() {
		kha.input.Keyboard.get().notify(downListener, upListener);
	}

	public function endFrame() {
		if (keyFrame.length > 0) {
			for (s in keyFrame) {
				keyStarted.set(s, false);
				keyReleased.set(s, false);
			}
			keyFrame.splice(0, keyFrame.length);
		}
	}

	public function reset() {
		for (s in keys) {
			keyDown.set(s, false);
			keyStarted.set(s, false);
			keyReleased.set(s, false);
		}
		endFrame();
	}

	public function started(key:KeyCode) {
		return keyStarted.get(key);
	}

	public function released(key:KeyCode) {
		return keyReleased.get(key);
	}

	public function down(key:KeyCode) {
		return keyDown.get(key);
	}

	function downListener(code: kha.input.KeyCode):Void {
		keyFrame.push(code);
		keyStarted.set(code, true);
		keyDown.set(code, true);

	}
	function upListener(code: kha.input.KeyCode):Void {
		keyFrame.push(code);
		keyReleased.set(code, true);
		keyDown.set(code, false);
	}
}
