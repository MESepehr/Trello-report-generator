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

    private const maxUnit:uint = houreUnit*4.5 ;
	
	/**This variable will generate when you call getHoures once. it is based on miliseconds*/
	public var dayToDateReport:Vector.<Number> ;

    public function UserReport() {
    }

    public function getHoures(fromDate:Date,toDate:Date,newMaxUnitInMiliSeconds:Number):Number
    {
		//trace("Control date : "+fromDate+' , '+toDate);
		if(isNaN(newMaxUnitInMiliSeconds))
		{
			newMaxUnitInMiliSeconds = maxUnit ;
		}
        var lastTime:Number = 0 ;
		var lastDate:Date ;
        var totalTime:Number = 0 ;
        var currentTime:Number = 0 ;
		var currentDate:Date ;
        trace(userName+" got "+userReports.length+" tasks");
		dayToDateReport = new Vector.<Number>();
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
			currentDate = userReports[i].date ;
            if(lastTime==0)
            {
                //First task
				dayToDateReport.push(0);
				//trace("- First task : "+currentTime);
            }
            else
            {
                //Next tasks
                var deltaTime:Number = currentTime-lastTime ;
				if(deltaTime>newMaxUnitInMiliSeconds)
				{
					totalTime+=houreUnit ;
					//trace("- The tasks delay is passed from maximom length ..."+totalTime+" >> delta time is : "+deltaTime );
					dayToDateReport[dayToDateReport.length-1]+=houreUnit ;
					dayToDateReport.push(0);
				}
				else
				{
	                totalTime += deltaTime ;
					//trace("- Two close task time : "+totalTime);
					dayToDateReport[dayToDateReport.length-1]+=deltaTime ;
				}
                //trace(">>"+deltaTime+' >>>> '+(deltaTime/houreUnit));
            }
            lastTime = currentTime ;
			lastDate = currentDate ;
        }
        //trace(userName+" saved taskes : "+totalTime);
		if(currentTime!=0)
        	totalTime+=houreUnit;
		//trace("Total time : "+totalTime);
        //trace(userName+" last taskes : "+totalTime);
        return Math.round((totalTime/houreUnit));
    }
}
}
