package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import packpan.iface.IColorable;
	import packpan.PP;
	
	/**
	 * A normal, vanilla box of mail.
	 * @author Alexander Huynh
	 */
	public class MailNormal extends ABST_Mail
	{
		[Embed(source="../../../img/packageNormal.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class						// must be directly below the embed code
		
		public function MailNormal(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
	}
}