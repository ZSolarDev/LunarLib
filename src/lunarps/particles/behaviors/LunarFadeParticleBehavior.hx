package lunarps.particles.behaviors;

import lunarps.particles.LunarParticle;
import lunarps.particles.LunarParticleEmitter;
import lunarps.particles.behaviors.LunarLifeParticleBehavior;

class LunarFadeParticleBehavior extends LunarLifeParticleBehavior
{
	public var fadeStartedCallback:(particle:LunarParticle, emitter:LunarParticleEmitter, dt:Float) -> Void = (particle, emitter, dt) -> {};
	public var fadeOnFrameCallback:(particle:LunarParticle, emitter:LunarParticleEmitter, dt:Float) -> Void = (particle, emitter, dt) -> {};
	public var fadeEndedCallback:(particle:LunarParticle, emitter:LunarParticleEmitter, dt:Float) -> Void = (particle, emitter, dt) ->
	{
		LunarParticleBehavior.killParticle(particle,);
	};

	public var fadeSpeed:Int = 1;

	public function new(lifeSecs:Float = 1, fadeSpeed:Int = 1)
	{
		super(lifeSecs);
		lifeEndedCallback = (particle, emitter, dt) ->
		{
			particle.values.fading = true;
		};
		this.fadeSpeed = fadeSpeed;
	}

	override public function onParticleSpawn(particle:LunarParticle, emitter:LunarParticleEmitter)
	{
		super.onParticleSpawn(particle, emitter);
		if (particle.values.fading == null)
			particle.values.fading = false;
		if (particle.values.calledFadeStartCallback == null)
			particle.values.calledFadeStartCallback = false;
	}

	override public function onParticleFrame(particle:LunarParticle, emitter:LunarParticleEmitter, dt:Float)
	{
		super.onParticleFrame(particle, emitter, dt);
		if (particle.values.fading)
		{
			if (!particle.values.calledFadeStartCallback)
			{
				fadeStartedCallback(particle, emitter, dt);
				particle.values.calledFadeStartCallback = true;
			}
			particle.shape.alpha -= fadeSpeed;
			fadeOnFrameCallback(particle, emitter, dt);
			if (particle.shape.alpha <= 0)
			{
				fadeEndedCallback(particle, emitter, dt);
			}
		}
	}
}
