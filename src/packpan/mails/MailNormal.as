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
	public class MailNormal extends ABST_Mail implements IColorable
	{
		public var color:uint = PP.COLOR_NONE;	// the color of this bin if it is colored

		[Embed(source="../../../img/packageNormal.png")]			// image embed code, auto-generated
		private var imgLayer:Class;									// needed to instantiate your image
		private var img:Bitmap = new imgLayer();					// reference to your image
		
		public function MailNormal(_cg:ContainerGame, _type:String, _position:Point, _color:uint = PP.COLOR_NONE) 
		{
			super(_cg, _type, _position);

			mc_mail.gotoAndStop("none");		// switch to an empty mail image
			mc_mail.addChild(img);				// add the new image
			img.x -= img.width * .5;			// center the image
			img.y -= img.height * .5;

			if (_color != PP.COLOR_NONE)
				setColor(_color);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isColored():Boolean
		{
			return color != PP.COLOR_NONE;
		}
		
		public function isSameColor(col:uint):Boolean
		{
			return !isColored() || color == col;
		}
		
		public function setColor(col:uint):void
		{
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = int(col / 0x10000) / 255;
			ct.greenMultiplier = int(col % 0x10000 / 0x100) / 255;
			ct.blueMultiplier = col % 0x100 / 255;
			mc_mail.transform.colorTransform = ct;
			
			color = col;
		}
		
		public function getColor():uint
		{
			return color;
		}
	}
}