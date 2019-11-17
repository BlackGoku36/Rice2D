package rice2d.data;

typedef ParticleData = {
    var lifeTime: Float;
    var speed: Float;
    var rots: Float;
    var rote: Float;
}

typedef EmitterData = {
    var x: Float;
    var y: Float;
    var particle: ParticleData;
    var amount:Int;
}