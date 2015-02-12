package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * A normal, vanilla box of mail.
	 * @author Alexander Huynh
	 */
	public class MailNormal extends ABST_Mail 
	{
		[Embed(source="../../../img/packageNormal.png")]			// image embed code, auto-generated
		private var imgLayer:Class;									// needed to instantiate your image
		private var img:Bitmap = new imgLayer();					// reference to your image
		
		public function MailNormal(_cg:ContainerGame, _type:String, _position:Point, _color:uint, _polarity:int = 0) 
		{
			super(_cg, _type, _position, _color, _polarity);

			mc_mail.gotoAndStop("none");		// switch to an empty mail image
			mc_mail.addChild(img);				// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;
		}	
	}
}