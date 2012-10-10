package asteroids 
{
	import engine.Entity;
	import engine.Game;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public class AsteroidsGame extends Game
	{
		public var players:Vector.<Entity> = new Vector.<Entity>();
		public var enemies:Vector.<Entity> = new Vector.<Entity>();
		public var messageField:TextField;
		
		public function AsteroidsGame() 
		{
			
		}
		
		override protected function startGame():void 
		{
			var asteroid:Asteroid;
			for (var i:int = 0; i < 10; i++)
			{
				asteroid = new Asteroid();
				asteroid.targets = players;
				asteroid.group = enemies;
				enemies.push(asteroid);
				addEntity(asteroid);
			}
			
			var ship:Ship = new Ship();
			ship.targets = enemies;
			ship.destroyed.add(onPlayerDestroyed);
			players.push(ship);
			addEntity(ship);
			
			var enemyShip:EnemyShip = new EnemyShip();
			enemyShip.targets = players;
			enemyShip.group = enemies;
			enemies.push(enemyShip);
			addEntity(enemyShip);
			
			filters = [new GlowFilter(0xFFFFFF, 0.8, 6, 6, 1)];
			
			update();
			
			render();
			
			isPaused = true;
			
			if (messageField)
			{
				addChild(messageField);
			}
			else
			{
				createMessage();
			}
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, start);
		}
		
		protected function createMessage():void
		{
			messageField = new TextField();
			messageField.selectable = false;
			messageField.textColor = 0xFFFFFF;
			messageField.width = 600;
			messageField.scaleX = 2;
			messageField.scaleY = 3;
			messageField.text = "CLICK TO START";
			messageField.x = 400 - messageField.textWidth;
			messageField.y = 240;
			addChild(messageField);
		}
		
		protected function start(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, start);
			isPaused = false;
			removeChild(messageField);
			stage.focus = stage;
		}
		
		protected function onPlayerDestroyed(entity:Entity):void
		{
			gameOver();
		}
		
		protected function gameOver():void
		{
			addChild(messageField);
			isPaused = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, restart);
		}
		
		protected function restart(event:MouseEvent):void
		{
			stopGame();
			startGame();
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, restart);
			isPaused = false;
			removeChild(messageField);
			stage.focus = stage;
		}
		
		override protected function stopGame():void 
		{
			super.stopGame();
			
			players.length = 0;
			enemies.length = 0;
		}
		
		override protected function update():void 
		{
			super.update();
			
			for each (var entity:Entity in entities)
			{
				if (entity.body.x > 850) entity.body.x -= 900;
				if (entity.body.x < -50) entity.body.x += 900;
			
				if (entity.body.y > 650) entity.body.y -= 700;
				if (entity.body.y < -50) entity.body.y += 700;
			}
			
			if (enemies.length == 0) gameOver();
		}
		
	}
}