package rice2d;

import rice2d.object.Object;
import rice2d.data.ObjectData;

class Label {

	/**
	 * Check if object have label.
	 * @param objectData Object to search label for
	 * @param label The label to search
	 * @return Bool It does or it doesn't
	 */
	public static function hasLabel(objectData:ObjectData, label:String):Bool {
		var has:Bool = false;
		for(objLabel in objectData.labels) if (objLabel == label) has = true;
		return has;
	}

	/**
	 * Get all objects that have the label
	 * @param label The label to search for
	 * @return Array<Object> List of objects that have label.
	 */
	public static function getObjectsOfLabel(label:String):Array<Object> {
		var objects:Array<Object> = [];
		for(object in Scene.objects)
			for(objLabel in object.props.labels)
				if(objLabel == label) objects.push(object);
		return objects;
	}
}
