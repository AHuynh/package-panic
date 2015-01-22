package packpan.levels 
{
	import cobaltric.ABST_ContainerGame;
	import cobaltric.Engine;
	import flash.geom.Point;
	import packpan.mails.MailPNG;
	import packpan.PP;
	
	/**
	 * Temporary testing/demonstration level
	 * @author Alexander Huynh
	 */
	public class level4 extends ABST_ContainerGame 
	{
		
		public function level4(eng:Engine, _levelXML:String = "../xml/level_basic.xml") 
		{
			super(eng);
		}
		
		override protected function setUp():void
		{
			timeLeft = 30 * SECOND;
			
			addLineOfNodes(new Point(1, 2), new Point(8, 2), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_DOWN);
			addLineOfNodes(new Point(1, 7), new Point(8, 7), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_DOWN);
			
			addNode(new Point(9, 2), PP.NODE_BIN_NORMAL);
			addNode(new Point(9, 7), PP.NODE_BIN_NORMAL);

			mailArray.push(new MailPNG(this, "default", new Point(2, 2)));
			mailArray.push(new MailPNG(this, "default", new Point(2, 7)));
		}
	}
}