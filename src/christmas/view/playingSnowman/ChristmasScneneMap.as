package christmas.view.playingSnowman
{
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.MonsterInfo;
   import christmas.manager.ChristmasManager;
   import christmas.manager.ChristmasMonsterManager;
   import christmas.model.ChristmasRoomModel;
   import christmas.player.ChristmasMonster;
   import christmas.player.ChristmasRoomPlayer;
   import christmas.player.PlayerVO;
   import church.view.churchScene.MoonSceneMap;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class ChristmasScneneMap extends Sprite implements Disposeable
   {
      
      private static var selectSpeek:int = 1;
      
      public static var packsNum:int = 2;
      
      protected var articleLayer:Sprite;
      
      protected var meshLayer:Sprite;
      
      protected var bgLayer:Sprite;
      
      protected var skyLayer:Sprite;
      
      protected var snowLayer:Sprite;
      
      public var sceneScene:SceneScene;
      
      protected var _data:DictionaryData;
      
      protected var _characters:DictionaryData;
      
      public var selfPlayer:ChristmasRoomPlayer;
      
      private var last_click:Number;
      
      private var current_display_fire:int = 0;
      
      private var _currentLoadingPlayer:ChristmasRoomPlayer;
      
      private var _isShowName:Boolean = true;
      
      private var _isChatBall:Boolean = true;
      
      private var _clickInterval:Number = 200;
      
      private var _lastClick:Number = 0;
      
      private var _sceneMapVO:SceneMapVO;
      
      private var _model:ChristmasRoomModel;
      
      private var armyPos:Point;
      
      private var decorationLayer:Sprite;
      
      protected var _mapObjs:DictionaryData;
      
      protected var _monsters:DictionaryData;
      
      private var _snowMC:MovieClip;
      
      private var _snowCenterMc:MovieClip;
      
      private var _snowSpeakPng:Bitmap;
      
      private var _snowSpeak:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _mouseMovie:MovieClip;
      
      private var r:int = 250;
      
      private var auto:Point;
      
      private var autoMove:Boolean = false;
      
      private var _entering:Boolean = false;
      
      private var _speakTimer:Timer;
      
      private var _timeFive:Timer;
      
      private var endPoint:Point = new Point();
      
      protected var reference:ChristmasRoomPlayer;
      
      public function ChristmasScneneMap(param1:ChristmasRoomModel, param2:SceneScene, param3:DictionaryData, param4:DictionaryData, param5:Sprite, param6:Sprite, param7:Sprite = null, param8:Sprite = null, param9:Sprite = null, param10:Sprite = null)
      {
         super();
         this._model = param1;
         this.sceneScene = param2;
         this._data = param3;
         this._mapObjs = param4;
         if(param5 == null)
         {
            this.bgLayer = new Sprite();
         }
         else
         {
            this.bgLayer = param5;
         }
         this.meshLayer = param6 == null ? new Sprite() : param6;
         this.meshLayer.alpha = 0;
         this.articleLayer = param7 == null ? new Sprite() : param7;
         this.decorationLayer = param9 == null ? new Sprite() : param9;
         this.skyLayer = param8 == null ? new Sprite() : param8;
         this.snowLayer = param10 == null ? new Sprite() : param10;
         this.decorationLayer.mouseChildren = this.decorationLayer.mouseEnabled = false;
         this.addChild(this.bgLayer);
         this.addChild(this.snowLayer);
         this.addChild(this.articleLayer);
         this.addChild(this.decorationLayer);
         this.addChild(this.meshLayer);
         this.addChild(this.skyLayer);
         this.init();
         this.addEvent();
         this.initSnow();
      }
      
      private function initSnow() : void
      {
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this._snowCenterMc = this.snowLayer.getChildByName("snowCenter_MC") as MovieClip;
            this._snowCenterMc.visible = false;
            this._snowCenterMc.buttonMode = false;
            this._snowCenterMc.mouseEnabled = false;
            this._snowCenterMc.mouseChildren = false;
            this._snowCenterMc.gotoAndStop(1);
            this._snowMC = this.skyLayer.getChildByName("snow_mc") as MovieClip;
            this._snowMC.addEventListener(MouseEvent.CLICK,this._enterSnowNPC);
            this._snowMC.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
            this._snowMC.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
            this._snowMC.buttonMode = true;
         }
      }
      
      private function __onMouseOver(param1:MouseEvent) : void
      {
         this._snowCenterMc.visible = true;
         this._snowCenterMc.gotoAndPlay(1);
      }
      
      private function __onMouseOut(param1:MouseEvent) : void
      {
         this._snowCenterMc.visible = false;
         this._snowCenterMc.gotoAndStop(1);
      }
      
      private function _enterSnowNPC(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.getPacksToPlayer(0);
      }
      
      private function isPacksComplete(param1:int = 1) : void
      {
         SocketManager.Instance.out.getPacksToPlayer(1);
      }
      
      private function checkDistance() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = this.selfPlayer.x - this.armyPos.x;
         var _loc2_:Number = this.selfPlayer.y - this.armyPos.y;
         if(Math.pow(_loc1_,2) + Math.pow(_loc2_,2) > Math.pow(this.r,2))
         {
            _loc3_ = Math.atan2(_loc2_,_loc1_);
            this.auto = new Point(this.armyPos.x,this.armyPos.y);
            this.auto.x += (_loc1_ > 0 ? 1 : -1) * Math.abs(Math.cos(_loc3_) * this.r);
            this.auto.y += (_loc2_ > 0 ? 1 : -1) * Math.abs(Math.sin(_loc3_) * this.r);
            return false;
         }
         return true;
      }
      
      private function checkCanStartGame() : Boolean
      {
         var _loc1_:Boolean = true;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function set enterIng(param1:Boolean) : void
      {
         this._entering = param1;
      }
      
      public function get sceneMapVO() : SceneMapVO
      {
         return this._sceneMapVO;
      }
      
      public function set sceneMapVO(param1:SceneMapVO) : void
      {
         this._sceneMapVO = param1;
      }
      
      protected function init() : void
      {
         this._characters = new DictionaryData(true);
         this._monsters = new DictionaryData(true);
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.christmas.room.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this.bgLayer.addChild(this._mouseMovie);
         this._snowSpeakPng = ComponentFactory.Instance.creatBitmap("asset.christmas.room.snowSpeakImg");
         this._snowSpeakPng.visible = false;
         this._snowSpeak = ComponentFactory.Instance.creatComponentByStylename("christmas.room.snowSpeakTxt");
         this._snowSpeak.visible = false;
         addChild(this._snowSpeakPng);
         addChild(this._snowSpeak);
         this.last_click = 0;
         if(this.bgLayer != null && this.articleLayer != null)
         {
            this.armyPos = new Point(this.bgLayer.getChildByName("armyPos").x,this.bgLayer.getChildByName("armyPos").y);
         }
         this._speakTimer = new Timer(300000,0);
         this._speakTimer.addEventListener(TimerEvent.TIMER,this.__santaSpeakTimer);
         this._speakTimer.start();
      }
      
      private function __santaSpeakTimer(param1:TimerEvent) : void
      {
         this._timeFive = new Timer(1000,5);
         this._timeFive.addEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
         this._timeFive.addEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         this._timeFive.start();
      }
      
      private function __santaSpeakFiveSeconds(param1:TimerEvent) : void
      {
         if(selectSpeek % 2 == 0)
         {
            this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.santaSpeakFiveSecondsText");
         }
         else
         {
            this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.santaSpeakFiveSecondsText2");
         }
         this._snowSpeakPng.visible = true;
         this._snowSpeak.visible = true;
         ++selectSpeek;
      }
      
      public function stopAllTimer() : void
      {
         if(Boolean(this._timeFive))
         {
            this._timeFive.stop();
            this._timeFive.removeEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
            this._timeFive.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         }
         if(Boolean(this._speakTimer))
         {
            this._speakTimer.stop();
            this._speakTimer.removeEventListener(TimerEvent.TIMER,this.__santaSpeakTimer);
         }
      }
      
      private function __santaSpeakFiveSecondsComplete(param1:TimerEvent) : void
      {
         (param1.target as Timer).removeEventListener(TimerEvent.TIMER,this.__santaSpeakFiveSeconds);
         (param1.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.__santaSpeakFiveSecondsComplete);
         (param1.target as Timer).stop();
         this._snowSpeakPng.visible = false;
         this._snowSpeak.visible = false;
      }
      
      protected function addEvent() : void
      {
         this._model.addEventListener(ChristmasRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.addEventListener(ChristmasRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._mapObjs.addEventListener(DictionaryEvent.ADD,this.__addMonster);
         this._mapObjs.addEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
         this._mapObjs.addEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,this.__getPacks);
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,this.__snowSpeak);
      }
      
      private function __getPacks(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc5_ - _loc6_;
         if(_loc4_ >= 2)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.full"),null,null,this,false);
            return;
         }
         var _loc8_:Number = ChristmasManager.instance.model.serverTime();
         if(_loc8_ < 14)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.unfinished2",packsNum < 0 ? 0 : packsNum),null,null,this,false);
            return;
         }
         if(_loc6_ < _loc5_ && _loc3_ && (_loc8_ >= 14 && _loc8_ <= 23))
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.unfinished",packsNum < 0 ? 0 : packsNum),null,null,this,false);
            return;
         }
         if(!_loc3_)
         {
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.room.packs.isFull"),null,null,this,false);
            return;
         }
         if(_loc6_ >= _loc5_ && _loc3_ && _loc8_ >= 14)
         {
            --packsNum;
            ChristmasManager.instance.showTransactionFrame(LanguageMgr.GetTranslation("christmas.snowPacks.complete",_loc7_.toString()),this.isPacksComplete,null,this,false);
            return;
         }
      }
      
      private function __addMonster(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ChristmasMonster = new ChristmasMonster(_loc2_,_loc2_.MonsterPos);
         this._monsters.add(_loc2_.ID,_loc3_);
         this.articleLayer.addChild(_loc3_);
      }
      
      private function __removeMonster(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ChristmasMonster = this._monsters[_loc2_.ID] as ChristmasMonster;
         this._monsters.remove(_loc2_.ID);
         _loc3_.dispose();
      }
      
      private function __onMonsterUpdate(param1:DictionaryEvent) : void
      {
         var _loc2_:MonsterInfo = param1.data as MonsterInfo;
         var _loc3_:ChristmasMonster = this._monsters[_loc2_.ID] as ChristmasMonster;
      }
      
      private function __snowSpeak(param1:CrazyTankSocketEvent) : void
      {
         this._timer = new Timer(1000,10);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timeShowSnowSpeak);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeSnowSpeakComplete);
         this._timer.start();
      }
      
      private function __timeShowSnowSpeak(param1:TimerEvent) : void
      {
         this._snowSpeak.text = LanguageMgr.GetTranslation("christmas.room.snowSpeakText");
         this._snowSpeakPng.visible = true;
         this._snowSpeak.visible = true;
      }
      
      private function __timeSnowSpeakComplete(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timeShowSnowSpeak);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeSnowSpeakComplete);
         this._timer.stop();
         this._snowSpeakPng.visible = false;
         this._snowSpeak.visible = false;
      }
      
      private function menuChange(param1:ChristmasRoomEvent) : void
      {
         switch(param1.type)
         {
            case ChristmasRoomEvent.PLAYER_NAME_VISIBLE:
               this.nameVisible();
         }
      }
      
      public function nameVisible() : void
      {
         var _loc1_:ChristmasRoomPlayer = null;
         for each(_loc1_ in this._characters)
         {
            _loc1_.isShowName = this._model.playerNameVisible;
         }
      }
      
      protected function updateMap(param1:Event) : void
      {
         var _loc2_:ChristmasRoomPlayer = null;
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
            _loc2_.isShowName = this._model.playerNameVisible;
         }
         this.BuildEntityDepth();
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         if(!this.selfPlayer || this.selfPlayer.playerVO.playerStauts != 0 || !this.selfPlayer.getCanAction())
         {
            return;
         }
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.autoMove = false;
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this.sceneScene.hit(_loc2_))
            {
               this.selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this.selfPlayer.playerPoint,_loc2_);
               this.selfPlayer.playerVO.walkPath.shift();
               this.selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint,this.selfPlayer.playerVO.walkPath[0]);
               this.selfPlayer.playerVO.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
               this.sendMyPosition(this.selfPlayer.playerVO.walkPath.concat());
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      public function sendMyPosition(param1:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc2_.push(int(param1[_loc3_].x),int(param1[_loc3_].y));
            _loc3_++;
         }
         var _loc4_:String = _loc2_.toString();
         SocketManager.Instance.out.sendChristmasRoomMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         var _loc3_:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[param1]))
         {
            _loc3_ = this._characters[param1] as ChristmasRoomPlayer;
            if(!_loc3_.getCanAction())
            {
               _loc3_.playerVO.playerStauts = 0;
               _loc3_.setStatus();
            }
            _loc3_.playerVO.walkPath = param2;
            _loc3_.playerWalk(param2);
         }
      }
      
      public function updatePlayersStauts(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[param1]))
         {
            _loc4_ = this._characters[param1] as ChristmasRoomPlayer;
            if(param2 == 0)
            {
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.playerVO.playerPos = param3;
               _loc4_.setStatus();
            }
            else if(param2 == 1)
            {
               if(!_loc4_.getCanAction())
               {
                  _loc4_.playerVO.playerStauts = 0;
                  _loc4_.setStatus();
               }
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.isReadyFight = true;
               _loc4_.addEventListener(ChristmasRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
               _loc4_.playerVO.walkPath = [param3];
               _loc4_.playerWalk([param3]);
            }
            else
            {
               _loc4_.playerVO.playerStauts = param2;
               _loc4_.setStatus();
            }
         }
      }
      
      public function __otherPlayrStartFight(param1:ChristmasRoomEvent) : void
      {
         var _loc2_:ChristmasRoomPlayer = param1.currentTarget as ChristmasRoomPlayer;
         _loc2_.removeEventListener(ChristmasRoomEvent.READYFIGHT,this.__otherPlayrStartFight);
         _loc2_.sceneCharacterDirection = SceneCharacterDirection.getDirection(_loc2_.playerPoint,this.armyPos);
         _loc2_.dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         _loc2_.isReadyFight = false;
         _loc2_.setStatus();
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         if(this.selfPlayer.playerVO.playerStauts == 2)
         {
            this.selfPlayer.playerVO.playerPos = ChristmasManager.instance.christmasInfo.playerDefaultPos;
            this.ajustScreen(this.selfPlayer);
            this.setCenter();
            this._entering = false;
         }
         this.selfPlayer.playerVO.playerStauts = param1;
         this.selfPlayer.setStatus();
      }
      
      public function checkSelfStatus() : int
      {
         return this.selfPlayer.playerVO.playerStauts;
      }
      
      public function playerRevive(param1:int) : void
      {
         var _loc2_:ChristmasRoomPlayer = null;
         if(Boolean(this._characters[param1]))
         {
            _loc2_ = this._characters[param1] as ChristmasRoomPlayer;
            _loc2_.revive();
            this.selfPlayer.playerVO.playerStauts = 0;
            this._entering = false;
         }
      }
      
      public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.reference))
         {
            _loc2_ = -(this.reference.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(this.reference.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         else
         {
            _loc2_ = -(ChristmasManager.instance.christmasInfo.playerDefaultPos.x - MoonSceneMap.GAME_WIDTH / 2);
            _loc3_ = -(ChristmasManager.instance.christmasInfo.playerDefaultPos.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW)
         {
            _loc2_ = MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH)
         {
            _loc3_ = MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:PlayerVO = null;
         if(!this.selfPlayer)
         {
            _loc1_ = ChristmasManager.instance.christmasInfo.myPlayerVO;
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new ChristmasRoomPlayer(_loc1_,this.addPlayerCallBack);
         }
      }
      
      protected function ajustScreen(param1:ChristmasRoomPlayer) : void
      {
         if(param1 == null)
         {
            if(Boolean(this.reference))
            {
               this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.reference = null;
            }
            return;
         }
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         this.reference = param1;
         this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerVO = param1.data as PlayerVO;
         this._currentLoadingPlayer = new ChristmasRoomPlayer(_loc2_,this.addPlayerCallBack);
      }
      
      private function addPlayerCallBack(param1:ChristmasRoomPlayer, param2:Boolean, param3:int) : void
      {
         if(param3 == 0)
         {
            if(!this.articleLayer || !param1)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            param1.sceneScene = this.sceneScene;
            param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
            if(!this.selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               param1.playerVO.playerPos = param1.playerVO.playerPos;
               this.selfPlayer = param1;
               this.articleLayer.addChild(this.selfPlayer);
               this.ajustScreen(this.selfPlayer);
               this.setCenter();
               this.selfPlayer.setStatus();
               this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this.articleLayer.addChild(param1);
            }
            param1.playerPoint = param1.playerVO.playerPos;
            param1.sceneCharacterStateType = "natural";
            this._characters.add(param1.playerVO.playerInfo.ID,param1);
            param1.isShowName = this._model.playerNameVisible;
         }
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc3_:ChristmasMonster = null;
         var _loc4_:Point = null;
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
            _loc3_ = ChristmasMonsterManager.Instance.curMonster;
            if(Boolean(_loc3_) && _loc3_.MonsterState <= MonsterInfo.LIVIN)
            {
               _loc4_ = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x,this.selfPlayer.playerPoint.y + 50));
               if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y) || _loc3_.hitTestObject(this.selfPlayer))
               {
                  _loc3_.StartFight();
               }
            }
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as PlayerVO).playerInfo.ID;
         var _loc3_:ChristmasRoomPlayer = this._characters[_loc2_] as ChristmasRoomPlayer;
         this._characters.remove(_loc2_);
         if(Boolean(_loc3_))
         {
            if(Boolean(_loc3_.parent))
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            _loc3_.dispose();
         }
         _loc3_ = null;
      }
      
      protected function BuildEntityDepth() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc1_:int = this.articleLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_ = this.articleLayer.getChildAt(_loc2_);
            _loc4_ = this.getPointDepth(_loc3_.x,_loc3_.y);
            _loc6_ = Number.MAX_VALUE;
            _loc7_ = _loc2_ + 1;
            while(_loc7_ < _loc1_)
            {
               _loc8_ = this.articleLayer.getChildAt(_loc7_);
               _loc9_ = this.getPointDepth(_loc8_.x,_loc8_.y);
               if(_loc9_ < _loc6_)
               {
                  _loc5_ = _loc7_;
                  _loc6_ = _loc9_;
               }
               _loc7_++;
            }
            if(_loc4_ > _loc6_)
            {
               this.articleLayer.swapChildrenAt(_loc2_,_loc5_);
            }
            _loc2_++;
         }
      }
      
      protected function getPointDepth(param1:Number, param2:Number) : Number
      {
         return this.sceneMapVO.mapW * param2 + param1;
      }
      
      protected function removeEvent() : void
      {
         this._model.removeEventListener(ChristmasRoomEvent.PLAYER_NAME_VISIBLE,this.menuChange);
         this._model.removeEventListener(ChristmasRoomEvent.PLAYER_CHATBALL_VISIBLE,this.menuChange);
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._mapObjs.removeEventListener(DictionaryEvent.ADD,this.__addMonster);
         this._mapObjs.removeEventListener(DictionaryEvent.REMOVE,this.__removeMonster);
         this._mapObjs.removeEventListener(DictionaryEvent.UPDATE,this.__onMonsterUpdate);
         if(Boolean(this.reference))
         {
            this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
         }
         if(Boolean(this.selfPlayer))
         {
            this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         this._snowMC.removeEventListener(MouseEvent.CLICK,this._enterSnowNPC);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,this.__getPacks);
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,this.__snowSpeak);
      }
      
      public function dispose() : void
      {
         var p:ChristmasRoomPlayer = null;
         var o:ChristmasMonster = null;
         var i:int = 0;
         var player:ChristmasRoomPlayer = null;
         this.removeEvent();
         if(Boolean(this._mapObjs))
         {
            this._mapObjs.clear();
            this._mapObjs = null;
         }
         if(Boolean(this._data))
         {
            this._data.clear();
            this._data = null;
         }
         this._sceneMapVO = null;
         for each(p in this._characters)
         {
            if(Boolean(p.parent))
            {
               p.parent.removeChild(p);
            }
            p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            p.dispose();
            p = null;
         }
         this._characters.clear();
         this._characters = null;
         if(Boolean(this.articleLayer))
         {
            i = this.articleLayer.numChildren;
            while(i > 0)
            {
               player = this.articleLayer.getChildAt(i - 1) as ChristmasRoomPlayer;
               if(Boolean(player))
               {
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
                  player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
                  if(Boolean(player.parent))
                  {
                     player.parent.removeChild(player);
                  }
                  player.dispose();
               }
               player = null;
               try
               {
                  this.articleLayer.removeChildAt(i - 1);
               }
               catch(e:RangeError)
               {
               }
               i--;
            }
            if(Boolean(this.articleLayer) && Boolean(this.articleLayer.parent))
            {
               this.articleLayer.parent.removeChild(this.articleLayer);
            }
         }
         this.articleLayer = null;
         if(Boolean(this.selfPlayer))
         {
            if(Boolean(this.selfPlayer.parent))
            {
               this.selfPlayer.parent.removeChild(this.selfPlayer);
            }
            this.selfPlayer.dispose();
         }
         this.selfPlayer = null;
         if(Boolean(this._currentLoadingPlayer))
         {
            if(Boolean(this._currentLoadingPlayer.parent))
            {
               this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
            }
            this._currentLoadingPlayer.dispose();
         }
         this._currentLoadingPlayer = null;
         for each(o in this._monsters)
         {
            o.dispose();
            o = null;
         }
         this._monsters.clear();
         if(Boolean(this._mouseMovie) && Boolean(this._mouseMovie.parent))
         {
            this._mouseMovie.parent.removeChild(this._mouseMovie);
         }
         this._mouseMovie = null;
         if(Boolean(this.meshLayer) && Boolean(this.meshLayer.parent))
         {
            this.meshLayer.parent.removeChild(this.meshLayer);
         }
         this.meshLayer = null;
         if(Boolean(this.bgLayer) && Boolean(this.bgLayer.parent))
         {
            this.bgLayer.parent.removeChild(this.bgLayer);
         }
         this.bgLayer = null;
         if(Boolean(this.skyLayer) && Boolean(this.skyLayer.parent))
         {
            this.skyLayer.parent.removeChild(this.skyLayer);
         }
         this.skyLayer = null;
         this.sceneScene = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

