package packpan 
{
	/**
	 * PackagePanic static helper
	 * @author Alexander Huynh
	 */
	public class PP 
	{
		public static const MAIL_IDLE:int = 0;
		public static const MAIL_SUCCESS:int = 1;
		public static const MAIL_FAILURE:int = 2;
		
		public static const GAME_IDLE:int = 10;
		public static const GAME_SUCCESS:int = 11;
		public static const GAME_FAILURE:int = 12;
		
		public static const DIR_NONE:int = 20;
		public static const DIR_LEFT:int = 21;
		public static const DIR_UP:int = 22;
		public static const DIR_RIGHT:int = 23;
		public static const DIR_DOWN:int = 24;
		
		public function PP() 
		{
			// -- Static class; do not instantiate
			trace("DO NOT INSTANTIATE PP!");
		}
	}
}