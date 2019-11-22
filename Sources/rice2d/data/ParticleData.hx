package rice2d.data;

typedef ParticleData = {
    var type:ParticleType;
    var width:Float;
    var height:Float;
    var speed: Float;
    var lifeTime: Float;
    var rots: Float;
    var rote: Float;
    @:optional var spriteRef: String;
}

typedef EmitterData = {
    var x: Float;
    var y: Float;
    var particle: ParticleData;
    var amount:Int;
}

@:enum abstract ParticleType(Int) from Int to Int {
    var Sprite = 0;
    var Rect = 1;
    var Triangle = 2;
    var Circle = 3;
}
