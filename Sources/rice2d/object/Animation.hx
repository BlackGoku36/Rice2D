
//Originally written by Robert Konrad in Kha2D (https://github.com/Kha-Samples/Kha2D/blob/master/Sources/kha2d/Animation.hx)

package rice2d.object;

class Animation {

	var indices: Array<Int>;
	var speeddiv: Int;
	var count: Int;
	var index: Int;

	public static function create(index: Int) {
		var indices = [index];
		return new Animation(indices, 1);
	}

	public static function createRange(minindex: Int, maxindex: Int, speeddiv: Int): Animation {
		var indices = new Array<Int>();
		for (i in 0...maxindex - minindex + 1) indices.push(minindex + i);
		return new Animation(indices, speeddiv);
	}

	public function new(indices: Array<Int>, speeddiv: Int) {
		this.indices = indices;
		index = 0;
		this.speeddiv = speeddiv;
	}

	public function take(animation: Animation) {
		if (indices == animation.indices) return;
		indices = animation.indices;
		speeddiv = animation.speeddiv;
		reset();
	}

	public function get(): Int {
		return indices[index];
	}

	public function getIndex(): Int {
		return index;
	}

	public function setIndex(index: Int): Void {
		if (index < indices.length) this.index = index;
	}

	public function update(): Bool {
		++count;
		if (count % speeddiv == 0) {
			++index;
			if (index >= indices.length) {
				index = 0;
				return false;
			}
		}
		return true;
	}

	public function reset(): Void {
		count = 0;
		index = 0;
	}
}
