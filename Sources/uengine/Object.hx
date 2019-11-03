package uengine;

import uengine.data.ObjectData;

class Object {

    public static function addScript(name:String, object:ObjectData) {
        if(object.scripts == null) object.scripts = [];

        object.scripts.push(name);
        var scr = Type.resolveClass("scripts."+name);
        if (scr == null) return;
        var cls:Script = Type.createInstance(scr, []);
        cls.object = object;
    }
}