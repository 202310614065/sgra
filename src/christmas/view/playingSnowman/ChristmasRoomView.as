package christmas.view.playingSnowman
{
   import christmas.controller.ChristmasRoomController;
   import christmas.loader.LoaderChristmasUIModule;
   import christmas.manager.ChristmasManager;
   import christmas.model.ChristmasRoomModel;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatView;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ChristmasRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [1738,1300];
      
      private var _contoller:ChristmasRoomController;
      
      private var _model:ChristmasRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:ChristmasScneneMap;
      
      private var _chatFrame:ChatView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _snowPackNumImg:Bitmap;
      
      private var _snowPackNumTxt:FilterFrameText;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      public function ChristmasRoomView(param1:ChristmasRoomController, param2:ChristmasRoomModel)
      {
         super();
         this._contoller = param1;
         this._model = param2;
         this.initialize();
      }
      
      public function show() : void
      {
         this._contoller.addChild(this);
      }
      
      private function initialize() : void
      {
         SoundManager.instance.playMusic("christmasRoom");
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_CHRISTMAS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         this._chatFrame.output.isLock = true;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._snowPackNumImg = ComponentFactory.Instance.creatBitmap("asset.christmas.snowpacknum");
         this._snowPackNumTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.christmasRoom.snowPackNumTxt");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.christmasRoom.activeTimeTxt");
         this._snowPackNumTxt.text = ChristmasManager.instance.getBagSnowPacksCount() + "";
         addChild(this._snowPackNumImg);
         addChild(this._snowPackNumTxt);
         addChild(this._activeTimeTxt);
         this._roomMenuView = ComponentFactory.Instance.creat("christmas.room.menuView");
         addChild(this._roomMenuView);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
         this.flushTip();
         this.setMap();
         this.firestGetTime();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,this.__updateRoomTimes);
      }
      
      private function removeEvent() : void
      {
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,this.__updateRoomTimes);
      }
      
      private function __updateRoomTimes(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Date = _loc2_.readDate();
         ChristmasManager.instance.model.gameEndTime = _loc2_.readDate();
         ChristmasScneneMap.packsNum = 2;
         this.firestGetTime();
      }
      
      public function removeTimer() : void
      {
         this._sceneMap.stopAllTimer();
      }
      
      public function setViewAgain() : void
      {
         SoundManager.instance.playMusic("christmasRoom");
         ChatManager.Instance.state = ChatManager.CHAT_CHRISTMAS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._chatFrame.output.isLock = true;
         this._sceneMap.enterIng = false;
         this.firestGetTime();
      }
      
      private function flushTip() : void
      {
         this._timer = new Timer(60000,0);
         this._timer.addEventListener(TimerEvent.TIMER,this.updateTip);
         this._timer.start();
      }
      
      private function updateTip(param1:TimerEvent) : void
      {
         this.firestGetTime();
      }
      
      private function firestGetTime() : void
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Number = Number(_loc1_.getTime());
         var _loc3_:Number = Number(ChristmasManager.instance.model.gameEndTime.getTime());
         var _loc4_:Number = _loc3_ - _loc2_;
         var _loc5_:int = _loc4_ / (1000 * 60 * 60);
         var _loc6_:int = (_loc4_ - _loc5_ * 1000 * 60 * 60) / (1000 * 60);
         if(_loc6_ >= 0)
         {
            this._activeTimeTxt.text = LanguageMgr.GetTranslation("christmas.flushTimecut",_loc5_,_loc6_ + 1);
         }
         else
         {
            this._activeTimeTxt.text = LanguageMgr.GetTranslation("christmas.flushTimecut",0,0);
         }
         this._snowPackNumTxt.text = ChristmasManager.instance.getBagSnowPacksCount() + "";
      }
      
      public function setMap(param1:Point = null) : void
      {
         ChristmasManager.isFrameChristmas = true;
         this.clearMap();
         var _loc2_:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(LoaderChristmasUIModule.Instance.getMapRes()) as Class)() as MovieClip;
         var _loc3_:Sprite = _loc2_.getChildByName("articleLayer") as Sprite;
         var _loc4_:Sprite = _loc2_.getChildByName("NPCMouse") as Sprite;
         var _loc5_:Sprite = _loc2_.getChildByName("mesh") as Sprite;
         var _loc6_:Sprite = _loc2_.getChildByName("bg") as Sprite;
         var _loc7_:Sprite = _loc2_.getChildByName("bgSize") as Sprite;
         var _loc8_:Sprite = _loc2_.getChildByName("snowCenter") as Sprite;
         var _loc9_:Sprite = _loc2_.getChildByName("decoration") as Sprite;
         if(Boolean(_loc7_))
         {
            MAP_SIZEII[0] = _loc7_.width;
            MAP_SIZEII[1] = _loc7_.height;
         }
         else
         {
            MAP_SIZEII[0] = _loc6_.width;
            MAP_SIZEII[1] = _loc6_.height;
         }
         this._sceneScene.setHitTester(new PathMapHitTester(_loc5_));
         if(!this._sceneMap)
         {
            this._sceneMap = new ChristmasScneneMap(this._model,this._sceneScene,this._model.getPlayers(),this._model.getObjects(),_loc6_,_loc5_,_loc3_,_loc4_,_loc9_,_loc8_);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(Boolean(param1))
         {
            this._sceneMap.sceneMapVO.defaultPos = param1;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         _loc1_.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         _loc1_.mapW = MAP_SIZEII[0];
         _loc1_.mapH = MAP_SIZEII[1];
         _loc1_.defaultPos = ComponentFactory.Instance.creatCustomObject("christmas.RoomView.sceneMapVOPosII");
         return _loc1_;
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.movePlayer(param1,param2);
         }
      }
      
      public function updatePlayerStauts(param1:int, param2:int, param3:Point = null) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.updatePlayersStauts(param1,param2,param3);
         }
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         this._sceneMap.updateSelfStatus(param1);
      }
      
      public function playerRevive(param1:int) : void
      {
         if(Boolean(this._sceneMap.selfPlayer) && param1 == this._sceneMap.selfPlayer.ID)
         {
            if(Boolean(this._roomMenuView))
            {
               this._roomMenuView.visible = true;
            }
         }
         this._sceneMap.playerRevive(param1);
      }
      
      private function _leaveRoom(param1:Event) : void
      {
         StateManager.setState(StateType.MAIN);
         this._contoller.dispose();
      }
      
      private function clearMap() : void
      {
         if(Boolean(this._sceneMap))
         {
            if(Boolean(this._sceneMap.parent))
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.updateTip);
         }
         this._roomMenuView = null;
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
      }
   }
}

