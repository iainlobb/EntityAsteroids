package asteroids 
{
	import com.iainlobb.gamepad.Gamepad;
	import com.iainlobb.gamepad.KeyCode;
	import engine.Body;
	import engine.Entity;
	import engine.Game;
	import engine.Health;
	import engine.Physics;
	import engine.View;
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Ship extends Entity
	{
		protected var gamepad:Gamepad;
		
		public function Ship() 
		{
			body = new Body(this);
			body.x = 400;
			body.y = 300;
			
			physics = new Physics(this);
			physics.drag = 0.9;
			
			view = new View(this);
			view.sprite = new Sprite();
			view.sprite.graphics.lineStyle(1.5, 0xFFFFFF);
			view.sprite.graphics.drawPath(Vector.<int>([1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]), 
											Vector.<Number>([ -7.3, 10.3, -5.5, 10.3, -7, 0.6, -0.5, -2.8, 6.2, 0.3, 4.5, 10.3, 6.3, 10.3, 11.1, -1.4, -0.2, -9.6, -11.9, -1.3, -7.3, 10.3]),
											GraphicsPathWinding.NON_ZERO);
			
			health = new Health(this);
			health.hits = 5;
			health.died.add(onDied);
											
			weapon = new Gun(this);
											
			gamepad = new Gamepad(Game.stage, false);
			gamepad.fire1.mapKey(KeyCode.SPACEBAR);
		}
		
		override public function update():void 
		{
			super.update();
			
			body.angle += gamepad.x * 0.1;
			
			physics.thrust(-gamepad.y);
			
			if (gamepad.fire1.isPressed) weapon.fire();
		}
		
		protected function onDied(entity:Entity):void
		{
			destroy();
		}
	}

}