package rice2d;

import rice2d.object.Object;
import rice2d.data.ObjectData;

class Label {

	public static function hasLabel(objectData:ObjectData, label:String):Bool {
		var has:Bool = false;
		for(objLabel in objectData.labels) if (objLabel == label) has = true;
		return has;
	}

	public static function getObjectsOfLabel(label:String):Array<Object> {
		var objects:Array<Object> = [];
		for(object in Scene.objects)
			for(objLabel in object.props.labels)
				if(objLabel == label) objects.push(object);
		return objects;
	}
}
