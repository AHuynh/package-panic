package packpan.mails 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
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
		
		[Embed(source="../../../img/packageNormal.png")]		// embed code; change this path to change the image
		private var CustomBitmap1:Class							// must be directly after the embed code
		[Embed(source="../../../img/packageNormalBig.png")]		// embed code; change this path to change the image
		private var CustomBitmap2:Class							// must be directly after the embed code
		[Embed(source="../../../img/packageNormalDouble.png")]	// embed code; change this path to change the image
		private var CustomBitmap3:Class							// must be directly after the embed code
		
		public function MailNormal(_cg:ContainerGame, _json:Object)
		{
			// choose a consistent mail GFX, based on the state of the game
			var gfx:Bitmap;			
			switch ((2 * _cg.lowestPackageDepth + _cg.engine.page + _cg.engine.levelInd + _cg.mailArray.length + 1) % 3)
			{
				case 0:	gfx = new CustomBitmap1(); break;
				case 1:	gfx = new CustomBitmap2(); break;
				case 2:	gfx = new CustomBitmap3(); break;
			}
			
			super(_cg, _json, gfx);
			
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
