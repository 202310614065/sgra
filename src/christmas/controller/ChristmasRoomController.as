package christmas.controller
{
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.MonsterInfo;
   import christmas.manager.ChristmasManager;
   import christmas.model.ChristmasRoomModel;
   import christmas.player.PlayerVO;
   import christmas.view.playingSnowman.ChristmasRoomView;
   import christmas.view.playingSnowman.WaitingChristmasView;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.geom.Point;
   import hall.GameLoadingManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ChristmasRoomController extends BaseStateView
   {
      
      private static var _instance:ChristmasRoomController;
      
      public static var isTimeOver:Boolean;
      
      private static var _isFirstCome:Boolean = true;
      
      private var _sceneModel:ChristmasRoomModel;
      
      private var _view:ChristmasRoomView;
      
      private var _waitingView:WaitingChristmasView;
      
      protected var _monsters:DictionaryData;
      
      private var _monsterCount:int = 0;
      
      private var _callback:Function;
      
      private var _callbackArg:int;
      
      public function ChristmasRoomController()
      {
         super();
      }
      
      public static function get Instance() : ChristmasRoomController
      {
         if(!_instance)
         {
            _instance = new ChristmasRoomController();
         }
         return _instance;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.CHRISTMAS_IN_ROOM);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         GameLoadingManager.Instance.hide();
         super.enter(param1,param2);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.hide();
         this.addEvent();
         if(ChristmasManager.isToRoom)
         {
            this.setSelfStatus(0);
            SocketManager.Instance.out.enterChristmasRoom(ChristmasManager.instance.christmasInfo.myPlayerVO.playerPos);
         }
         else
         {
            SocketManager.Instance.out.enterChristmasRoom(ChristmasManager.instance.christmasInfo.playerDefaultPos);
         }
         if(_isFirstCome)
         {
            this.init();
            _isFirstCome = false;
         }
         else if(Boolean(this._view))
         {
            this._view.setViewAgain();
         }
         if(this._callback != null)
         {
            this._callback(this._callbackArg);
         }
      }
      
      private function init() : void
      {
         this._sceneModel = new ChristmasRoomModel();
         this._view = new ChristmasRoomView(this,this._sceneModel);
         this._view.show();
         this._waitingView = new WaitingChristmasView();
         addChild(this._waitingView);
         this._waitingView.visible = false;
         this._waitingView.addEventListener(ChristmasRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
      }
      
      protected function __onTimeOut(param1:Event) : void
      {
         this._waitingView.stop();
         this._waitingView.visible = false;
         ChristmasManager.instance.exitGame();
      }
      
      private function addEvent() : void
      {
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.ADDPLAYER_ROOM,this.__addPlayer);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_MOVE,this.__movePlayer);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.PLAYER_STATUE,this.__updatePlayerStauts);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_EXIT,this.__removePlayer);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_MONSTER,this.__monstersEvent);
      }
      
      public function __updatePlayerStauts(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         this._view.updatePlayerStauts(_loc3_,_loc4_,_loc5_);
         this._sceneModel.updatePlayerStauts(_loc3_,_loc4_,_loc5_);
      }
      
      private function __monstersEvent(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:MonsterInfo = null;
         var _loc8_:int = 0;
         var _loc9_:MonsterInfo = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc2_:QueueLoader = new QueueLoader();
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readByte();
         var _loc5_:String = "";
         if(_loc4_ == 0)
         {
            this._monsterCount = _loc3_.readInt();
            _loc6_ = 0;
            while(_loc6_ < this._monsterCount)
            {
               _loc7_ = new MonsterInfo();
               _loc7_.ID = _loc3_.readInt();
               _loc7_.type = _loc3_.readInt();
               switch(_loc7_.type)
               {
                  case 0:
                     _loc7_.ActionMovieName = "game.living.Living0012";
                     _loc7_.MissionID = 3101;
                     _loc5_ = "living0012";
                     break;
                  case 1:
                     _loc7_.ActionMovieName = "game.living.Living0014";
                     _loc7_.MissionID = 3102;
                     _loc5_ = "living0014";
                     break;
                  case 2:
                     _loc7_.ActionMovieName = "game.living.Living0013";
                     _loc7_.MissionID = 3103;
                     _loc5_ = "living0013";
               }
               _loc7_.MonsterName = "";
               _loc7_.State = _loc3_.readInt();
               _loc7_.MonsterPos = new Point(_loc3_.readInt(),_loc3_.readInt());
               if(_loc7_.State != MonsterInfo.DEAD && !this._sceneModel._mapObjects.hasKey(_loc7_.ID))
               {
                  _loc2_.addLoader(LoaderManager.Instance.creatLoader(PathManager.solveChristmasMonsterPath(_loc5_),BaseLoader.MODULE_LOADER));
                  this._sceneModel._mapObjects.add(_loc7_.ID,_loc7_);
               }
               _loc6_++;
            }
            _loc2_.addEventListener(Event.COMPLETE,this.__onLoadComplete);
            _loc2_.start();
         }
         else if(_loc4_ == 1)
         {
            _loc8_ = _loc3_.readInt();
            for each(_loc9_ in this._sceneModel._mapObjects)
            {
               if(_loc9_.ID == _loc8_)
               {
                  this._sceneModel._mapObjects.remove(_loc9_.ID);
               }
            }
         }
         else if(_loc4_ == 2)
         {
            _loc10_ = _loc3_.readInt();
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc12_ = _loc3_.readInt();
               _loc13_ = _loc3_.readInt();
               _loc14_ = _loc3_.readInt();
               _loc15_ = _loc3_.readInt();
               if(this._sceneModel._mapObjects && this._sceneModel._mapObjects.hasKey(_loc12_) && this._sceneModel._mapObjects[_loc12_].State != 1)
               {
                  this._sceneModel._mapObjects[_loc12_].State = _loc15_;
                  this._sceneModel._mapObjects[_loc12_].MonsterNewPos = new Point(_loc13_,_loc14_);
               }
               _loc11_++;
            }
         }
         else if(_loc4_ == 3)
         {
            _loc16_ = _loc3_.readInt();
            _loc17_ = _loc3_.readInt();
            if(Boolean(this._sceneModel._mapObjects) && this._sceneModel._mapObjects.hasKey(_loc16_))
            {
               this._sceneModel._mapObjects[_loc16_].State = _loc17_;
            }
         }
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         if(_loc2_.completeCount == this._monsterCount)
         {
            _loc2_.removeEvent();
         }
      }
      
      public function setSelfStatus(param1:int) : void
      {
         if(Boolean(this._view))
         {
            this._view.updateSelfStatus(param1);
         }
         else
         {
            this._callback = this.setSelfStatus;
            this._callbackArg = param1;
         }
      }
      
      private function removeEvent() : void
      {
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.ADDPLAYER_ROOM,this.__addPlayer);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_MOVE,this.__movePlayer);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_EXIT,this.__removePlayer);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_MONSTER,this.__monstersEvent);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.PLAYER_STATUE,this.__updatePlayerStauts);
         if(Boolean(this._waitingView))
         {
            this._waitingView.removeEventListener(ChristmasRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
         }
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function __addPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:PlayerVO = null;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new PlayerInfo();
            _loc5_.beginChanges();
            _loc5_.Grade = _loc2_.readInt();
            _loc5_.Hide = _loc2_.readInt();
            _loc5_.Repute = _loc2_.readInt();
            _loc5_.ID = _loc2_.readInt();
            _loc5_.NickName = _loc2_.readUTF();
            _loc5_.typeVIP = _loc2_.readByte();
            _loc5_.VIPLevel = _loc2_.readInt();
            _loc5_.Sex = _loc2_.readBoolean();
            _loc5_.Style = _loc2_.readUTF();
            _loc5_.Colors = _loc2_.readUTF();
            _loc5_.Skin = _loc2_.readUTF();
            _loc5_.FightPower = _loc2_.readInt();
            _loc5_.WinCount = _loc2_.readInt();
            _loc5_.TotalCount = _loc2_.readInt();
            _loc5_.Offer = _loc2_.readInt();
            _loc5_.commitChanges();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readInt();
            _loc8_ = new PlayerVO();
            _loc8_.playerInfo = _loc5_;
            _loc8_.playerPos = new Point(_loc6_,_loc7_);
            _loc8_.playerStauts = _loc2_.readByte();
            if(_loc5_.ID != PlayerManager.Instance.Self.ID)
            {
               this._sceneModel.addPlayer(_loc8_);
            }
            _loc4_++;
         }
      }
      
      public function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            if(StateManager.currentStateType == StateType.CHRISTMAS_ROOM)
            {
               this._view.removeTimer();
               StateManager.setState(StateType.MAIN);
            }
            else
            {
               isTimeOver = true;
               this._view.removeTimer();
            }
         }
         this._sceneModel.removePlayer(_loc2_);
      }
      
      public function __movePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:Point = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = new Point(_loc6_[_loc8_],_loc6_[_loc8_ + 1]);
            _loc7_.push(_loc9_);
            _loc8_ += 2;
         }
         if(this._view == null)
         {
            if(this._sceneModel == null)
            {
               this._sceneModel = new ChristmasRoomModel();
            }
            this._view = new ChristmasRoomView(this,this._sceneModel);
            this._view.show();
         }
         this._view.movePlayer(_loc2_,_loc7_);
      }
      
      override public function getType() : String
      {
         return StateType.CHRISTMAS_ROOM;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.CHRISTMAS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.CHRISTMAS_IN_ROOM);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.leaving(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._sceneModel))
         {
            this._sceneModel.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         this._view = null;
         this._sceneModel = null;
         CacheSysManager.unlock(CacheConsts.CHRISTMAS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.CHRISTMAS_IN_ROOM);
         _isFirstCome = true;
         ChristmasManager.isToRoom = false;
      }
   }
}

