package packpan
{
	import cobaltric.Engine;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Executable file that starts up the game.
	 * @author Alexander Huynh
	 */
	[SWF(width="800", height="600", backgroundColor="#666666", framerate="30")]
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addChild(new Engine());
		}
	}
}