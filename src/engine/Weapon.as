package engine 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class Weapon
	{
		public var entity:Entity;
		public var ammo:int;
			
		/*
		 * Weapon is the base class for all weapons.
		 */
		
		public function Weapon(entity:Entity) 
		{
			this.entity = entity;
		}
		
		public function fire():void
		{
			ammo--;
		}
	}
}