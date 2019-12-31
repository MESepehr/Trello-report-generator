package pages
//pages.InputTextWithCash
{
    import flash.text.TextField;
    import dataManager.GlobalStorage;
    import flash.events.Event;
    import flash.display.MovieClip;

    public class InputTextWithCash extends MovieClip
    {
        private var textTF:TextField ;
        public function InputTextWithCash()
        {
            super();
            textTF = Obj.findThisClass(TextField,this);
            var earlierText:String = GlobalStorage.load(this.name);
            if(earlierText!=null)
            {
                textTF.text = earlierText ;
            }
            textTF.addEventListener(Event.CHANGE,textUpdaed);
        }

        private function textUpdaed(e:Event):void
        {
            trace("Chage!!")
            GlobalStorage.save(this.name,textTF.text);
        }
    }
}