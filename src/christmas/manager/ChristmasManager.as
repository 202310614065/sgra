package christmas.manager
{
   import christmas.data.ChristmasPackageType;
   import christmas.event.ChristmasRoomEvent;
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.items.ExpBar;
   import christmas.loader.LoaderChristmasUIModule;
   import christmas.model.ChristmasModel;
   import christmas.player.PlayerVO;
   import christmas.view.ChristmasChooseRoomFrame;
   import christmas.view.makingSnowmenView.ChristmasMakingSnowmenFrame;
   import christmas.view.makingSnowmenView.SnowPackDoubleFrame;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import ddt.data.BagInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ChristmasManager extends EventDispatcher
   {
      
      private static var _instance:ChristmasManager;
      
      public static var isFrameChristmas:Boolean;
      
      public static var isToRoom:Boolean;
      
      public static var isComeRoom:Boolean;
      
      private var _self:SelfInfo;
      
      private var _model:ChristmasModel;
      
      private var _isShowIcon:Boolean = false;
      
      private var _makingSnoFrame:ChristmasMakingSnowmenFrame;
      
      private var _christmasResourceId:String;
      
      private var _currentPVE_ID:int;
      
      private var _mapPath:String;
      
      private var _appearPos:Array = new Array();
      
      private var _christmasInfo:ChristmasSystemItemsInfo;
      
      private var _snowPackDoubleFrame:SnowPackDoubleFrame;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      private var _goods:ShopItemInfo;
      
      private var _chooseRoomFrame:ChristmasChooseRoomFrame;
      
      public function ChristmasManager(param1:PrivateClass)
      {
         super();
      }
      
      public static function get instance() : ChristmasManager
      {
         if(ChristmasManager._instance == null)
         {
            ChristmasManager._instance = new ChristmasManager(new PrivateClass());
         }
         return ChristmasManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new ChristmasModel();
         this._self = new SelfInfo();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         var _loc4_:CrazyTankSocketEvent = null;
         switch(_loc3_)
         {
            case ChristmasPackageType.CHRISTMAS_OPENORCLOSE:
               this.openOrclose(_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER:
               this.enterChristmasGame(_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_MAKING_SNOWMAN_ENTER:
               this.makingSnowmanEnter(_loc2_);
               break;
            case ChristmasPackageType.FIGHT_SPIRIT_LEVELUP:
               this.snowIsUpdata(_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_PACKS:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_PACKS,_loc2_);
               break;
            case ChristmasPackageType.GET_PAKCS_TO_PLAYER:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_PAKCS_TO_PLAYER,_loc2_);
               break;
            case ChristmasPackageType.PLAYER_STATUE:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STATUE,_loc2_);
               break;
            case ChristmasPackageType.MOVE:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_MOVE,_loc2_);
               break;
            case ChristmasPackageType.ADDPLAYER:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADDPLAYER_ROOM,_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_EXIT:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_EXIT,_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_MONSTER:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_MONSTER,_loc2_);
               break;
            case ChristmasPackageType.CHRISTMAS_ROOM_SPEAK:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_ROOM_SPEAK,_loc2_);
               break;
            case ChristmasPackageType.UPDATE_TIMES_ROOM:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_TIMES_ROOM,_loc2_);
         }
         if(Boolean(_loc4_))
         {
            dispatchEvent(_loc4_);
         }
      }
      
      private function enterChristmasGame(param1:PackageIn) : void
      {
         this._goods = ShopManager.Instance.getGoodsByTemplateID(201145);
         this._model.isEnter = param1.readBoolean();
         if(this._model.isEnter)
         {
            this._model.gameBeginTime = param1.readDate();
            this._model.gameEndTime = param1.readDate();
            this._model.count = param1.readInt();
            this.playingSnowmanEnter();
         }
         else
         {
            this.showTransactionFrame(LanguageMgr.GetTranslation("christmas.buy.playingSnowman.volumes",this._goods.AValue1),this.buyPlayingSnowmanVolumes,null,null,false,false,1);
         }
      }
      
      private function buyPlayingSnowmanVolumes(param1:int = 0) : void
      {
         if(!this.checkMoney(this._goods.AValue1))
         {
            SocketManager.Instance.out.sendBuyPlayingSnowmanVolumes();
         }
      }
      
      public function playingSnowmanEnter() : void
      {
         this._mapPath = LoaderChristmasUIModule.Instance.getChristmasResource() + "/map/ChristmasMap.swf";
         this._christmasInfo.playerDefaultPos = new Point(500,500);
         this._christmasInfo.myPlayerVO.playerPos = this._christmasInfo.playerDefaultPos;
         this._christmasInfo.myPlayerVO.playerStauts = 0;
         LoaderChristmasUIModule.Instance.loadMap();
      }
      
      private function snowIsUpdata(param1:PackageIn) : void
      {
         var _loc2_:ChristmasSystemItemsInfo = new ChristmasSystemItemsInfo();
         _loc2_.isUp = param1.readBoolean();
         this._model.count = param1.readInt();
         this._model.exp = param1.readInt();
         _loc2_.num = param1.readInt();
         _loc2_.snowNum = param1.readInt();
         if(Boolean(this._makingSnoFrame))
         {
            this._makingSnoFrame.upDatafitCount();
            this._makingSnoFrame.snowmenAction(_loc2_);
            dispatchEvent(new ChristmasRoomEvent(ChristmasRoomEvent.SCORE_CONVERT));
         }
      }
      
      private function makingSnowmanEnter(param1:PackageIn) : void
      {
         this._model.count = param1.readInt();
         this._model.exp = param1.readInt();
         this._model.totalExp = 10;
         this._model.awardState = param1.readInt();
         this._model.packsNumber = param1.readInt();
         this._makingSnoFrame = ComponentFactory.Instance.creatComponentByStylename("chooseRoom.christmas.ChristmasMakingSnowmenFrame");
         LayerManager.Instance.addToLayer(this._makingSnoFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         var _loc2_:Vector.<ChristmasSystemItemsInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:ChristmasSystemItemsInfo = null;
         this._model.isOpen = param1.readBoolean();
         if(this._model.isOpen)
         {
            this._model.beginTime = param1.readDate();
            this._model.endTime = param1.readDate();
            this._model.packsLen = param1.readInt();
            this._model.snowPackNum = new Array();
            _loc2_ = new Vector.<ChristmasSystemItemsInfo>();
            _loc3_ = 0;
            while(_loc3_ < this._model.packsLen)
            {
               _loc4_ = new ChristmasSystemItemsInfo();
               _loc4_.TemplateID = param1.readInt();
               _loc2_.push(_loc4_);
               this._model.snowPackNum[_loc3_] = param1.readInt();
               _loc3_++;
            }
            this._model.lastPacks = param1.readInt();
            this._model.money = param1.readInt();
            this._model.myGiftData = _loc2_;
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            if(StateManager.currentStateType == StateType.CHRISTMAS || StateManager.currentStateType == StateType.CHRISTMAS_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
         }
      }
      
      public function getBagSnowPacksCount() : int
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         var _loc2_:BagInfo = _loc1_.getBag(BagInfo.PROPBAG);
         return _loc2_.getItemCountByTemplateId(201144);
      }
      
      public function showEnterIcon() : void
      {
         this._isShowIcon = true;
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHRISTMAS,true);
         this._christmasInfo = new ChristmasSystemItemsInfo();
         this._christmasInfo.myPlayerVO = new PlayerVO();
      }
      
      public function onClickChristmasIcon(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.Icon.NoEnter"));
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderChristmasUIModule.Instance.loadUIModule(this.doOpenChristmasFrame);
         }
      }
      
      private function doOpenChristmasFrame() : void
      {
         if(this._isShowIcon)
         {
            this._chooseRoomFrame = ComponentFactory.Instance.creatComponentByStylename("chooseRoom.christmas.ChristmasChooseRoomFrame");
            LayerManager.Instance.addToLayer(this._chooseRoomFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function get expBar() : ExpBar
      {
         return this._makingSnoFrame.expBar;
      }
      
      public function get christmasInfo() : ChristmasSystemItemsInfo
      {
         return this._christmasInfo;
      }
      
      public function getCount() : int
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         var _loc2_:BagInfo = _loc1_.getBag(BagInfo.PROPBAG);
         return _loc2_.getItemCountByTemplateId(201144);
      }
      
      public function showTransactionFrame(param1:String, param2:Function = null, param3:Function = null, param4:Sprite = null, param5:Boolean = true, param6:Boolean = false, param7:int = 0) : void
      {
         this._snowPackDoubleFrame = ComponentFactory.Instance.creatComponentByStylename("christmas.views.SnowPackDoubleFrame");
         this._snowPackDoubleFrame.setTxt(param1);
         this._snowPackDoubleFrame.buyFunction = param2;
         this._snowPackDoubleFrame.clickFunction = param3;
         this._snowPackDoubleFrame.setIsShow(param5,param7);
         this._snowPackDoubleFrame.initAddView(param6);
         this._snowPackDoubleFrame.target = param4;
         LayerManager.Instance.addToLayer(this._snowPackDoubleFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function setRemindSnowPackDouble(param1:Boolean) : void
      {
         SharedManager.Instance.isRemindSnowPackDouble = param1;
      }
      
      public function getRemindSnowPackDouble() : Boolean
      {
         return SharedManager.Instance.isRemindSnowPackDouble;
      }
      
      public function checkMoney(param1:int) : Boolean
      {
         this._money = param1;
         if(PlayerManager.Instance.Self.Money < param1)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         this.disposeEnterIcon();
      }
      
      public function disposeEnterIcon() : void
      {
         if(Boolean(this._makingSnoFrame))
         {
            this._makingSnoFrame.dispose();
            this._makingSnoFrame = null;
         }
         if(Boolean(this._chooseRoomFrame))
         {
            this._chooseRoomFrame.dispose();
            this._chooseRoomFrame = null;
         }
         if(Boolean(this._snowPackDoubleFrame))
         {
            this._snowPackDoubleFrame.dispose();
            this._snowPackDoubleFrame = null;
         }
         HallIconManager.instance.updateSwitchHandler(HallIconType.CHRISTMAS,false);
      }
      
      public function returnComponentBnt(param1:BaseButton, param2:String) : Component
      {
         var _loc3_:Component = null;
         _loc3_ = new Component();
         _loc3_.tipData = param2;
         _loc3_.tipDirctions = "0,1,2";
         _loc3_.tipStyle = "ddt.view.tips.OneLineTip";
         _loc3_.tipGapH = 20;
         _loc3_.width = param1.width;
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         param1.x = 0;
         param1.y = 0;
         _loc3_.addChild(param1);
         return _loc3_;
      }
      
      public function exitGame() : void
      {
         GameInSocketOut.sendGamePlayerExit();
      }
      
      public function CanGetGift(param1:int) : Boolean
      {
         return (ChristmasManager.instance.model.awardState >> param1 & 1) == 0;
      }
      
      public function get model() : ChristmasModel
      {
         return this._model;
      }
      
      public function get mapPath() : String
      {
         return this._mapPath;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
