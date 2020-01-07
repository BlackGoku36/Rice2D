package rice2d.node;

class GateNode extends LogicNode {

	public var operations: String;

	public function new(tree: LogicTree) {
		super(tree);
	}

	override function run(from: Int) {

		var v1: Dynamic = inputs[1].get();
		var v2: Dynamic = inputs[2].get();
		var cond = false;

		switch (operations) {
            case "Equal":
                cond = v1 == v2;
            case "Greater":
                cond = v1 > v2;
            case "Greater Equal":
                cond = v1 >= v2;
            case "Less":
                cond = v1 < v2;
            case "Less Equal":
                cond = v1 <= v2;
            case "OR":
                for (i in 1...inputs.length) {
                    if (inputs[i].get()) {
                        cond = true;
                        break;
                    }
                }
            case "AND":
                cond = true;
                for (i in 1...inputs.length) {
                    if (!inputs[i].get()) {
                        cond = false;
                        break;
                    }
                }
		}

		cond ? runOutput(0) : runOutput(1);
	}
}