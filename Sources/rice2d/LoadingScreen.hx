package rice2d;

import kha.Image;
import kha.System;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

class LoadingScreen {

    public static var logo:Image;

	public static function render(g: Graphics, assetsLoaded: Int, assetsTotal: Int) {
        var wc = Window.getCenter();
        g.begin();
        var col = g.color;
        g.fillRect(0, 0, System.windowWidth(), System.windowWidth());
        g.drawImage(logo, wc.x - (logo.width/2), wc.y - (logo.height/2)-20);
        g.color = 0xffcf2b43;
        g.drawArc(wc.x, wc.y, 300, -Math.PI / 2, ((Math.PI * 2) / 5 * 4) - Math.PI / 2, 20);
        g.color = col;
        g.end();
	}
}