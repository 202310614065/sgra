package battleGroud
{
   import battleGroud.data.BatlleData;
   import battleGroud.data.BattlPrestigeData;
   import battleGroud.data.BattleUpdateData;
   import battleGroud.data.PlayerBattleData;
   import battleGroud.view.BattleGroudView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import room.RoomManager;
   
   public class BattleGroudManager
   {
      
      private static var _instance:BattleGroudManager;
      
      public var initBattleIcon:Function;
      
      public var dispBattleIcon:Function;
      
      public var isShow:Boolean;
      
      private var _battlGroudView:BattleGroudView;
      
      private var _moduleComplete:Boolean;
      
      private var _battleDataList:Array;
      
      public var orderdata:BattleUpdateData;
      
      private var _isBattleUILoaded:Boolean;
      
      private var _battlePresDataList:Vector.<BattlPrestigeData>;
      
      public var playerBattleData:PlayerBattleData;
      
      public function BattleGroudManager()
      {
         super();
         this.orderdata = new BattleUpdateData();
      }
      
      public static function get Instance() : BattleGroudManager
      {
         if(!_instance)
         {
            _instance = new BattleGroudManager();
         }
         return _instance;
      }
      
      public function open(param1:CrazyTankSocketEvent) : void
      {
         this.isShow = true;
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            if(this.initBattleIcon != null)
            {
               this.initBattleIcon();
            }
         }
      }
      
      public function over(param1:CrazyTankSocketEvent) : void
      {
         this.isShow = false;
         if(this.dispBattleIcon != null)
         {
            this.dispBattleIcon();
         }
         DdtActivityIconManager.Instance.currObj = null;
      }
      
      private function realTimeUpdataValue(param1:CrazyTankSocketEvent) : void
      {
         this.orderdata.addDayPrestge = param1.pkg.readInt();
         this.orderdata.totalPrestige = param1.pkg.readInt();
      }
      
      private function updataValue(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = param1.pkg.readByte();
         if(_loc3_ == 1)
         {
            this.orderdata.addDayPrestge = param1.pkg.readInt();
            this.orderdata.totalPrestige = param1.pkg.readInt();
            this.orderdata.fairBattleDayPrestige = param1.pkg.readInt();
         }
         else if(_loc3_ == 2)
         {
            this.orderdata.rankings = param1.pkg.readInt();
            if(Boolean(this._battlGroudView))
            {
               this._battlGroudView.setRanks(String(this.orderdata.rankings));
            }
         }
      }
      
      public function getBattleDataByPrestige(param1:int) : BatlleData
      {
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            return new BatlleData();
         }
         var _loc2_:int = int(this._battleDataList.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 >= this._battleDataList[_loc3_].Prestige)
            {
               return this._battleDataList[_loc3_] as BatlleData;
            }
            _loc3_--;
         }
         return new BatlleData();
      }
      
      public function getBattleDataByLevel(param1:int) : BatlleData
      {
         var _loc2_:int = int(this._battleDataList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this._battleDataList[_loc3_].Level)
            {
               return this._battleDataList[_loc3_] as BatlleData;
            }
            _loc3_++;
         }
         return new BatlleData();
      }
      
      public function setup() : void
      {
         this.orderData();
         this.celeTotalPrestigeData();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_OPEN,this.open);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_OVER,this.over);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLEDATA_UPDATA,this.updataValue);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLEDATA_UPDATA_REALTIME,this.realTimeUpdataValue);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DATA_UPDATA,this.playerDataUpDate);
      }
      
      protected function playerDataUpDate(param1:CrazyTankSocketEvent) : void
      {
         this.playerBattleData = new PlayerBattleData();
         this.playerBattleData.Attack = param1.pkg.readInt();
         this.playerBattleData.Defend = param1.pkg.readInt();
         this.playerBattleData.Agility = param1.pkg.readInt();
         this.playerBattleData.Lucky = param1.pkg.readInt();
         this.playerBattleData.Damage = param1.pkg.readInt();
         this.playerBattleData.Guard = param1.pkg.readInt();
         this.playerBattleData.Blood = param1.pkg.readInt();
         this.playerBattleData.Energy = param1.pkg.readInt();
         this.playerBattleData.ID = PlayerManager.Instance.Self.ID;
      }
      
      private function orderData() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("FairBattleRewardTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new BattleGroundAnalyer(this.completeHander);
      }
      
      private function celeTotalPrestigeData() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("CelebByTotalPrestige.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new CeleTotalPrestigeAnalyer(this.completeHander2);
      }
      
      public function completeHander(param1:BattleGroundAnalyer) : void
      {
         this._battleDataList = param1.battleDataList;
      }
      
      public function completeHander2(param1:CeleTotalPrestigeAnalyer) : void
      {
         this._battlePresDataList = param1.battleDataList;
      }
      
      public function getCurrBattlePresData(param1:int) : BattlPrestigeData
      {
         var _loc2_:int = int(this._battlePresDataList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this._battlePresDataList[_loc3_].ID)
            {
               return this._battlePresDataList[_loc3_];
            }
            _loc3_++;
         }
         return new BattlPrestigeData();
      }
      
      public function initBattleView() : void
      {
         if(Boolean(this._battlGroudView) && Boolean(this._battlGroudView.parent))
         {
            this.hide();
         }
         else if(this._moduleComplete)
         {
            this.show();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BATTLEGROUD);
         }
      }
      
      public function addBattleSingleRoom() : void
      {
         if(this._isBattleUILoaded)
         {
            GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOM);
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BATTLEGROUD)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function show() : void
      {
         if(Boolean(this._battlGroudView))
         {
            ObjectUtils.disposeObject(this._battlGroudView);
            this._battlGroudView = null;
         }
         this._battlGroudView = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView");
         LayerManager.Instance.addToLayer(this._battlGroudView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         if(Boolean(this._battlGroudView))
         {
            this._battlGroudView.dispose();
         }
         this._battlGroudView = null;
      }
      
      private function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BATTLEGROUD)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._moduleComplete = true;
            UIModuleSmallLoading.Instance.hide();
            this.show();
         }
         else if(param1.module == UIModuleTypes.DDTROOM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._isBattleUILoaded = true;
            UIModuleSmallLoading.Instance.hide();
            GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         this._moduleComplete = false;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
   }
}

