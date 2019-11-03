package uengine.system;

import haxe.display.Position;
import haxe.macro.Context;

class Input {
    public static var occupied = false;
    static var registered = false;
    static var mouse: Mouse;
    static var keyboard:Keyboard;

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

    public function down(button: String = "left"){
		return buttonDown.get(button);
	}

    public function started(button: String = "left"){
		return buttonStarted.get(button);
	}

    public function released(button: String = "left"){
		return buttonReleased.get(button);
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
		this.x = x;
		this.y = y;
    }

	function upListener(button: Int, x: Int, y: Int):Void{
		var b = buttonCode(button);
        buttonDown.set(b, false);
        buttonReleased.set(b, true);
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
		this.x = x;
		this.y = y;

		moved = true;
	}

	function wheelListener(delta: Int){
		wheelDelta = delta;
	}
}

class Keyboard {
    var keys = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','up','down','left','right','space','return','shift','tab'];
    var keyDown = new Map<String, Bool>();
    var keyStarted = new Map<String, Bool>();
    var keyReleased = new Map<String, Bool>();

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

    public function started(key:String) {
        return keyStarted.get(key);
    }

    public function released(key:String) {
        return keyReleased.get(key);
    }

    public function down(key:String) {
        return keyDown.get(key);
    }

    function getKeyCode(keyCode:kha.input.KeyCode):String {
        var key = "";
        switch(keyCode){
            case A: key = "a";
            case B: key = "b";
            case C: key = "c";
            case D: key = "d";
            case E: key = "e";
            case F: key = "f";
            case G: key = "g";
            case H: key = "h";
            case I: key = "i";
            case J: key = "j";
            case K: key = "k";
            case L: key = "l";
            case M: key = "m";
            case N: key = "n";
            case O: key = "o";
            case P: key = "p";
            case Q: key = "q";
            case R: key = "r";
            case S: key = "s";
            case T: key = "t";
            case U: key = "u";
            case V: key = "v";
            case W: key = "w";
            case X: key = "x";
            case Y: key = "y";
            case Z: key = "z";
            case Up: key = "up";
            case Down: key = "down";
            case Left: key = "left";
            case Right: key = "right";
            case Space: key = "space";
            case Return: key = "return";
            case Shift: key = "shift";
            case Tab: key = "tab";
            case _: throw "Keycode "+ keyCode +" is not yet supported";
        }
        return key;
    }

    function downListener(code: kha.input.KeyCode):Void {
        var key = getKeyCode(code);
        keyFrame.push(key);
        keyStarted.set(key, true);
        keyDown.set(key, true);
        
    }
    function upListener(code: kha.input.KeyCode):Void {
        var key = getKeyCode(code);
        keyFrame.push(key);
        keyReleased.set(key, true);
        keyDown.set(key, false);
    }
}