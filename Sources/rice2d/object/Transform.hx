package rice2d.object;

class Transform{

	public var object: Object;

	public function new() {}

	/**
		* Get object center
		*/
	public function getCenter() {
		var x: Float;
		var y: Float;
		x = object.props.x + (object.props.width / 2);
		y = object.props.y + (object.props.height / 2);
		return { x : x, y : y}
	}
	
	/**
	 * Set object's center
	 * @param x 
	 * @param y 
	 */
	public function setCenter(x:Float, y:Float) {
		object.props.x = x - (object.props.width / 2);
		object.props.y = y - (object.props.height / 2);
	}
	/**
		* Translate object
		* @param x translate on x-axis
		* @param y translate on y-axis
		* @param s speed of translation
		*/
	public function translate(x:Float, y:Float, s:Float) {
		object.props.x += x * s;
		object.props.y += y * s;
	}

	/**
	 * Resize the object
	 * @param width amount of width to be resized
	 * @param height amount of height to be resized
	 */
	public function resize(width:Float = 0.0, height:Float = 0.0) {
		object.props.width += width;
		object.props.height += height;
	}

	/**
	 * Make object look at some point
	 * @param x 
	 * @param y 
	 */
	public function lookAt(x:Float, y:Float) {
		var center = getCenter();
		var rot = Math.atan2(y - center.y, x - center.x);
		object.props.rotation = rot;
		return rot;
	}
}
