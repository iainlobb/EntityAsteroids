package engine 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	
	 public class Game extends Sprite
	{
		public var entities:Vector.<Entity> = new Vector.<Entity>();
		public var isPaused:Boolean;
		static public var stage:Stage;
		
		/*
		 * Game is the base class for games.
		 */
		
		public function Game() 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if (isPaused) return;
			
			update();
			
			render();
		}
		
		protected function update():void
		{
			for each (var entity:Entity in entities) entity.update();
		}
		
		protected function render():void
		{
			for each (var entity:Entity in entities) entity.render();
		}
		
		protected function onAddedToStage(event:Event):void
		{
			Game.stage = stage;
			
			startGame();
		}
		
		protected function startGame():void
		{
			
		}
		
		protected function stopGame():void
		{
			for each (var entity:Entity in entities)
			{
				if (entity.view) removeChild(entity.view.sprite);
			}
			
			entities.length = 0;
		}
		
		public function addEntity(entity:Entity):Entity
		{
			entities.push(entity);
			
			entity.destroyed.add(onEntityDestroyed);
			entity.entityCreated.add(addEntity);
			
			if (entity.view) addChild(entity.view.sprite);
			
			return entity;
		}
		
		protected function onEntityDestroyed(entity:Entity):void
		{
			entities.splice(entities.indexOf(entity), 1);
			
			if (entity.view) removeChild(entity.view.sprite);
			
			entity.destroyed.remove(onEntityDestroyed);
		}
		
		
	}
}