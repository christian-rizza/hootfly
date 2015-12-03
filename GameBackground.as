package  
{
	import flash.display.Sprite
	import flash.events.Event;

	public class GameBackground extends Sprite
	{
		
		public var speed:Number = 0;
		
		public function GameBackground() 
		{
			super();
			cacheAsBitmap = true;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{	
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void
		{
			this.x -= Math.ceil(speed);
			
			if (this.x <= -stage.stageWidth) this.x = 0;
		}
	}
	
}
