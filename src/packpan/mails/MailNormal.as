package packpan.mails 
{
	import cobaltric.ContainerGame;
	import flash.geom.ColorTransform;
	import packpan.iface.IColorable;
	import packpan.iface.IDestroyable;
	import packpan.iface.IProcessable;
	import packpan.PP;
	
	/**
	 * A colorable but otherwise vanilla mail object.
	 * @author Alexander Huynh
	 */
	public class MailNormal extends ABST_Mail implements IColorable
	{
		/// The color of this object
		private var color:uint = 15;
		
		[Embed(source="../../../img/packageNormal.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class	// must be directly after the embed code
		
		public function MailNormal(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json, new CustomBitmap());
			
			// the color of this mail if it is colored	
			if (json["color"])
				setColor(json["color"]);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isSameColor(col:uint):Boolean
		{
			return getColor() == col;
		}
		
		public function setColor(coli:int):void
		{
			var col:uint = PP.COLORS[coli];
			
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = int(col / 0x10000) / 255;
			ct.greenMultiplier = int(col % 0x10000 / 0x100) / 255;
			ct.blueMultiplier = col % 0x100 / 255;
			mc_object.transform.colorTransform = ct;
			
			color = col;
		}
		
		public function getColor():uint
		{
			return color;
		}
	}
}
