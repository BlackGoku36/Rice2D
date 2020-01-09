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
}
