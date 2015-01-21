package packpan.mails 
{
	import cobaltric.ABST_ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * An example Mail object using an imported PNG.
	 * @author Alexander Huynh
	 */
	public class MailPNG extends ABST_Mail 
	{
		// import your image to the "img" folder
		// right-click your image and choose "Generate embed code"
		
		[Embed(source="../../../img/packageExample.png")]			// image embed code, auto-generated
		private var imgLayer:Class;									// needed to instantiate your image
		private var img:Bitmap = new imgLayer();					// reference to your image
		
		public function MailPNG(_cg:ABST_ContainerGame, _type:String, _position:Point) 
		{
			super(_cg, _type, _position);

			mc_mail.gotoAndStop("none");		// switch to an empty mail image
			mc_mail.addChild(img);				// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;
		}
	}
}