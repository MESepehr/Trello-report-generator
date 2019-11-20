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
    import flash.display.Sprite;
    import diagrams.calender.MyShamsi;

    public class RoadMap extends MovieClip
    {

        private var service_getBordList:GetBoardList ;

        private var urlField:TextField ;

        private var loadReportsButton:MovieClip ;

        private var boardURL:String;

        private const id_boardURL:String = "id_boardURL" ;

        private var chartMC:MovieClip ;

        private var gridContainer:Sprite ;


        private var headerMC:MovieClip,
                    dateTF:TextField,
                    pageTF:TextField;

        public function RoadMap()
        {
            super();

            headerMC = Obj.get("header_mc",this);
            dateTF = Obj.get("date_txt",headerMC);
            pageTF = Obj.get("page_mc",headerMC);

            dateTF.text = MyShamsi.miladiToShamsi(new Date()).showStringFormat(false);

            UnicodeStatic.deactiveConvertor = false ;

            urlField = Obj.get("url_txt",this) ;
            loadReportsButton = Obj.get("get_report_mc",this) ;
            loadReportsButton.buttonMode = true ;
            loadReportsButton.addEventListener(MouseEvent.CLICK,loadRoadMapPlease);

            chartMC = Obj.get("chart_mc",this);
            chartMC.visible = false ;

            gridContainer = new Sprite();
            this.addChild(gridContainer);
            gridContainer.x = chartMC.x ;
            gridContainer.y = chartMC.y;
            new ScrollMT(gridContainer,chartMC.getBounds(this),null,true);

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
                const scale:Number = 2 ;
                pageTF.text = captureIndex+"/"+maxPage;
                var bitmapdata:BitmapData = new BitmapData(scale*(chartMC.width+1),scale*(chartMC.height+1)+scale*headerMC.height,false,0xffffffff);
                var matr:Matrix = new Matrix();
                matr.scale(scale,scale);
                matr.ty=headerMC.height*scale;
                bitmapdata.draw(myTable,matr);
                var matr2:Matrix = new Matrix();
                matr2.scale(scale,scale);
                bitmapdata.draw(headerMC,matr2);
                var imageTarget:File = File.desktopDirectory.resolvePath('RoadMap'+captureIndex+'.png');
                FileManager.saveFile(imageTarget,BitmapEffects.createPNG(bitmapdata));
                captureIndex++;
            }


            loadReportsButton.alpha = 1 ;
            var maxH:uint = 6 ;
            var extraCharts:uint = 0 ;
            var maxW:uint = Math.min(service_getBordList.data.length,9) ;
            var j:int = 0 ;
            
            //Calculate max page
            var maxPage:uint = 0 ;
            for(j=0;j<maxW;j++)
            {
                maxPage = Math.max(service_getBordList.data[j].cards.length);
            }
            maxPage = Math.ceil(maxPage/maxH)


            //var i:int = 0;
            gridContainer.removeChildren();
            var myTable:DataGrid = new DataGrid(maxW*3+1,maxH*3+1,chartMC.width,chartMC.height,0xffffff,0x000000) ;
            gridContainer.addChild(myTable) ;
           
            var minus:uint = 0 ;
            for(j = -1 ; true ; j++)
            {
                var canContinue:Boolean = false ;
                for(var i:int = 0 ; i<maxW+1 ;i++)
                {
                    var parag:TextParag = new TextParag() ;
                    if(j==-1)
                    {
                        canContinue = true ;
                        myTable.addContent(parag,i,j,i==maxW?1:3,1,0x000000,0xeeeeee,0) ;
                        if(i==maxW)
                        {
                            parag.setUp('ردیف',true,false,false,false,false,false,false,false,true,true);
                        }
                        else
                        {
                            parag.setUp(service_getBordList.data[i].name,true,false,false,false,false,true,false,false,false,true,true) ;
                        }
                    }
                    else
                    {
                        if(i==maxW)
                        {
                            parag.setUp(String(j+minus),false);
                        }
                        else if(service_getBordList.data[i].cards.length>j+minus)
                        {
                            canContinue = true ;
                            parag.setUp(service_getBordList.data[i].cards[j+minus].name,true,false,false,false,false,true,false,false,true,true);
                        }   
                        myTable.addContent(parag,i,j,i==maxW?1:3,3,0x000000,0xffffff,0) ;
                    }
                }
                if(canContinue==false)
                {
                    break;
                }
                if(j+extraCharts>=maxH)
                {
                    captureTable();
                    minus+=maxH;
                    j=-2;
                    var lastY:Number = myTable.y;
                    myTable = new DataGrid(maxW*3+1,maxH*3+1,chartMC.width,chartMC.height,0xffffff,0x000000) ;
                    gridContainer.addChild(myTable) ;
                    myTable.y = lastY + chartMC.height ;
                    extraCharts++;
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