/**
 * Created by mes on 5/27/2017.
 */
package services {
import restDoaService.RestDoaServiceCaller;

public class GetBoardAction extends RestDoaServiceCaller
{
    public var data:Vector.<GetBoardActionsRespond> = new Vector.<GetBoardActionsRespond>();

    public function GetBoardAction() {
        super("https://api.trello.com/1/boards/JDJxNfgj/actions",data,true,false,null,true);
    }

    public function load(limit:uint):void
    {
        super.loadParam({limit:limit,key:Main.apiKey,token:Main.tocken});
    }
}
}
