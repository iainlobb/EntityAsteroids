package engine
{
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	
	public class Body
	{
		public var entity:Entity;
		public var x:Number = 0;
		public var y:Number = 0;
		public var angle:Number = 0;
		public var radius:Number = 10;
		
		/*
		* If you give an entity a body it can take physical form in the world, although to see it you will need a view.
		*/
		
		public function Body(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function testCollision(otherEntity:Entity):Boolean
		{
			var dx:Number;
			var dy:Number;
			
			dx = x - otherEntity.body.x;
			dy = y - otherEntity.body.y;
			
			return Math.sqrt((dx * dx) + (dy * dy)) <= radius + otherEntity.body.radius; 
		}
	}
}