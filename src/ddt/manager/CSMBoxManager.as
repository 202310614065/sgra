package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.TimeBoxInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.CSMBoxView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import hall.HallStateView;
   import road7th.data.DictionaryData;
   
   public class CSMBoxManager extends EventDispatcher
   {
      
      private static var _instance:CSMBoxManager;
      
      public var CSMBoxList:DictionaryData;
      
      public var isShowBox:Boolean;
      
      private var _GSMBox:CSMBoxView;
      
      private var _awards:AwardsView;
      
      private var _timer:Timer;
      
      private var _currentLevel:int = 1;
      
      private var _currentNum:int;
      
      private var _remainTime:Number;
      
      private var _startTime:Number;
      
      private var _hall:HallStateView;
      
      private var _boxLoader:BaseLoader;
      
      public function CSMBoxManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : CSMBoxManager
      {
         if(_instance == null)
         {
            _instance = new CSMBoxManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_CSM_TIME_BOX,this._getGSMTimeBox);
      }
      
      private function _getGSMTimeBox(param1:CrazyTankSocketEvent) : void
      {
         this.isShowBox = true;
         this._currentLevel = param1.pkg.readInt();
         this._currentNum = param1.pkg.readInt();
         if(Boolean(this.CSMBoxList))
         {
            this.createBoxAndTimer();
         }
         else if(this._boxLoader == null)
         {
            this._boxLoader = LoaderCreate.Instance.creatUserBoxInfoLoader();
            this._boxLoader.addEventListener(LoaderEvent.COMPLETE,this.__onBoxLoaderComplete);
            LoaderManager.Instance.startLoad(this._boxLoader);
         }
      }
      
      private function __onBoxLoaderComplete(param1:LoaderEvent) : void
      {
         BaseLoader(param1.currentTarget).removeEventListener(LoaderEvent.COMPLETE,this.__onBoxLoaderComplete);
         if(Boolean(this.CSMBoxList))
         {
            this.createBoxAndTimer();
         }
      }
      
      private function createBoxAndTimer() : void
      {
         var _loc1_:TimeBoxInfo = TimeBoxInfo(this.CSMBoxList[this._currentLevel].info);
         this._remainTime = _loc1_.Condition * 60 - this._currentNum;
         this._startTime = getTimer();
         this.showBox();
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__updateBoxTime);
            this._timer.start();
         }
      }
      
      public function showBox(param1:HallStateView = null) : void
      {
         if(Boolean(param1))
         {
            this._hall = param1;
         }
         if(Boolean(this._hall) && this.isShowBox)
         {
            this.removeBox();
            if(!this._GSMBox)
            {
               this._GSMBox = new CSMBoxView();
               PositionUtils.setPos(this._GSMBox,"CSMBoxViewPos");
            }
            LayerManager.Instance.addToLayer(this._GSMBox,LayerManager.GAME_DYNAMIC_LAYER);
         }
      }
      
      public function removeBox() : void
      {
         if(Boolean(this._GSMBox))
         {
            ObjectUtils.disposeObject(this._GSMBox);
            this._GSMBox = null;
         }
      }
      
      public function showAwards(param1:int = 0) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(Boolean(this.CSMBoxList))
         {
            this._awards = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
            this._awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendGetAwards);
            this._awards.addEventListener(FrameEvent.RESPONSE,this.__awardsFrameEventHandler);
            this._awards.boxType = 0;
            _loc2_ = this.CSMBoxList[this._currentLevel].goodListIds;
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = int(_loc2_[_loc4_]);
               _loc6_ = BossBoxManager.instance.inventoryItemList[_loc5_];
               _loc3_ = _loc3_.concat(_loc6_);
               _loc4_++;
            }
            this._awards.goodsList = _loc3_;
            if(param1 == 0)
            {
               this._awards.setCheck();
            }
            LayerManager.Instance.addToLayer(this._awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __awardsFrameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
         }
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function __sendGetAwards(param1:Event) : void
      {
         SocketManager.Instance.out.sendGetCSMTimeBox();
         this.removeAwards();
         this.removeBox();
         this.removeTimer();
      }
      
      private function __updateBoxTime(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this._GSMBox))
         {
            _loc2_ = (getTimer() - this._startTime) / 1000;
            if(_loc2_ < this._remainTime)
            {
               _loc3_ = this._remainTime - _loc2_;
               this._GSMBox.showBox(0);
               this._GSMBox.updateTime(_loc3_);
            }
            else
            {
               this._GSMBox.showBox(1);
            }
         }
      }
      
      private function removeTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateBoxTime);
            this._timer.stop();
            this._timer = null;
         }
      }
      
      private function removeAwards() : void
      {
         if(Boolean(this._awards))
         {
            this._awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendGetAwards);
            this._awards.removeEventListener(FrameEvent.RESPONSE,this.__awardsFrameEventHandler);
            ObjectUtils.disposeObject(this._awards);
            this._awards = null;
         }
      }
   }
}

