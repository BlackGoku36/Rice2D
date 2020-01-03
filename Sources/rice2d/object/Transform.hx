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
		* @param x
		* @param y
		* @param s
		*/
	public function translate(x:Float, y:Float, s:Float) {
		object.props.x += x * s;
		object.props.y += y * s;
	}

	public function resize(width:Float = 0.0, height:Float = 0.0) {
		object.props.width += width;
		object.props.height += height;
	}
}
