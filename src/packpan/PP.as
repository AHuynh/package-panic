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
		
		public function PP() 
		{
			// -- Static class; do not instantiate
			trace("DO NOT INSTANTIATE PP!");
		}
	}
}