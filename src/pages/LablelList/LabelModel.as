package pages.LablelList
{
    import services.BoardList.GetBoardListRespondcardsModel;
    import services.BoardList.GetBoardListRespondcardsModelLabels;


    public class LabelModel
    {
        public var myCards:Vector.<GetBoardListRespondcardsModel> ;

        public var label:GetBoardListRespondcardsModelLabels ;

        public function LabelModel(currentLabel:GetBoardListRespondcardsModelLabels=null,currentCard:GetBoardListRespondcardsModel=null)
        {
            super();
            myCards  = new Vector.<GetBoardListRespondcardsModel>();
            addCard(currentCard);
            if(currentLabel!=null)
            {
                label = currentLabel ;
            }
        }

        public function addCard(card:GetBoardListRespondcardsModel):void
        {
            if(card!=null)
            {
                myCards.push(card);
            }
        }

        public function getCartList():String
        {
            var text:String = '' ;
            for(var i:int = 0 ; i<myCards.length ; i++)
            {
                text += myCards[i].name +'-';
            }
            if(text.length>0)
            {
                text = text.substring(0,text.length-1);
            }
            return text ;
        }
    }
}