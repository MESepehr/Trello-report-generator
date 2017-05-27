/**
 * Created by mes on 5/27/2017.
 */
package pages.model {
import services.GetBoardActionsRespond;

public class UserReport {

    public var userName:String ;

    public var userId:String ;

    public var userReports:Vector.<GetBoardActionsRespond> = new Vector.<GetBoardActionsRespond>();

    private const houreUnit:uint = 1000*60*60 ;

    private const maxUnit:uint = houreUnit*2 ;

    public function UserReport() {
    }

    public function getHoures():Number
    {
        var lastTime:Number = 0 ;
        var totalTime:Number = 0 ;
        var currentTime:Number ;
        trace(userName+" got "+userReports.length+" tasks");
        for(var i:int = userReports.length-1 ; i>=0 ; i--)
        {
            currentTime = userReports[i].date.valueOf();
            if(lastTime==0)
            {
                //First task
            }
            else
            {
                //Next tasks
                var deltaTime:Number = currentTime-lastTime ;
                //trace(">>"+deltaTime+' >>>> '+(deltaTime/houreUnit));
                totalTime+=Math.min(maxUnit,deltaTime);
            }
            lastTime = currentTime ;
        }
        //trace(userName+" saved taskes : "+totalTime);
        totalTime+=houreUnit;
        //trace(userName+" last taskes : "+totalTime);
        return Math.round((totalTime/houreUnit));
    }
}
}
