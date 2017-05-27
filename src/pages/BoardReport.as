/**
 * Created by mes on 5/26/2017.
 */
package pages
//pages.BoardReport
{
import dataManager.GlobalStorage;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.system.System;
import flash.text.TextField;

import pages.model.UserReport;

import restDoaService.RestDoaEvent;

import services.GetBoardAction;
import services.GetBoardActionsRespond;

public class BoardReport extends MovieClip{

    private var urlField:TextField;

    private var getReportMC:MovieClip;

    private var boardURL:String;

    private const id_boardURL:String = "id_boardURL" ;

    private var service_getBoardActivitis:GetBoardAction ;

    private var reportTF:TextField ;

    private const reportPageSize:uint = 1000 ;

    private var userReports:Vector.<UserReport> ;

    public function BoardReport() {
        super() ;
        urlField = Obj.get("url_txt",this) ;
        getReportMC = Obj.get("get_report_mc",this) ;
        reportTF = Obj.get("report_txt",this);

        boardURL = GlobalStorage.load(id_boardURL) ;
        if(boardURL==null)
        {
            boardURL = '' ;
        }
        urlField.text = boardURL ;

        getReportMC.buttonMode = true ;
        getReportMC.addEventListener(MouseEvent.CLICK, getReport);

    }

    private function getReport(event:MouseEvent):void
    {
        //      https://trello.com/b/JDJxNfgj/azta-bazar
        var foundedID:Array = urlField.text.match(/\/([a-z\d]{8})\//i);
        var myID:String ;
        if(foundedID.length==2)
        {
            boardURL = urlField.text ;
            GlobalStorage.save(id_boardURL,urlField.text);
            myID = foundedID[1];
            trace("foundedID : "+myID);
            userReports = new Vector.<UserReport>();
            reportTF.text = "Please wait...";
			
			if(service_getBoardActivitis)
			{
				service_getBoardActivitis.removeEventListener(RestDoaEvent.SERVER_RESULT, reportLoaded)
				service_getBoardActivitis.cansel();
				service_getBoardActivitis = null ;
			}
			
			service_getBoardActivitis = new GetBoardAction(myID);
			service_getBoardActivitis.addEventListener(RestDoaEvent.SERVER_RESULT, reportLoaded)
			
            service_getBoardActivitis.load(reportPageSize);
        }
    }

    private function reportLoaded(event:RestDoaEvent):void {
        var l:int = service_getBoardActivitis.data.length ;
        var currentReport:GetBoardActionsRespond ;
        var foundedReportUnit:UserReport ;
        trace("Report loaded : "+l);
        if(l>0) {
            trace("First report is : " + service_getBoardActivitis.data[0].id);
        }
        for(var i:int = 0 ; i<l ; i++)
        {
            foundedReportUnit = null ;
            currentReport = service_getBoardActivitis.data[i];
            //trace("Action id : "+currentReport.id);
            //trace("idMemberCreator : "+currentReport.idMemberCreator);
           // trace("fullName : "+currentReport.memberCreator.fullName);
            for(var j:int = 0 ; j<userReports.length ; j++)
            {
                //trace("Check : "+userReports[j].userName+'  '+userReports[j].userId);
                if(userReports[j].userId == currentReport.idMemberCreator)
                {
                    foundedReportUnit = userReports[j] ;
                    break ;
                }
            }
            if(foundedReportUnit==null)
            {
                foundedReportUnit = new UserReport();
                foundedReportUnit.userId = currentReport.idMemberCreator ;
                foundedReportUnit.userName = currentReport.memberCreator.fullName ;
                //trace("New user is : "+foundedReportUnit.userName);
                userReports.push(foundedReportUnit);
            }
            else
            {
                //trace("Founded user is : "+foundedReportUnit.userName);
            }
            foundedReportUnit.userReports.push(service_getBoardActivitis.data[i]);
        }
        if(l==reportPageSize)
        {
            trace("load more services now ...");
            var lastReport:GetBoardActionsRespond = service_getBoardActivitis.data[l-1] ;
            trace("Last report date : "+lastReport.date)
            service_getBoardActivitis.load(reportPageSize,service_getBoardActivitis.data[l-1].date);
        }
        else
        {
            service_getBoardActivitis.cansel();
            generateReport();
        }
    }

    private function generateReport():void {
       reportTF.text = '' ;
       var totalHoures:Number = 0 ;
       for(var i:int = 0 ; i<userReports.length ; i++)
       {
           var userHoures:Number = userReports[i].getHoures();
           totalHoures+=userHoures ;
           reportTF.appendText(userReports[i].userName+' : '+userHoures.toString()+' Hrs\n');
       }
        reportTF.appendText("Total houres on project : "+totalHoures.toString()+' Hrs');
    }
}
}
