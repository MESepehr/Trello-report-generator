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

    private const maxUnit:uint = houreUnit*3.5 ;

    public function UserReport() {
    }

    public function getHoures(fromDate:Date,toDate:Date):Number
    {
		trace("Control date : "+fromDate);
        var lastTime:Number = 0 ;
        var totalTime:Number = 0 ;
        var currentTime:Number = 0 ;
        trace(userName+" got "+userReports.length+" tasks");
        for(var i:int = userReports.length-1 ; i>=0 ; i--)
        {
			if(userReports[i].date.time<fromDate.time)
			{
				continue ;
			}
			else if(userReports[i].date.time>toDate.time)
			{
				break ;
			}
            currentTime = userReports[i].date.valueOf();
            if(lastTime==0)
            {
                //First task
            }
            else
            {
                //Next tasks
                var deltaTime:Number = currentTime-lastTime ;
				if(deltaTime>maxUnit)
				{
					totalTime+=houreUnit ;
				}
				else
				{
	                totalTime += deltaTime ;
				}
                //trace(">>"+deltaTime+' >>>> '+(deltaTime/houreUnit));
            }
            lastTime = currentTime ;
        }
        //trace(userName+" saved taskes : "+totalTime);
		if(currentTime!=0)
        	totalTime+=houreUnit;
        //trace(userName+" last taskes : "+totalTime);
        return Math.round((totalTime/houreUnit));
    }
}
}
