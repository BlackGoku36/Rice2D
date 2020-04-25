package rice2d.data;

typedef ShaderData = {
	var fragmentShader: kha.graphics4.FragmentShader;
	var constants:Array<ConstantData>;
	var type: ShaderType;
}

enum abstract ShaderType(Int) from Int to Int {
	var Texture;
	var Color;
}

typedef ConstantData = {
	var name:String;
	var type:ConstantType;
	var ?val:Array<Float>;
	var ?bool:Bool;
	var ?tex:kha.Image;
}

enum abstract ConstantType(Int) from Int to Int {
	var Int;
	var Float;
	var Bool;
	var Vec2;
	var Texture;
}
