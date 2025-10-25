package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mainbutton.MainButtnController;
   import road7th.data.DictionaryData;
   import vip.VipController;
   import vip.view.VipViewFrame;
   
   public class CalendarFrame extends Frame
   {
      
      private var _model:CalendarModel;
      
      private var _stateback:MovieImage;
      
      private var _currentState:ICalendar;
      
      private var _state:int;
      
      private var _activityList:ActivityList;
      
      private var _titlebitmap:Bitmap;
      
      private var _recentbitmap:Bitmap;
      
      private var _dateCombox:ComboBox;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      public function CalendarFrame(param1:CalendarModel)
      {
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._stateback = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.StateBg");
         addToContent(this._stateback);
         this._activityList = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityList",[this._model]);
         addToContent(this._activityList);
         this._recentbitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityRecent");
         addToContent(this._recentbitmap);
         this._dateCombox = ComponentFactory.Instance.creatComponentByStylename("dateSelect.combox");
         var _loc1_:Rectangle = ComponentFactory.Instance.creatCustomObject("dateSelect.comboxRec");
         ObjectUtils.copyPropertyByRectangle(this._dateCombox,_loc1_);
         this._dateCombox.beginChanges();
         this._dateCombox.selctedPropName = "text";
         this._dateCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("ddt.today"));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(1));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(2));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(3));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(4));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(5));
         this._dateCombox.listPanel.vectorListModel.append(this.getWeek(6));
         this._dateCombox.commitChanges();
         this._dateCombox.textField.text = LanguageMgr.GetTranslation("ddt.today");
         addToContent(this._dateCombox);
      }
      
      public function lookActivity(param1:Date) : void
      {
      }
      
      private function getWeek(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Date = this._model.today;
         var _loc5_:Date = new Date(_loc4_.fullYearUTC,_loc4_.monthUTC,_loc4_.dateUTC + param1);
         if(_loc4_.day > _loc5_.day)
         {
            if(_loc5_.day == 0)
            {
               _loc3_ = false;
            }
            else
            {
               _loc3_ = true;
            }
         }
         switch(_loc5_.day)
         {
            case 0:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextSunday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekSunday");
               break;
            case 1:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextMonday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekMonday");
               break;
            case 2:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextTuesday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekTuesday");
               break;
            case 3:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextWednesday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekWednesday");
               break;
            case 4:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextThursday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekThursday");
               break;
            case 5:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextFriday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekFriday");
               break;
            case 6:
               if(_loc3_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.weekNextSaturday");
                  break;
               }
               _loc2_ = LanguageMgr.GetTranslation("ddt.weekSaturday");
         }
         return _loc2_;
      }
      
      public function get activityList() : ActivityList
      {
         return this._activityList;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         this._dateCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__dateComboxChanged);
      }
      
      private function __dateComboxChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._dateCombox.currentSelectedIndex;
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:Date = new Date(_loc3_.fullYearUTC,_loc3_.monthUTC,_loc3_.dateUTC + _loc2_,_loc3_.hours,_loc3_.minutes,_loc3_.seconds);
         CalendarManager.getInstance().lookActivity(_loc4_);
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().reciveDayAward();
      }
      
      private function __vipOpen(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showVipPackage();
      }
      
      private function showVipPackage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            if(VipController.loadComplete)
            {
               this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
               this._vipInfoTipBox.escEnable = true;
               this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
               this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
               LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
            else if(VipController.useFirst)
            {
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
               VipController.useFirst = false;
            }
         }
         else
         {
            _loc1_ = 0;
            _loc2_ = PlayerManager.Instance.Self.systemDate as Date;
            _loc3_ = new Date();
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",_loc3_.month + 1,_loc3_.date + 1),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function __alertHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         if(Boolean(this.alertFrame) && Boolean(this.alertFrame.parent))
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case FrameEvent.ENTER_CLICK:
               MainButtnController.instance.VipAwardState = false;
               MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(param1:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __sendReward(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
      }
      
      private function getVIPInfoTip(param1:DictionaryData) : Array
      {
         var _loc2_:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      private function _getStrArr(param1:DictionaryData) : Array
      {
         return param1[VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            VipController.loadComplete = true;
            this.showVipPackage();
         }
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CalendarManager.getInstance().close();
               this.dispose();
         }
      }
      
      private function __signCountChanged(param1:Event) : void
      {
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      public function setState(param1:* = null) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            ObjectUtils.disposeObject(this._currentState);
            this._currentState = null;
            this._currentState = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityState",[this._model]);
            addToContent(this._currentState as DisplayObject);
         }
         if(Boolean(this._currentState))
         {
            this._currentState.setData(param1);
         }
      }
      
      public function showByQQ(param1:int) : void
      {
         this._activityList.showByQQ(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._stateback);
         this._stateback = null;
         ObjectUtils.disposeObject(this._activityList);
         this._activityList = null;
         ObjectUtils.disposeObject(this._currentState);
         this._currentState = null;
         ObjectUtils.disposeObject(this._titlebitmap);
         this._titlebitmap = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

