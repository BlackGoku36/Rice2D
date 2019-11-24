package rice2d.data;

typedef ShaderData = {
    var vertexShader: kha.graphics4.VertexShader;
    var fragmentShader: kha.graphics4.FragmentShader;
    @:optional var constants: Array<ConstantData>;
}

typedef ConstantData = {
    var name: String;
    var type: ValueType;
    var value: Array<Float>;
}

@:enum abstract ValueType(Int) from Int to Int {
    var Int = 0;
    var Float = 1;
    var Vec2 = 2;
    var Vec3 = 3;
    var Vec4 = 4;
}