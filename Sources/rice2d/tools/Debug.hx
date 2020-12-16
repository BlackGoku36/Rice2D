package rice2d.tools;

import kha.Color;
import kha.Canvas;

class Debug {

    public static var visible = false;
    static var fontSize = 25;

    static function render(canvas:Canvas) {
        if(!visible) return;
        if(App.font == null) return;

        var col = canvas.g2.color;
        canvas.g2.color = Color.Black;
        canvas.g2.font = App.font;
        canvas.g2.fontSize = fontSize;
        canvas.g2.fillRect(0, 0, Window.getWindowSize().width, canvas.g2.font.height(fontSize)+5);
        canvas.g2.color = Color.White;
        canvas.g2.drawString("FPS: "+App.fps+" | Render time: "+Math.round(App.renderTime*100000)/100+"ms | Update time: "+Math.round(App.updateTime*100000)/100+"ms", 5, 0);
        canvas.g2.color = col;
    }
}
