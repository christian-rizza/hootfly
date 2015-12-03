package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	
	public class Owl extends MovieClip {
		
		private const ACCELERATION:int = 6;				//Acceleration
		
		public function Owl() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void
		{
			checkKeys();
		}
		private function checkKeys():void
		{
			if (KeyManager.isKeyDown(Keyboard.LEFT) && x > Game.MARGIN_X)
			{
				x = x - ACCELERATION;
			}
			else if (KeyManager.isKeyDown(Keyboard.RIGHT) && x < Game.WIDTH - Game.MARGIN_X)
			{
				x = x + ACCELERATION;
			}
			
			if (KeyManager.isKeyDown(Keyboard.UP) && y > 70)
			{
				y = y - ACCELERATION;
				//vespino.currentFrame = 29;
			}
			else if (KeyManager.isKeyDown(Keyboard.DOWN) && y < Game.HEIGHT - Game.MARGIN_Y)
			{
				y = y + ACCELERATION;
				//vespino.currentFrame = 32;
			}
		}
	}
	
}
