package {

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

public class Main extends MovieClip {

    private var button1:MovieClip;

    public function Main() {
       trace("Hello world!");

        button1 = Obj.get("board_report_mc",this);
        button1.buttonMode = true ;
        button1.addEventListener(MouseEvent.CLICK, openReportPage);

        this.stop();
    }

    private function openReportPage(event:MouseEvent):void {
        this.gotoAndStop(2);
    }

}
}
