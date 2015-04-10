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
		[Embed(source = "../../sound/BGM_PackagePanicLoop.mp3")]
		private static var bgm_main:Class;
		[Embed(source = "../../sound/BGM_ConveyerBelts.mp3")]
		private static var bgm_cb:Class;
		[Embed(source = "../../sound/BGM_PanickingPackages.mp3")]
		private static var bgm_pp:Class;
		[Embed(source = "../../sound/BGM_PackagePalooza.mp3")]
		private static var bgm_pl:Class;
		
		
		[Embed(source = "../../sound/SFX_conveyorRotate.mp3")]
		private static var SFX_rotate:Class;
		[Embed(source = "../../sound/SFX_elevator.mp3")]
		private static var SFX_elevator:Class;
		[Embed(source = "../../sound/SFX_incinerator.mp3")]
		private static var SFX_incinerate:Class;
		[Embed(source = "../../sound/SFX_packageBin.mp3")]
		private static var SFX_bin:Class;
		[Embed(source = "../../sound/SFX_packageFall.mp3")]
		private static var SFX_fall:Class;
		[Embed(source = "../../sound/SFX_xrayBad.mp3")]
		private static var SFX_xgood:Class;
		[Embed(source = "../../sound/SFX_xrayGood.mp3")]
		private static var SFX_xbad:Class;
		
		private static var sfx_rotate:Sound = new SFX_rotate();
		private static var sfx_elevator:Sound = new SFX_elevator();
		private static var sfx_incinerate:Sound = new SFX_incinerate();
		private static var sfx_bin:Sound = new SFX_bin();
		private static var sfx_fall:Sound = new SFX_fall();
		private static var sfx_xgood:Sound = new SFX_xgood();
		private static var sfx_xbad:Sound = new SFX_xbad();
		
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
				case "sfx_rotate":		sfx_rotate.play();		break;
				case "sfx_elevator":	sfx_elevator.play();	break;
				case "sfx_incinerate":	sfx_incinerate.play();	break;
				case "sfx_bin":			sfx_bin.play();			break;
				case "sfx_fall":		sfx_fall.play();		break;
				case "sfx_xgood":		sfx_xgood.play();		break;
				case "sfx_xbad":		sfx_xbad.play();		break;
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