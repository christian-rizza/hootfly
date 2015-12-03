package  {
	
	import flash.display.Sprite;
	import flash.media.Sound;
	
	
	public class Enemy extends Sprite
	{
		public var position:String;
		public var distance:int;
		public var explosion:Boolean;
		public var speed:int=0;
		public var alreadyHit:Boolean;
		
		public function Enemy(distance:int, speed:int=0) 
		{
			this.distance = distance;
		}
		
		public function destroy()
		{
			parent.removeChild(this);
		}
	}
	
}
