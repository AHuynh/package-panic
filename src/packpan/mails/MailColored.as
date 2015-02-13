package packpan.mails 
{
	import cobaltric.ContainerGame;
	import flash.geom.ColorTransform;
	import packpan.iface.IColorable;
	import packpan.PP;
	
	/**
	 * MailNormal that implements IColorable.
	 * @author Alexander Huynh
	 */
	public class MailColored extends ABST_Mail implements IColorable
	{
		/// The color of this object, PP.COLOR_NONE if uncolored.
		private var color:uint = PP.COLOR_NONE;
		
		public function MailColored(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			
			// the color of this mail if it is colored
			color = PP.COLOR_NONE;	
			if (json["color"])
				setColor(json["color"]);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// IColorable
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function isColored():Boolean
		{
			return getColor() != PP.COLOR_NONE;
		}
		
		public function isSameColor(col:uint):Boolean
		{
			return !isColored() || getColor() == col;
		}
		
		public function setColor(colS:String):void
		{
			var col:uint = convertColor(colS);
			
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