package rice2d;

import kha.System;
import kha.graphics2.Graphics;

class LoadingScreen {

	public static function render(g: Graphics, assetsLoaded: Int, assetsTotal: Int) {
        g.begin();
		g.color = 0xffcf2b43;
        g.fillRect(0, System.windowHeight() - 6, System.windowWidth() / assetsTotal * assetsLoaded, 6);
        g.end();
	}
}