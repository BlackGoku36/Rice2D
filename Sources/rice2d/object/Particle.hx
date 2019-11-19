package rice2d.object;

//Kha
import kha.Image;
import kha.graphics2.Graphics;

//Engine
import rice2d.data.ParticleData;
import rice2d.tools.Util;

class Emitter {
    public var props: EmitterData;
    var particles: Array<Particle>;

    public function new(emitter:EmitterData) {
        this.props = emitter;
        particles = [];
    }

    public function spawn() {
        for(i in 0...props.amount){
            var newParticle:Particle = new Particle(props.x, props.y,{
                width: props.particle.width, height: props.particle.height,
                lifeTime: props.particle.lifeTime, speed: props.particle.speed,
                spriteRef: props.particle.spriteRef,
                rots: props.particle.rots, rote:props.particle.rote
            });
            particles.push(newParticle);
        }
    }

    public function update() {
        for (particle in particles) particle.update();
    }

    public function render(g:Graphics) {
        for (particle in particles) particle.render(g);
    }
}

class Particle {
    public var x:Float;
    public var y:Float;

    public var props: ParticleData;
    public var deltaTime: Float;
    public var rotataion: Float;

    public var sprite:Image;

    public function new(x:Float, y:Float, particle:ParticleData) {
        deltaTime = 0.0;
        this.x = x;
        this.y = y;
        this.sprite = getImage(particle.spriteRef);
        rotataion = rice2d.tools.Util.randomRangeF(particle.rots, particle.rote);
        this.props = particle;
    }

    public function update() {
        deltaTime += 1/60;
        if(props.lifeTime > deltaTime){
            x += props.speed * Math.cos(rotataion);
            y += -props.speed * Math.sin(rotataion);
        }
    }

    public function render(g:Graphics) {
        var center = Util.getCenter(x, y, props.width, props.height);
        if(props.lifeTime > deltaTime){
            g.drawScaledImage(sprite, Math.round(center.x), Math.round(center.y), props.width, props.height);
        }
    }

    function getImage(ref:String):Image {
        var image:Image = null;
        for (i in Scene.assets){
            if(i.exists(ref)) image = i.get(ref);
        }
        return image;
    }
}
