package rice2d.object;

//Kha
import kha.Image;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

//Engine
import rice2d.data.ParticleData;
import rice2d.tools.Util;

class Emitter {
    public var props: EmitterData;
    var particles: Array<Particle>;

    /**
     * Create new emitter
     * @param emitter Emitter's data
     */
    public function new(emitter:EmitterData) {
        this.props = emitter;
        particles = [];
    }

    /**
     * Spawn particles
     */
    public function spawn() {
        for(i in 0...props.amount){
            var newParticle:Particle = new Particle(props.x, props.y,{
                type: props.particle.type,
                width: props.particle.width, height: props.particle.height,
                lifeTime: props.particle.lifeTime, speed: props.particle.speed,
                spriteRef: props.particle.spriteRef,
                rots: props.particle.rots, rote:props.particle.rote
            });
            particles.push(newParticle);
        }
    }

    /**
     * Update particles
     */
    public function update() {
        if(particles != null)  for (particle in particles){
            if(particle.done) particles.remove(particle);
            particle.update();
        }
    }

    /**
     * Render particles
     * @param g
     */
    public function render(g:Graphics) {
        if(particles != null) for (particle in particles) particle.render(g);
    }
}

class Particle {
    public var x:Float;
    public var y:Float;

    public var props: ParticleData;
    public var deltaTime: Float;
    public var rotataion: Float;

    public var sprite:Image;

    public var done:Bool = false;

    public function new(x:Float, y:Float, particle:ParticleData) {
        deltaTime = 0.0;
        this.x = x;
        this.y = y;
        this.sprite = rice2d.Assets.getImage(particle.spriteRef);
        rotataion = rice2d.tools.Util.randomRangeF(particle.rots, particle.rote);
        this.props = particle;
    }

    public function update() {
        deltaTime += 1/60;
        if(props.lifeTime < deltaTime) done = true;
        x += props.speed * Math.cos(rotataion);
        y += -props.speed * Math.sin(rotataion);
    }

    public function render(g:Graphics) {
        var center = Util.getCenter(x, y, props.width, props.height);
        switch (props.type){
            case Sprite: g.drawScaledImage(sprite, Math.round(center.x), Math.round(center.y), props.width, props.height);
            case Rect: g.fillRect(Math.round(center.x), Math.round(center.y), props.width, props.height);
            case Triangle: g.fillTriangle(x, y-(props.width/2), x-(props.width/2), y+(props.width/2), x+(props.width/2), y+(props.width/2));
            case Circle: g.fillCircle(Math.round(center.x), Math.round(center.y), props.width);
        }
    }
}
