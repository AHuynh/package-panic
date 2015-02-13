package packpan.mails 
{
	import cobaltric.ContainerGame;
	import flash.display.Bitmap;
	import packpan.iface.IMagnetic;
	
	/**
	 * ...
	 * @author Cheng Hann Gan
	 */
	public class MailMagnetic extends ABST_Mail implements IMagnetic
	{
		
		public function MailMagnetic(_cg:ContainerGame, _json:Object, _bitmap:Bitmap=null) 
		{
			super(_cg, _json);
			
			if (json["polarity"])
				setPolarity(json["polarity"]);
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