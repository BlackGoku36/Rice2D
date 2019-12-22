package rice2d.node;

@:keep
class Logic {

	static var nodes:Array<TNode>;
	static var links:Array<TNodeLink>;

	static var parsed_nodes:Array<String> = null;
	static var parsed_labels:Map<String, String> = null;
	static var nodeMap:Map<String, LogicNode>;

	public static var enumTexts: String->Array<String> = null;

	public static var packageName = "rice2d.node";

	public static function getNode(id: Int): TNode {
		for (n in nodes) if (n.id == id) return n;
		return null;
	}

	public static function getLink(id: Int): TNodeLink {
		for (l in links) if (l.id == id) return l;
		return null;
	}

	public static function getInputLink(inp: TNodeSocket): TNodeLink {
		for (l in links) {
			if (l.to_id == inp.node_id) {
				var node = getNode(inp.node_id);
				if (node.inputs.length <= l.to_socket) return null;
				if (node.inputs[l.to_socket] == inp) return l;
			}
		}
		return null;
	}

	public static function getOutputLinks(out: TNodeSocket): Array<TNodeLink> {
		var res: Array<TNodeLink> = [];
		for (l in links) {
			if (l.from_id == out.node_id) {
				var node = getNode(out.node_id);
				if (node.outputs.length <= l.from_socket) continue;
				if (node.outputs[l.from_socket] == out) res.push(l);
			}
		}
		return res;
	}

	static function safesrc(s:String):String {
		return StringTools.replace(s, ' ', '');
	}

	static function node_name(node:TNode):String {
		var s = safesrc(node.name) + node.id;
		return s;
	}

	static var tree: LogicTree;
	public static function parse(canvas:TNodeCanvas, onAdd = true): LogicTree {

		nodes = canvas.nodes;
		links = canvas.links;

		parsed_nodes = [];
		parsed_labels = new Map();
		nodeMap = new Map();
		var root_nodes = get_root_nodes(canvas);

		tree = new LogicTree();
		if (onAdd) {
			// tree.notifyOnAdd(function() {
				for (node in root_nodes) build_node(node);
			// });
		}
		else {
			for (node in root_nodes) build_node(node);
		}
		return tree;
	}

	static function build_node(node: TNode): String {

		// Get node name
		var name =  node_name(node);

		// Check if node already exists
		if (parsed_nodes.indexOf(name) != -1) {
			return name;
		}

		parsed_nodes.push(name);

		// Create node
		var v = createClassInstance(node.type, [tree]);
		nodeMap.set(name, v);

		// Expose button values in node class
		for (b in node.buttons) {
			if (b.type == "ENUM") {
				var arrayData = Std.is(b.data, Array);
				var texts = arrayData ? b.data : enumTexts(node.type);
				Reflect.setProperty(v, b.name, texts[b.default_value]);
			}
			else {
				Reflect.setProperty(v, b.name, b.default_value);
			}
		}

		// Create inputs
		var inp_node: LogicNode = null;
		var inp_from = 0;
		for (i in 0...node.inputs.length) {
			var inp = node.inputs[i];
			// Is linked - find node
			var l = getInputLink(inp);
			if (l != null) {
				var n = getNode(l.from_id);
				var socket = n.outputs[l.from_socket];
				inp_node = nodeMap.get(build_node(n));
				for (i in 0...n.outputs.length) {
					if (n.outputs[i] == socket) {
						inp_from = i;
						break;
					}
				}
			}
			// Not linked - create node with default values
			else {
				inp_node = build_default_node(inp);
				inp_from = 0;
			}
			// Add input
			v.addInput(inp_node, inp_from);
		}

		// Create outputs
		for (out in node.outputs) {
			var outNodes:Array<LogicNode> = [];
			var ls = getOutputLinks(out);
			if (ls != null && ls.length > 0) {
				for (l in ls) {
					var n = getNode(l.to_id);
					var out_name = build_node(n);
					outNodes.push(nodeMap.get(out_name));
				}
			}
			// Not linked - create node with default values
			else {
				outNodes.push(build_default_node(out));
			}
			// Add outputs
			v.addOutputs(outNodes);
		}

		return name;
	}

	static function get_root_nodes(node_group:TNodeCanvas):Array<TNode> {
		var roots:Array<TNode> = [];
		for (node in node_group.nodes) {
			// if (node.bl_idname == 'NodeUndefined') {
				// arm.log.warn('Undefined logic nodes in ' + node_group.name)
				// return []
			// }
			var linked = false;
			for (out in node.outputs) {
				var ls = getOutputLinks(out);
				if (ls != null && ls.length > 0) {
					linked = true;
					break;
				}
			}
			if (!linked) { // Assume node with no connected outputs as roots
				roots.push(node);
			}
		}
		return roots;
	}

	static function build_default_node(inp:TNodeSocket): LogicNode {

		var v: LogicNode = null;

		if (inp.type == 'OBJECT') {
			v = createClassInstance('ObjectNode', [tree, inp.default_value]);
		}
		else if (inp.type == 'ANIMACTION') {
			v = createClassInstance('StringNode', [tree, inp.default_value]);
		}
		else if (inp.type == 'VECTOR2') {
			if (inp.default_value == null) inp.default_value = [0, 0]; // TODO
			v = createClassInstance('Vector2Node', [tree, inp.default_value[0], inp.default_value[1]]);
		}
		else if (inp.type == 'RGBA') {
			if (inp.default_value == null) inp.default_value = [0, 0, 0]; // TODO
			v = createClassInstance('ColorNode', [tree, inp.default_value[0], inp.default_value[1], inp.default_value[2], inp.default_value[3]]);
		}
		else if (inp.type == 'RGB') {
			if (inp.default_value == null) inp.default_value = [0, 0, 0]; // TODO
			v = createClassInstance('ColorNode', [tree, inp.default_value[0], inp.default_value[1], inp.default_value[2]]);
		}
		else if (inp.type == 'VALUE') {
			v = createClassInstance('FloatNode', [tree, inp.default_value]);
		}
		else if (inp.type == 'INT') {
			v = createClassInstance('IntegerNode', [tree, inp.default_value]);
		}
		else if (inp.type == 'BOOLEAN') {
			v = createClassInstance('BooleanNode', [tree, inp.default_value]);
		}
		else if (inp.type == 'STRING') {
			v = createClassInstance('StringNode', [tree, inp.default_value]);
		}
		else { // ACTION, ARRAY
			v = createClassInstance('NullNode', [tree]);
		}
		return v;
	}

	static function createClassInstance(className:String, args:Array<Dynamic>):Dynamic {
		var cname = Type.resolveClass(packageName + '.' + className);
		if (cname == null) return null;
		return Type.createInstance(cname, args);
	}
}

typedef TNodeCanvas = {
	var name: String;
	var nodes: Array<TNode>;
	var links: Array<TNodeLink>;
}

typedef TNode = {
	var id: Int;
	var name: String;
	var type: String;
	var x: Float;
	var y: Float;
	var inputs: Array<TNodeSocket>;
	var outputs: Array<TNodeSocket>;
	var buttons: Array<TNodeButton>;
	var color: Int;
}

typedef TNodeSocket = {
	var id: Int;
	var node_id: Int;
	var name: String;
	var type: String;
	var color: Int;
	var default_value: Dynamic;
	@:optional var min: Null<Float>;
	@:optional var max: Null<Float>;
}

typedef TNodeLink = {
	var id: Int;
	var from_id: Int;
	var from_socket: Int;
	var to_id: Int;
	var to_socket: Int;
}

typedef TNodeButton = {
	var name: String;
	var type: String;
	@:optional var output: Null<Int>;
	@:optional var default_value: Dynamic;
	@:optional var data: Dynamic;
	@:optional var min: Null<Float>;
	@:optional var max: Null<Float>;
}
