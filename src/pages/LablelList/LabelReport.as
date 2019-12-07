package pages.LablelList
//pages.LablelList.LabelReport
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
    import services.BoardList.GetBoardListRespondcardsModelLabels;
    import services.BoardList.GetBoardListRespond;
    import services.BoardList.GetBoardListRespondcardsModel;
    import com.mteamapp.StringFunctions;

    public class LabelReport extends MovieClip
    {

        private var service_getBordList:GetBoardList ;

        private var urlField:TextField ;

        private var loadReportsButton:MovieClip ;

        private var boardURL:String;

        private const id_boardURL:String = "id_boardURL4" ;

        private var chartMC:MovieClip ;

        private var gridContainer:Sprite ;


        private var headerMC:MovieClip,
                    dateTF:TextField,
                    pageTF:TextField;

        public function LabelReport()
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
                var imageTarget:File = File.desktopDirectory.resolvePath('LabelReport'+captureIndex+'.png');
                FileManager.saveFile(imageTarget,BitmapEffects.createPNG(bitmapdata));
                captureIndex++;
            }


            loadReportsButton.alpha = 1 ;
            var maxH:uint = 6 ;
            var extraCharts:uint = 0 ;
            var maxW:uint = 9 ;
            var j:int = 0 ,i:int=0;
            
            //Calculate max rows
            //var maxRows:uint = 0 ;
            var maxPage:uint = 0 ;
            var chartList:Vector.<LabelModel> = new Vector.<LabelModel>();
            //var labelTemp:Array = [] ;
            for(j=0;j<service_getBordList.data.length-1;j++)
            {
                var currentList:GetBoardListRespond = service_getBordList.data[j];
                for(i=0;i<currentList.cards.length ; i++)
                {
                    var currentCard:GetBoardListRespondcardsModel = currentList.cards[i];
                    //maxRows = Math.max(currentCard.labels.length);
                    //Alert.show("currentCard.labels.length "+currentCard.name+" : "+currentCard.labels.length);
                    for(var k:int = 0 ; k<currentCard.labels.length || (k==0 && currentCard.labels.length==0) ; k++)
                    {
                        var currentLabel:GetBoardListRespondcardsModelLabels 
                        if(currentCard.labels.length==0)
                        {
                            //Alert.show("Create clean label");
                            currentLabel = new GetBoardListRespondcardsModelLabels();
                        }
                        else
                        {
                            currentLabel = currentCard.labels[k];
                        }
                        
                        var currentChartItem:LabelModel = null ;
                        for(var l:int = 0 ; l<chartList.length ; l++)
                        {
                            if(chartList[l].label.id == currentLabel.id)
                            {
                                currentChartItem = chartList[l] ;
                                //Alert.show("founded currentLabel : "+currentLabel.name+" vs "+currentLabel.id);
                                break;
                            }
                        }
                        if(currentChartItem==null)
                        {
                            //Alert.show("Didnt found"+currentLabel);
                            currentChartItem = new LabelModel(currentLabel,null);
                            chartList.push(currentChartItem);
                        }
                        currentChartItem.addCard(currentCard);
                    }
                }
            }
            maxPage = Math.ceil(chartList.length/maxH);
            function sortLabels(a:LabelModel,b:LabelModel):int
            {
                return StringFunctions.compairFarsiString(a.label.name,b.label.name);
            }
            chartList.sort(sortLabels);


            //var i:int = 0;
            gridContainer.removeChildren();
            var myTable:DataGrid = new DataGrid(maxW*3+1,maxH*3,chartMC.width,chartMC.height,0xffffff,0x000000) ;
            gridContainer.addChild(myTable) ;
           
            var minus:uint = 0 ;
            
            for(j = 0 ; j<chartList.length ; j++)
            {
                //var canContinue:Boolean = false ;
                var firstW:uint = 18 ;
                var total:uint = maxW*3+1;
                var secondW:uint = total - firstW - 1 ;
                var secondH:uint = 3 ;

                var parag:TextParag = new TextParag() ;
                myTable.addContent(parag,0,j-extraCharts,firstW,secondH,0x000000,0xffffff,0) ;
                parag.setUp(chartList[j].getCartList(),true,false,false,false,false,false,false,false,true,true);
                parag = new TextParag() ;
                myTable.addContent(parag,firstW,j-extraCharts,secondW,secondH,0x000000,0xeeeeee,0) ;
                parag.setUp(chartList[j].label.name,true,false,false,false,false,false,false,false,true,true);
                parag = new TextParag() ;
                myTable.addContent(parag,firstW+secondW,j-extraCharts,1,secondH,0x000000,0xeeeeee,0) ;
                parag.setUp((j+1).toString(),true,false,false,false,false,false,false,false,true,true);
                
                if(j-extraCharts>=maxH-1)
                {
                    captureTable();
                    minus+=maxH;
                    //j=0;
                    var lastY:Number = myTable.y;
                    myTable = new DataGrid(maxW*3+1,maxH*3,chartMC.width,chartMC.height,0xffffff,0x000000) ;
                    gridContainer.addChild(myTable) ;
                    myTable.y = lastY + chartMC.height ;
                    extraCharts+=maxH;
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