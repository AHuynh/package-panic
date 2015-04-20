package cobaltric 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	
	/**
	 * Static class for playing sounds.
	 * @author Alexander Huynh
	 */
	public class SoundManager 
	{
		// background music
		[Embed(source = "../../sound/BGM_PackagePanicLoop.mp3")]
		private static var bgm_main:Class;
		[Embed(source = "../../sound/BGM_ConveyerBelts.mp3")]
		private static var bgm_cb:Class;
		[Embed(source = "../../sound/BGM_PanickingPackages.mp3")]
		private static var bgm_pp:Class;
		[Embed(source = "../../sound/BGM_PackagePalooza.mp3")]
		private static var bgm_pl:Class;
		
		// sound effects
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
		[Embed(source = "../../sound/SFX_success.mp3")]
		private static var SFX_success:Class;
		[Embed(source = "../../sound/SFX_successSuper.mp3")]
		private static var SFX_successSuper:Class;
		[Embed(source = "../../sound/SFX_failure.mp3")]
		private static var SFX_failure:Class;
		
		private static var sfx_rotate:Sound = new SFX_rotate();
		private static var sfx_elevator:Sound = new SFX_elevator();
		private static var sfx_incinerate:Sound = new SFX_incinerate();
		private static var sfx_bin:Sound = new SFX_bin();
		private static var sfx_fall:Sound = new SFX_fall();
		private static var sfx_xgood:Sound = new SFX_xgood();
		private static var sfx_xbad:Sound = new SFX_xbad();
		private static var sfx_success:Sound = new SFX_success();
		private static var sfx_successSuper:Sound = new SFX_successSuper();
		private static var sfx_failure:Sound = new SFX_failure();
		
		public static var bgm:SoundChannel;
		
		public function SoundManager() 
		{
			// -- static class; do not instiantiate
			trace("WARNING: SoundManager should not be instiantiated!");
		}
		
		/**
		 * Plays the given SFX once.
		 * @param	sound		String of the SFX to play, ex "sfx_bin"
		 */
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
				case "sfx_success":		sfx_success.play();		break;
				case "sfx_successSuper":sfx_successSuper.play();break;
				case "sfx_failure":		sfx_failure.play();		break;
				default:
					trace("WARNING: no sound defined for " + sound);
			}
		}
		
		/**
		 * Plays the given BGM on a loop.
		 * @param	sound		String of the BGM to play, ex "bgm_main"
		 */
		public static function playBGM(sound:String):void
		{
			stopBGM();
			
			var snd:Sound;
			switch (sound)
			{
				case "main":	snd = new bgm_main();		break;
				case "bgm_cb":	snd = new bgm_cb();			break;
				case "bgm_pp":	snd = new bgm_pp();			break;
				case "bgm_pl":	snd = new bgm_pl();			break;
				default:
					trace("WARNING: no BGM defined for " + sound);
					return;
			}
			bgm = snd.play(0, 9999);
		}
		
		/**
		 * Checker if BGM is currently playing.
		 * @return		true if BGM is playing, false otherwise
		 */
		public static function isBGMplaying():Boolean
		{
			return bgm != null;
		}
		
		/**
		 * Stops the BGM if it is playing.
		 */
		public static function stopBGM():void
		{
			if (bgm)
			{
				bgm.stop();
				bgm = null;
			}
		}
		
		/**
		 * Stops all sounds.
		 */
		public static function shutUp():void
		{
			SoundMixer.stopAll();
		}
	}
}