package rice2d.node;

import kha.input.KeyCode;

class OnKeyboardNode extends LogicNode {

	public var operations1: String;
	public var operations2: String;

	public function new(tree: LogicTree) {
		super(tree);
		tree.notifyOnUpdate(update);
	}

	function update() {
		var keyboard = rice2d.system.Input.getKeyboard();
		var bool = false;
		switch (operations1) {
            case "Started":
                bool = keyboard.started(getKeyboard(operations2));
            case "Released":
                bool = keyboard.released(getKeyboard(operations2));
            case "Down":
                bool = keyboard.down(getKeyboard(operations2));
		}
		if (bool) runOutput(0);
	}

    function getKeyboard(string:String):KeyCode {
        var key: Null<KeyCode> = null;
        switch (string){
            case "Up": key = Up;
            case "Down": key = Down;
            case "Left": key = Left;
            case "Right": key = Right;
            case "Space": key = Space;
            case "Return": key = Return;
            case "Shift": key = Shift;
            case "Tab": key = Tab;
            case "A": key = A;
            case "B": key = B;
            case "C": key = C;
            case "D": key = D;
            case "E": key = E;
            case "F": key = F;
            case "G": key = G;
            case "H": key = H;
            case "I": key = I;
            case "J": key = J;
            case "K": key = K;
            case "L": key = L;
            case "M": key = M;
            case "N": key = N;
            case "O": key = O;
            case "P": key = P;
            case "Q": key = Q;
            case "R": key = R;
            case "S": key = S;
            case "T": key = T;
            case "U": key = U;
            case "V": key = V;
            case "W": key = W;
            case "X": key = X;
            case "Y": key = Y;
            case "Z": key = Z;
        }
        return key;
    }
}