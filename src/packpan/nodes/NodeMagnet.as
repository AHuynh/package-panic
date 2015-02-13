package packpan.nodes
{
	import cobaltric.ContainerGame;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import packpan.PhysicsUtils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NodeMagnet extends ABST_Node 
	{
		private var img:Bitmap;
		
		[Embed(source="../../../img/magnetNorth.png")]
		private var imgLayer:Class;
		private var magnetNorth:Bitmap = new imgLayer();
		[Embed(source="../../../img/magnetSouth.png")]
		private var imgLayer2:Class;
		private var magnetSouth:Bitmap = new imgLayer2();
		[Embed(source="../../../img/magnetElectroNorth.png")]
		private var imgLayer3:Class;
		private var magnetElectroNorth:Bitmap = new imgLayer3();
		[Embed(source="../../../img/magnetElectroSouth.png")]
		private var imgLayer4:Class;
		private var magnetElectroSouth:Bitmap = new imgLayer4();
		
		private var sign:int;
		
		public const strength:Number = 27;
		public const range:Number = .3;
		
		public function NodeMagnet(_cg:ContainerGame, _json:Object) 
		{
			super(_cg, _json);
			if (facing != PP.DIR_NONE) {
				mc_object.rotation = facing;
			}
			
			mc_object.gotoAndStop("none");
			if (facing < 0) {
				polarity = -1;
				facing += 360;
			}
			
			if (polarity == 1 && !clickable) {
				img = magnetNorth;
			} else if (polarity == -1 && !clickable) {
				img = magnetSouth;
			} else if (polarity == 1 && clickable) {
				img = magnetElectroNorth
			} else {
				img = magnetElectroSouth;
			}
			
			mc_object.addChild(img);
			img.x -= img.width * .5;
			img.y -= img.height * .5;
		}
		
		override public function step():void {
			for each (var mail:ABST_Mail in ContainerGame.mailArray) {
				sign = polarity * mail.polarity;
				if (sign == 0 || mail.mailState == PP.MAIL_SUCCESS) {
					continue;
				}
				if (sign == -1) {
					if (facing == PP.DIR_DOWN) {
						if (Math.abs(mail.state.position.x - position.x) <= range && mail.state.position.y - position.y <= .82) {
							mail.state.velocity.y = 0;
							continue;
						}
					} else if (facing == PP.DIR_LEFT) {
						if (Math.abs(mail.state.position.y - position.y) <= range && position.x - mail.state.position.x <= .92) {
							mail.state.velocity.x = 0;
							continue;
						}
					} else if (facing == PP.DIR_RIGHT) {
						if (Math.abs(mail.state.position.y - position.y) <= range && mail.state.position.x - position.x <= .92) {
							mail.state.velocity.x = 0;
							continue;
						}
					} else /*if (facing == PP.DIR_UP)*/ {
						if (Math.abs(mail.state.position.x - position.x) <= range && position.y - mail.state.position.y <= .82) {
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
					default: trace("WARNING: NodeConveyorNormal at " + position + " has an invalid facing!");
				}
				mc_object.rotation = facing;
			}
		}
		
	}

}