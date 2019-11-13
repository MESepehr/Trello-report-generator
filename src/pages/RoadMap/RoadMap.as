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
    import flash.display.BitmapData;
    import flash.filesystem.File;
    import flash.geom.Matrix;

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

            UnicodeStatic.deactiveConvertor = false ;

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
            var captureIndex:uint = 1 ;
            function captureTable():void
            {
                var bitmapdata:BitmapData = new BitmapData(2*(chartMC.width+1),2*(chartMC.height+1),false,0xffffffff);
                var matr:Matrix = new Matrix();
                matr.scale(2,2);
                bitmapdata.draw(myTable,matr);
                var imageTarget:File = File.desktopDirectory.resolvePath('RoadMap'+captureIndex+'.png');
                FileManager.saveFile(imageTarget,BitmapEffects.createPNG(bitmapdata));
                captureIndex++;
            }


            loadReportsButton.alpha = 1 ;
            var maxH:uint = 11 ;
            var maxW:uint = 9 ;
            //var i:int = 0;
            var myTable:DataGrid = new DataGrid(Math.min(maxW,service_getBordList.data.length),maxH,chartMC.width,chartMC.height,0xffffff,0x000000) ;
            this.addChild(myTable) ;
            myTable.x = chartMC.x ;
            myTable.y = chartMC.y ;
            var minus:uint = 0 ;
            for(var j:int = -1 ; true ; j++)
            {
                var canContinue:Boolean = false ;
                for(var i:int = 0 ; i<service_getBordList.data.length && i<9 ;i++)
                {
                    var parag:TextParag = new TextParag() ;
                    if(j==-1)
                    {
                        canContinue = true ;
                        myTable.addContent(parag,i,j,1,1,0x000000,0xeeeeee,0) ;
                        parag.setUp(service_getBordList.data[i].name,true,false,false,false,false,true,false,false,false,true,true) ;
                    }
                    else
                    {
                        if(service_getBordList.data[i].cards.length>j+minus)
                        {
                            canContinue = true ;
                            parag.setUp(service_getBordList.data[i].cards[j+minus].name,true,false,false,false,false,true,false,false,true,true);
                        }   
                        myTable.addContent(parag,i,j,1,1,0x000000,0xffffff,0) ;
                    }
                }
                if(canContinue==false)
                {
                    break;
                }
                if(j>=maxH)
                {
                    captureTable();
                    Obj.remove(myTable);
                    minus+=maxH-1;
                    j=-2;
                    myTable = new DataGrid(Math.min(maxW,service_getBordList.data.length),maxH,chartMC.width,chartMC.height,0xffffff,0x000000) ;
                    this.addChild(myTable) ;
                    myTable.x = chartMC.x ;
                    myTable.y = chartMC.y ;
                }
            }
            captureTable();
            
        }

        private function noNetToShowReport(event:RestDoaEvent):void
        {
            Alert.show("Connection Problem")
        }
    }
}