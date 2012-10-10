package engine  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class View
	{
		public var entity:Entity;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		public var sprite:Sprite;
		
		/*
		 * View is display component which renders an Entity using the standard display list. 
		 */
		
		public function View(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function render():void
		{
			sprite.x = entity.body.x;
			sprite.y = entity.body.y;
			sprite.rotation = entity.body.angle * (180 / Math.PI);
			sprite.alpha = alpha;
			sprite.scaleX = scale;
			sprite.scaleY = scale;
		}
	}
}