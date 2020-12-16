package rice2d;

import kha.math.Vector2;
import kha.System;

class Window {

    public static function getTitle() {
        return kha.Window.get(0).title;
    }

    public static function setTitle(newTitle: String) {
        kha.Window.get(0).title = newTitle;
    }

    public static function getWindowSize() {
        return {width: System.windowWidth(), height: System.windowHeight()};
    }

    public static function setWindowSize(width:Int, height:Int) {
        kha.Window.get(0).resize(width, height);
    }

    public static function setFullscreen() {
        kha.Window.get(0).mode = Fullscreen;
    }

    public static function setWindowed() {
        kha.Window.get(0).mode = Windowed;
    }

    public static function getRaw() {
        return kha.Window.get(0);
    }

    public static function getCenter() {
        var size = getWindowSize();
        return new Vector2(size.width/2, size.height/2);
    }

}
