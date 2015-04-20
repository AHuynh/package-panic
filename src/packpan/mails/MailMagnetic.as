package packpan.mails 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import packpan.iface.IMagnetic;
	
	/**
	 * A Mail object that is affected by magnet Nodes.
	 * @author Cheng Hann Gan
	 */
	public class MailMagnetic extends ABST_Mail implements IMagnetic
	{
		[Embed(source="../../../img/packagePlus.png")]
		private var CustomBitmap1:Class
		[Embed(source="../../../img/packageMinus.png")]
		private var CustomBitmap2:Class
		
		/// The magnetic polarity of this Mail
		public var polarity:int = 0;

		public function MailMagnetic(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			
			if (json["polarity"])
				setPolarity(json["polarity"]);
			
			// determine graphic based on polarity
			var CustomBitmap:Class;
			if (getPolarity() == 1) {
				addImage(new CustomBitmap1());
			} else {
				addImage(new CustomBitmap2());
			}
		}
		
		public function getPolarity():int {
			return polarity;
		}
		
		public function setPolarity(newPolarity:int):void {
			polarity = newPolarity;
		}
		
		public function getInteraction(pol:int):int {
			return polarity * pol;
		}
	}
}