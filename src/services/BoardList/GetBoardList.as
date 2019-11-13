package services.BoardList
{
	import restDoaService.RestDoaServiceCaller;
	
	public class GetBoardList extends RestDoaServiceCaller
	{
		public var data:Vector.<GetBoardListRespond> = new Vector.<GetBoardListRespond>() ;
		
		/***/
		public function GetBoardList(boardId:String)
		{
			super("https://api.trello.com/1/boards/"+boardId+"/lists", data, false, false, null, true);
		}
		
		public function load(card_fields:String="all",cards:String="open",fields:String='all',filter:String='open'):void
		{
			super.loadParam({card_fields:card_fields,cards:cards,fields:fields,filter:filter,key:Main.apiKey,token:Main.tocken});
		}
	}
}