package rice2d.data;

typedef ParticleData = {
	var type:ParticleType;
	var width:Float;
	var ?height:Float;
	var speed: Float;
	var lifeTime: Float;
	var rots: Float;
	var rote: Float;
	var ?color: Array<Int>;
	var ?spriteRef: String;
	var ?controlLifetime: Array<LifetimeAttribute>;
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

@:enum abstract LifetimeAttribute(Int) from Int to Int {
	var Alpha = 0;
	var Size = 1;
}
