package dayActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.ActivityData;
   import dayActivity.view.DayActiveView;
   import dayActivity.view.DayActivityAdvView;
   import dayActivity.view.DayActivityView;
   import dayActivity.view.DdtImportantView;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import times.TimesManager;
   
   public class ActivityFrame extends Frame implements Disposeable
   {
      
      private var _dayActivityBtn:SelectedButton;
      
      private var _dayActiveBtn:SelectedButton;
      
      private var _dayActivityAdvBtn:SelectedButton;
      
      private var _ddtImportantAdvBtn:SelectedButton;
      
      private var _seleBtnGroup:SelectedButtonGroup;
      
      private var _treeImage:ScaleBitmapImage;
      
      private var _dayActivityView:DayActivityView;
      
      private var _dayActiveView:DayActiveView;
      
      private var _dayActivityAdvView:DayActivityAdvView;
      
      private var _ddtImportantAdvView:DdtImportantView;
      
      private var _serverTimeTxt:FilterFrameText;
      
      private var _serverTimeTxtStr:String;
      
      private var _serverTimer:Timer;
      
      public function ActivityFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._seleBtnGroup.addEventListener(Event.CHANGE,this.changeHandler);
      }
      
      public function updataBtn(param1:int) : void
      {
         if(Boolean(this._dayActivityView))
         {
            this._dayActivityView.updataBtn(param1);
         }
      }
      
      protected function changeHandler(param1:Event) : void
      {
         this.showView(this._seleBtnGroup.selectIndex);
      }
      
      private function showView(param1:int) : void
      {
         this.hideAll();
         SoundManager.instance.play("008");
         switch(param1)
         {
            case DayActivityManager.DAY_ACTIVITY:
               this.setWidthAndHeight(1);
               if(Boolean(this._dayActiveView))
               {
                  this._dayActiveView.visible = true;
                  this._dayActiveView.updata(DayActivityManager.Instance.sessionArr);
                  break;
               }
               this._dayActiveView = new DayActiveView(DayActivityManager.Instance.acitiveDataList);
               this._dayActiveView.y = 5;
               this._dayActiveView.updata(DayActivityManager.Instance.sessionArr);
               addToContent(this._dayActiveView);
               break;
            case DayActivityManager.DAY_ACTIVE:
               this.setWidthAndHeight(1);
               if(Boolean(this._dayActivityView))
               {
                  this._dayActivityView.visible = true;
                  this._dayActivityView.setLeftView(DayActivityManager.Instance.overList,DayActivityManager.Instance.noOverList);
                  this._dayActivityView.setBar(DayActivityManager.Instance.activityValue);
                  break;
               }
               this._dayActivityView = new DayActivityView();
               this._dayActivityView.setLeftView(DayActivityManager.Instance.overList,DayActivityManager.Instance.noOverList);
               this._dayActivityView.setBar(DayActivityManager.Instance.activityValue);
               addToContent(this._dayActivityView);
               break;
            case DayActivityManager.DAY_ACTIVITYADV:
               if(TimesManager.Instance.isShowActivityAdvView)
               {
                  this.setWidthAndHeight(1);
                  if(Boolean(this._dayActivityAdvView))
                  {
                     this._dayActivityAdvView.visible = true;
                     break;
                  }
                  this._dayActivityAdvView = new DayActivityAdvView(TimesManager.Instance.updateContentList);
                  addToContent(this._dayActivityAdvView);
                  PositionUtils.setPos(this._dayActivityAdvView,"activityAdv.viewPos");
                  break;
               }
               this.openDdtImportantAdvView();
               break;
            case DayActivityManager.DDT_IMPORTANTADV:
               this.openDdtImportantAdvView();
         }
      }
      
      private function setWidthAndHeight(param1:int) : void
      {
         if(param1 == 2)
         {
            this.width = 780;
            this.height = 567;
            this._treeImage.width = 745;
            this._treeImage.height = 469;
         }
         else
         {
            this.width = 770;
            this.height = 555;
            this._treeImage.width = 735;
            this._treeImage.height = 455;
         }
      }
      
      private function openDdtImportantAdvView() : void
      {
         this.setWidthAndHeight(2);
         if(Boolean(this._ddtImportantAdvView))
         {
            this._ddtImportantAdvView.visible = true;
         }
         else
         {
            this._ddtImportantAdvView = new DdtImportantView();
            addToContent(this._ddtImportantAdvView);
         }
      }
      
      public function setLeftView(param1:Vector.<ActivityData>, param2:Vector.<ActivityData>) : void
      {
         if(Boolean(this._dayActivityView))
         {
            this._dayActivityView.setLeftView(param1,param2);
         }
      }
      
      public function setBar(param1:int) : void
      {
         if(Boolean(this._dayActivityView))
         {
            this._dayActivityView.setBar(param1);
         }
      }
      
      public function updata(param1:Array) : void
      {
         this._dayActiveView.updata(param1);
      }
      
      private function initActivityFrame() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CALENDAR);
      }
      
      protected function onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CALENDAR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function createActivityFrame(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      protected function onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      private function hideAll() : void
      {
         if(Boolean(this._dayActiveView))
         {
            this._dayActiveView.visible = false;
         }
         if(Boolean(this._dayActivityView))
         {
            this._dayActivityView.visible = false;
         }
         if(Boolean(this._dayActivityAdvView))
         {
            this._dayActivityAdvView.visible = false;
         }
         if(Boolean(this._ddtImportantAdvView))
         {
            this._ddtImportantAdvView.visible = false;
         }
      }
      
      private function initView() : void
      {
         this.width = 771;
         this.height = 556;
         titleText = LanguageMgr.GetTranslation("ddt.dayActivity.title");
         this._treeImage = ComponentFactory.Instance.creatComponentByStylename("dayActivity.scale9cornerImageTree");
         addToContent(this._treeImage);
         this._dayActivityBtn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame.seleBtn1");
         addToContent(this._dayActivityBtn);
         this._dayActiveBtn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame.seleBtn2");
         addToContent(this._dayActiveBtn);
         if(TimesManager.Instance.isShowActivityAdvView)
         {
            this._dayActivityAdvBtn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame.seleBtn3");
            addToContent(this._dayActivityAdvBtn);
         }
         this._seleBtnGroup = new SelectedButtonGroup();
         this._seleBtnGroup.addSelectItem(this._dayActivityBtn);
         this._seleBtnGroup.addSelectItem(this._dayActiveBtn);
         if(TimesManager.Instance.isShowActivityAdvView)
         {
            this._seleBtnGroup.addSelectItem(this._dayActivityAdvBtn);
         }
         this._seleBtnGroup.selectIndex = DayActivityManager.DAY_ACTIVITY;
         this._ddtImportantAdvBtn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame.ddtImportantAdvBtn");
         if(TimesManager.Instance.isShowActivityAdvView)
         {
            this._ddtImportantAdvBtn.x = 268;
         }
         else
         {
            this._ddtImportantAdvBtn.x = 268;
         }
         this._seleBtnGroup.addSelectItem(this._ddtImportantAdvBtn);
         this._seleBtnGroup.selectIndex = DayActivityManager.DAY_ACTIVE;
         this.showView(this._seleBtnGroup.selectIndex);
         this._serverTimeTxt = ComponentFactory.Instance.creatComponentByStylename("dayActivity.activityFrame.tiem.txt");
         this._serverTimeTxtStr = LanguageMgr.GetTranslation("ddt.activieView.serverTimeTxtTitle");
         this.updateServerTime();
         addToContent(this._serverTimeTxt);
         this._serverTimer = new Timer(10 * 1000);
         this._serverTimer.addEventListener(TimerEvent.TIMER,this.updateServerTime);
         this._serverTimer.start();
      }
      
      private function updateServerTime(param1:TimerEvent = null) : void
      {
         var _loc2_:Date = null;
         if(Boolean(this._serverTimeTxt))
         {
            _loc2_ = TimeManager.Instance.Now();
            this._serverTimeTxt.text = LanguageMgr.GetTranslation("dayActivity.activityFrame.tiem.LG",_loc2_.fullYear,_loc2_.month + 1,_loc2_.date,_loc2_.hours,_loc2_.minutes < 10 ? "0" + _loc2_.minutes : _loc2_.minutes);
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            DayActivityManager.Instance.dispose();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._seleBtnGroup.removeEventListener(Event.CHANGE,this.changeHandler);
         if(Boolean(this._dayActiveView))
         {
            ObjectUtils.disposeObject(this._dayActiveView);
         }
         if(Boolean(this._dayActivityView))
         {
            ObjectUtils.disposeObject(this._dayActivityView);
         }
         if(Boolean(this._dayActivityAdvView))
         {
            ObjectUtils.disposeObject(this._dayActivityAdvView);
         }
         if(Boolean(this._ddtImportantAdvView))
         {
            ObjectUtils.disposeObject(this._ddtImportantAdvView);
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._dayActivityView = null;
         this._dayActiveView = null;
         this._dayActivityAdvView = null;
         this._ddtImportantAdvView = null;
         if(Boolean(this._serverTimeTxt))
         {
            ObjectUtils.disposeObject(this._serverTimeTxt);
            this._serverTimeTxt = null;
         }
         if(Boolean(this._serverTimer))
         {
            this._serverTimer.stop();
            this._serverTimer.removeEventListener(TimerEvent.TIMER,this.updateServerTime);
            this._serverTimer = null;
         }
         this._serverTimeTxtStr = null;
         super.dispose();
      }
   }
}

