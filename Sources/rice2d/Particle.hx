package rice2d;

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
                lifeTime: props.particle.lifeTime, speed: props.particle.speed, 
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
    public function new(x:Float, y:Float, particle:ParticleData) {
        deltaTime = 0.0;
        this.x = x;
        this.y = y;
        rotataion = randomRangeFloat(particle.rots, particle.rote);
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
        if(props.lifeTime > deltaTime){
            //TODO: Add more types, visibility and size as it age.
            g.fillRect(x, y, 5, 5);
        }
    }

    public static function randomRangeFloat(min:Float, max:Float):Float {
		return Math.random() * (max - min) + min;
	}
}