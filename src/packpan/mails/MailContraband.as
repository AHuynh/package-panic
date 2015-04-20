package packpan.mails 
{
	import cobaltric.ContainerGame;
	import packpan.nodes.NodeXRay;

	/**
	 * A Mail object that either needs to be binned or destroyed, depending on its contents.
	 * Contents can be checked with an XRay.
	 * @author James Liu
	 */
	public class MailContraband extends ABST_Mail
	{
		[Embed(source="../../../img/packageContraband.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class							// must be directly after the embed code

		public var is_contraband:Boolean = false;
		
		/**
		 * If JSON does not specify "is_contraband", 50% chance of being contraband
		 * @param	_cg		Reference to ContainerGame
		 * @param	_json	JSON info for this Mail
		 */
		public function MailContraband(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json, new CustomBitmap());
			if (json["is_contraband"] != null)
				is_contraband = json["is_contraband"];
			else
				is_contraband = getRand(0, 1) > 0.5;
		}
		
		override public function ShouldDestroy():Boolean 
		{
			return is_contraband;
		}
	}

}