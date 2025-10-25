package ddt.manager
{
   import baglocked.data.BagLockedEvent;
   import boguAdventure.model.BoguAdventureType;
   import chickActivation.ChickActivationType;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.data.ConsumeRankEvent;
   import ddt.data.socket.*;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.view.CheckCodeFrame;
   import entertainmentMode.data.EntertainmentPackageType;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flowerGiving.data.FlowerGivingType;
   import flowerGiving.events.FlowerGivingEvent;
   import growthPackage.GrowthPackageType;
   import halloween.data.HalloweenType;
   import kingDivision.data.KingDivisionPackageType;
   import kingDivision.event.KingDivisionEvent;
   import labyrinth.data.LabyrinthPackageType;
   import littleGame.LittleGamePacketQueue;
   import littleGame.data.LittleGamePackageInType;
   import littleGame.events.LittleGameSocketEvent;
   import magicStone.data.MagicStoneEvent;
   import magicStone.data.MagicStoneType;
   import newChickenBox.model.NewChickenBoxPackageType;
   import petsBag.controller.PetBagController;
   import playerDress.data.PlayerDressEvent;
   import playerDress.data.PlayerDressType;
   import quest.TrusteeshipPackageType;
   import ringStation.event.RingStationEvent;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageIn;
   import road7th.comm.SocketEvent;
   import room.transnational.TransnationalPackageType;
   import worldboss.model.WorldBossPackageType;
   
   public class SocketManager extends EventDispatcher
   {
      
      private static var _instance:SocketManager;
      
      public static const PACKAGE_CONTENT_START_INDEX:int = 20;
      
      private var _socket:ByteSocket;
      
      private var _out:GameSocketOut;
      
      private var _isLogin:Boolean;
      
      public function SocketManager()
      {
         super();
         this._socket = new ByteSocket();
         this._socket.addEventListener(Event.CONNECT,this.__socketConnected);
         this._socket.addEventListener(Event.CLOSE,this.__socketClose);
         this._socket.addEventListener(SocketEvent.DATA,this.__socketData);
         this._socket.addEventListener(ErrorEvent.ERROR,this.__socketError);
         this._out = new GameSocketOut(this._socket);
      }
      
      public static function get Instance() : SocketManager
      {
         if(_instance == null)
         {
            _instance = new SocketManager();
         }
         return _instance;
      }
      
      public function set isLogin(param1:Boolean) : void
      {
         this._isLogin = param1;
      }
      
      public function get isLogin() : Boolean
      {
         return this._isLogin;
      }
      
      public function get socket() : ByteSocket
      {
         return this._socket;
      }
      
      public function get out() : GameSocketOut
      {
         return this._out;
      }
      
      public function connect(param1:String, param2:Number) : void
      {
         this._socket.connect(param1,param2);
      }
      
      private function __socketConnected(param1:Event) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONNECT_SUCCESS));
         this.out.sendLogin(PlayerManager.Instance.Account);
      }
      
      private function __socketClose(param1:Event) : void
      {
         LeavePageManager.forcedToLoginPath(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
         this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
      }
      
      private function __socketError(param1:ErrorEvent) : void
      {
         this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.false"));
         CheckCodeFrame.Instance.close();
         ServerManager.Instance.refreshFlag = false;
      }
      
      private function __systemAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
         _loc2_.dispose();
         if(Boolean(_loc2_.parent))
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      public function testWishBead() : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP));
      }
      
      private function __socketData(param1:SocketEvent) : void
      {
         var pkg:PackageIn = null;
         var type:int = 0;
         var msg:String = null;
         var systemAlert:BaseAlerFrame = null;
         var event:SocketEvent = param1;
         try
         {
            pkg = event.data;
            switch(pkg.code)
            {
               case ePackageType.RSAKEY:
                  break;
               case ePackageType.SYS_MESSAGE:
                  type = pkg.readInt();
                  msg = pkg.readUTF();
                  if(msg == "" || msg == null)
                  {
                     return;
                  }
                  if(msg.substr(0,5) == "撮合成功!")
                  {
                     StateManager.getInGame_Step_2 = true;
                  }
                  switch(type)
                  {
                     case 0:
                        if(msg == "MissionLucreDecrease")
                        {
                           msg = LanguageMgr.GetTranslation("MissionLucreDecrease.info");
                        }
                        MessageTipManager.getInstance().show(msg,0,true);
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 1:
                        MessageTipManager.getInstance().show(msg,0,true);
                        ChatManager.Instance.sysChatRed(msg);
                        break;
                     case 2:
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 3:
                        ChatManager.Instance.sysChatRed(msg);
                        break;
                     case 4:
                        systemAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                        systemAlert.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
                        break;
                     case 5:
                        ChatManager.Instance.sysChatYellow(msg);
                        break;
                     case 6:
                        ChatManager.Instance.sysChatLinkYellow(msg);
                        break;
                     case 7:
                        PetBagController.instance().pushMsg(msg);
                  }
                  break;
               case ePackageType.OLD_PLAYER_LOGIN:
                  ChatManager.Instance.sendOldPlayerLoginPrompt(pkg);
                  break;
               case ePackageType.RING_STATION:
                  this.setRingStationInfo(pkg);
                  break;
               case ePackageType.DAILY_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_AWARD,pkg));
                  break;
               case ePackageType.WONDERFUL_ACTIVITY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WONDERFUL_ACTIVITY,pkg));
                  break;
               case ePackageType.WONDERFUL_ACTIVITY_INIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WONDERFUL_ACTIVITY_INIT,pkg));
                  break;
               case ePackageType.LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN,pkg));
                  break;
               case ePackageType.KIT_USER:
                  this.kitUser(pkg.readUTF());
                  break;
               case ePackageType.UPDATE_PLAYER_PROPERTY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY,pkg));
                  break;
               case ePackageType.PING:
                  this.out.sendPint();
                  break;
               case ePackageType.EDITION_ERROR:
                  this.cleanLocalFile(pkg.readUTF());
                  break;
               case ePackageType.WISHBEADEQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP,pkg));
                  break;
               case ePackageType.BAG_LOCKED:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAG_LOCKED,pkg));
                  break;
               case ePackageType.SCENE_ADD_USER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_ADD_USER,pkg));
                  break;
               case ePackageType.SCENE_REMOVE_USER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_REMOVE_USER,pkg));
                  break;
               case ePackageType.GAME_ROOM:
                  this.createGameRoomEvent(pkg);
                  break;
               case ePackageType.GAME_CMD:
                  this.createGameEvent(pkg);
                  break;
               case ePackageType.FIGHTFOOTBALLTIMETAKEOUT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_CMD,pkg));
                  break;
               case ePackageType.FIGHTFOOTBALLTIMEACTIVE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_ACTIVE,pkg));
                  break;
               case ePackageType.SCENE_CHANNEL_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHANNEL_CHANGE,pkg));
                  break;
               case ePackageType.LEAGUE_START_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE,pkg));
                  break;
               case ePackageType.GAME_MISSION_START:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_START,pkg));
                  break;
               case ePackageType.SCENE_CHAT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHAT,pkg));
                  break;
               case ePackageType.SCENE_FACE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_FACE,pkg));
                  break;
               case ePackageType.DELETE_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_GOODS,pkg));
                  break;
               case ePackageType.BUY_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_GOODS,pkg));
                  break;
               case ePackageType.CHANGE_PLACE_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_GOODS_PLACE,pkg));
                  break;
               case ePackageType.CHAIN_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAIN_EQUIP,pkg));
                  break;
               case ePackageType.UNCHAIN_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UNCHAIN_EQUIP,pkg));
                  break;
               case ePackageType.SEND_MAIL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_EMAIL,pkg));
                  break;
               case ePackageType.DELETE_MAIL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_MAIL,pkg));
                  break;
               case ePackageType.GET_MAIL_ATTACHMENT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,pkg));
                  break;
               case ePackageType.MAIL_CANCEL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_CANCEL,pkg));
                  break;
               case ePackageType.SEll_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELL_GOODS,pkg));
                  break;
               case ePackageType.UPDATE_COUPONS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_COUPONS,pkg));
                  break;
               case ePackageType.ITEM_STORE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STORE,pkg));
                  break;
               case ePackageType.BATTLE_GROUND:
                  this.battleGoundHander(pkg);
                  break;
               case ePackageType.UPDATE_PRIVATE_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,pkg));
                  break;
               case ePackageType.UPDATE_PLAYER_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,pkg));
                  break;
               case ePackageType.GRID_PROP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_PROP,pkg));
                  break;
               case ePackageType.EQUIP_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EQUIP_CHANGE,pkg));
                  break;
               case ePackageType.GRID_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_GOODS,pkg));
                  break;
               case ePackageType.NETWORK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NETWORK,pkg));
                  break;
               case ePackageType.GAME_TAKE_TEMP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_TEMP,pkg));
                  break;
               case ePackageType.SCENE_USERS_LIST:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_USERS_LIST,pkg));
                  break;
               case ePackageType.GAME_INVITE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_INVITE,pkg));
                  break;
               case ePackageType.S_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.S_BUGLE,pkg));
                  break;
               case ePackageType.B_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.B_BUGLE,pkg));
                  break;
               case ePackageType.C_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.C_BUGLE,pkg));
                  break;
               case ePackageType.DEFY_AFFICHE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEFY_AFFICHE,pkg));
                  break;
               case ePackageType.CHAT_PERSONAL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_PERSONAL,pkg));
                  break;
               case ePackageType.AREA_CHAT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AREA_CHAT,pkg));
                  break;
               case ePackageType.ITEM_COMPOSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_COMPOSE,pkg));
                  break;
               case ePackageType.ITEM_ADVANCE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_ADVANCE,pkg));
                  break;
               case ePackageType.ITEM_STRENGTHEN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STRENGTH,pkg));
                  break;
               case ePackageType.ITEM_TRANSFER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_TRANSFER,pkg));
                  break;
               case ePackageType.ITEM_FUSION_PREVIEW:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,pkg));
                  break;
               case ePackageType.ITEM_REFINERY_PREVIEW:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,pkg));
                  break;
               case ePackageType.RUNE_COMMAND:
                  this.handleBeadPkg(pkg);
                  break;
               case ePackageType.OPEN_FIVE_SIX_HOLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,pkg));
                  break;
               case ePackageType.ITEM_FUSION:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION,pkg));
                  break;
               case ePackageType.QUEST_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_UPDATE,pkg));
                  break;
               case ePackageType.QUSET_OBTAIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_OBTAIN,pkg));
                  break;
               case ePackageType.QUEST_CHECK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_CHECK,pkg));
                  break;
               case ePackageType.QUEST_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_FINISH,pkg));
                  break;
               case ePackageType.ITEM_OBTAIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OBTAIN,pkg));
                  break;
               case ePackageType.ITEM_CONTINUE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_CONTINUE,pkg));
                  break;
               case ePackageType.SYS_DATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_DATE,pkg));
                  break;
               case ePackageType.ITEM_EQUIP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EQUIP,pkg));
                  break;
               case ePackageType.MATE_ONLINE_TIME:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MATE_ONLINE_TIME,pkg));
                  break;
               case ePackageType.SYS_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_NOTICE,pkg));
                  break;
               case ePackageType.MAIL_RESPONSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_RESPONSE,pkg));
                  break;
               case ePackageType.AUCTION_REFRESH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_REFRESH,pkg));
                  break;
               case ePackageType.CHECK_CODE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHECK_CODE,pkg));
                  break;
               case ePackageType.QUEST_ONEKEYFINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_ONEKEYFINISH,pkg));
                  break;
               case ePackageType.SEARCH_GOODS:
                  this.buriedEvents(pkg);
                  break;
               case ePackageType.IM_CMD:
                  this.createIMEvent(pkg);
                  break;
               case ePackageType.ELITEGAME:
                  this.createEliteGameEvent(pkg);
                  break;
               case ePackageType.CONSORTIA_CMD:
                  this.createConsortiaEvent(pkg);
                  break;
               case ePackageType.CONSORTIA_RESPONSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RESPONSE,pkg));
                  break;
               case ePackageType.CONSORTIA_MAIL_MESSAGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,pkg));
                  break;
               case ePackageType.CID_CHECK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CID_CHECK,pkg));
                  break;
               case ePackageType.ENTHRALL_LIGHT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTHRALL_LIGHT,pkg));
                  break;
               case ePackageType.BUFF_OBTAIN:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
                     break;
                  }
                  QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
                  break;
               case ePackageType.BUFF_ADD:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
                     break;
                  }
                  QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
                  break;
               case ePackageType.BUFF_UPDATE:
                  if(pkg.clientId == PlayerManager.Instance.Self.ID)
                  {
                     dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
                     break;
                  }
                  QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
                  break;
               case ePackageType.USE_COLOR_CARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_CARD,pkg));
                  break;
               case ePackageType.AUCTION_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_UPDATE,pkg));
                  break;
               case ePackageType.GOODS_PRESENT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_PRESENT,pkg));
                  break;
               case ePackageType.GOODS_COUNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_COUNT,pkg));
                  break;
               case ePackageType.UPDATE_SHOP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,pkg));
                  break;
               case ePackageType.MARRYINFO_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_GET,pkg));
                  break;
               case ePackageType.MARRY_STATUS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_STATUS,pkg));
                  break;
               case ePackageType.MARRY_ROOM_CREATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_CREATE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,pkg));
                  break;
               case ePackageType.MARRY_SCENE_LOGIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_LOGIN,pkg));
                  break;
               case ePackageType.PLAYER_ENTER_MARRY_ROOM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,pkg));
                  break;
               case ePackageType.PLAYER_EXIT_MARRY_ROOM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,pkg));
                  break;
               case ePackageType.MARRY_APPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY,pkg));
                  break;
               case ePackageType.MARRY_APPLY_REPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY_REPLY,pkg));
                  break;
               case ePackageType.DIVORCE_APPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIVORCE_APPLY,pkg));
                  break;
               case ePackageType.MARRY_ROOM_STATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_STATE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_DISPOSE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,pkg));
                  break;
               case ePackageType.MARRY_ROOM_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,pkg));
                  break;
               case ePackageType.MARRYPROP_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYPROP_GET,pkg));
                  break;
               case ePackageType.MARRY_CMD:
                  this.createChurchEvent(pkg);
                  break;
               case ePackageType.AMARRYINFO_REFRESH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AMARRYINFO_REFRESH,pkg));
                  break;
               case ePackageType.MARRYINFO_ADD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_ADD,pkg));
                  break;
               case ePackageType.LINKREQUEST_GOODS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LINKGOODSINFO_GET,pkg));
                  break;
               case CrazyTankPackageType.INSUFFICIENT_MONEY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INSUFFICIENT_MONEY,pkg));
                  break;
               case ePackageType.GET_ITEM_MESS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_ITEM_MESS,pkg));
                  break;
               case ePackageType.USER_ANSWER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_ANSWER,pkg));
                  break;
               case ePackageType.MARRY_SCENE_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_CHANGE,pkg));
                  break;
               case ePackageType.HOTSPRING_CMD:
                  this.createHotSpringEvent(pkg);
                  break;
               case ePackageType.HOTSPRING_ROOM_CREATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ENTER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ADD_OR_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_REMOVE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_LIST_GET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_ADD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,pkg));
                  break;
               case ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,pkg));
                  break;
               case ePackageType.GET_TIME_BOX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX,pkg));
                  break;
               case ePackageType.GET_TIME_BOX_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX_INFO,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,pkg));
                  break;
               case ePackageType.ACHIEVEMENT_INIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_INIT,pkg));
                  break;
               case ePackageType.ACHIEVEMENTDATA_INIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,pkg));
                  break;
               case ePackageType.USER_RANK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RANK,pkg));
                  break;
               case ePackageType.FIGHT_NPC:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_NPC,pkg));
                  break;
               case ePackageType.LOTTERY_ALTERNATE_LIST:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,pkg));
                  break;
               case ePackageType.LOTTERY_GET_ITEM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_GET_ITEM,pkg));
                  break;
               case ePackageType.CADDY_GET_AWARDS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_AWARDS,pkg));
                  break;
               case ePackageType.CADDY_CONVERTED_ALL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_CONVERTED,pkg));
                  break;
               case ePackageType.CADDY_EXCHANGE_ALL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_EXCHANGEALL,pkg));
                  break;
               case ePackageType.CADDY_GET_BADLUCK:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_BADLUCK,pkg));
                  break;
               case ePackageType.LOOKUP_EFFORT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOOKUP_EFFORT,pkg));
                  break;
               case ePackageType.LOTTERY_FINISH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OFFERPACK_COMPLETE,pkg));
                  break;
               case ePackageType.QQTIPS_GET_INFO:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QQTIPS_GET_INFO,pkg));
                  break;
               case ePackageType.EDICTUM_GET_SERVION:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EDICTUM_GET_VERSION,pkg));
                  break;
               case ePackageType.FEEDBACK_REPLY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FEEDBACK_REPLY,pkg));
                  break;
               case ePackageType.ANSWERBOX_QUESTIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ANSWERBOX_QUESTIN,pkg));
                  break;
               case ePackageType.VIP_RENEWAL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_IS_OPENED,pkg));
                  break;
               case ePackageType.USE_CHANGE_COLOR_SHELL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_SHELL,pkg));
                  break;
               case AcademyPackageType.ACADEMY_FATHER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER,pkg));
                  break;
               case ePackageType.ITEM_OPENUP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OPENUP,pkg));
                  break;
               case ePackageType.GET_DYNAMIC:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_DYNAMIC,pkg));
                  break;
               case ePackageType.USER_GET_GIFTS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_GET_GIFTS,pkg));
                  break;
               case ePackageType.USER_SEND_GIFTS:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_SEND_GIFTS,pkg));
                  break;
               case ePackageType.USER_UPDATE_GIFT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_UPDATE_GIFT,pkg));
                  break;
               case ePackageType.WEEKLY_CLICK_CNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,pkg));
                  break;
               case ePackageType.USER_RELOAD_GIFT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RELOAD_GIFT,pkg));
                  break;
               case ePackageType.ACTIVE_PULLDOWN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_PULLDOWN,pkg));
                  break;
               case ePackageType.CARDS_SOUL:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_SOUL,pkg));
                  break;
               case ePackageType.CARDS_DATA:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_DATA,pkg));
                  break;
               case ePackageType.CARD_RESET:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARD_RESET,pkg));
                  break;
               case ePackageType.CARDS_SLOT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_CARD,pkg));
                  break;
               case ePackageType.GET_PLAYER_CARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_PLAYER_DATA,pkg));
                  break;
               case ePackageType.LOAD_RESOURCE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,pkg));
                  break;
               case ePackageType.CHAT_FILTERING_FRIENDS_SHARE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,pkg));
                  break;
               case ePackageType.LOTTERY_OPEN_BOX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_OPNE,pkg));
                  break;
               case ePackageType.DAILYRECORD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILYRECORD,pkg));
                  break;
               case ePackageType.TEXP:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TEXP,pkg));
                  break;
               case ePackageType.LITTLEGAME_COMMAND:
                  this.createLittleGameEvent(pkg);
                  break;
               case ePackageType.LITTLEGAME_ACTIVED:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LITTLEGAME_ACTIVED,pkg));
                  break;
               case ePackageType.USER_LUCKYNUM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_LUCKYNUM,pkg));
                  break;
               case ePackageType.LEFT_GUN_ROULETTE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE,pkg));
                  break;
               case ePackageType.LEFT_GUN_ROULETTE_START:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,pkg));
                  break;
               case ePackageType.OPTION_CHANGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPTION_CHANGE,pkg));
                  break;
               case ePackageType.LOTTERY_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKY_LOTTERY,pkg));
                  break;
               case ePackageType.CAN_CARD_LOTTERY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,pkg));
                  break;
               case ePackageType.PET:
                  this.handlePetPkg(pkg);
                  break;
               case ePackageType.FARM:
                  this.handFarmPkg(pkg);
                  break;
               case ePackageType.USE_CHANGE_SEX:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_SEX,pkg));
                  break;
               case ePackageType.WORLDBOSS_CMD:
                  this.createWorldBossEvent(pkg);
                  break;
               case ePackageType.LUCKSTONE_CONFIG:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKLYSTONE_ACTIVITY,pkg));
                  break;
               case ePackageType.RELOAD_XML:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.RELOAD_XML,pkg));
               case ePackageType.NEWCHICKENBOX_SYS:
                  this.createNewChickenBoxEvent(pkg);
                  break;
               case ePackageType.DICE_SYSTEM:
                  this.createDiceSystemEvent(pkg);
                  break;
               case ePackageType.TOTEM:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TOTEM,pkg));
                  break;
               case ePackageType.NEWCHICKENBOX_SYS:
                  this.createNewChickenBoxEvent(pkg);
                  break;
               case ePackageType.FIGHT_SPIRIT:
                  this.fightSpirit(pkg);
                  break;
               case ePackageType.LABYRINTH:
                  this.labyrinthPkg(pkg);
                  break;
               case ePackageType.LUCKSTONE_RANK_LIMIT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKSTONE_RANK_LIMIT,pkg));
                  break;
               case ePackageType.RECHARGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OPEN,pkg));
                  break;
               case ePackageType.FIRSTRECHARGE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIRSTRECHARGE_OPEN,pkg));
                  break;
               case ePackageType.HONOR_UP_COUNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HONOR_UP_COUNT,pkg));
                  break;
               case ePackageType.KING_BLESS_MAIN:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KING_BLESS_MAIN,pkg));
                  break;
               case ePackageType.KING_BLESS_UPDATE_BUFF_DATA:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KING_BLESS_UPDATE_BUFF_DATA,pkg));
                  break;
               case ePackageType.TRUSTEESHIP:
                  this.trusteeshipPkg(pkg);
                  break;
               case ePackageType.TREASURE_IN:
                  this.treasurePkgHandler(pkg);
                  break;
               case ePackageType.AREA_INFO_UPDATE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AREA_INFO_UPDATE,pkg));
                  break;
               case ePackageType.EVERYDAY_ACTIVEPOINT:
                  this.dayActivity(pkg);
                  break;
               case ePackageType.LATENT_ENERGY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LATENT_ENERGY,pkg));
                  break;
               case ePackageType.NECKLACE_STRENGTH:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NECKLACE_STRENGTH,pkg));
                  break;
               case ePackageType.CONSORTIA_BATTLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BATTLE,pkg));
                  break;
               case ePackageType.DRAGON_BOAT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DRAGON_BOAT,pkg));
                  break;
               case ePackageType.REQUEST_FRIENDS_PAY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REQUEST_FRIENDS_PAY,pkg));
                  break;
               case ePackageType.CAMPBATTLE:
                  this.CampBattleHander(pkg);
                  break;
               case ePackageType.OLDPLAYER_REGRESS:
                  this.oldPlayerRegressHandle(pkg);
                  break;
               case ePackageType.FIND_BACK_INCOME:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.Find_Back_Income,pkg));
                  break;
               case ePackageType.GROUP_PURCHASE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GROUP_PURCHASE,pkg));
                  break;
               case ePackageType.UPDATE_LOGIN_FIGHTPOWER:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_LOGIN_FIGHTPOWER,pkg));
                  break;
               case ePackageType.SEVEN_DOUBLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVEN_DOUBLE_ESCORT,pkg));
                  break;
               case ePackageType.SEPARATE_ACTIVITY:
                  this.separateActivityHandler(pkg);
                  break;
               case ePackageType.MISSION_ENERGY:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_ENERGY,pkg));
                  break;
               case ePackageType.BAGLOCK_PWD:
                  dispatchEvent(new BagLockedEvent(BagLockedEvent.GET_BACK_LOCK_PWD,pkg));
                  break;
               case ePackageType.DEL_QUESTION:
                  dispatchEvent(new BagLockedEvent(BagLockedEvent.DEL_QUESTION,pkg));
                  break;
               case ePackageType.TRANSNATIONALFIGHT_ACTIVED:
                  this.transnationalHandle(pkg);
                  break;
               case ePackageType.ACTIVITY_SYSTEM:
                  this.activitySystem(pkg);
                  break;
               case ePackageType.UPDATE_SHOPLIMIT_COUNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_SHOPLIMIT_COUNT,pkg));
                  break;
               case ePackageType.ACCUMULATIVELOGIN_AWARD:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACCUMULATIVELOGIN_AWARD,pkg));
                  break;
               case ePackageType.AVATAR_COLLECTION:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AVATAR_COLLECTION,pkg));
                  break;
               case ePackageType.PLAYER_DRESS:
                  this.playerDressHandler(pkg);
                  break;
               case ePackageType.PEER_ID:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PEER_ID,pkg));
                  break;
               case ePackageType.FLOWER_GIVING:
                  this.flowerGivingHandler(pkg);
                  break;
               case ePackageType.MAGIC_STONE:
                  this.magicStoneHandler(pkg);
                  break;
               case ePackageType.CONSUME_RANK:
                  dispatchEvent(new ConsumeRankEvent(ConsumeRankEvent.UPDATE,pkg));
                  break;
               case ePackageType.FAST_AUCTION_SMALL_BUGLE:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FAST_AUCTION_BUGLE,pkg));
                  break;
               case ePackageType.KING_DIVISION:
                  this.kingDivisionHandler(pkg);
                  break;
               case ePackageType.SHOP_BUYLIMITEDCOUNT:
                  dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOP_BUYLIMITEDCOUNT,pkg));
            }
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendErrorMsg(err.message + "\r\n" + err.getStackTrace());
         }
      }
      
      private function magicStoneHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case MagicStoneType.MAGIC_STONE_SCORE:
               dispatchEvent(new MagicStoneEvent(MagicStoneEvent.MAGIC_STONE_SCORE,param1));
               break;
            case MagicStoneType.UPDATE_REMAIN_COUNT:
               dispatchEvent(new MagicStoneEvent(MagicStoneEvent.UPDATE_REMAIN_COUNT,param1));
         }
      }
      
      private function kingDivisionHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case KingDivisionPackageType.ACTIVITY_OPEN:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.ACTIVITY_OPEN,param1));
               break;
            case KingDivisionPackageType.CONSORTIA_MATCH_INFO:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_INFO,param1));
               break;
            case KingDivisionPackageType.CONSORTIA_MATCH_SCORE:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_SCORE,param1));
               break;
            case KingDivisionPackageType.CONSORTIA_MATCH_RANK:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_RANK,param1));
               break;
            case KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK,param1));
               break;
            case KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK_INFO:
               dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK_INFO,param1));
         }
      }
      
      private function flowerGivingHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case FlowerGivingType.GIVE_FLOWER:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GIVE_FLOWER,param1));
               break;
            case FlowerGivingType.FLOWER_FALL:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.FLOWER_FALL,param1));
               break;
            case FlowerGivingType.GET_RECORD:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_RECORD,param1));
               break;
            case FlowerGivingType.GET_FLOWER_RANK:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_FLOWER_RANK,param1));
               break;
            case FlowerGivingType.GET_REWARD:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_REWARD,param1));
               break;
            case FlowerGivingType.REWARD_INFO:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.REWARD_INFO,param1));
               break;
            case FlowerGivingType.FLOWER_GIVING_OPEN:
               dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.FLOWER_GIVING_OPEN,param1));
         }
      }
      
      private function activitySystem(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         if(_loc2_ > -1 && _loc2_ <= 6)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PYRAMID_SYSTEM,param1,_loc2_));
         }
         else if(_loc2_ >= 7 && _loc2_ <= 13)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_SYSTEM,param1,_loc2_));
         }
         else if(_loc2_ >= 15 && _loc2_ <= 31)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_SYSTEM,param1,_loc2_));
         }
         else if(_loc2_ >= 48 && _loc2_ <= 57)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SUPER_WINNER,param1,_loc2_));
         }
         else if(_loc2_ >= 86 && _loc2_ <= 88)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GODS_ROADS,param1,_loc2_));
         }
         else if(_loc2_ >= 32 && _loc2_ <= 36)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_BEGIN,param1,_loc2_));
         }
         else if(_loc2_ >= 37 && _loc2_ <= 45)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_BEGIN,param1,_loc2_));
         }
         else if(_loc2_ >= 64 && _loc2_ <= 66)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,param1,_loc2_));
         }
         else if(_loc2_ >= 80 && _loc2_ <= 85)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVENDAYTARGET_GODSROADS,param1,_loc2_));
         }
         else if(_loc2_ >= 96 && _loc2_ <= 98)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVENDAYTARGET_NEWPLAYERREWARD,param1,_loc2_));
         }
         else if(_loc2_ >= 74 && _loc2_ <= 76)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_BEGIN,param1,_loc2_));
         }
         else if(_loc2_ >= 102 && _loc2_ <= 108)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TREASUREPUZZLE_SYSTEM,param1,_loc2_));
         }
         else if(_loc2_ >= 112 && _loc2_ <= 114)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WITCHBLESSING_DATA,param1,_loc2_));
         }
         else if(_loc2_ == HalloweenType.OPEN || _loc2_ == HalloweenType.ENTER)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HALLOWEEN,param1,_loc2_));
         }
         else if(_loc2_ == EntertainmentPackageType.BUY_ICON || _loc2_ == EntertainmentPackageType.GET_SCORE)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTERTAINMENT,param1,_loc2_));
         }
         else if(_loc2_ >= BoguAdventureType.ACTIVITY_OPEN && _loc2_ <= BoguAdventureType.OUT_BOGUADVENTURE || _loc2_ == BoguAdventureType.FREE_RESET)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BOGU_ADVENTURE,param1,_loc2_));
         }
      }
      
      private function activityPackageHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         if(_loc2_ == GrowthPackageType.GROWTHPACKAGE)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GROWTHPACKAGE,param1));
         }
         else if(_loc2_ == ChickActivationType.CHICKACTIVATION)
         {
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHICKACTIVATION_SYSTEM,param1));
         }
      }
      
      private function CSMTimeBoxHandler(param1:PackageIn) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_CSM_TIME_BOX,param1));
      }
      
      private function CampBattleHander(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case CampPackageType.ADD_ROLE_LIST:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ADD_ROLE_LIST_EVENT,param1));
               break;
            case CampPackageType.ADD_MONSTER_LIST:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ADD_MONSTER_LIST_EVENT,param1));
               break;
            case CampPackageType.INIT_SECEN:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.INIT_SECEN_EVENT,param1));
               break;
            case CampPackageType.ROLE_MOVE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ROLE_MOVE_EVENT,param1));
               break;
            case CampPackageType.PLAYER_STATE_CHANGE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.PLAYER_STATE_CHANGE_EVENT,param1));
               break;
            case CampPackageType.MONSTER_STATE_CHANGE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.MONSTER_STATE_CHANGE_EVENT,param1));
               break;
            case CampPackageType.REMOVE_ROLE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.REMOVE_ROLE_EVENT,param1));
               break;
            case CampPackageType.CAPTURE_MAP:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.CAPTURE_MAP_EVENT,param1));
               break;
            case CampPackageType.WIN_COUNT_PTP:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.WIN_COUNT_PTP_EVENT,param1));
               break;
            case CampPackageType.UPDATE_SCORE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.UPDATE_SCORE_EVENT,param1));
               break;
            case CampPackageType.PER_SCORE_RANK:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.PER_SCORE_RANK_EVENT,param1));
               break;
            case CampPackageType.CAMP_SOCER_RANK:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.CAMP_SOCER_RANK_EVENT,param1));
               break;
            case CampPackageType.ACTION_ISOPEN:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ACTION_ISOPEN_EVENT,param1));
               break;
            case CampPackageType.DOOR_STATUS:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.DOOR_STATUS_EVENT,param1));
               break;
            case CampPackageType.OUT_CAMPBATTLE:
               dispatchEvent(new CrazyTankSocketEvent(CampPackageType.OUT_CAMPBATTLE_EVENT,param1));
         }
      }
      
      private function transnationalHandle(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case TransnationalPackageType.OPEN:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALFIGHT_ACTIVED,param1));
               break;
            case TransnationalPackageType.OVER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALfIGHT_OVER));
               break;
            case TransnationalPackageType.UPDATE_PLAYER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALFIGHT_PLAYERINFO,param1));
               break;
            case TransnationalPackageType.UPDATE_VALUE_REP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALSCORE_UPDATA,param1));
         }
      }
      
      private function treasurePkgHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         switch(_loc2_)
         {
            case TreasurePackageType.IN_TREASURE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_TREASURE,param1));
               break;
            case TreasurePackageType.ARRANGE_FRIEND_FARM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,param1));
               break;
            case TreasurePackageType.END_TREASURE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.END_TREASURE,param1));
               break;
            case TreasurePackageType.DIG:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIG,param1));
               break;
            case TreasurePackageType.LOGIN_ABOUT_TREASURE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN_ABOUT_TREASURE,param1));
               break;
            case TreasurePackageType.BEREPAIR_FRIEND_FARM_SEND:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEREPAIR_FRIEND_FARM_SEND,param1));
               break;
            case TreasurePackageType.START_GAME:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.START_GAME_TREASURE,param1));
         }
      }
      
      private function battleGoundHander(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case BattleGoundPackageType.OPEN:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLE_OPEN,param1));
               break;
            case BattleGoundPackageType.OVER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLE_OVER,param1));
               break;
            case BattleGoundPackageType.UPDATE_VALUE_REQ:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLEDATA_UPDATA,param1));
               break;
            case BattleGoundPackageType.UPDATE_VALUE_REP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLEDATA_UPDATA_REALTIME,param1));
               break;
            case BattleGoundPackageType.UPDATE_PLAYER_DATA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DATA_UPDATA,param1));
         }
      }
      
      private function recharge(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case RechargePackageType.CUMULATECHARGE_DATA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_DATA,param1));
               break;
            case RechargePackageType.CUMULATECHARGE_OPEN:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OPEN,param1));
               break;
            case RechargePackageType.CUMULATECHARGE_OVER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OVER,param1));
               break;
            case RechargePackageType.GET_SPREE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_SPREE,param1));
         }
      }
      
      private function trusteeshipPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case TrusteeshipPackageType.START:
               dispatchEvent(new CrazyTankSocketEvent(TrusteeshipPackageType.START_EVENT,param1));
               break;
            case TrusteeshipPackageType.BUY_SPIRIT:
               dispatchEvent(new CrazyTankSocketEvent(TrusteeshipPackageType.BUY_SPIRIT_EVENT,param1));
         }
      }
      
      private function fightSpirit(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case FightSpiritPackageType.PLAYER_FIGHT_SPIRIT_UP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,param1));
               break;
            case FightSpiritPackageType.FIGHT_SPIRIT_INIT:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,param1));
         }
      }
      
      private function labyrinthPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case LabyrinthPackageType.REQUEST_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.REQUEST_UPDATE_EVENT,param1));
               break;
            case LabyrinthPackageType.PUSH_CLEAN_OUT_INFO:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.PUSH_CLEAN_OUT_INFO_EVENT,param1));
               break;
            case LabyrinthPackageType.CLEAN_OUT:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.CLEAN_OUT_EVENT,param1));
               break;
            case LabyrinthPackageType.TRY_AGAIN:
               dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.TRY_AGAIN_EVENT,param1));
         }
      }
      
      private function handFarmPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case FarmPackageType.PAY_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FIELD,param1));
               break;
            case FarmPackageType.GAIN_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAIN_FIELD,param1));
               break;
            case FarmPackageType.FRUSH_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRUSH_FIELD,param1));
               break;
            case FarmPackageType.ENTER_FARM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_FARM,param1));
               break;
            case FarmPackageType.GROW_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEEDING,param1));
               break;
            case FarmPackageType.COMPOSE_FOOD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.COMPOSE_FOOD,param1));
               break;
            case FarmPackageType.ACCELERATE_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DO_MATURE,param1));
               break;
            case FarmPackageType.HELPER_SWITCH_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_SWITCH,param1));
               break;
            case FarmPackageType.KILLCROP_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KILL_CROP,param1));
               break;
            case FarmPackageType.HELPER_PAY_FIELD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_PAY,param1));
               break;
            case FarmPackageType.EXIT_FARM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_FARM,param1));
               break;
            case FarmPackageType.FARM_LAND_INFO:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_LAND_INFO,param1));
         }
      }
      
      private function kitUser(param1:String) : void
      {
         this._socket.close();
         if(param1.indexOf(LanguageMgr.GetTranslation("tank.manager.SocketManager.copyRight")) != -1)
         {
            LoaderSavingManager.clearFiles("*.png");
         }
         LeavePageManager.forcedToLoginPath(param1);
      }
      
      private function errorAlert(param1:String) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),param1,"","",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
         _loc2_.moveEnable = false;
      }
      
      private function __onAlertClose(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
         if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
         {
            if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
            {
               if(PlayerManager.Instance.Self.IsFirst <= 1)
               {
                  ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"3");
               }
               else
               {
                  ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"1");
               }
            }
         }
         LeavePageManager.leaveToLoginPath();
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function cleanLocalFile(param1:String) : void
      {
         this._socket.close();
         LoaderSavingManager.clearFiles("*.png");
         this.errorAlert(param1);
      }
      
      private function createEliteGameEvent(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case EliteGamePackageType.ELITE_MATCH_TYPE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_TYPE,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_RANK_START:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_START,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_PLAYER_RANK:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_PLAYER_RANK,param1));
               break;
            case EliteGamePackageType.ELITE_MATCH_RANK_DETAIL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_DETAIL,param1));
         }
      }
      
      private function createIMEvent(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case IMPackageType.FRIEND_ADD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_ADD,param1));
               break;
            case IMPackageType.FRIEND_REMOVE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_REMOVE,param1));
               break;
            case IMPackageType.FRIEND_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_UPDATE,param1));
               break;
            case IMPackageType.FRIEND_STATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_STATE,param1));
               break;
            case IMPackageType.FRIEND_RESPONSE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_RESPONSE,param1));
               break;
            case IMPackageType.ONS_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONS_EQUIP,param1));
               break;
            case IMPackageType.SAME_CITY_FRIEND:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SAME_CITY_FRIEND,param1));
               break;
            case IMPackageType.ADD_CUSTOM_FRIENDS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS,param1));
               break;
            case IMPackageType.ONE_ON_ONE_TALK:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONE_ON_ONE_TALK,param1));
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function createChurchEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case ChurchPackageType.MOVE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.MOVE,param1);
               break;
            case ChurchPackageType.HYMENEAL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL,param1);
               break;
            case ChurchPackageType.CONTINUATION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINUATION,param1);
               break;
            case ChurchPackageType.INVITE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE,param1);
               break;
            case ChurchPackageType.USEFIRECRACKERS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USEFIRECRACKERS,param1);
               break;
            case ChurchPackageType.HYMENEAL_STOP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL_STOP,param1);
               break;
            case ChurchPackageType.GUNSALUTE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUNSALUTE,param1);
               break;
            case ChurchPackageType.MARRYROOMSENDGIFT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYROOMSENDGIFT,param1);
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function buriedEvents(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case SearchGoodsPackageType.PlayNowPosition:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayNowPosition,param1));
               break;
            case SearchGoodsPackageType.BackToStart:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BackToStart,param1));
               break;
            case SearchGoodsPackageType.QuitTakeCard:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QuitTakeCard,param1));
               break;
            case SearchGoodsPackageType.BeforeStep:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BeforeStep,param1));
               break;
            case SearchGoodsPackageType.FlopCard:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FlopCard,param1));
               break;
            case SearchGoodsPackageType.GetGoods:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GetGoods,param1));
               break;
            case SearchGoodsPackageType.PlayerEnter:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerEnter,param1));
               break;
            case SearchGoodsPackageType.PlayerRollDice:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerRollDice,param1));
               break;
            case SearchGoodsPackageType.PlayerUpgradeStartLevel:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerUpgradeStartLevel,param1));
               break;
            case SearchGoodsPackageType.ReachTheEnd:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ReachTheEnd,param1));
               break;
            case SearchGoodsPackageType.TakeCardResponse:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TakeCardResponse,param1));
               break;
            case SearchGoodsPackageType.RemoveEvent:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.RemoveEvent,param1));
               break;
            case SearchGoodsPackageType.OneStep:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OneStep,param1));
         }
      }
      
      private function createLittleGameEvent(param1:PackageIn) : void
      {
         var _loc3_:LittleGameSocketEvent = null;
         var _loc2_:int = param1.readByte();
         if(_loc2_ != LittleGamePackageInType.MOVE)
         {
         }
         switch(_loc2_)
         {
            case LittleGamePackageInType.WORLD_LIST:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.WORLD_LIST,param1);
               break;
            case LittleGamePackageInType.START_LOAD:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.START_LOAD,param1);
               dispatchEvent(_loc3_);
               return;
            case LittleGamePackageInType.ADD_SPRITE:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_SPRITE,param1);
               break;
            case LittleGamePackageInType.REMOVE_SPRITE:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.REMOVE_SPRITE,param1);
               break;
            case LittleGamePackageInType.GAME_START:
               LittleGamePacketQueue.Instance.reset();
               LittleGamePacketQueue.Instance.setLifeTime(param1.extend2);
               LittleGamePacketQueue.Instance.startup();
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.GAME_START,param1);
               break;
            case LittleGamePackageInType.MOVE:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.MOVE,param1);
               break;
            case LittleGamePackageInType.UPDATE_POS:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATE_POS,param1);
               break;
            case LittleGamePackageInType.ADD_OBJECT:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_OBJECT,param1);
               break;
            case LittleGamePackageInType.UPDATELIVINGSPROPERTY:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATELIVINGSPROPERTY,param1);
               break;
            case LittleGamePackageInType.DoAction:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.DOACTION,param1);
               break;
            case LittleGamePackageInType.DoMovie:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.DOMOVIE,param1);
               break;
            case LittleGamePackageInType.GETSCORE:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.GETSCORE,param1);
               break;
            case LittleGamePackageInType.INVOKE_OBJECT:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.INVOKE_OBJECT,param1);
               break;
            case LittleGamePackageInType.SETCLOCK:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.SETCLOCK,param1);
               break;
            case LittleGamePackageInType.PONG:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.PONG,param1);
               break;
            case LittleGamePackageInType.NET_DELAY:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.NET_DELAY,param1);
               break;
            case LittleGamePackageInType.KICK_PLAYE:
               _loc3_ = new LittleGameSocketEvent(LittleGameSocketEvent.KICK_PLAYE,param1);
         }
         if(Boolean(_loc3_))
         {
            LittleGamePacketQueue.Instance.addQueue(_loc3_);
         }
      }
      
      private function createHotSpringEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case HotSpringPackageType.TARGET_POINT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE,param1));
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_INVITE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_TIME_UPDATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,param1);
               break;
            case HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,param1);
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function createConsortiaEvent(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case ConsortiaPackageType.CONSORTIA_TRYIN:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CREATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CREATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DISBAND:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DISBAND,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_RENEGADE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RENEGADE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TRYIN_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TRYIN_DEL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_RICHES_OFFER:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_APPLY_STATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DUTY_DELETE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_DELETE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DUTY_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_INVITE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_INVITE_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_REMARK_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_CHAT:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAT,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_LEVEL_UP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_TASK_RELEASE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,param1));
               break;
            case ConsortiaPackageType.POLL_CANDIDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POLL_CANDIDATE,param1));
               break;
            case ConsortiaPackageType.SKILL_SOCKET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SKILL_SOCKET,param1));
               break;
            case ConsortiaPackageType.CONSORTION_MAIL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_MAIL,param1));
               break;
            case ConsortiaPackageType.BUY_BADGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_BADGE,param1));
               break;
            case ConsortiaPackageType.BOSS_OPEN_CLOSE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BOSS_OPEN_CLOSE,param1));
               break;
            case ConsortiaPackageType.CONSORTIA_BOSS_INFO:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,param1));
         }
      }
      
      private function createGameRoomEvent(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case GameRoomPackageType.GAME_ROOM_CREATE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_LOGIN:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_LOGIN,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_SETUP_CHANGE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_KICK:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_KICK,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_ADDPLAYER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_ENTER,param1));
               break;
            case GameRoomPackageType.SINGLE_ROOM_BEGIN:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLE_ROOM_BEGIN,param1));
               break;
            case GameRoomPackageType.GAME_TEAM:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TEAM,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_UPDATE_PLACE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_CANCEL:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_AWIT_CANCEL,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_STYLE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GMAE_STYLE_RECV,param1));
               break;
            case GameRoomPackageType.GAME_PICKUP_WAIT:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_RECV,param1));
               break;
            case GameRoomPackageType.ROOM_PASS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ROOMLIST_PASS,param1));
               break;
            case GameRoomPackageType.GAME_PLAYER_STATE_CHANGE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,param1));
               break;
            case GameRoomPackageType.ROOMLIST_UPDATE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_REMOVEPLAYER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_EXIT,param1));
               break;
            case GameRoomPackageType.GAME_ROOM_FULL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_FULL));
               break;
            case GameRoomPackageType.FAST_INVITE_CALL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FAST_INVITE_CALL,param1));
               break;
            case GameRoomPackageType.GAME_ENERGY_NOT_ENOUGH:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ENERGY_NOT_ENOUGH,param1));
               break;
            case GameRoomPackageType.LAST_MISSION_FOR_WARRIORSARENA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,param1));
               break;
            case GameRoomPackageType.PASSED_WARRIORSARENA_10:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PASSED_WARRIORSARENA_10,param1));
               break;
            case GameRoomPackageType.No_WARRIORSARENA_TICKET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.No_WARRIORSARENA_TICKET,param1));
         }
      }
      
      private function createGameEvent(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case CrazyTankPackageType.GEM_GLOW:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW,param1);
               break;
            case CrazyTankPackageType.SEND_PICTURE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF,param1);
               break;
            case CrazyTankPackageType.GAME_MISSION_PREPARE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE,param1);
               break;
            case CrazyTankPackageType.UPDATE_BOARD_STATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE,param1);
               break;
            case CrazyTankPackageType.ADD_MAP_THING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING,param1);
               break;
            case CrazyTankPackageType.BARRIER_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO,param1);
               break;
            case CrazyTankPackageType.GAME_CREATE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE,param1));
               break;
            case CrazyTankPackageType.START_GAME:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START,param1));
               break;
            case CrazyTankPackageType.WANNA_LEADER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER,param1);
               break;
            case CrazyTankPackageType.FIGHTFOOTBALLTIME_TAKEOUTALL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_TAKEOUTALL,param1);
               break;
            case CrazyTankPackageType.GAME_LOAD:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD,param1));
               break;
            case CrazyTankPackageType.GAME_MISSION_INFO:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO,param1));
               break;
            case CrazyTankPackageType.GAME_OVER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER,param1));
               break;
            case CrazyTankPackageType.MISSION_OVE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE,param1));
               break;
            case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,param1));
               break;
            case CrazyTankPackageType.IS_LAST_MISSION:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.IS_LAST_MISSION,param1));
               break;
            case CrazyTankPackageType.DIRECTION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED,param1);
               break;
            case CrazyTankPackageType.GUN_ROTATION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE,param1);
               break;
            case CrazyTankPackageType.FIRE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT,param1);
               break;
            case CrazyTankPackageType.SYNC_LIFETIME:
               QueueManager.setLifeTime(param1.readInt());
               break;
            case CrazyTankPackageType.MOVESTART:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE,param1);
               break;
            case CrazyTankPackageType.MOVESTOP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE,param1);
               break;
            case CrazyTankPackageType.TURN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE,param1);
               break;
            case CrazyTankPackageType.HEALTH:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD,param1);
               break;
            case CrazyTankPackageType.FROST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST,param1);
               break;
            case CrazyTankPackageType.NONOLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE,param1);
               break;
            case CrazyTankPackageType.CHANGE_STATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE,param1);
               break;
            case CrazyTankPackageType.PLAYER_PROPERTY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROPERTY,param1);
               break;
            case CrazyTankPackageType.INVINCIBLY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY,param1);
               break;
            case CrazyTankPackageType.VANE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE,param1);
               break;
            case CrazyTankPackageType.HIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE,param1);
               break;
            case CrazyTankPackageType.CARRY:
               break;
            case CrazyTankPackageType.BECKON:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON,param1);
               break;
            case CrazyTankPackageType.FIGHTPROP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP,param1);
               break;
            case CrazyTankPackageType.STUNT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT,param1);
               break;
            case CrazyTankPackageType.PROP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP,param1);
               break;
            case CrazyTankPackageType.DANDER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER,param1);
               break;
            case CrazyTankPackageType.REDUCE_DANDER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.REDUCE_DANDER,param1);
               break;
            case CrazyTankPackageType.LOAD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD,param1);
               break;
            case CrazyTankPackageType.ADDATTACK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK,param1);
               break;
            case CrazyTankPackageType.ADDBALL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL,param1);
               break;
            case CrazyTankPackageType.SHOOTSTRAIGHT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT,param1);
               break;
            case CrazyTankPackageType.SUICIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE,param1);
               break;
            case CrazyTankPackageType.FIRE_TAG:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,param1);
               break;
            case CrazyTankPackageType.CHANGE_BALL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL,param1);
               break;
            case CrazyTankPackageType.PICK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX,param1);
               break;
            case CrazyTankPackageType.BLAST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE,param1);
               break;
            case CrazyTankPackageType.BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT,param1);
               break;
            case CrazyTankPackageType.DISAPPEAR:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR,param1);
               break;
            case CrazyTankPackageType.TAKE_CARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT,param1);
               break;
            case CrazyTankPackageType.ADD_LIVING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING,param1);
               break;
            case CrazyTankPackageType.PLAY_MOVIE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE,param1);
               break;
            case CrazyTankPackageType.PLAY_SOUND:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND,param1);
               break;
            case CrazyTankPackageType.LOAD_RESOURCE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,param1);
               break;
            case CrazyTankPackageType.ADD_MAP_THINGS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS,param1);
               break;
            case CrazyTankPackageType.LIVING_BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT,param1);
               break;
            case CrazyTankPackageType.LIVING_FALLING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING,param1);
               break;
            case CrazyTankPackageType.LIVING_JUMP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP,param1);
               break;
            case CrazyTankPackageType.LIVING_MOVETO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO,param1);
               break;
            case CrazyTankPackageType.LIVING_SAY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY,param1);
               break;
            case CrazyTankPackageType.LIVING_RANGEATTACKING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING,param1);
               break;
            case CrazyTankPackageType.SHOW_CARDS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS,param1);
               break;
            case CrazyTankPackageType.FOCUS_ON_OBJECT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT,param1);
               break;
            case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,param1);
               break;
            case CrazyTankPackageType.PLAY_INFO_IN_GAME:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,param1);
               QueueManager.setLifeTime(param1.extend2);
               break;
            case CrazyTankPackageType.GAME_ROOM_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO,param1);
               break;
            case CrazyTankPackageType.ADD_TIP_LAYER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER,param1);
               break;
            case CrazyTankPackageType.PLAY_ASIDE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE,param1);
               break;
            case CrazyTankPackageType.FORBID_DRAG:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG,param1);
               break;
            case CrazyTankPackageType.TOP_LAYER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER,param1);
               break;
            case CrazyTankPackageType.CONTROL_BGM:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM,param1);
               break;
            case CrazyTankPackageType.USE_DEPUTY_WEAPON:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,param1);
               break;
            case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,param1);
               break;
            case CrazyTankPackageType.POPUP_QUESTION_FRAME:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,param1);
               break;
            case CrazyTankPackageType.PASS_STORY:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,param1);
               break;
            case CrazyTankPackageType.LIVING_BOLTMOVE:
               QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE,param1));
               break;
            case CrazyTankPackageType.CHANGE_TARGET:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET,param1);
               break;
            case CrazyTankPackageType.LIVING_SHOW_BLOOD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,param1);
               break;
            case CrazyTankPackageType.TEMP_STYLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_STYLE,param1);
               break;
            case CrazyTankPackageType.ACTION_MAPPING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTION_MAPPING,param1);
               break;
            case CrazyTankPackageType.FIGHT_ACHIEVEMENT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,param1);
               break;
            case CrazyTankPackageType.APPLYSKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.APPLYSKILL,param1);
               break;
            case CrazyTankPackageType.REMOVESKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.REMOVESKILL,param1);
               break;
            case CrazyTankPackageType.MAXFORCE_CHANGED:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGEMAXFORCE,param1);
               break;
            case CrazyTankPackageType.WIND_PIC:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WINDPIC,param1);
               break;
            case CrazyTankPackageType.SYSMESSAGE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAMESYSMESSAGE,param1);
               break;
            case CrazyTankPackageType.LIVING_CHAGEANGLE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_CHAGEANGLE,param1);
               break;
            case CrazyTankPackageType.PET_SKILL:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_PET_SKILL,param1);
               break;
            case CrazyTankPackageType.PET_BUFF:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BUFF,param1);
               break;
            case CrazyTankPackageType.PET_BEAT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BEAT,param1);
               break;
            case CrazyTankPackageType.PET_SKILL_CD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_SKILL_CD,param1);
               break;
            case CrazyTankPackageType.ADD_NEW_PLAYER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_NEW_PLAYER,param1);
               break;
            case CrazyTankPackageType.ADD_TERRACE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TERRACE,param1);
               break;
            case CrazyTankPackageType.WISHOFDD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHOFDD,param1);
               break;
            case CrazyTankPackageType.PICK_BOX:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.PICK_BOX,param1);
               break;
            case CrazyTankPackageType.SELECT_OBJECT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SELECT_OBJECT,param1);
               break;
            case CrazyTankPackageType.COLOR_CHANGE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,param1);
               break;
            case CrazyTankPackageType.GAME_TRUSTEESHIP:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TRUSTEESHIP,param1);
               break;
            case CrazyTankPackageType.SINGLEBATTLE_STARTMATCH:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLEBATTLE_STARTMATCH,param1);
               break;
            case CrazyTankPackageType.REVIVE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_REVIVE,param1);
               break;
            case CrazyTankPackageType.FIGHT_STATUS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_STATUS,param1);
               break;
            case CrazyTankPackageType.SKIPNEXT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SKIPNEXT,param1);
               break;
            case CrazyTankPackageType.CLEAR_DEBUFF:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CLEAR_DEBUFF,param1);
               break;
            case CrazyTankPackageType.ADD_ANIMATION:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_ANIMATION,param1);
               break;
            case CrazyTankPackageType.SINGBATTLE_FORCED_EXIT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGBATTLE_FORCED_EXIT,param1);
         }
         if(Boolean(_loc3_))
         {
            QueueManager.addQueue(_loc3_);
         }
      }
      
      private function handlePetPkg(param1:PackageIn) : void
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         switch(_loc2_)
         {
            case CrazyTankPackageType.UPDATE_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,param1));
               break;
            case CrazyTankPackageType.DEL_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEL_PET_EQUIP,param1));
               break;
            case CrazyTankPackageType.REFRESH_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REFRESH_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET,param1));
               break;
            case CrazyTankPackageType.ADD_PET_EQUIP:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,param1));
               break;
            case FarmPackageType.BUY_PET_EXP_ITEM:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,param1));
               break;
            case CrazyTankPackageType.PET_RISINGSTAR:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_RISINGSTAR,param1));
               break;
            case CrazyTankPackageType.PET_EVOLUTION:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_EVOLUTION,param1));
         }
      }
      
      private function createDiceSystemEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case 1:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_ACTIVE_OPEN,param1);
               break;
            case 2:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_ACTIVE_CLOSE,param1);
               break;
            case 3:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_RECEIVE_DATA,param1);
               break;
            case 4:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_RECEIVE_RESULT,param1);
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function createWorldBossEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case WorldBossPackageType.OPEN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_INIT,param1);
               break;
            case WorldBossPackageType.OVER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_OVER,param1);
               break;
            case WorldBossPackageType.CANENTER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ENTER,param1);
               break;
            case WorldBossPackageType.ENTER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOM,param1);
               break;
            case WorldBossPackageType.MOVE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_MOVE,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_EXIT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_EXIT,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_PLAYERSTAUTSUPDATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_FIGHTOVER:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_ROOM_CLOSE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_RANKING:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING,param1);
               break;
            case WorldBossPackageType.WORLDBOSS_BUYBUFF:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL,param1));
               break;
            case WorldBossPackageType.WORLDBOSS_PRIVATE_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO,param1);
               break;
            case WorldBossPackageType.ASSISTANT:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ASSISTANT,param1);
               break;
            case WorldBossPackageType.PlayerFightAssistant:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERFIGHTASSIATANT,param1);
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function handleBeadPkg(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case CrazyTankPackageType.RUNE_SENDINFO_TOCLIENT:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_HOLE_INFO,param1));
               break;
            case CrazyTankPackageType.RUNE_OPENPACKAGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_OPEN_PACKAGE,param1));
         }
      }
      
      private function dayActivity(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case ActivityPackageType.USEMONEYPOINT_COMPLETE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USEMONEYPOINT_COMPLETE,param1));
               break;
            case ActivityPackageType.GETACTIVEPOINT_REWARD:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GETACTIVEPOINT_REWARD,param1));
               break;
            case ActivityPackageType.EVERYDAYACTIVEPOINT_DATA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_DATA,param1));
               break;
            case ActivityPackageType.EVERYDAYACTIVEPOINT_CHANGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_CHANGE,param1));
               break;
            case ActivityPackageType.ADD_ACTIVITY_DATA_CHANGE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_ACTIVITY_DATA_CHANGE,param1));
               break;
            case ActivityPackageType.GET_EXPBLESSED_DATA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_EXPBLESSED_DATA,param1));
         }
      }
      
      private function createNewChickenBoxEvent(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:CrazyTankSocketEvent = null;
         switch(_loc2_)
         {
            case NewChickenBoxPackageType.CHICKENBOXOPEN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN,param1);
               break;
            case NewChickenBoxPackageType.CHICKENBOXCLOSE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,param1);
               break;
            case NewChickenBoxPackageType.GETITEMLIST:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,param1);
               break;
            case NewChickenBoxPackageType.CANCLICKCARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.CANCLICKCARDENABLE,param1);
               break;
            case NewChickenBoxPackageType.TACKOVERCARD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,param1);
               break;
            case NewChickenBoxPackageType.EAGLEEYE:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,param1);
               break;
            case NewChickenBoxPackageType.OVERSHOWITEMS:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.OVERSHOWITEMS,param1);
               break;
            case NewChickenBoxPackageType.ACTIVITY_OPEN:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_OPEN,param1);
               break;
            case NewChickenBoxPackageType.ACTIVITY_END:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_END,param1);
               break;
            case NewChickenBoxPackageType.ALL_GOODS_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,param1);
               break;
            case NewChickenBoxPackageType.REWARD_RECORD:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_RECORD,param1);
               break;
            case NewChickenBoxPackageType.GOODS_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,param1);
               break;
            case NewChickenBoxPackageType.PLAY_REWARD_INFO:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,param1);
               break;
            case NewChickenBoxPackageType.AWARD_RANK:
               _loc3_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,param1);
         }
         if(Boolean(_loc3_))
         {
            dispatchEvent(_loc3_);
         }
      }
      
      private function oldPlayerRegressHandle(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case RegressPackageType.REGRESS_PACKS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_PACKS,param1));
               break;
            case RegressPackageType.REGRESS_CALL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_CALLAPPLY,param1));
               break;
            case RegressPackageType.REGRESS_CHECK:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_CHECK,param1));
               break;
            case RegressPackageType.REGRESS_APPLYPACKS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_APPLYPACKS,param1));
               break;
            case RegressPackageType.REGRESS_REVCPACKS:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_RECVPACKS,param1));
               break;
            case RegressPackageType.REGRESS_APPLY_ENABLE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_APPLY_ENABLE,param1));
               break;
            case RegressPackageType.REGRESS_GET_TICKET:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_GET_TICKET,param1));
               break;
            case RegressPackageType.REGRESS_GET_TICKETINFO:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_GET_TICKETINFO,param1));
               break;
            case RegressPackageType.REGRESS_UPDATE_INTEGRAL:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_UPDATE_INTEGRAL,param1));
         }
      }
      
      private function separateActivityHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case CrazyTankPackageType.INIT_TREASURE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INIT_TREASURE,param1));
               break;
            case CrazyTankPackageType.PAY_FOR_HUNTING:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FOR_HUNTING,param1));
               break;
            case CrazyTankPackageType.HUNTING_BY_SCORE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HUNTING_BY_SCORE,param1));
               break;
            case CrazyTankPackageType.CONVERT_SCORE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONVERT_SCORE,param1));
               break;
            case CrazyTankPackageType.GET_MYSTERIOUS_DATA:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MYSTERIOUS_DATA,param1));
               break;
            case CrazyTankPackageType.DAWN_LOTTERY:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAWN_LOTTERY,param1));
         }
      }
      
      private function setRingStationInfo(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case RingStationPackageType.RINGSTATION_VIEWINFO:
               dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_VIEWINFO,param1));
               break;
            case RingStationPackageType.RINGSTATION_BUYCOUNTORTIME:
               dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_BUYCOUNTORTIME,param1));
               break;
            case RingStationPackageType.RINGSTATION_ARMORY:
               dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_ARMORY,param1));
               break;
            case RingStationPackageType.RINGSTATION_NEWBATTLEFIELD:
               dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_NEWBATTLEFIELD,param1));
               break;
            case RingStationPackageType.RINGSTATION_FIGHTFLAG:
               dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_FIGHTFLAG,param1));
               break;
            case RingStationPackageType.LANDERSAWARD_RECEIVE:
               dispatchEvent(new RingStationEvent(RingStationEvent.LANDERSAWARD_RECEIVE,param1));
         }
      }
      
      private function playerDressHandler(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case PlayerDressType.CURRENT_MODEL:
               dispatchEvent(new PlayerDressEvent(PlayerDressEvent.CURRENT_MODEL,param1));
               break;
            case PlayerDressType.GET_DRESS_MODEL:
               dispatchEvent(new PlayerDressEvent(PlayerDressEvent.GET_DRESS_MODEL,param1));
               break;
            case PlayerDressType.LOCK_DRESSBAG:
               dispatchEvent(new PlayerDressEvent(PlayerDressEvent.LOCK_DRESSBAG,param1));
         }
      }
      
      private function treasureHuntingHandle(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case CrazyTankPackageType.INIT_TREASURE:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INIT_TREASURE,param1));
               break;
            case CrazyTankPackageType.PAY_FOR_HUNTING:
               dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FOR_HUNTING,param1));
         }
      }
   }
}

