package rice2d.data;

typedef ShaderData = {
	var fragmentShader: kha.graphics4.FragmentShader;
	var constants:Array<ConstantData>;
	var type: ShaderType;
}

@:enum abstract ShaderType(Int) from Int to Int {
	var Texture = 0;
	var Color = 1;
}

typedef ConstantData = {
	var name:String;
	var type:ConstantType;
	var ?val:Array<Float>;
	var ?bool:Bool;
	var ?tex:kha.Image;
}

@:enum abstract ConstantType(Int) from Int to Int {
	var Int = 0;
	var Float = 1;
	var Bool = 2;
	var Vec2 = 3;
	var Texture = 4;
}
