package services.BoardList
{
	public class GetBoardListRespond
	{
		/**"cards":"[object Object],[object Object],[object Object],[object Object],[object Object],[object Object]"*/
		public var cards:Vector.<GetBoardListRespondcardsModel> = new Vector.<GetBoardListRespondcardsModel>()
		/**"closed":"false"*/
		public var closed:Boolean ;
		/**"creationMethod":"null"*/
		public var creationMethod:* ;
		/**"id":"5d0215c86a069f08e0cdcfd1"*/
		public var id:String ;
		/**"idBoard":"5d021542f44bf37a7c391f6a"*/
		public var idBoard:String ;
		/**"limits":"[object Object]"*/
		public var limits:GetBoardListRespondlimitsModel = new GetBoardListRespondlimitsModel()
		/**"name":"اقدامات"*/
		public var name:String ;
		/**"pos":"526335"*/
		public var pos:Number ;
		/**"softLimit":"null"*/
		public var softLimit:* ;
		/**"subscribed":"false"*/
		public var subscribed:Boolean ;

		
		public function GetBoardListRespond()
		{
		}
	}
}