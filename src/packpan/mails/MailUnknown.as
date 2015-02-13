package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import packpan.PP;
	
	/**
	 * A mail object that is created when the mail type is unidentified.
	 * @author Jay Fisher
	 */
	public class MailUnknown extends ABST_Mail
	{
		[Embed(source="../../../img/packageUnknown.png")]
		private var CustomBitmap:Class;
		
		public function MailUnknown(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
	}
}
