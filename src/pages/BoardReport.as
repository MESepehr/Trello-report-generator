/**
 * Created by mes on 5/26/2017.
 */
package pages
//pages.BoardReport
{
import dataManager.GlobalStorage;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class BoardReport extends MovieClip{

    private var urlField:TextField;

    private var getReportMC:MovieClip;

    private var boardURL:String;

    private const id_boardURL:String = "id_boardURL" ;

    public function BoardReport() {
        super() ;
        urlField = Obj.get("url_txt",this) ;
        getReportMC = Obj.get("get_report_mc",this) ;

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
        }
    }
}
}
