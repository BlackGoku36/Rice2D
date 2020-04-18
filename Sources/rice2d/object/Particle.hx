package rice2d.object;

//Kha
import kha.Color;
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
				color: props.particle.color,
				width: props.particle.width, height: props.particle.height,
				lifeTime: props.particle.lifeTime, speed: props.particle.speed,
				controlLifetime: props.particle.controlLifetime,
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
	public function render(g:kha.Canvas) {
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
		this.sprite = rice2d.Assets.getAsset(particle.spriteRef, Image);
		rotataion = rice2d.tools.Util.randomRangeF(particle.rots, particle.rote);
		this.props = particle;
		if(props.height == null) props.height = 1.0;
	}

	public function update() {
		deltaTime += 1/60;
		if(props.lifeTime < deltaTime) done = true;
		x += props.speed * Math.cos(rotataion);
		y += -props.speed * Math.sin(rotataion);
		if(props.controlLifetime != null && props.controlLifetime.indexOf(Size) != -1){
			var width = props.width;
			var height = props.height;
			props.width = Util.lerp(width, 0, deltaTime);
			props.height = Util.lerp(height, 0, deltaTime);
		}
	}

	public function render(canvas:kha.Canvas) {
		var g = canvas.g2;
		var center = Util.getCenter(x, y, props.width, props.height);
		var col = g.color;
		var alpha = props.color == null ? 255 : props.color[3];
		if(props.controlLifetime != null && props.controlLifetime.indexOf(Alpha) != -1) alpha = Std.int(Util.lerp(props.color[3], 0, deltaTime));
		if(props.color != null) g.color = Color.fromBytes(props.color[0], props.color[1], props.color[2], alpha);
		switch (props.type){
			case Sprite: g.drawScaledImage(sprite, Math.round(center.x), Math.round(center.y), props.width, props.height);
			case Rect: g.fillRect(Math.round(center.x), Math.round(center.y), props.width, props.height);
			case Triangle: g.fillTriangle(x, y-(props.width/2), x-(props.width/2), y+(props.width/2), x+(props.width/2), y+(props.width/2));
			case Circle: g.fillCircle(Math.round(center.x), Math.round(center.y), props.width);
		}
		g.color = col;
	}
}
