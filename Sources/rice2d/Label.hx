package rice2d;

import rice2d.data.ObjectData;

class Label {

    public static function hasLabel(objectData:ObjectData, hasLabel:String):Bool {
        var has:Bool = false;
        for(label in objectData.labels) if (label == hasLabel) has = true;
        return has;
    }
}