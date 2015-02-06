package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PhysicsUtils;
	import flash.display.Bitmap;
	
	/**
	 * A barrier that prevents packages from moving through it.
	 * 
	 * @author Cheng Hann Gan
	 */
	public class NodeBarrier extends ABST_Node
	{
		[Embed(source="../../../img/barrier.png")]
		private var imgLayer:Class;
		private var img:Bitmap = new imgLayer();
		private var relativePosition:Point;
		
		public function NodeBarrier(_cg:ContainerGame, _type:String, _position:Point,
										   _facing:int, _clickable:Boolean, _color:uint) 
		{
			super(_cg, _type, _position, _facing, _clickable, _color);
			mc_node.addChild(img);
			img.x -= img.width * .5;
			img.y -= img.height * .5;
		}
		
		override public function affectMail(mail:ABST_Mail):void
		{
			//mail.state.velocity.x *= -1;
			//mail.state.velocity.y *= -1;
			relativePosition = new Point(position.x - mail.state.position.x, position.y - mail.state.position.y);
			if (relativePosition.x > 0 && mail.state.velocity.x > 0 || 
			    relativePosition.x < 0 && mail.state.velocity.x < 0) {
				mail.state.velocity.x *= -1;
			}
			if (relativePosition.y > 0 && mail.state.velocity.y > 0 || 
			    relativePosition.y < 0 && mail.state.velocity.y < 0) {
				mail.state.velocity.y *= -1;
			}
		}
	}

}