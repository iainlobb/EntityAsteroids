package asteroids 
{
	import engine.Body;
	import engine.Entity;
	import engine.Health;
	import engine.Physics;
	import engine.View;
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class EnemyShip extends Entity
	{
		protected var turnDirection:Number = 1;
		
		public function EnemyShip() 
		{
			body = new Body(this);
			body.x = 750;
			body.y = 550;
			
			physics = new Physics(this);
			physics.drag = 0.9;
			
			view = new View(this);
			view.sprite = new Sprite();
			view.sprite.graphics.lineStyle(1.5, 0xFFFFFF);
			view.sprite.graphics.drawPath(Vector.<int>([1, 2, 2, 2, 2]), 
											Vector.<Number>([ 0, 10, 10, -10, 0, 0, -10, -10, 0, 10]),
											GraphicsPathWinding.NON_ZERO);
			
			health = new Health(this);
			health.hits = 5;
			health.died.add(onDied);
		
			weapon = new Gun(this);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Math.random() < 0.1) turnDirection = -turnDirection;
			
			body.angle += turnDirection * 0.1;
			
			physics.thrust(Math.random());
			
			if (Math.random() < 0.05) weapon.fire();
		}
		
		protected function onDied(entity:Entity):void
		{
			destroy();
		}
		
	}

}