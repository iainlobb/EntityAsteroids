package engine  
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Health
	{
		public var entity:Entity;
		public var hits:int;
		public var died:Signal;
		public var hurt:Signal;
		
		public function Health(entity:Entity) 
		{
			this.entity = entity;
			died = new Signal(Entity);
			hurt = new Signal(Entity);
		}
		
		public function hit(damage:int):void
		{
			hits -= damage;
			
			hurt.dispatch(entity);
			
			if (hits < 0)
			{
				died.dispatch(entity);
			}
		}
		
	}

}