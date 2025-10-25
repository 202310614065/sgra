package campbattle
{
   import campbattle.data.CampModel;
   import campbattle.data.RoleData;
   import campbattle.event.MapEvent;
   import campbattle.view.rank.CampRankView;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.rank.RankData;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.data.socket.CampPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import game.model.SmallEnemy;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class CampBattleManager extends EventDispatcher
   {
      
      private static var _instance:CampBattleManager;
      
      public static const resClassUrl:String = "tank.campBattle.Map-1";
      
      public static const resClassUrl2:String = "tank.campBattle.Map-2";
      
      public static const PVE_MAPRESOURCEURL:String = PathManager.SITE_MAIN + "image/camp/map/campBattlePassage.swf";
      
      public static const PVP_MAPRESOURCEURL:String = PathManager.SITE_MAIN + "image/camp/map/campBattleMap.swf";
      
      private var _lastCreatTime:int;
      
      private var _model:CampModel;
      
      private var _endTime:Date;
      
      private var completeCount:int = 0;
      
      public function CampBattleManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this._model = new CampModel();
      }
      
      public static function get instance() : CampBattleManager
      {
         if(!_instance)
         {
            _instance = new CampBattleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CampPackageType.INIT_SECEN_EVENT,this.__onInitSecenHander);
         SocketManager.Instance.addEventListener(CampPackageType.ACTION_ISOPEN_EVENT,this.__onActionIsOpenHander);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CampPackageType.ADD_ROLE_LIST_EVENT,this.__onAddRoleList);
         SocketManager.Instance.addEventListener(CampPackageType.OUT_CAMPBATTLE_EVENT,this.__onOutBattleHander);
         SocketManager.Instance.addEventListener(CampPackageType.CAMP_SOCER_RANK_EVENT,this.__onCampScoreRankHander);
         SocketManager.Instance.addEventListener(CampPackageType.PER_SCORE_RANK_EVENT,this.__onPerScoreRankHander);
         SocketManager.Instance.addEventListener(CampPackageType.REMOVE_ROLE_EVENT,this.__onRemoveRoleChange);
         SocketManager.Instance.addEventListener(CampPackageType.WIN_COUNT_PTP_EVENT,this.__onWinCountHander);
         SocketManager.Instance.addEventListener(CampPackageType.PLAYER_STATE_CHANGE_EVENT,this.__onPlayerStateChange);
         SocketManager.Instance.addEventListener(CampPackageType.UPDATE_SCORE_EVENT,this.__onUpdateScoreHander);
      }
      
      protected function __onPlayerStateChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:RoleData = null;
         var _loc2_:PackageIn = param1.pkg;
         if(!this._model.isFighting)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = this.getRoleData(_loc3_,_loc4_);
            if(Boolean(_loc7_))
            {
               if(_loc6_ > 0)
               {
                  _loc5_ = 4;
                  _loc7_.stateType = 4;
                  _loc7_.isDead = true;
               }
               else
               {
                  _loc7_.stateType = _loc5_;
               }
            }
            dispatchEvent(new MapEvent(MapEvent.PLAYER_STATE_CHANGE,[_loc3_,_loc4_,_loc5_]));
         }
      }
      
      protected function __onInitSecenHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:RoleData = null;
         var _loc10_:int = 0;
         var _loc11_:SmallEnemy = null;
         var _loc12_:String = null;
         var _loc13_:Point = null;
         var _loc14_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._model.monsterCount = _loc2_.readInt();
         this._model.isCapture = _loc2_.readBoolean();
         if(this._model.isCapture)
         {
            this._model.captureZoneID = _loc2_.readInt();
            this._model.captureUserID = _loc2_.readInt();
         }
         else
         {
            this._model.captureName = LanguageMgr.GetTranslation("ddt.campBattle.NOcapture");
            this._model.captureZoneID = 0;
            this._model.captureUserID = 0;
         }
         var _loc4_:int = _loc2_.readInt();
         this._model.playerModel.clear();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc9_ = new RoleData();
            _loc9_.userID = _loc2_.readInt();
            _loc9_.zoneID = _loc2_.readInt();
            _loc9_.sex = _loc2_.readBoolean();
            _loc9_.name = _loc2_.readUTF();
            _loc9_.team = _loc2_.readInt();
            _loc9_.posX = _loc2_.readInt();
            _loc9_.posY = _loc2_.readInt();
            _loc9_.stateType = _loc2_.readInt();
            _loc9_.timerCount = _loc2_.readInt();
            _loc9_.baseURl = PathManager.SITE_MAIN + "image/camp/";
            _loc9_.isDefault = false;
            _loc9_.sceneID = 4;
            _loc9_.isVip = _loc2_.readBoolean();
            _loc9_.vipLev = _loc2_.readInt();
            if(this._model.captureZoneID == _loc9_.zoneID && this._model.captureUserID == _loc9_.userID)
            {
               _loc9_.isCapture = true;
               this._model.captureName = _loc9_.name;
               this._model.captureTeam = _loc9_.team;
               if(this._model.captureName.length > 50)
               {
                  this._model.captureName = this._model.captureName.replace(10,"......");
               }
            }
            if(_loc9_.timerCount > 0)
            {
               _loc9_.stateType = 4;
               this._model.liveTime = _loc9_.timerCount / 1000;
               _loc9_.isDead = true;
            }
            if(PlayerManager.Instance.Self.ZoneID == _loc9_.zoneID && PlayerManager.Instance.Self.ID == _loc9_.userID)
            {
               this._model.myTeam = _loc9_.team;
               this._model.myOutPos = new Point(_loc9_.posX,_loc9_.posY);
               if(_loc9_.timerCount > 0)
               {
                  this._model.isShowResurrectView = true;
               }
               _loc9_.type = 1;
            }
            else
            {
               _loc9_.type = 2;
            }
            this._model.playerModel.add(_loc9_.zoneID + "_" + _loc9_.userID,_loc9_);
            _loc5_++;
         }
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = 0;
         this._model.monsterList.clear();
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc10_ = _loc2_.readInt();
            _loc11_ = new SmallEnemy(_loc10_,2,1000);
            _loc11_.typeLiving = 2;
            _loc11_.actionMovieName = _loc2_.readUTF();
            _loc12_ = _loc2_.readUTF();
            _loc11_.direction = 1;
            _loc13_ = new Point(_loc2_.readInt(),_loc2_.readInt());
            _loc11_.name = LanguageMgr.GetTranslation("ddt.campleBattle.insectText");
            _loc11_.stateType = _loc2_.readInt();
            _loc14_ = _loc2_.readInt();
            if(_loc11_.stateType != 4)
            {
               this._model.monsterList.add(_loc11_.LivingID,_loc11_);
               if(this._model.monsterCount == 10)
               {
                  _loc11_.pos = new Point(this._model.monsterPosList[_loc7_][0],this._model.monsterPosList[_loc7_][1]);
               }
               else if(_loc14_ > 0)
               {
                  _loc11_.pos = _loc13_;
               }
               else
               {
                  _loc11_.pos = new Point(this._model.monsterPosList[_loc7_][0],this._model.monsterPosList[_loc7_][1]);
               }
               _loc7_++;
            }
            _loc8_++;
         }
         this._model.myScore = _loc2_.readInt();
         this._model.doorIsOpen = _loc2_.readBoolean();
         StateManager.setState(StateType.CAMP_BATTLE_SCENE,_loc3_,_loc3_);
         this.initEvent();
      }
      
      private function __onAddRoleList(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:RoleData = null;
         var _loc2_:PackageIn = param1.pkg;
         if(!this._model.isFighting)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new RoleData();
               _loc5_.userID = _loc2_.readInt();
               _loc5_.zoneID = _loc2_.readInt();
               _loc5_.sex = _loc2_.readBoolean();
               _loc5_.name = _loc2_.readUTF();
               _loc5_.team = _loc2_.readInt();
               _loc5_.posX = _loc2_.readInt();
               _loc5_.posY = _loc2_.readInt();
               _loc5_.stateType = _loc2_.readInt();
               _loc5_.timerCount = _loc2_.readInt();
               _loc5_.isVip = _loc2_.readBoolean();
               _loc5_.vipLev = _loc2_.readInt();
               if(_loc5_.timerCount > 0)
               {
                  _loc5_.stateType = 4;
               }
               if(_loc5_.userID == PlayerManager.Instance.Self.ID && PlayerManager.Instance.Self.ZoneID == _loc5_.zoneID)
               {
                  _loc5_.type = 1;
               }
               else
               {
                  _loc5_.type = 2;
               }
               _loc5_.baseURl = this.clothPath;
               _loc5_.isDefault = false;
               _loc5_.sceneID = 4;
               if(Boolean(this._model.playerModel))
               {
                  this._model.playerModel.add(_loc5_.zoneID + "_" + _loc5_.userID,_loc5_);
                  dispatchEvent(new MapEvent(MapEvent.ADD_ROLE,[_loc5_.zoneID + "_" + _loc5_.userID,_loc5_]));
               }
               _loc4_++;
            }
         }
      }
      
      private function __onActionIsOpenHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.isOpen = _loc2_.readBoolean();
         var _loc3_:Date = _loc2_.readDate();
         this._endTime = _loc2_.readDate();
         if(!this._model.isOpen)
         {
            this.deleCanpBtn();
            DdtActivityIconManager.Instance.currObj = null;
            this._model.captureName = LanguageMgr.GetTranslation("ddt.campBattle.NOcapture");
            this._model.captureTeam = 0;
            this._model.captureUserID = 0;
            this._model.captureZoneID = 0;
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.campBattle.close"));
            SocketManager.Instance.out.outCampBatttle();
         }
         else
         {
            this.addCampBtn();
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.campBattle.open"));
         }
      }
      
      public function addCampBtn(param1:Boolean = true, param2:String = null) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CAMP,param1,param2);
      }
      
      public function deleCanpBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CAMP,false);
      }
      
      public function onCampBtnHander(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
            return;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            GameInSocketOut.sendSingleRoomBegin(RoomManager.CAMP_BATTLE_ROOM);
         }
      }
      
      private function __onOutBattleHander(param1:CrazyTankSocketEvent) : void
      {
         StateManager.setState(StateType.MAIN);
         this.removeEvent();
      }
      
      private function __onPerScoreRankHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:RankData = null;
         var _loc2_:PackageIn = param1.pkg;
         this._model.perScoreRankList = [];
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new RankData();
            _loc5_.ZoneID = _loc2_.readInt();
            _loc5_.UserID = _loc2_.readInt();
            _loc5_.ZoneName = _loc2_.readUTF();
            _loc5_.Name = _loc2_.readUTF();
            _loc5_.Score = _loc2_.readInt();
            _loc5_.Rank = _loc4_ + 1;
            this._model.perScoreRankList.push(_loc5_);
            _loc4_++;
         }
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT) && StateManager.currentStateType != StateType.CAMP_BATTLE_SCENE)
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(this.loadFrameUIModule));
         }
         else
         {
            this.loadFrameUIModule();
         }
         dispatchEvent(new MapEvent(MapEvent.PER_SCORE_RANK,this._model.perScoreRankList));
      }
      
      private function __onRemoveRoleChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         if(!this._model.isFighting)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc3_ + "_" + _loc4_;
            if(Boolean(this._model.playerModel))
            {
               this._model.playerModel.remove(_loc5_);
               dispatchEvent(new MapEvent(MapEvent.REMOVE_ROLE,_loc5_));
            }
         }
      }
      
      private function __onWinCountHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._model.winCount = _loc3_;
         dispatchEvent(new MapEvent(MapEvent.WIN_COUNT_PVP));
      }
      
      public function rankFrame() : void
      {
         var _loc1_:CampRankView = ComponentFactory.Instance.creatComponentByStylename("campBattle.views.CampRankView");
         _loc1_.setList(this._model.perScoreRankList);
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onCampScoreRankHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         this._model.scoreList = [];
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Object();
            _loc5_.team = _loc2_.readInt();
            _loc5_.score = _loc2_.readInt();
            _loc5_.roles = _loc2_.readInt();
            this._model.scoreList.push(_loc5_);
            _loc4_++;
         }
         dispatchEvent(new MapEvent(MapEvent.CAMP_SOCER_RANK,this._model.scoreList));
      }
      
      private function __onUpdateScoreHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._model.myScore = _loc3_;
         dispatchEvent(new MapEvent(MapEvent.UPDATE_SCORE));
      }
      
      private function getRoleData(param1:int, param2:int) : RoleData
      {
         var _loc3_:String = param1 + "_" + param2;
         var _loc4_:RoleData = null;
         if(Boolean(this._model.playerModel))
         {
            _loc4_ = this._model.playerModel[_loc3_];
         }
         return _loc4_;
      }
      
      public function get toEndTime() : int
      {
         if(!this._endTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._endTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      private function getDateHourTime(param1:Date) : int
      {
         return int(param1.hours * 3600 + param1.minutes * 60 + param1.seconds);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CampPackageType.ADD_ROLE_LIST_EVENT,this.__onAddRoleList);
         SocketManager.Instance.removeEventListener(CampPackageType.OUT_CAMPBATTLE_EVENT,this.__onOutBattleHander);
         SocketManager.Instance.removeEventListener(CampPackageType.CAMP_SOCER_RANK_EVENT,this.__onCampScoreRankHander);
         SocketManager.Instance.removeEventListener(CampPackageType.PER_SCORE_RANK_EVENT,this.__onPerScoreRankHander);
         SocketManager.Instance.removeEventListener(CampPackageType.REMOVE_ROLE_EVENT,this.__onRemoveRoleChange);
         SocketManager.Instance.removeEventListener(CampPackageType.WIN_COUNT_PTP_EVENT,this.__onWinCountHander);
         SocketManager.Instance.removeEventListener(CampPackageType.PLAYER_STATE_CHANGE_EVENT,this.__onPlayerStateChange);
         SocketManager.Instance.removeEventListener(CampPackageType.UPDATE_SCORE_EVENT,this.__onUpdateScoreHander);
      }
      
      public function get model() : CampModel
      {
         return this._model;
      }
      
      public function get clothPath() : String
      {
         return PathManager.SITE_MAIN + "image/camp/";
      }
      
      public function loadFrameUIModule() : void
      {
         this.completeCount = 0;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CAMP_BATTLE_SCENE);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTCONSORTIA);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CAMP_BATTLE_SCENE || param1.module == UIModuleTypes.DDTCONSORTIA)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CAMP_BATTLE_SCENE || param1.module == UIModuleTypes.DDTCONSORTIA)
         {
            ++this.completeCount;
         }
         if(this.completeCount >= 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.rankFrame();
            this.completeCount = 0;
         }
      }
   }
}

