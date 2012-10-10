package asteroids 
{
	import engine.Body;
	import engine.Entity;
	import engine.Physics;
	import engine.View;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Bullet extends Entity
	{
		public var age:int;
		
		public function Bullet() 
		{
			body = new Body(this);
			body.radius = 5;
			
			physics = new Physics(this);
			
			view = new View(this);
			view.sprite = new Sprite();
			view.sprite.graphics.beginFill(0xFFFFFF);
			view.sprite.graphics.drawCircle(0, 0, body.radius);
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
			
			age++;
			if (age > 20) view.alpha -= 0.2;
			if (age > 25) destroy();
		}
		
	}

}