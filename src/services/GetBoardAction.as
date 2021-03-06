/**
 * Created by mes on 5/27/2017.
 */
package services {
import restDoaService.RestDoaServiceCaller;

public class GetBoardAction extends RestDoaServiceCaller
{
    public var data:Vector.<GetBoardActionsRespond> = new Vector.<GetBoardActionsRespond>();

    public function GetBoardAction(boardId:String) {
        super("https://api.trello.com/1/boards/"+boardId+"/actions",data,true,false,null,true);
    }

    public function load(limit:uint,before:Date=null):void
    {
        var beforDate:String ;
        if(before!=null)
        {
            beforDate = ServerDate.dateToServerDate2(before,false);
        }
        super.loadParam({limit:limit,key:Main.apiKey,token:Main.tocken,before:beforDate});
    }
}
}
