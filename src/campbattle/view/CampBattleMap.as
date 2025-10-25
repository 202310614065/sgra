package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.data.RoleData;
   import campbattle.view.roleView.CampBaseRole;
   import campbattle.view.roleView.CampBattleMonsterRole;
   import campbattle.view.roleView.CampBattleOtherRole;
   import campbattle.view.roleView.CampBattlePlayer;
   import campbattle.view.roleView.CampGameSmallEnemy;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.scenePathSearcher.PathMapHitTester;
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
   import game.model.SmallEnemy;
   import game.objects.GameLiving;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CampBattleMap extends Sprite
   {
      
      public static const GAME_WIDTH:int = 1000;
      
      public static const GAME_HEIGHT:int = 600;
      
      public static var MAP_SIZE:Array = [3208,2000];
      
      protected var _mapClassDefinition:String;
      
      protected var _playerModel:DictionaryData;
      
      protected var _monsterModel:DictionaryData;
      
      protected var _bgLayer:Sprite;
      
      protected var _articleLayer:Sprite;
      
      protected var _decorationLayer:Sprite;
      
      protected var _meshLayer:Sprite;
      
      protected var _sceneScene:SceneScene;
      
      private var _roleList:Array;
      
      private var _monsterList:Array;
      
      private var _isLoadMapComplete:Boolean;
      
      private var _targetRole:CampBaseRole;
      
      private var _mainRole:CampBaseRole;
      
      private var _actItemList:Array;
      
      private var _gameLiving:GameLiving;
      
      private var _sendMove:Function;
      
      private var _mouseMovie:MovieClip;
      
      private var _antoObjList:Array;
      
      private var _lastClick:Number = 0;
      
      private var _clickInterval:Number = 200;
      
      private var _addMonsterTimer:Timer;
      
      private var _mIndex:int;
      
      private var _mapResUrl:String;
      
      private var _smallMap:Bitmap;
      
      public function CampBattleMap(param1:String, param2:String, param3:DictionaryData = null, param4:DictionaryData = null, param5:Array = null, param6:Bitmap = null)
      {
         super();
         this._actItemList = param5;
         this._mapClassDefinition = param1;
         this._playerModel = new DictionaryData();
         this._playerModel.setData(param3);
         this._monsterModel = param4;
         this._roleList = [];
         this._monsterList = [];
         this._antoObjList = [];
         this._mapResUrl = param2;
         this._smallMap = param6;
         if(Boolean(this._smallMap))
         {
            addChild(this._smallMap);
         }
         this.loaderMap(param2);
      }
      
      private function loaderMap(param1:String) : void
      {
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(param1,BaseLoader.MODULE_LOADER);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.onMapLoadError);
         LoadResourceManager.Instance.startLoad(_loc2_);
      }
      
      protected function onMapLoadError(param1:LoaderEvent) : void
      {
         ChatManager.Instance.sysChatRed("地图资源加载出错Url=" + this._mapResUrl);
      }
      
      private function onMapLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         this._isLoadMapComplete = true;
         this.initMap();
         this.initEvent();
         this.initSceneScene();
         this.initPlayerList();
         this.initMonstersList();
      }
      
      private function initPlayerList() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._playerModel.length)
         {
            this.addRoleToMap(this._playerModel.list[_loc1_]);
            _loc1_++;
         }
      }
      
      private function initMonstersList() : void
      {
         if(this._monsterModel.length > 0)
         {
            this._addMonsterTimer = new Timer(500);
            this._addMonsterTimer.repeatCount = this._monsterModel.length;
            this._addMonsterTimer.start();
            this._addMonsterTimer.addEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
            this._addMonsterTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
         }
      }
      
      private function __onMonsterTimerHander(param1:TimerEvent) : void
      {
         var _loc2_:SmallEnemy = this._monsterModel.list[this._mIndex] as SmallEnemy;
         var _loc3_:CampGameSmallEnemy = new CampGameSmallEnemy(_loc2_);
         PositionUtils.setPos(_loc3_,_loc2_.pos);
         this._monsterList.push(_loc3_);
         this._antoObjList.push(_loc3_);
         this._articleLayer.addChild(_loc3_);
         ++this._mIndex;
      }
      
      private function __onMonsterTimerCompleteHander(param1:TimerEvent) : void
      {
         this._addMonsterTimer.stop();
         this._addMonsterTimer.removeEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
         this._addMonsterTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
         this._addMonsterTimer = null;
         this._mIndex = 0;
      }
      
      private function checkRoleList() : void
      {
         var _loc3_:CampBaseRole = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._roleList.length != this._playerModel.length)
         {
            return;
         }
         var _loc1_:int = int(this._roleList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._roleList[_loc2_] as CampBaseRole;
            if(!(_loc3_.playerInfo.zoneID == PlayerManager.Instance.Self.ZoneID && _loc3_.playerInfo.userID == PlayerManager.Instance.Self.ID))
            {
               _loc4_ = Math.abs(this._mainRole.x - _loc3_.x);
               _loc5_ = Math.abs(this._mainRole.y - _loc3_.y);
               _loc3_.visible = _loc4_ > 500 || _loc5_ > 300 ? false : true;
            }
            _loc2_++;
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onPlayerClickHander);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         if(Boolean(this._monsterModel))
         {
            this._monsterModel.addEventListener(DictionaryEvent.ADD,this.__onAddMonsters);
            this._monsterModel.addEventListener(DictionaryEvent.REMOVE,this.__onRemoveMonsters);
         }
         this._playerModel.addEventListener(DictionaryEvent.ADD,this.__onAddPlayer);
         this._playerModel.addEventListener(DictionaryEvent.REMOVE,this.__onRemovePlayer);
         this._playerModel.addEventListener(DictionaryEvent.UPDATE,this.__onUpdatePlayerStatus);
      }
      
      protected function __onAddMonsters(param1:DictionaryEvent) : void
      {
         var _loc2_:CampGameSmallEnemy = new CampGameSmallEnemy(param1.data as SmallEnemy);
         _loc2_.setStateType((param1.data as SmallEnemy).stateType);
         this._monsterList.push(_loc2_);
         this._articleLayer.addChild(_loc2_);
         this._antoObjList.push(_loc2_);
      }
      
      private function __onRemoveMonsters(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as SmallEnemy).LivingID;
         var _loc3_:int = this.getMonsterIndex(_loc2_);
         if(!this._monsterList[_loc3_])
         {
            return;
         }
         var _loc4_:CampGameSmallEnemy = this._monsterList[_loc3_] as CampGameSmallEnemy;
         this._monsterList.splice(_loc3_,1);
         this.deleAntoObjList(_loc4_);
         _loc4_.dispose();
         _loc4_.dispose();
         _loc4_ = null;
      }
      
      public function getMonsterIndex(param1:int) : int
      {
         var _loc2_:int = int(this._monsterList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == CampGameSmallEnemy(this._monsterList[_loc3_]).info.LivingID)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      private function __onPlayerClickHander(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(!this._mainRole || this._mainRole.playerInfo.stateType == 4)
         {
            return;
         }
         this._targetRole = null;
         _loc2_ = new Point(mouseX,mouseY);
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this._sceneScene.hit(_loc2_))
            {
               SocketManager.Instance.out.CampbattleRoleMove(this._mainRole.playerInfo.zoneID,this._mainRole.playerInfo.userID,_loc2_);
               this._mainRole.walk(_loc2_);
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      protected function initMouseMovie() : void
      {
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.campBattle.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._bgLayer.addChild(this._mouseMovie);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._mainRole))
         {
            this._mainRole.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         removeEventListener(MouseEvent.CLICK,this.__onPlayerClickHander);
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         if(Boolean(this._monsterModel))
         {
            this._monsterModel.removeEventListener(DictionaryEvent.ADD,this.__onAddMonsters);
            this._monsterModel.removeEventListener(DictionaryEvent.REMOVE,this.__onRemoveMonsters);
         }
         this._playerModel.removeEventListener(DictionaryEvent.ADD,this.__onAddPlayer);
         this._playerModel.removeEventListener(DictionaryEvent.REMOVE,this.__onRemovePlayer);
         this._playerModel.removeEventListener(DictionaryEvent.UPDATE,this.__onUpdatePlayerStatus);
      }
      
      public function setCenter(param1:SceneCharacterEvent = null, param2:Boolean = true, param3:Point = null) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         if(Boolean(this._mainRole))
         {
            _loc6_ = this._mainRole.playerPoint;
         }
         else
         {
            _loc6_ = param3;
         }
         _loc4_ = -(_loc6_.x - GAME_WIDTH / 2);
         _loc5_ = -(_loc6_.y - GAME_HEIGHT / 2) + 50;
         if(_loc4_ > 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ < GAME_WIDTH - MAP_SIZE[0])
         {
            _loc4_ = GAME_WIDTH - MAP_SIZE[0];
         }
         if(_loc5_ > 0)
         {
            _loc5_ = 0;
         }
         if(_loc5_ < GAME_HEIGHT - MAP_SIZE[1])
         {
            _loc5_ = GAME_HEIGHT - MAP_SIZE[1];
         }
         x = _loc4_;
         y = _loc5_;
      }
      
      private function enterFrameHander(param1:Event) : void
      {
         this.roleDeepthSort();
         if(Boolean(this._mainRole))
         {
            this.setCenter(null,false,this._mainRole.playerPoint);
            this.checkRoleList();
         }
      }
      
      public function checkPonitDistance(param1:Point, param2:Function, param3:int = 0, param4:int = 0) : void
      {
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         if(Boolean(this._mainRole))
         {
            _loc5_ = new Point(this._mainRole.x,this._mainRole.y);
            _loc6_ = Math.abs(Point.distance(_loc5_,param1));
            if(_loc6_ > 100)
            {
               _loc7_ = this.getDesPoint(_loc5_,param1,_loc6_);
               this._mouseMovie.x = _loc7_.x;
               this._mouseMovie.y = _loc7_.y;
               this._mouseMovie.play();
               SocketManager.Instance.out.CampbattleRoleMove(this._mainRole.playerInfo.zoneID,this._mainRole.playerInfo.userID,_loc7_);
               this._mainRole.walk(_loc7_,param2,param3,param4);
            }
            else if(param3 != 0 && param4 != 0)
            {
               param2(param4,param3);
            }
            else if(param3 != 0)
            {
               param2(param3);
            }
            else
            {
               param2();
            }
         }
      }
      
      private function getDesPoint(param1:Point, param2:Point, param3:int) : Point
      {
         var _loc4_:int = param1.x - param2.x < 0 ? -1 : 1;
         var _loc5_:int = param1.y - param2.y < 0 ? -1 : 1;
         return new Point(Math.abs(100 * (param1.x - param2.x) / param3) * _loc4_ + param2.x,Math.abs(100 * (param1.y - param2.y) / param3) * _loc5_ + param2.y);
      }
      
      private function roleDeepthSort() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._antoObjList.length > 1)
         {
            _loc1_ = int(this._antoObjList.length);
            this._antoObjList.sortOn("y",Array.NUMERIC);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._articleLayer.addChild(this._antoObjList[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      protected function __onAddPlayer(param1:DictionaryEvent) : void
      {
         this.addRoleToMap(param1.data as RoleData);
      }
      
      private function addRoleToMap(param1:RoleData) : void
      {
         var _loc2_:CampBaseRole = null;
         if(!param1)
         {
            return;
         }
         if(param1.zoneID == PlayerManager.Instance.Self.ZoneID && param1.userID == PlayerManager.Instance.Self.ID)
         {
            _loc2_ = this.creatRole(param1,this.roleCallback);
         }
         else
         {
            _loc2_ = this.creatRole(param1,this.otherRoleCallback);
         }
      }
      
      private function creatRole(param1:RoleData, param2:Function) : CampBaseRole
      {
         var _loc3_:CampBaseRole = null;
         switch(param1.type)
         {
            case 1:
               _loc3_ = new CampBattlePlayer(param1,param2);
               break;
            case 2:
               _loc3_ = new CampBattleOtherRole(param1,param2);
               break;
            case 3:
               _loc3_ = new CampBattleMonsterRole(param1,param2);
         }
         return _loc3_;
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            if(Boolean(this._mouseMovie))
            {
               this._mouseMovie.gotoAndStop(1);
            }
         }
      }
      
      public function setRoleState(param1:int, param2:int, param3:int) : void
      {
         var _loc6_:CampBattlePlayer = null;
         var _loc4_:int = int(this._roleList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this._roleList[_loc5_] as CampBattlePlayer;
            if(_loc6_.playerInfo.zoneID == param1 && _loc6_.playerInfo.userID == param2)
            {
               _loc6_.setStateType(param3);
               break;
            }
            _loc5_++;
         }
      }
      
      public function setMonsterState(param1:int, param2:int) : void
      {
         var _loc5_:CampGameSmallEnemy = null;
         var _loc3_:int = int(this._monsterList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._monsterList[_loc4_] as CampGameSmallEnemy;
            if(_loc5_.info.LivingID == param1)
            {
               _loc5_.setStateType(param2);
               break;
            }
            _loc4_++;
         }
      }
      
      private function deleAntoObjList(param1:Object) : void
      {
         var _loc2_:int = int(this._antoObjList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 is CampBaseRole)
            {
               if(this._antoObjList[_loc3_] is CampBaseRole)
               {
                  if(CampBaseRole(param1).playerInfo.zoneID == CampBaseRole(this._antoObjList[_loc3_]).playerInfo.zoneID && CampBaseRole(param1).playerInfo.userID == CampBaseRole(this._antoObjList[_loc3_]).playerInfo.userID)
                  {
                     this._antoObjList.splice(_loc3_,1);
                     return;
                  }
               }
            }
            else if(param1 is CampGameSmallEnemy)
            {
               if(this._antoObjList[_loc3_] is CampGameSmallEnemy)
               {
                  if(CampGameSmallEnemy(param1).LivingID == CampGameSmallEnemy(this._antoObjList[_loc3_]).LivingID && CampGameSmallEnemy(param1).LivingID == CampGameSmallEnemy(this._antoObjList[_loc3_]).LivingID)
                  {
                     this._antoObjList.splice(_loc3_,1);
                     return;
                  }
               }
            }
            _loc3_++;
         }
      }
      
      private function roleCallback(param1:CampBaseRole, param2:Boolean, param3:int) : void
      {
         var role:CampBaseRole = param1;
         var isLoadSucceed:Boolean = param2;
         var vFlag:int = param3;
         if(vFlag == 0)
         {
            if(Boolean(role))
            {
               this._mainRole = role;
               this._mainRole.sceneCharacterStateType = "natural";
               this._mainRole.update();
               this._mainRole.scene = this._sceneScene;
               this._mainRole.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
               try
               {
                  this._articleLayer.addChild(this._mainRole);
                  this._roleList.push(this._mainRole);
                  this._antoObjList.push(role);
                  this.setCenter(null,false,this._mainRole.playerPoint);
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      private function otherRoleCallback(param1:CampBaseRole, param2:Boolean, param3:int) : void
      {
         if(!param1)
         {
            return;
         }
         if(param3 != 0)
         {
            return;
         }
         param1.sceneCharacterStateType = "natural";
         param1.update();
         param1.scene = this._sceneScene;
         param1.mouseEnabled = param1.mouseChildren = false;
         if(param1.playerInfo.team != CampBattleManager.instance.model.myTeam)
         {
            param1.mouseEnabled = param1.mouseChildren = true;
            param1.addClickEvent();
         }
         this._articleLayer.addChild(param1);
         this._roleList.push(param1);
         this._antoObjList.push(param1);
      }
      
      public function hideRoles(param1:Boolean) : void
      {
         var _loc4_:CampBaseRole = null;
         var _loc2_:int = int(this._roleList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._roleList[_loc3_] as CampBaseRole;
            if(_loc4_.playerInfo.userID != PlayerManager.Instance.Self.ID)
            {
               _loc4_.visible = param1;
            }
            _loc3_++;
         }
      }
      
      protected function __onUpdatePlayerStatus(param1:DictionaryEvent) : void
      {
         var _loc3_:RoleData = null;
         var _loc2_:String = (param1.data as RoleData).zoneID + "_" + (param1.data as RoleData).userID;
         if(Boolean(this._playerModel[_loc2_]))
         {
            _loc3_ = this._playerModel[_loc2_] as RoleData;
         }
      }
      
      public function getCurrRole(param1:int, param2:int) : CampBattlePlayer
      {
         var _loc3_:String = param1 + "_" + param2;
         var _loc4_:int = this.getRoleIndex(_loc3_);
         return CampBattlePlayer(this._roleList[_loc4_]);
      }
      
      public function getMainRole() : CampBaseRole
      {
         return this._mainRole;
      }
      
      protected function __onRemovePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:String = (param1.data as RoleData).zoneID + "_" + (param1.data as RoleData).userID;
         var _loc3_:int = this.getRoleIndex(_loc2_);
         var _loc4_:CampBaseRole = this._roleList[_loc3_] as CampBaseRole;
         this._roleList.splice(_loc3_,1);
         this.deleAntoObjList(_loc4_);
         if(_loc4_ == this._targetRole)
         {
            this._targetRole = null;
         }
         if(Boolean(_loc4_))
         {
            if(Boolean(_loc4_.parent))
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            _loc4_.dispose();
         }
         _loc4_ = null;
      }
      
      public function roleMoves(param1:int, param2:int, param3:Point) : void
      {
         var _loc6_:CampBaseRole = null;
         if(!this._roleList)
         {
            return;
         }
         var _loc4_:String = param1 + "_" + param2;
         var _loc5_:int = this.getRoleIndex(_loc4_);
         if(Boolean(this._roleList[_loc5_]))
         {
            _loc6_ = this._roleList[_loc5_] as CampBaseRole;
            _loc6_.walk(param3);
         }
      }
      
      private function getRoleIndex(param1:String) : int
      {
         var _loc4_:CampBaseRole = null;
         var _loc2_:int = int(this._roleList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._roleList[_loc3_] as CampBaseRole;
            if(param1 == _loc4_.playerInfo.zoneID + "_" + _loc4_.playerInfo.userID)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      private function initMap() : void
      {
         var _loc1_:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this._mapClassDefinition) as Class)() as MovieClip;
         var _loc2_:Sprite = _loc1_.getChildByName("articleLayer") as Sprite;
         var _loc3_:Sprite = _loc1_.getChildByName("mesh") as Sprite;
         var _loc4_:Sprite = _loc1_.getChildByName("bg") as Sprite;
         var _loc5_:Sprite = _loc1_.getChildByName("bgSize") as Sprite;
         var _loc6_:Sprite = _loc1_.getChildByName("decoration") as Sprite;
         this._bgLayer = _loc4_ == null ? new Sprite() : _loc4_;
         this._articleLayer = _loc2_ == null ? new Sprite() : _loc2_;
         this._decorationLayer = _loc6_ == null ? new Sprite() : _loc6_;
         this._decorationLayer.mouseChildren = this._decorationLayer.mouseEnabled = false;
         this._meshLayer = _loc3_ == null ? new Sprite() : _loc3_;
         this._meshLayer.alpha = 0;
         this._meshLayer.mouseChildren = false;
         this._meshLayer.mouseEnabled = false;
         MAP_SIZE = [_loc4_.width,_loc4_.height];
         addChild(this._bgLayer);
         addChild(this._articleLayer);
         addChild(this._decorationLayer);
         addChild(this._meshLayer);
         this.initBtnList();
         this.initMouseMovie();
         if(Boolean(this._smallMap))
         {
            removeChild(this._smallMap);
            this._smallMap.bitmapData.dispose();
            this._smallMap = null;
         }
      }
      
      private function initBtnList() : void
      {
         var _loc1_:int = int(this._actItemList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._articleLayer.addChild(this._actItemList[_loc2_]);
            _loc2_++;
         }
      }
      
      private function clearBtnList() : void
      {
         var _loc1_:int = int(this._actItemList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            ObjectUtils.disposeObject(this._actItemList[_loc2_]);
            this._actItemList[_loc2_] = null;
            _loc2_++;
         }
      }
      
      protected function initSceneScene() : void
      {
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
      }
      
      private function clearRoleList() : void
      {
         var _loc3_:CampBaseRole = null;
         var _loc1_:int = int(this._roleList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._roleList[_loc2_];
            _loc3_.dispose();
            _loc3_ = null;
            _loc2_++;
         }
         this._roleList = [];
      }
      
      private function clearMonstList() : void
      {
         var _loc3_:CampGameSmallEnemy = null;
         var _loc1_:int = int(this._monsterList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._monsterList[_loc2_];
            _loc3_.dispose();
            _loc3_ = null;
            _loc2_++;
         }
         this._monsterList.length = 0;
      }
      
      private function clearAntoObjList() : void
      {
         var _loc3_:CampGameSmallEnemy = null;
         var _loc4_:CampBattlePlayer = null;
         var _loc1_:int = int(this._antoObjList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this._antoObjList[_loc2_] is CampGameSmallEnemy)
            {
               _loc3_ = this._antoObjList[_loc2_] as CampGameSmallEnemy;
               _loc3_.dispose();
               _loc3_ = null;
            }
            else if(this._antoObjList[_loc2_] is CampBattlePlayer)
            {
               _loc4_ = this._antoObjList[_loc2_] as CampBattlePlayer;
               _loc4_.dispose();
               _loc4_ = null;
            }
            _loc2_++;
         }
         this._antoObjList.length = 0;
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:MovieClip = null;
         if(Boolean(this._smallMap))
         {
            removeChild(this._smallMap);
            this._smallMap.bitmapData.dispose();
            this._smallMap = null;
         }
         if(Boolean(this._addMonsterTimer))
         {
            this._addMonsterTimer.stop();
            this._addMonsterTimer.removeEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
            this._addMonsterTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
            this._addMonsterTimer = null;
         }
         this.removeEvent();
         this.clearRoleList();
         this.clearMonstList();
         this.clearBtnList();
         this.clearAntoObjList();
         while(Boolean(this._articleLayer.numChildren))
         {
            ObjectUtils.disposeObject(this._articleLayer.getChildAt(0));
         }
         while(Boolean(this._bgLayer.numChildren))
         {
            if(this._bgLayer.getChildAt(0) is DisplayObject)
            {
               _loc1_ = this._bgLayer.getChildAt(0) as DisplayObject;
               this._bgLayer.removeChild(_loc1_);
               _loc1_ = null;
            }
            else
            {
               ObjectUtils.disposeObject(this._bgLayer.getChildAt(0));
            }
         }
         while(Boolean(this._meshLayer.numChildren))
         {
            ObjectUtils.disposeObject(this._meshLayer.getChildAt(0));
         }
         while(Boolean(this._decorationLayer.numChildren))
         {
            if(this._decorationLayer.getChildAt(0) is MovieClip)
            {
               _loc2_ = this._decorationLayer.getChildAt(0) as MovieClip;
               _loc2_.stop();
               while(Boolean(_loc2_.numChildren))
               {
                  ObjectUtils.disposeObject(_loc2_.getChildAt(0));
               }
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
            }
            else
            {
               ObjectUtils.disposeObject(this._decorationLayer.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._mainRole);
         ObjectUtils.disposeObject(this._mouseMovie);
         ObjectUtils.disposeObject(this._bgLayer);
         ObjectUtils.disposeObject(this._articleLayer);
         ObjectUtils.disposeObject(this._decorationLayer);
         ObjectUtils.disposeObject(this._meshLayer);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._monsterModel = null;
         this._bgLayer = null;
         this._articleLayer = null;
         this._decorationLayer = null;
         this._meshLayer = null;
         this._roleList = null;
         this._monsterList = null;
         this._targetRole = null;
         this._playerModel = null;
         this._antoObjList = null;
         this._mouseMovie = null;
         this._mainRole = null;
      }
      
      public function get playerModel() : DictionaryData
      {
         return this._playerModel;
      }
   }
}

