package dayActivity
{
   import battleGroud.BattleGroudManager;
   import campbattle.CampBattleManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortionBattle.ConsortiaBattleManager;
   import dayActivity.data.ActivityData;
   import dayActivity.data.DayActiveData;
   import dayActivity.data.DayRewaidData;
   import dayActivity.items.DayActivieListItem;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import league.manager.LeagueManager;
   import littleGame.LittleGameManager;
   import wantstrong.WantStrongManager;
   import worldboss.WorldBossManager;
   
   public class DayActivityManager extends EventDispatcher
   {
      
      private static var _instance:DayActivityManager;
      
      public static const ACTIVITY_VALUE_CHANGE:String = "daily_activity_value_change";
      
      public static const ACTIVITY_GET_STATUS_CHANGE:String = "daily_activity_get_status_change";
      
      public static var TIME1:String = "20:00-21:00";
      
      public static var TIME2:String = "14:00-15:00";
      
      public static var TIME3:String = "21:00-23:00";
      
      public static var TIME4:String = "12:00-14:00";
      
      public static var TIME5:String = "Kaptan açık";
      
      public static var TIME6:String = "18:00-19:30";
      
      public static const DAY_ACTIVITY:int = 0;
      
      public static const DAY_ACTIVE:int = 1;
      
      public static const DAY_ACTIVITYADV:int = 2;
      
      public static const DDT_IMPORTANTADV:int = 3;
      
      private static var activityNumber:int = 0;
      
      public var overList:Vector.<ActivityData>;
      
      public var noOverList:Vector.<ActivityData>;
      
      public var acitivityList:Vector.<ActivityData>;
      
      private var _activityFrame:ActivityFrame;
      
      public var acitivityDataList:Vector.<ActivityData>;
      
      public var acitiveDataList:Vector.<DayActiveData>;
      
      public var reweadDataList:Vector.<DayRewaidData>;
      
      public var bossDataDic:Dictionary = new Dictionary();
      
      private var findBackDic:Dictionary = new Dictionary();
      
      private var _activityValue:int;
      
      public var isOverList:Array;
      
      private var rezArray:Array;
      
      public var btnArr:Array;
      
      public var sessionArr:Array;
      
      private var ANYEBOJUE:String;
      
      public var ANYEBOJUE_DAYOFWEEK:String;
      
      private var YUANGUJULONG:String;
      
      public var YUANGUJULONG_DAYOFWEEK:String;
      
      private var LIANSAI:String;
      
      private var ZHANCHANG:String;
      
      private var GONGHUIBOSS:String;
      
      private var BOGUQUNYING:String;
      
      private var ZHENYINGZHAN:String;
      
      private var ZUQIUBOSS:String;
      
      public var ZUQIUBOSS_DAYOFWEEK:String;
      
      private var GONGHUIZHAN:String;
      
      public function DayActivityManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.overList = new Vector.<ActivityData>();
         this.noOverList = new Vector.<ActivityData>();
         this.acitivityList = new Vector.<ActivityData>();
      }
      
      public static function get Instance() : DayActivityManager
      {
         if(_instance == null)
         {
            _instance = new DayActivityManager();
         }
         return _instance;
      }
      
      public function get activityValue() : int
      {
         return this._activityValue;
      }
      
      public function set activityValue(param1:int) : void
      {
         this._activityValue = param1;
         dispatchEvent(new Event(ACTIVITY_VALUE_CHANGE));
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEMONEYPOINT_COMPLETE,this.addSpeedResp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GETACTIVEPOINT_REWARD,this.changGoodsBtn);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_DATA,this.initActivityList);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_CHANGE,this.initSingleActivity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_ACTIVITY_DATA_CHANGE,this.addActivityChange);
      }
      
      private function creatActiveLoader() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActivePointTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new ActivityAnalyzer(this.everyDayActive);
      }
      
      private function creatActivePointLoader() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActiveProgressInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new ActivePointAnalzer(this.everyDayActivePoint);
      }
      
      private function creatRewardLoader() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActiveRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new ActivityRewardAnalyzer(this.activityRewardComp);
      }
      
      public function activityRewardComp(param1:ActivityRewardAnalyzer) : void
      {
         this.reweadDataList = param1.itemList;
      }
      
      public function everyDayActivePoint(param1:ActivePointAnalzer) : void
      {
         this.acitiveDataList = param1.itemList;
         DdtActivityIconManager.Instance.timerList = param1.itemList;
         this.setActionTime();
      }
      
      private function setActionTime() : void
      {
         var _loc1_:int = int(this.acitiveDataList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            switch(this.acitiveDataList[_loc2_].ID)
            {
               case 1:
                  this.ANYEBOJUE = this.acitiveDataList[_loc2_].ActiveTime;
                  this.ANYEBOJUE_DAYOFWEEK = this.acitiveDataList[_loc2_].DayOfWeek;
                  break;
               case 2:
                  this.YUANGUJULONG = this.acitiveDataList[_loc2_].ActiveTime;
                  this.YUANGUJULONG_DAYOFWEEK = this.acitiveDataList[_loc2_].DayOfWeek;
                  break;
               case 4:
                  this.LIANSAI = this.acitiveDataList[_loc2_].ActiveTime;
                  break;
               case 5:
                  this.ZHANCHANG = this.acitiveDataList[_loc2_].ActiveTime;
                  break;
               case 6:
                  this.GONGHUIBOSS = this.acitiveDataList[_loc2_].ActiveTime;
                  break;
               case 10:
                  this.BOGUQUNYING = this.acitiveDataList[_loc2_].ActiveTime;
                  break;
               case 18:
                  this.ZHENYINGZHAN = this.acitiveDataList[_loc2_].ActiveTime;
                  break;
               case 19:
                  this.ZUQIUBOSS = this.acitiveDataList[_loc2_].ActiveTime;
                  this.ZUQIUBOSS_DAYOFWEEK = this.acitiveDataList[_loc2_].DayOfWeek;
                  break;
               case 20:
                  this.GONGHUIZHAN = this.acitiveDataList[_loc2_].ActiveTime;
            }
            _loc2_++;
         }
      }
      
      public function everyDayActive(param1:ActivityAnalyzer) : void
      {
         this.acitivityDataList = param1.itemList;
         this.noOverList = this.copyArr(this.acitivityDataList);
      }
      
      public function changGoodsBtn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            this.btnArr[_loc2_ - 1][1] = 1;
            if(Boolean(this._activityFrame))
            {
               this._activityFrame.updataBtn(_loc2_);
            }
            dispatchEvent(new Event(ACTIVITY_GET_STATUS_CHANGE));
         }
      }
      
      public function get isHasActivityAward() : Boolean
      {
         if(!this.btnArr || this.btnArr.length == 0)
         {
            return false;
         }
         if(this.activityValue >= 30 && this.btnArr[0][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 60 && this.btnArr[1][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 80 && this.btnArr[2][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 100 && this.btnArr[3][1] == 0)
         {
            return true;
         }
         return false;
      }
      
      public function addActivityChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         this.updataNum(_loc2_,_loc3_);
      }
      
      public function send(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.addSpeed(param1,param2);
      }
      
      private function updataNum(param1:int, param2:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(this.sessionArr == null)
         {
            this.sessionArr = [];
         }
         var _loc3_:int = int(this.sessionArr.length);
         if(_loc3_ == 0)
         {
            _loc4_ = [];
            _loc4_[0] = param1;
            _loc4_[1] = param2;
            this.sessionArr.push(_loc4_);
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               if(this.sessionArr[_loc5_][0] == param1)
               {
                  this.sessionArr[_loc5_][1] = param2;
                  break;
               }
               if(_loc5_ >= _loc3_ - 1)
               {
                  _loc4_ = [];
                  _loc4_[0] = param1;
                  _loc4_[1] = param2;
                  this.sessionArr.push(_loc4_);
               }
               _loc5_++;
            }
         }
      }
      
      public function addSpeedResp(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         this.activityValue = param1.pkg.readInt();
         this.addOverList(_loc3_,_loc2_);
         if(Boolean(this._activityFrame) && Boolean(this._activityFrame.parent))
         {
            this._activityFrame.setLeftView(this.overList,this.noOverList);
            this._activityFrame.setBar(this.activityValue);
         }
      }
      
      private function addOverList(param1:Boolean, param2:int, param3:int = 0) : void
      {
         var _loc4_:int = int(this.acitivityDataList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.acitivityDataList[_loc5_].ID == param2)
            {
               if(param1)
               {
                  this.acitivityDataList[_loc5_].OverCount = this.acitivityDataList[_loc5_].Count;
                  this.overList.push(this.acitivityDataList[_loc5_]);
                  this.deleNoOverListItem(param2);
                  break;
               }
               this.acitivityDataList[_loc5_].OverCount = param3;
               if(this.acitivityDataList[_loc5_].Count <= param3)
               {
                  if(!this.checkOverList(this.acitivityDataList[_loc5_].ID))
                  {
                     this.overList.push(this.acitivityDataList[_loc5_]);
                  }
                  this.deleNoOverListItem(param2);
               }
               break;
            }
            _loc5_++;
         }
      }
      
      private function checkOverList(param1:int) : Boolean
      {
         var _loc2_:int = int(this.overList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.overList[_loc3_].ID == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function initSingleActivity(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         if(_loc2_ == 4 || _loc2_ == 5 || _loc2_ == 6 || _loc2_ == 18 || _loc2_ == 19)
         {
            this.bossDataDic[_loc2_] = _loc3_;
         }
         this.activityValue = param1.pkg.readInt();
         this.addOverList(false,_loc2_,_loc3_);
         if(Boolean(this._activityFrame) && Boolean(this._activityFrame.parent))
         {
            this._activityFrame.setLeftView(this.overList,this.noOverList);
            this._activityFrame.setBar(this.activityValue);
         }
      }
      
      private function deleNoOverListItem(param1:int) : void
      {
         var _loc2_:int = int(this.noOverList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.noOverList[_loc3_].ID)
            {
               this.noOverList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function initActivityList(param1:CrazyTankSocketEvent) : void
      {
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == 0)
         {
            this.overList.splice(0,this.overList.length);
            this.noOverList.splice(0,this.noOverList.length);
            this.noOverList = this.copyArr(this.acitivityDataList);
         }
         this.rezArray = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc12_ = new Array();
            _loc12_[0] = param1.pkg.readInt();
            _loc12_[1] = param1.pkg.readInt();
            if(_loc12_[0] == 4 || _loc12_[0] == 5 || _loc12_[0] == 6 || _loc12_[0] == 18 || _loc12_[0] == 19)
            {
               this.bossDataDic[_loc12_[0]] = _loc12_[1];
            }
            this.rezArray.push(_loc12_);
            _loc3_++;
         }
         this.btnArr = [[1,0],[2,0],[3,0],[4,0]];
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc13_ = param1.pkg.readInt();
            _loc14_ = param1.pkg.readInt();
            _loc15_ = int(this.btnArr.length);
            _loc16_ = 0;
            while(_loc16_ < _loc15_)
            {
               if(this.btnArr[_loc16_][0] == _loc13_)
               {
                  this.btnArr[_loc16_][1] = _loc14_;
                  break;
               }
               _loc16_++;
            }
            _loc5_++;
         }
         this.sessionArr = [];
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc17_ = new Array();
            _loc17_[0] = param1.pkg.readInt();
            _loc17_[1] = param1.pkg.readInt();
            this.sessionArr.push(_loc17_);
            _loc7_++;
         }
         this.activityValue = param1.pkg.readInt();
         this.initSession();
         var _loc8_:int = int(this.rezArray.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc18_ = int(this.noOverList.length);
            _loc19_ = 0;
            while(_loc19_ < _loc18_)
            {
               _loc20_ = int(this.rezArray[_loc9_][0]);
               _loc21_ = int(this.rezArray[_loc9_][1]);
               if(this.noOverList[_loc19_].ID == _loc20_)
               {
                  this.noOverList[_loc19_].OverCount = _loc21_;
                  if(this.noOverList[_loc19_].OverCount >= this.noOverList[_loc19_].Count)
                  {
                     this.overList.push(this.noOverList[_loc19_]);
                     this.deleNoOverListItem(_loc20_);
                  }
                  break;
               }
               _loc19_++;
            }
            _loc9_++;
         }
         var _loc10_:int = param1.pkg.readInt();
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc22_ = param1.pkg.readInt();
            _loc23_ = new Array();
            _loc23_[0] = param1.pkg.readBoolean();
            _loc23_[1] = param1.pkg.readBoolean();
            this.findBackDic[_loc22_] = _loc23_;
            _loc11_++;
         }
         WantStrongManager.Instance.findBackDic = this.findBackDic;
      }
      
      private function copyArr(param1:Vector.<ActivityData>) : Vector.<ActivityData>
      {
         var _loc4_:ActivityData = null;
         var _loc2_:Vector.<ActivityData> = new Vector.<ActivityData>();
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_].resetOverCount();
            _loc4_ = param1[_loc3_];
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function initActivityFrame() : void
      {
         if(!this._activityFrame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DAY_ACTIVITY);
         }
         else
         {
            this._activityFrame = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame");
            this._activityFrame.width = 770;
            this._activityFrame.height = 550;
            LayerManager.Instance.addToLayer(this._activityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function initActivityStata(param1:Vector.<DayActivieListItem>) : void
      {
         var _loc2_:Array = null;
         if(WorldBossManager.Instance.isOpen)
         {
            if(WorldBossManager.Instance.currentPVE_ID == 30002)
            {
               this.updateActivityData(this.ANYEBOJUE,param1,false);
            }
            else if(WorldBossManager.Instance.currentPVE_ID == 1243)
            {
               this.updateActivityData(this.YUANGUJULONG,param1,false);
            }
            else
            {
               this.updateActivityData(this.ZUQIUBOSS,param1,false);
            }
         }
         else if(WorldBossManager.Instance.currentPVE_ID == 30002)
         {
            this.updateActivityData(this.ANYEBOJUE,param1,true);
         }
         else if(WorldBossManager.Instance.currentPVE_ID == 1243)
         {
            this.updateActivityData(this.YUANGUJULONG,param1,true);
         }
         else
         {
            this.updateActivityData(this.ZUQIUBOSS,param1,true);
         }
         if(BattleGroudManager.Instance.isShow)
         {
            this.updateActivityData(this.ZHANCHANG,param1,false);
         }
         else
         {
            this.updateActivityData(this.ZHANCHANG,param1,true);
         }
         if(LeagueManager.instance.isOpen)
         {
            this.updateActivityData(this.LIANSAI,param1,false);
         }
         else
         {
            this.updateActivityData(this.LIANSAI,param1,true);
         }
         if(ConsortionModelControl.Instance.isBossOpen)
         {
            this.updateActivityData(this.GONGHUIBOSS,param1,false);
         }
         else
         {
            this.updateActivityData(this.GONGHUIBOSS,param1,true);
         }
         if(LittleGameManager.Instance.hasActive())
         {
            _loc2_ = this.encounterTime(this.BOGUQUNYING);
            if(Number(_loc2_[0]) >= Number(_loc2_[1]) && Number(_loc2_[0]) <= Number(_loc2_[2]))
            {
               this.updateActivityData(this.BOGUQUNYING,param1,false);
            }
            else
            {
               this.updateActivityData(this.BOGUQUNYING,param1,true);
            }
         }
         else
         {
            this.updateActivityData(this.BOGUQUNYING,param1,true);
         }
         if(CampBattleManager.instance.model.isOpen)
         {
            this.updateActivityData(this.ZHENYINGZHAN,param1,false);
         }
         else
         {
            this.updateActivityData(this.ZHENYINGZHAN,param1,true);
         }
         if(ConsortiaBattleManager.instance.isOpen)
         {
            this.updateActivityData(this.GONGHUIZHAN,param1,false);
         }
         else
         {
            this.updateActivityData(this.GONGHUIZHAN,param1,true);
         }
      }
      
      private function encounterTime(param1:String) : Array
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Number = _loc2_.hours * 60 * 60 + _loc2_.minutes * 60;
         var _loc4_:Array = [];
         _loc4_.push(_loc3_);
         var _loc5_:Array = param1.split("-");
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = _loc6_.split(":");
            _loc8_ = Number(_loc7_[0]) * 60 * 60 + Number(_loc7_[1]) * 60;
            _loc4_.push(_loc8_);
         }
         return _loc4_;
      }
      
      private function updateActivityData(param1:String, param2:Vector.<DayActivieListItem>, param3:Boolean) : void
      {
         var _loc4_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1 == param2[_loc5_].data.ActiveTime)
            {
               param2[_loc5_].initTxt(param3);
               return;
            }
            _loc5_++;
         }
      }
      
      protected function onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DAY_ACTIVITY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function createActivityFrame(param1:UIModuleEvent) : void
      {
         if(param1.module != UIModuleTypes.DAY_ACTIVITY)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._activityFrame = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame");
         this._activityFrame.width = 770;
         this._activityFrame.height = 550;
         LayerManager.Instance.addToLayer(this._activityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      public function dispose() : void
      {
         this._activityFrame.dispose();
         ObjectUtils.disposeObject(this._activityFrame);
         this._activityFrame = null;
      }
      
      private function initSession() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.sessionArr.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.acitiveDataList.length)
            {
               if(Boolean(this.sessionArr[_loc1_]))
               {
                  if(this.sessionArr[_loc1_][0] == this.acitiveDataList[_loc2_].ActivityTypeID)
                  {
                     this.acitiveDataList[_loc2_].TotalCount = this.sessionArr[_loc1_][1];
                     break;
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
   }
}

