package  {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	public class KeyManager {

		private static var _enabled:Boolean;
		private static var stage:Stage;
		private static var key_pressed:Array = [];
		
		public static function init(s:Stage):void
		{
			stage = s;
		}
		public static function enable():void
		{
			if (!_enabled)
			{
				_enabled=true;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				key_pressed = [];
			}
		}
		
		public static function disable():void
		{
			if (_enabled)
			{
				_enabled=false;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				key_pressed = [];
			}
		}

		
		private static function onKeyDown(e:KeyboardEvent):void
		{
			key_pressed[e.keyCode] = true;
		}
		
		private static function onKeyUp(e:KeyboardEvent):void
		{
			key_pressed[e.keyCode] = false;
		}
		
		public static function isKeyDown( keyCode:uint ):Boolean
		{
			return key_pressed[keyCode] as Boolean;
		}

	}
	
}
