package pages.RoadMap
//pages.RoadMap.RoadMap
{
    import flash.display.MovieClip;
    import services.BoardList.GetBoardList;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import dataManager.GlobalStorage;
    import restDoaService.RestDoaEvent;
    import contents.alert.Alert;
    import diagrams.dataGrid.DataGrid;
    import appManager.displayContentElemets.TextParag;

    public class RoadMap extends MovieClip
    {

        private var service_getBordList:GetBoardList ;

        private var urlField:TextField ;

        private var loadReportsButton:MovieClip ;

        private var boardURL:String;

        private const id_boardURL:String = "id_boardURL" ;

        private var chartMC:MovieClip ;

        public function RoadMap()
        {
            super();

            urlField = Obj.get("url_txt",this) ;
            loadReportsButton = Obj.get("get_report_mc",this) ;
            loadReportsButton.buttonMode = true ;
            loadReportsButton.addEventListener(MouseEvent.CLICK,loadRoadMapPlease);

            chartMC = Obj.get("chart_mc",this);
            chartMC.visible = false ;

            boardURL = GlobalStorage.load(id_boardURL) ;
            if(boardURL==null)
            {
                boardURL = '' ;
            }
            urlField.text = boardURL ;
        }

        private function loadRoadMapPlease(e:MouseEvent):void
        {
            var foundedID:Array = urlField.text.match(/\/([a-z\d]{8})\//i);
            var myID:String ;
            if(foundedID.length==2)
            {
                boardURL = urlField.text ;
                GlobalStorage.save(id_boardURL,urlField.text);
                myID = foundedID[1];
                trace("foundedID : "+myID);


                if(service_getBordList!=null)
                {
                    service_getBordList.cansel();
                }
                service_getBordList = new GetBoardList(myID);
                service_getBordList.addEventListener(RestDoaEvent.SERVER_RESULT,reportLoaded);
                service_getBordList.addEventListener(RestDoaEvent.CONNECTION_ERROR,noNetToShowReport);
                loadReportsButton.alpha = 0.5 ;
                service_getBordList.load();
            }
        }

        private function reportLoaded(event:RestDoaEvent):void
        {
            loadReportsButton.alpha = 1 ;
            var j:int = 0 ;
            var myTable:DataGrid = new DataGrid(9,13,chartMC.width,chartMC.height,0xffffff,0x000000);
            this.addChild(myTable);
            for(var i:int = 0 ; i<service_getBordList.data.length && i<9 ;i++)
            {
                if(j==0)
                {
                    var parag:TextParag = new TextParag();
                    myTable.addContent(parag,i,j,1,1,0x000000,0xeeeeee,1);
                    parag.setUp(service_getBordList.data[i].name,true,false,false,false,false,false,false,false,true,true,false);
                }
            }
            myTable.x = chartMC.x ;
            myTable.y = chartMC.y ;
        }

        private function noNetToShowReport(event:RestDoaEvent):void
        {
            Alert.show("Connection Problem")
        }
    }
}