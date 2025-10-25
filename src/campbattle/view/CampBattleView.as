package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.data.CampModel;
   import campbattle.data.RoleData;
   import campbattle.event.MapEvent;
   import campbattle.view.rank.ScoreRankView;
   import campbattle.view.roleView.CampBaseRole;
   import campbattle.view.roleView.CampBattlePlayer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.socket.CampPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.SmallEnemy;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class CampBattleView extends BaseStateView
   {
      
      private var _mapID:int;
      
      private var _mapLayer:Sprite;
      
      private var _uiLayer:Sprite;
      
      private var _headView:HeadInfoView;
      
      private var _titleView:CampBattleTitle;
      
      private var _backBtn:CampBattleReturnBtn;
      
      private var _smallMap:Bitmap;
      
      private var _mapView:CampBattleMap;
      
      private var _campLight:Bitmap;
      
      private var _progressBar:CampProgress;
      
      private var _statueBtn:CampStatueBtn;
      
      private var _clickDoor:ClickDoor;
      
      private var _battleTimer:CampBattleInTimer;
      
      private var _chatView:ChatView;
      
      private var _hideBtn:CampStateHideBtn;
      
      private var _helpBtn:BaseButton;
      
      private var _rankView:ScoreRankView;
      
      private var _itemList:Array;
      
      public function CampBattleView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._mapID = int(param2);
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._uiLayer = new Sprite();
         addChild(this._uiLayer);
      }
      
      private function initView() : void
      {
         this._headView = new HeadInfoView(PlayerManager.Instance.Self);
         this._uiLayer.addChild(this._headView);
         this._titleView = new CampBattleTitle();
         this._uiLayer.addChild(this._titleView);
         this._titleView.setTitleTxt2(CampBattleManager.instance.model.captureName);
         this._titleView.setTitleTxt4(CampBattleManager.instance.model.winCount.toString());
         this._battleTimer = new CampBattleInTimer();
         this._uiLayer.addChild(this._battleTimer);
         this._backBtn = new CampBattleReturnBtn();
         PositionUtils.setPos(this._backBtn,"ddtCampBattle.views.returnBtnPos");
         this._uiLayer.addChild(this._backBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("stateMap.texpSystem.btnHelp");
         addChild(this._helpBtn);
         this._hideBtn = new CampStateHideBtn();
         PositionUtils.setPos(this._hideBtn,"ddtCampBattle.views.hideBtnPos");
         this._hideBtn.visible = false;
         addChild(this._hideBtn);
         this._rankView = new ScoreRankView();
         PositionUtils.setPos(this._rankView,"ddtCampBattle.views.rankViewPos");
         addChild(this._rankView);
         this.createBg();
         this.addChatView();
      }
      
      public function changeMap(param1:int) : void
      {
         this._mapID = param1;
         this.createBg();
      }
      
      private function createActItem() : void
      {
         this._itemList = [];
         this._progressBar = new CampProgress();
         PositionUtils.setPos(this._progressBar,"ddtCampBattle.views.progressBarPos");
         this._campLight = ComponentFactory.Instance.creat("camp.campBattle.light");
         if(CampBattleManager.instance.model.isCapture)
         {
            this._progressBar.setCapture();
            if(CampBattleManager.instance.model.captureZoneID == PlayerManager.Instance.Self.ZoneID && CampBattleManager.instance.model.captureUserID == PlayerManager.Instance.Self.ID)
            {
               this._campLight.visible = true;
            }
         }
         this._statueBtn = new CampStatueBtn();
         PositionUtils.setPos(this._statueBtn,"ddtCampBattle.views.statueBtnPos");
         this._itemList.push(this._campLight);
         this._itemList.push(this._statueBtn);
         this._itemList.push(this._progressBar);
      }
      
      private function initEvent() : void
      {
         this._backBtn.returnBtn.addEventListener(MouseEvent.CLICK,this.__onBackBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._hideBtn.addEventListener(MouseEvent.CLICK,this.__onHideBtnClick);
         SocketManager.Instance.addEventListener(CampPackageType.MONSTER_STATE_CHANGE_EVENT,this.__onMonsterStateChange);
         SocketManager.Instance.addEventListener(CampPackageType.ROLE_MOVE_EVENT,this.__onRoleMoveHander);
         SocketManager.Instance.addEventListener(CampPackageType.CAPTURE_MAP_EVENT,this.__onCapMapHander);
         SocketManager.Instance.addEventListener(CampPackageType.ADD_MONSTER_LIST_EVENT,this.__onAddMonstersList);
         SocketManager.Instance.addEventListener(CampPackageType.DOOR_STATUS_EVENT,this.__onDoorstatus);
         CampBattleManager.instance.addEventListener(MapEvent.ENTER_FIGHT,this.__onFighterHander);
         CampBattleManager.instance.addEventListener(MapEvent.TO_OTHER_MAP,this.__onToOhterMapHander);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_STATUE,this.__onCaptureMapHander);
         CampBattleManager.instance.addEventListener(MapEvent.STATUE_GOTO_FIGHT,this.__onStatueGotoFightHander);
         CampBattleManager.instance.addEventListener(MapEvent.CAPTURE_OVER,this.__onCaptureOverHander);
         CampBattleManager.instance.addEventListener(MapEvent.GOTO_FIGHT,this.__onGotoFightHander);
         CampBattleManager.instance.addEventListener(MapEvent.WIN_COUNT_PVP,this.__onUpdateWinCount);
         CampBattleManager.instance.addEventListener(MapEvent.PLAYER_STATE_CHANGE,this.__onPlayerStateChange);
         CampBattleManager.instance.addEventListener(MapEvent.UPDATE_SCORE,this.__onUpdateScoreHander);
         CampBattleManager.instance.addEventListener(MapEvent.ADD_ROLE,this.__onAddRole);
         CampBattleManager.instance.addEventListener(MapEvent.REMOVE_ROLE,this.__onRemoveRole);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrameHander);
      }
      
      protected function __onAddRole(param1:MapEvent) : void
      {
         this._mapView.playerModel.add(param1.data[0],param1.data[1]);
      }
      
      protected function __onRemoveRole(param1:MapEvent) : void
      {
         this._mapView.playerModel.remove(param1.data);
      }
      
      protected function __onUpdateWinCount(param1:MapEvent) : void
      {
         if(Boolean(this._titleView))
         {
            this._titleView.setTitleTxt4(CampBattleManager.instance.model.winCount.toString());
         }
      }
      
      private function __onDoorstatus(param1:CrazyTankSocketEvent) : void
      {
         CampBattleManager.instance.model.doorIsOpen = true;
         this._clickDoor.doorStatus();
      }
      
      private function __onUpdateScoreHander(param1:MapEvent) : void
      {
         this._headView.updateScore(CampBattleManager.instance.model.myScore);
      }
      
      private function __onEnterFrameHander(param1:Event) : void
      {
         var _loc2_:Point = null;
         var _loc3_:CampBaseRole = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(CampBattleManager.instance.model.isCapture)
         {
            _loc2_ = new Point(1459,864);
            if(Boolean(this._mapView) && Boolean(this._mapView.getMainRole()))
            {
               _loc3_ = this._mapView.getMainRole();
               _loc4_ = new Point(_loc3_.x,_loc3_.y);
               _loc5_ = Math.abs(_loc4_.x - _loc2_.x);
               _loc6_ = Math.abs(_loc4_.y - _loc2_.y);
               if(_loc5_ > 300 || _loc6_ > 200)
               {
                  if(_loc3_.playerInfo.isCapture)
                  {
                     SocketManager.Instance.out.captureMap(false);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.outofCaptrue"));
                  }
               }
            }
         }
      }
      
      private function createBg() : void
      {
         if(CampBattleManager.instance.model.isShowResurrectView)
         {
            this.createRrsurrectView();
         }
         if(this._mapID == 0)
         {
            this._titleView.visible = false;
            this._clickDoor = new ClickDoor();
            PositionUtils.setPos(this._clickDoor,"ddtCampBattle.views.clickDoorPos");
            this._smallMap = ComponentFactory.Instance.creat("campbattle.passSmall");
            this.creatMap(CampBattleManager.resClassUrl,CampBattleManager.PVE_MAPRESOURCEURL,CampBattleManager.instance.model.playerModel,CampBattleManager.instance.model.monsterList,[this._clickDoor],this._smallMap);
         }
         else if(this._mapID == 1)
         {
            this._titleView.visible = true;
            this.createActItem();
            this._smallMap = ComponentFactory.Instance.creat("campbattle.pkSmall");
            this.creatMap(CampBattleManager.resClassUrl2,CampBattleManager.PVP_MAPRESOURCEURL,CampBattleManager.instance.model.playerModel,CampBattleManager.instance.model.monsterList,this._itemList,this._smallMap);
         }
      }
      
      private function addChatView() : void
      {
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
      }
      
      private function __onStatueGotoFightHander(param1:MapEvent) : void
      {
         var _loc2_:Point = new Point(param1.data[0],param1.data[1]);
         var _loc3_:int = CampBattleManager.instance.model.captureZoneID;
         var _loc4_:int = CampBattleManager.instance.model.captureUserID;
         var _loc5_:CampBaseRole = this._mapView.getMainRole();
         if(this._mapView.getCurrRole(_loc3_,_loc4_).playerInfo.team == _loc5_.playerInfo.team)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.statuCaptured"));
            return;
         }
         if(!_loc5_.playerInfo.isDead)
         {
            this._mapView.checkPonitDistance(_loc2_,SocketManager.Instance.out.enterPTPFight,_loc4_,_loc3_);
         }
      }
      
      private function creatMap(param1:String = null, param2:String = null, param3:DictionaryData = null, param4:DictionaryData = null, param5:Array = null, param6:Bitmap = null) : void
      {
         this._mapView = new CampBattleMap(param1,param2,param3,param4,param5,param6);
         this._mapLayer.addChild(this._mapView);
      }
      
      private function __onGotoFightHander(param1:MapEvent) : void
      {
         var _loc2_:Point = new Point(param1.data[0],param1.data[1]);
         var _loc3_:int = int(param1.data[2]);
         var _loc4_:int = int(param1.data[3]);
         if(Boolean(this._mapView.getMainRole()))
         {
            if(!this._mapView.getMainRole().playerInfo.isDead)
            {
               this._mapView.checkPonitDistance(_loc2_,SocketManager.Instance.out.enterPTPFight,_loc4_,_loc3_);
            }
         }
      }
      
      private function __onCaptureMapHander(param1:MapEvent) : void
      {
         var _loc2_:Point = new Point(param1.data[0],param1.data[1]);
         this._mapView.checkPonitDistance(_loc2_,this.captureMap);
      }
      
      private function captureMap() : void
      {
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.CAPTURE_START));
      }
      
      private function __onCapMapHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:CampModel = CampBattleManager.instance.model;
         _loc3_.isCapture = _loc2_.readBoolean();
         _loc3_.captureZoneID = _loc2_.readInt();
         _loc3_.captureUserID = _loc2_.readInt();
         _loc3_.captureName = _loc2_.readUTF();
         if(_loc3_.captureName.length > 4)
         {
            _loc3_.captureName = _loc3_.captureName.replace(4,"......");
         }
         _loc3_.captureTeam = _loc2_.readInt();
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.CAPTURE_OVER,[_loc3_.captureZoneID,_loc3_.captureUserID]));
         var _loc4_:RoleData = this.getRoleData(_loc3_.captureZoneID,_loc3_.captureUserID);
         if(Boolean(_loc4_))
         {
            _loc4_.isCapture = _loc3_.isCapture;
         }
      }
      
      private function __onAddMonstersList(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SmallEnemy = null;
         var _loc7_:String = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            CampBattleManager.instance.model.monsterCount = _loc2_.readInt();
            _loc3_ = _loc2_.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = new SmallEnemy(_loc5_,2,1000);
               _loc6_.typeLiving = 2;
               _loc6_.actionMovieName = _loc2_.readUTF();
               _loc7_ = _loc2_.readUTF();
               _loc6_.direction = 1;
               _loc8_ = new Point(_loc2_.readInt(),_loc2_.readInt());
               _loc6_.name = "虫子";
               _loc6_.stateType = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               CampBattleManager.instance.model.monsterList.add(_loc6_.LivingID,_loc6_);
               if(_loc9_ > 0)
               {
                  if(CampBattleManager.instance.model.monsterCount == 10)
                  {
                     _loc6_.pos = new Point(CampBattleManager.instance.model.monsterPosList[_loc4_][0],CampBattleManager.instance.model.monsterPosList[_loc4_][1]);
                  }
                  else
                  {
                     _loc6_.pos = _loc8_;
                  }
               }
               else
               {
                  _loc6_.pos = new Point(CampBattleManager.instance.model.monsterPosList[_loc4_][0],CampBattleManager.instance.model.monsterPosList[_loc4_][1]);
               }
               _loc4_++;
            }
            dispatchEvent(new MapEvent(MapEvent.PVE_COUNT));
         }
      }
      
      private function __onCaptureOverHander(param1:MapEvent) : void
      {
         var _loc2_:int = int(param1.data[0]);
         var _loc3_:int = int(param1.data[1]);
         if(CampBattleManager.instance.model.isCapture)
         {
            if(Boolean(this._titleView))
            {
               this._titleView.setTitleTxt2(CampBattleManager.instance.model.captureName);
               this._titleView.setTitleTxt4("0");
            }
            this._statueBtn._arrowMc.stop();
            this._statueBtn._arrowMc.visible = false;
         }
         else if(Boolean(this._titleView))
         {
            this._titleView.setTitleTxt2(LanguageMgr.GetTranslation("ddt.campBattle.NOcapture"));
            this._titleView.setTitleTxt4("0");
         }
         var _loc4_:CampBattlePlayer = this._mapView.getCurrRole(_loc2_,_loc3_);
         if(Boolean(_loc4_))
         {
            _loc4_.setCaptureVisible(CampBattleManager.instance.model.isCapture);
         }
         var _loc5_:CampBattlePlayer = CampBattlePlayer(this._mapView.getMainRole());
         if(Boolean(_loc5_))
         {
            if(_loc5_.playerInfo.zoneID == _loc2_ && _loc5_.playerInfo.userID == _loc3_)
            {
               this._campLight.visible = CampBattleManager.instance.model.isCapture;
            }
         }
      }
      
      private function __onRoleMoveHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:RoleData = null;
         var _loc8_:Point = null;
         var _loc2_:PackageIn = param1.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = this.getRoleData(_loc5_,_loc6_);
            if(Boolean(_loc7_))
            {
               _loc7_.posX = _loc3_;
               _loc7_.posY = _loc4_;
               _loc7_.stateType = 1;
               if(PlayerManager.Instance.Self.ZoneID == _loc5_ && PlayerManager.Instance.Self.ID == _loc6_)
               {
                  return;
               }
               _loc8_ = new Point(_loc3_,_loc4_);
               this._mapView.roleMoves(_loc5_,_loc6_,_loc8_);
            }
         }
      }
      
      private function __onToOhterMapHander(param1:MapEvent) : void
      {
         var _loc2_:Point = new Point(param1.data[0],param1.data[1]);
         if(!this._mapView.getMainRole().playerInfo.isDead)
         {
            this._mapView.checkPonitDistance(_loc2_,SocketManager.Instance.out.changeMap);
         }
      }
      
      private function __onPlayerStateChange(param1:MapEvent) : void
      {
         this._mapView.setRoleState(param1.data[0],param1.data[1],param1.data[2]);
      }
      
      private function __onMonsterStateChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         if(!CampBattleManager.instance.model.isFighting)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = _loc2_.readInt();
            if(_loc4_ == 4)
            {
               CampBattleManager.instance.model.monsterList.remove(_loc3_);
            }
            else
            {
               this._mapView.setMonsterState(_loc3_,_loc4_);
            }
         }
      }
      
      private function getRoleData(param1:int, param2:int) : RoleData
      {
         var _loc3_:String = param1 + "_" + param2;
         var _loc4_:RoleData = null;
         if(Boolean(CampBattleManager.instance.model.playerModel))
         {
            _loc4_ = CampBattleManager.instance.model.playerModel[_loc3_];
         }
         return _loc4_;
      }
      
      private function createRrsurrectView() : void
      {
         CampBattleManager.instance.model.isShowResurrectView = false;
         var _loc1_:CampBattleResurrectView = new CampBattleResurrectView(CampBattleManager.instance.model.liveTime);
         _loc1_.addEventListener(Event.COMPLETE,this.__onResurrectHandler,false,0,true);
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true);
      }
      
      private function __onResurrectHandler(param1:Event) : void
      {
         var _loc2_:CampBattleResurrectView = param1.currentTarget as CampBattleResurrectView;
         if(Boolean(_loc2_))
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.__onResurrectHandler);
            _loc2_.dispose();
            _loc2_ = null;
         }
         SocketManager.Instance.out.resurrect(false,false);
         this._mapView.setRoleState(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID,1);
      }
      
      private function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __onFighterHander(param1:MapEvent) : void
      {
         var _loc2_:Point = new Point(param1.data[0],param1.data[1]);
         var _loc3_:int = int(param1.data[2]);
         if(!this._mapView || !this._mapView.getMainRole() || !this._mapView.getMainRole().playerInfo || this._mapView.getMainRole().playerInfo.isDead)
         {
            return;
         }
         this._mapView.checkPonitDistance(_loc2_,SocketManager.Instance.out.CampbattleEnterFight,_loc3_);
      }
      
      protected function __onHideBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._mapView.hideRoles(this._hideBtn.isHide);
      }
      
      protected function __onHelpBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:CampBattleHelpView = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.views.helpView");
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.frameEvent);
         param1.currentTarget.dispose();
      }
      
      protected function __onBackBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.campBattle.outCampBattle");
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onConfirm);
      }
      
      protected function __onConfirm(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.outCampBatttle();
            StateManager.setState(StateType.MAIN);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      override public function getType() : String
      {
         return StateType.CAMP_BATTLE_SCENE;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         super.dispose();
      }
      
      private function removeEvent() : void
      {
         this._backBtn.returnBtn.removeEventListener(MouseEvent.CLICK,this.__onBackBtnClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         this._hideBtn.removeEventListener(MouseEvent.CLICK,this.__onHideBtnClick);
         SocketManager.Instance.removeEventListener(CampPackageType.MONSTER_STATE_CHANGE_EVENT,this.__onMonsterStateChange);
         SocketManager.Instance.removeEventListener(CampPackageType.ROLE_MOVE_EVENT,this.__onRoleMoveHander);
         SocketManager.Instance.removeEventListener(CampPackageType.CAPTURE_MAP_EVENT,this.__onCapMapHander);
         SocketManager.Instance.removeEventListener(CampPackageType.ADD_MONSTER_LIST_EVENT,this.__onAddMonstersList);
         SocketManager.Instance.removeEventListener(CampPackageType.DOOR_STATUS_EVENT,this.__onDoorstatus);
         CampBattleManager.instance.removeEventListener(MapEvent.ENTER_FIGHT,this.__onFighterHander);
         CampBattleManager.instance.removeEventListener(MapEvent.TO_OTHER_MAP,this.__onToOhterMapHander);
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_STATUE,this.__onCaptureMapHander);
         CampBattleManager.instance.removeEventListener(MapEvent.STATUE_GOTO_FIGHT,this.__onStatueGotoFightHander);
         CampBattleManager.instance.removeEventListener(MapEvent.CAPTURE_OVER,this.__onCaptureOverHander);
         CampBattleManager.instance.removeEventListener(MapEvent.GOTO_FIGHT,this.__onGotoFightHander);
         CampBattleManager.instance.removeEventListener(MapEvent.WIN_COUNT_PVP,this.__onUpdateWinCount);
         CampBattleManager.instance.removeEventListener(MapEvent.PLAYER_STATE_CHANGE,this.__onPlayerStateChange);
         CampBattleManager.instance.removeEventListener(MapEvent.UPDATE_SCORE,this.__onUpdateScoreHander);
         CampBattleManager.instance.removeEventListener(MapEvent.ADD_ROLE,this.__onAddRole);
         CampBattleManager.instance.removeEventListener(MapEvent.REMOVE_ROLE,this.__onRemoveRole);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrameHander);
      }
      
      private function removeMap() : void
      {
         if(Boolean(this._smallMap))
         {
            this._smallMap.bitmapData.dispose();
         }
         this._smallMap = null;
         if(Boolean(this._mapView))
         {
            this._mapView.dispose();
         }
         this._mapView = null;
         if(Boolean(this._clickDoor))
         {
            this._clickDoor.dispose();
         }
         this._clickDoor = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeMap();
         if(Boolean(this._campLight))
         {
            this._campLight.bitmapData.dispose();
         }
         this._campLight = null;
         if(Boolean(this._headView))
         {
            this._headView.dispose();
         }
         this._headView = null;
         if(Boolean(this._titleView))
         {
            this._titleView.dispose();
         }
         this._titleView = null;
         if(Boolean(this._backBtn))
         {
            this._backBtn.dispose();
         }
         this._backBtn = null;
         if(Boolean(this._progressBar))
         {
            this._progressBar.dispose();
         }
         this._progressBar = null;
         if(Boolean(this._statueBtn))
         {
            this._statueBtn.dispose();
         }
         this._statueBtn = null;
         if(Boolean(this._battleTimer))
         {
            this._battleTimer.dispose();
         }
         this._battleTimer = null;
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
         }
         this._helpBtn = null;
         if(Boolean(this._hideBtn))
         {
            this._hideBtn.dispose();
         }
         this._hideBtn = null;
         if(Boolean(this._rankView))
         {
            this._rankView.dispose();
         }
         this._rankView = null;
         if(Boolean(this._mapLayer))
         {
            this._mapLayer = null;
         }
         if(Boolean(this._uiLayer))
         {
            this._uiLayer = null;
         }
      }
   }
}

