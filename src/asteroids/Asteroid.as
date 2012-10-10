package asteroids 
{
	import engine.Body;
	import engine.Entity;
	import engine.Health;
	import engine.Physics;
	import engine.View;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Asteroid extends Entity
	{
		public function Asteroid() 
		{
			body = new Body(this);
			body.radius = 20;
			body.x = Math.random() * 800;
			body.y = Math.random() * 600;
			
			physics = new Physics(this);
			physics.velocityX = (Math.random() * 10) - 5;
			physics.velocityY = (Math.random() * 10) - 5;
			
			view = new View(this);
			view.sprite = new Sprite();
			view.sprite.graphics.lineStyle(1.5, 0xFFFFFF);
			view.sprite.graphics.drawCircle(0, 0, body.radius);
			
			health = new Health(this);
			health.hits = 3;
			health.hurt.add(onHurt);
		}
		
		override public function update():void 
		{
			super.update();
			
			for each (var target:Entity in targets)
			{
				if (body.testCollision(target))
				{
					target.health.hit(1);
					destroy();
					return;
				}
			}
		}
		
		protected function onHurt(entity:Entity):void
		{
			body.radius *= 0.75;
			view.scale *= 0.75;
			
			if (body.radius < 10)
			{
				destroy();
				return;
			}
			
			var asteroid:Asteroid = new Asteroid();
			asteroid.targets = targets;
			group.push(asteroid);
			asteroid.group = group;
			asteroid.body.x = body.x;
			asteroid.body.y = body.y;
			asteroid.body.radius = body.radius;
			asteroid.view.scale = view.scale;
			entityCreated.dispatch(asteroid);
		}
		
	}

}