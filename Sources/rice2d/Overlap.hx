package rice2d;

import kha.math.Vector2;

class Overlap {
    
    public static function RectvsRect(pos1:Vector2, w1:Float, h1:Float, pos2:Vector2, w2:Float, h2:Float) {

        if (pos1.x + w1 >= pos2.x && pos1.x <= pos2.x  + w2 &&
            pos1.y + h1 >= pos2.y && pos1.y <= pos2.y + h2) return true;

        return false;
    }

    public static function CirclevsRect(cPos:Vector2, r:Float, rPos:Vector2, rw:Float, rh:Float) {

        var temp = new Vector2(cPos.x, cPos.y);

        if (cPos.x < rPos.x) temp.x = rPos.x;
        else if (cPos.x > rPos.x+rw) temp.x = rPos.x+rw;

        if (cPos.y < rPos.y) temp.y = rPos.y; 
        else if (cPos.y > rPos.y+rh) temp.y = rPos.y+rh; 

        var d = cPos.sub(temp).length;

        if (d <= r) return true;

        return false;
    }

    public static function CirclevsCircle(c1:Vector2, r1:Float, c2:Vector2, r2:Float) {

        var distance = c1.sub(c2).length;

        if (distance <= r1+r2) {
            return true;
        }

        return false;
    }
}