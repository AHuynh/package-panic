package packpan.nodes
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import packpan.iface.IMagnetic;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import packpan.PhysicsUtils;
	
	/**
	 * A Node that affects mail implementing the Magnetic interface.
	 * @author Cheng Hann Gan
	 */
	public class NodeMagnet extends ABST_Node 
	{
		private var img:Bitmap;
		
		[Embed(source="../../../img/magnetNorth.png")]
		private var CustomBitmap1:Class
		[Embed(source="../../../img/magnetSouth.png")]
		private var CustomBitmap2:Class
		[Embed(source="../../../img/magnetElectroNorth.png")]
		private var CustomBitmap3:Class
		[Embed(source="../../../img/magnetElectroSouth.png")]
		private var CustomBitmap4:Class
		
		/// The magnetic polarity of this Magnet
		public var polarity:int = 0;
		
		public const strength:Number = 27;
		public const range:Number = .3;
		
		public function NodeMagnet(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			
			polarity = json["polarity"];
			
			if (facing != PP.DIR_NONE) {
				mc_object.rotation = facing;
			}
			if (polarity == 1 && !clickable) {
				addImage(new CustomBitmap1());
			} else if (polarity == -1 && !clickable) {
				addImage(new CustomBitmap2());
			} else if (polarity == 1 && clickable) {
				addImage(new CustomBitmap3());
			} else {
				addImage(new CustomBitmap4());
			}
		}
		
		override public function step():void {
			var sign:int;
			for each (var mail:ABST_Mail in cg.mailArray) {
				if (!(mail is IMagnetic) || mail.mailState == PP.MAIL_SUCCESS) {
					continue;
				}
				sign = IMagnetic(mail).getPolarity() * polarity;
				if (sign == -1) {
					if (facing == PP.DIR_DOWN) {
						if (Math.abs(mail.state.position.x - position.x) <= range && Math.abs(mail.state.position.y - position.y) <= .82) {
							mail.state.velocity.y = 0;
							continue;
						}
					} else if (facing == PP.DIR_LEFT) {
						if (Math.abs(mail.state.position.y - position.y) <= range && Math.abs(position.x - mail.state.position.x) <= .92) {
							mail.state.velocity.x = 0;
							continue;
						}
					} else if (facing == PP.DIR_RIGHT) {
						if (Math.abs(mail.state.position.y - position.y) <= range && Math.abs(mail.state.position.x - position.x) <= .92) {
							mail.state.velocity.x = 0;
							continue;
						}
					} else /*if (facing == PP.DIR_UP)*/ {
						if (Math.abs(mail.state.position.x - position.x) <= range && Math.abs(position.y - mail.state.position.y) <= .82) {
							mail.state.velocity.y = 0;
							continue;
						}
					}
				}
				if (facing == PP.DIR_DOWN) {
					if (Math.abs(mail.state.position.x - position.x) <= range && mail.state.position.y > position.y) {
						mail.state.addForce(new Point(0,strength*sign));
					}
				} else if (facing == PP.DIR_LEFT) {
					if (Math.abs(mail.state.position.y - position.y) <= range && mail.state.position.x < position.x) {
						mail.state.addForce(new Point(strength*sign*-1,0));
					}
				} else if (facing == PP.DIR_RIGHT) {
					if (Math.abs(mail.state.position.y - position.y) <= range && mail.state.position.x > position.x) {
						mail.state.addForce(new Point(strength*sign,0));
					}
				} else /*if (facing == PP.DIR_UP)*/ {
					if (Math.abs(mail.state.position.x - position.x) <= range && mail.state.position.y < position.y) {
						mail.state.addForce(new Point(0,strength*sign*-1));
					}
				}
			}
		}
		
		override public function onClick(e:MouseEvent):void
		{
			if (clickable) {
				switch (facing) {
					case PP.DIR_RIGHT:
						facing = PP.DIR_LEFT;
					break;
					case PP.DIR_UP:
						facing = PP.DIR_DOWN;
					break;
					case PP.DIR_LEFT:
						facing = PP.DIR_RIGHT;
					break;
					case PP.DIR_DOWN:
						facing = PP.DIR_UP;
					break;
					default: trace("WARNING: NodeMagnet at " + position + " has an invalid facing!");
				}
				mc_object.rotation = facing;
			}
		}
	}
}