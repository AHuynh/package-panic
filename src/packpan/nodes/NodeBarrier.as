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
		[Embed(source="../../../img/barrier.png")]	// embed code; change this path to change the image
		private var CustomBitmap:Class;				// must be directly below the embed code

		private var relativePosition:Point;
		private var blockedMail:Array;
		
		public function NodeBarrier(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json, new CustomBitmap());
		}
		
		override public function step():void
		{
			blockedMail = PhysicsUtils.cullRectangle(cg.mailArray, new Point(position.x - .92, position.y - .82), new Point(position.x + .92, position.y + .82));
			for each (var mail:ABST_Mail in blockedMail) {
				relativePosition = new Point(position.x - mail.state.position.x, position.y - mail.state.position.y);
				if ((relativePosition.x > 0 && mail.state.velocity.x > 0 || 
					relativePosition.x < 0 && mail.state.velocity.x < 0) &&
					Math.abs(relativePosition.y) < .5) {
					mail.state.velocity.x *= -1;
				}
				if ((relativePosition.y > 0 && mail.state.velocity.y > 0 || 
					relativePosition.y < 0 && mail.state.velocity.y < 0) &&
					Math.abs(relativePosition.x) < .5) {
					mail.state.velocity.y *= -1;
				}
			}
		}
	}

}