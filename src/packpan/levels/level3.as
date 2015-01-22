package packpan.levels 
{
	import cobaltric.ABST_ContainerGame;
	import cobaltric.Engine;
	import flash.geom.Point;
	import packpan.mails.MailNormal;
	import packpan.PP;
	
	/**
	 * Temporary testing/demonstration level
	 * @author Alexander Huynh
	 */
	public class level3 extends ABST_ContainerGame 
	{
		
		public function level3(eng:Engine, _levelXML:String = "../xml/level_basic.xml") 
		{
			super(eng);
		}
		
		override protected function setUp():void
		{
			timeLeft = 20 * SECOND;
			
			addLineOfNodes(new Point(5, 0), new Point(5, 1), PP.NODE_CONV_NORMAL).setDirection(PP.DIR_RIGHT);
			for (var i:int = 4; i < 7; i++)
				for (var j:int = 2; j < 14; j++)
					addNode(new Point(i, j), PP.NODE_CONV_NORMAL, 90 * ((j+i) % 4), true);
			
			addNode(new Point(5, 14), PP.NODE_BIN_NORMAL);

			mailArray.push(new MailNormal(this, "default", new Point(5, 0)));
		}
	}
}