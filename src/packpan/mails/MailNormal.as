package packpan.mails
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	
	/**
	 * A normal, vanilla box of mail.
	 * @author Alexander Huynh
	 */
	public class MailNormal extends ABST_Mail 
	{
		public function MailNormal(_cg:ContainerGame, _type:String, _position:Point, _color:uint) 
		{
			super(_cg, _type, _position, _color);
		}	
	}
}