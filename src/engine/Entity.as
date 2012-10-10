package engine  
{
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	
	public class Entity implements IEntity
	{
		private var _body:Body;
		private var _physics:Physics;
		private var _health:Health;
		private var _weapon:Weapon;
		private var _view:View;
		private var _entityCreated:Signal;
		private var _destroyed:Signal;
		private var _targets:Vector.<Entity>;
		private var _group:Vector.<Entity>;

		/*
		 * Anything that exists within your game is an Entity!
		 */
		
		public function Entity() 
		{
			entityCreated = new Signal(Entity);
			destroyed = new Signal(Entity);
		}
		
		public function destroy():void
		{
			destroyed.dispatch(this);
			
			if (group) group.splice(group.indexOf(this), 1);
		}
		
		public function update():void
		{
			if (physics) physics.update();
		}
		
		public function render():void
		{
			if (view) view.render();
		}
		
		public function get body():Body 
		{
			return _body;
		}
		
		public function set body(value:Body):void 
		{
			_body = value;
		}
		
		public function get physics():Physics 
		{
			return _physics;
		}
		
		public function set physics(value:Physics):void 
		{
			_physics = value;
		}
		
		public function get health():Health 
		{
			return _health;
		}
		
		public function set health(value:Health):void 
		{
			_health = value;
		}
		
		public function get weapon():Weapon 
		{
			return _weapon;
		}
		
		public function set weapon(value:Weapon):void 
		{
			_weapon = value;
		}
		
		public function get view():View 
		{
			return _view;
		}
		
		public function set view(value:View):void 
		{
			_view = value;
		}
		
		public function get entityCreated():Signal 
		{
			return _entityCreated;
		}
		
		public function set entityCreated(value:Signal):void 
		{
			_entityCreated = value;
		}
		
		public function get destroyed():Signal 
		{
			return _destroyed;
		}
		
		public function set destroyed(value:Signal):void 
		{
			_destroyed = value;
		}
		
		public function get targets():Vector.<Entity> 
		{
			return _targets;
		}
		
		public function set targets(value:Vector.<Entity>):void 
		{
			_targets = value;
		}
		
		public function get group():Vector.<Entity> 
		{
			return _group;
		}
		
		public function set group(value:Vector.<Entity>):void 
		{
			_group = value;
		}
	}
}