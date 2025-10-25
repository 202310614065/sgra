package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionJobManageFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _textBG:ScaleBitmapImage;
      
      private var _cancel:TextButton;
      
      private var _list:VBox;
      
      private var _items:Vector.<JobManageItem>;
      
      private var _jobManager:FilterFrameText;
      
      private var _limits:FilterFrameText;
      
      private var _textArea:FilterFrameText;
      
      private var _dottedline:MutipleImage;
      
      public function ConsortionJobManageFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaRightsFrame.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.bg");
         this._dottedline = ComponentFactory.Instance.creatComponentByStylename("consortion.dottedline");
         this._textBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionJobManageFrame.textAreaBG");
         this._jobManager = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManageText");
         this._jobManager.text = LanguageMgr.GetTranslation("consortion.ConsortionJobManageFrame.jobManageText");
         this._limits = ComponentFactory.Instance.creatComponentByStylename("consortion.limitsText");
         this._limits.text = LanguageMgr.GetTranslation("consortion.ConsortionJobManageFrame.limitsText");
         this._textArea = ComponentFactory.Instance.creatComponentByStylename("ConsortionJobManageFrame.limitsText");
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.list");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.cancel");
         addToContent(this._bg);
         addToContent(this._dottedline);
         addToContent(this._textBG);
         addToContent(this._jobManager);
         addToContent(this._limits);
         addToContent(this._textArea);
         addToContent(this._list);
         addToContent(this._cancel);
         this._cancel.text = LanguageMgr.GetTranslation("close");
         this._items = new Vector.<JobManageItem>(5);
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(Boolean(this._items[_loc1_]))
            {
               this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            }
            _loc1_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __dutyListChange(param1:ConsortionEvent) : void
      {
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function setDataList(param1:Vector.<ConsortiaDutyInfo>) : void
      {
         var _loc2_:int = 0;
         this.clearList();
         if(Boolean(param1))
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this._items[_loc2_] = new JobManageItem();
               this._items[_loc2_].dutyInfo = param1[_loc2_];
               this._items[_loc2_].name = String(_loc2_);
               this._items[_loc2_].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._list.addChild(this._items[_loc2_]);
               _loc2_++;
            }
         }
         this._textArea.text = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text");
      }
      
      private function clearList() : void
      {
         this._list.disposeAllChildren();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._items[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(param1.currentTarget != this._items[_loc2_])
            {
               this._items[_loc2_].selected = false;
               this._items[_loc2_].editable = false;
            }
            else
            {
               this._items[_loc2_].selected = true;
               this._textArea.text = this.setText(_loc2_ + 1);
            }
            _loc2_++;
         }
      }
      
      private function setText(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
               _loc2_ = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text1");
               break;
            case 2:
               _loc2_ = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text2");
               break;
            case 3:
               _loc2_ = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text3");
               break;
            case 4:
               _loc2_ = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text4");
               break;
            case 5:
               _loc2_ = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text4");
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._dottedline = null;
         this._textBG = null;
         this._jobManager = null;
         this._limits = null;
         this._textArea = null;
         this._cancel = null;
         this._list = null;
         this._items = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

