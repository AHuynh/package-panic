package cobaltric 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	/**
	 * Static class for playing sounds.
	 * @author Alexander Huynh
	 */
	public class SoundManager 
	{
		[Embed(source = "../../sound/PackagePanicLoop.mp3")]
		private static var bgm_main:Class;
		
		public static var bgm:SoundChannel;
		
		public function SoundManager() 
		{
			// -- static class; do not instiantiate
			trace("WARNING: SoundManager should not be instiantiated!");
		}
		
		public static function play(sound:String):void
		{
			switch (sound)
			{
				
			}
		}
		
		public static function playBGM(sound:String):void
		{
			stopBGM();
			
			var snd:Sound;
			switch (sound)
			{
				case "main":	snd = new bgm_main();		break;
			}
			bgm = snd.play(0, 9999);
		}
		
		public static function isBGMplaying():Boolean
		{
			return bgm != null;
		}
		
		public static function stopBGM():void
		{
			if (bgm)
			{
				bgm.stop();
				bgm = null;
			}
		}
	}
}