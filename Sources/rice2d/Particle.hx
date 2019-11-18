package rice2d;

import kha.Image;
import kha.graphics2.Graphics;
import rice2d.data.ParticleData;

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
        rotataion = randomRangeFloat(particle.rots, particle.rote);
        this.props = particle;
    }

    public function update() {
        deltaTime += 1/60;
        if(props.lifeTime > deltaTime){
            x += props.speed * Math.cos(rotataion);
            y += -props.speed * Math.sin(rotataion) *2;
        }
    }

    public function render(g:Graphics) {
        if(props.lifeTime > deltaTime){
            g.drawScaledImage(sprite, Math.round(x - (props.width / 2)), Math.round(y - (props.height / 2)), props.width, props.height);
        }
    }

    public static function randomRangeFloat(min:Float, max:Float):Float {
		return Math.random() * (max - min) + min;
	}

    function getImage(ref:String):Image {
        var image:Image = null;
        for (i in Scene.assets){
            if(i.exists(ref)) image = i.get(ref);
        }
        return image;
    }
}