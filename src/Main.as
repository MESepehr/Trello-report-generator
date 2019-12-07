package {

import dataManager.GlobalStorage;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextField;
import flash.ui.Mouse;

import mteam.animation.Anim_jump;

public class Main extends MovieClip {

    private var button1:MovieClip,
                button2:MovieClip,
                button3:MovieClip,
                tockenField:TextField,
                apiField:TextField,

                apiHelp:MovieClip,
                tockenHelp:MovieClip;

    public static var   apiKey:String ,
                        tocken:String ;

    private const   id_key:String = "id_key",
                    id_tocken:String = "id_tocken";

    private var apiHelpY:Number,tockenHelpY:Number;

    public function Main() {
       trace("Hello world!");
	   
	   UnicodeStatic.deactiveConvertor = true ;

        button1 = Obj.get("board_report_mc",this);
        button1.buttonMode = true ;
        button1.addEventListener(MouseEvent.CLICK, openReportPage);

        button2 = Obj.get("board_roadmap_mc",this);
        button2.buttonMode = true ;
        button2.addEventListener(MouseEvent.CLICK, openReportPage);

        button3 = Obj.get("label_repost_mc",this);
        button3.buttonMode = true ;
        button3.addEventListener(MouseEvent.CLICK, openReportPage);

        apiHelp = Obj.get("apihelp_mc",this);
        apiHelp.buttonMode = true ;
        apiHelp.addEventListener(MouseEvent.CLICK,openAPIHelpPage);

        tockenHelp = Obj.get("tocken_mc",this);
        tockenHelp.buttonMode = true ;
        tockenHelp.addEventListener(MouseEvent.CLICK, openTockenHelp);

        apiHelpY = apiHelp.y;
        tockenHelpY = tockenHelp.y;

        apiField = Obj.get("api_txt",this);
        apiKey = GlobalStorage.load(id_key);
        if(apiKey==null)
        {
            apiKey = '' ;
        }
        apiField.text = apiKey ;

        tockenField = Obj.get("tocken_txt",this);
        tocken = GlobalStorage.load(id_tocken);
        if(tocken==null)
        {
            tocken = '' ;
        }
        tockenField.text = tocken ;

        this.stop();
    }

    private function openTockenHelp(event:MouseEvent):void {
        navigateToURL(new URLRequest("https://trello.com/1/authorize?expiration=never&scope=read,account&response_type=token&name=Server%20Token&key="+apiField.text));
    }

    private function openAPIHelpPage(event:MouseEvent):void {
        navigateToURL(new URLRequest("https://trello.com/app-key"));
    }

    private function openReportPage(event:MouseEvent):void {
        apiKey = apiField.text ;
        tocken = tockenField.text ;
        if(apiKey=='')
        {
            trace("Error");
            apiHelp.y = apiHelpY-100;
            new Anim_jump(apiHelp,apiHelp.x,apiHelpY,new Function());
            return ;
        }
        GlobalStorage.save(id_key,apiKey);
        if(tocken=='')
        {
            trace("Error");
            tockenHelp.y = tockenHelpY-100;
            new Anim_jump(tockenHelp,tockenHelp.x,tockenHelpY,new Function());
            return ;
        }
        GlobalStorage.save(id_tocken,tocken);
        trace("Success : "+apiKey,tocken);

        switch((event.currentTarget as MovieClip).name)
        {
            case 'board_report_mc':
                this.gotoAndStop(2);
                break;
            case 'board_roadmap_mc':
                this.gotoAndStop(3);
                break;
            case 'label_repost_mc':
                this.gotoAndStop(4);
                break;
        }
    }

}
}
