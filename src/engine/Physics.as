package engine  
{
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Physics
	{
		public var entity:Entity;
		public var drag:Number = 1;
		public var velocityX:Number = 0;
		public var velocityY:Number = 0;
		
		/*
		 * Provides a basic physics step without collision detection. Extend to add collision handling.
		 */
		
		public function Physics(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function update():void
		{
			entity.body.x += velocityX;
			entity.body.y += velocityY;
			
			velocityX *= drag;
			velocityY *= drag;
		}
		
		public function thrust(power:Number):void
		{
			velocityX += Math.sin(-entity.body.angle) * power;
			velocityY += Math.cos(-entity.body.angle) * power;
		}
	}

}