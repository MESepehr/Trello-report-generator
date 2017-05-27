/**
 * Created by mes on 5/27/2017.
 */
package pages.model {
import services.GetBoardActionsRespond;

public class UserReport {

    public var userName:String ;

    public var userId:String ;

    public var userReports:Vector.<GetBoardActionsRespond> = new Vector.<GetBoardActionsRespond>();

    public function UserReport() {
    }

    public function getHoures():Number
    {
        return 2;
        //TODO create real houres
    }
}
}
