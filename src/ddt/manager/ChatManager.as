package ddt.manager
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.debug.DebugStats;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ePackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.utils.ChatHelper;
   import ddt.utils.FilterWordManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.ChatModel;
   import ddt.view.chat.ChatOutputView;
   import ddt.view.chat.ChatView;
   import ddt.view.chat.chat_system;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flashP2P.FlashP2PManager;
   import flashP2P.event.StreamEvent;
   import game.GameManager;
   import im.IMController;
   import road7th.comm.PackageIn;
   import road7th.comm.PackageOut;
   import road7th.data.DictionaryData;
   import road7th.utils.StringHelper;
   import room.RoomManager;
   import shop.view.NewShopBugleView;
   import trainer.data.Step;
   
   use namespace chat_system;
   
   public final class ChatManager extends EventDispatcher
   {
      
      private static var _instance:ChatManager;
      
      public static const CHAT_HALL_STATE:int = 0;
      
      public static const CHAT_GAME_STATE:int = 1;
      
      public static const CHAT_CLUB_STATE:int = 2;
      
      public static const CHAT_WEDDINGLIST_STATE:int = 3;
      
      public static const CHAT_WEDDINGROOM_STATE:int = 4;
      
      public static const CHAT_ROOM_STATE:int = 5;
      
      public static const CHAT_ROOMLIST_STATE:int = 6;
      
      public static const CHAT_DUNGEONLIST_STATE:int = 7;
      
      public static const CHAT_GAMEOVER_STATE:int = 8;
      
      public static const CHAT_GAME_LOADING:int = 9;
      
      public static const CHAT_DUNGEON_STATE:int = 10;
      
      public static const CHAT_CONSORTIA_CHAT_VIEW:int = 12;
      
      public static const CHAT_CONSORTIA_ALL:int = 13;
      
      public static const CHAT_CIVIL_VIEW:int = 14;
      
      public static const CHAT_TOFFLIST_VIEW:int = 15;
      
      public static const CHAT_SHOP_STATE:int = 16;
      
      public static const CHAT_HOTSPRING_VIEW:int = 17;
      
      public static const CHAT_HOTSPRING_ROOM_VIEW:int = 18;
      
      public static const CHAT_HOTSPRING_ROOM_GOLD_VIEW:int = 19;
      
      public static const CHAT_TRAINER_STATE:int = 20;
      
      public static const CHAT_GAMEOVER_TROPHY:int = 21;
      
      public static const CHAT_TRAINER_ROOM_LOADING:int = 22;
      
      public static const CHAT_LITTLEHALL:int = 26;
      
      public static const CHAT_LITTLEGAME:int = 24;
      
      public static const CHAT_FARM:int = 27;
      
      public static const CHAT_FIGHT_LIB:int = 23;
      
      public static const CHAT_ACADEMY_VIEW:int = 25;
      
      private static const CHAT_LEVEL:int = 1;
      
      public static const CHAT_WORLDBOS_ROOM:int = 28;
      
      public static const CHAT_CHRISTMAS_ROOM:int = 21;
      
      public static const CHAT_CONSORTIABATTLE_SCENE:int = 29;
      
      public static const CHAT_SEVENDOUBLEGAME_SECENE:int = 30;
      
      public static const CHAT_ESCORT_SECENE:int = 31;
      
      public static const CHAT_TREASURE_STATE:int = 30;
      
      public static const SUPER_WINNER_ROOM:int = 31;
      
      public static var SHIELD_NOTICE:Boolean = false;
      
      private var _shopBugle:NewShopBugleView;
      
      private var _isFastInvite:Boolean = false;
      
      private var _isFastAuction:Boolean = false;
      
      public var chatDisabled:Boolean = false;
      
      private var _chatView:ChatView;
      
      private var _model:ChatModel;
      
      private var _state:int = -1;
      
      private var _visibleSwitchEnable:Boolean = false;
      
      private var _focusFuncEnabled:Boolean = true;
      
      private var fpsContainer:DebugStats;
      
      private var _firstsetup:Boolean = true;
      
      public function ChatManager()
      {
         super();
      }
      
      public static function get Instance() : ChatManager
      {
         if(_instance == null)
         {
            _instance = new ChatManager();
         }
         return _instance;
      }
      
      public function chat(param1:ChatData, param2:Boolean = true) : void
      {
         if(this.chatDisabled)
         {
            return;
         }
         if(param2)
         {
            param1.msg = StringHelper.reverseHtmlTextField(param1.msg);
            param1.msg = FilterWordManager.filterWrodFromServer(param1.msg);
            if(param1.channel != ChatInputView.COMPLEX_NOTICE)
            {
               ChatFormats.formatChatStyle(param1);
            }
            else
            {
               ChatFormats.formatComplexChatStyle(param1);
            }
         }
         param1.htmlMessage = Helpers.deCodeString(param1.htmlMessage);
         this._model.addChat(param1);
      }
      
      public function addTimePackTip(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.type = ChatFormats.CLICK_TIME_GIFTPACK;
         _loc2_.channel = ChatInputView.SYS_TIP;
         _loc2_.msg = LanguageMgr.GetTranslation("ddt.timeGiftPack.tip",param1);
         ChatManager.Instance.chat(_loc2_);
      }
      
      public function get isInGame() : Boolean
      {
         return this.output.isInGame();
      }
      
      public function set focusFuncEnabled(param1:Boolean) : void
      {
         this._focusFuncEnabled = param1;
      }
      
      public function get focusFuncEnabled() : Boolean
      {
         return this._focusFuncEnabled;
      }
      
      public function get input() : ChatInputView
      {
         return this._chatView.input;
      }
      
      public function set inputChannel(param1:int) : void
      {
         this._chatView.input.channel = param1;
      }
      
      public function get lock() : Boolean
      {
         return this._chatView.output.isLock;
      }
      
      public function set lock(param1:Boolean) : void
      {
         this._chatView.output.isLock = param1;
      }
      
      public function get model() : ChatModel
      {
         return this._model;
      }
      
      public function get output() : ChatOutputView
      {
         return this._chatView.output;
      }
      
      public function set outputChannel(param1:int) : void
      {
         this._chatView.output.channel = param1;
      }
      
      public function privateChatTo(param1:String, param2:int = 0, param3:Object = null) : void
      {
         this._chatView.input.setPrivateChatTo(param1,param2,param3);
      }
      
      public function sendBugle(param1:String, param2:int, param3:Boolean = false) : void
      {
         this._isFastInvite = param3;
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(param2,true) <= 0)
         {
            if(Boolean(ShopManager.Instance.getMoneyShopItemByTemplateID(param2)))
            {
               this.input.setInputText(param1);
            }
            this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
            if(!this._shopBugle || !this._shopBugle.info)
            {
               this._shopBugle = new NewShopBugleView(param2);
            }
            else if(this._shopBugle.type != param2)
            {
               this._shopBugle.dispose();
               this._shopBugle = null;
               this._shopBugle = new NewShopBugleView(param2);
            }
         }
         else
         {
            param1 = Helpers.enCodeString(param1);
            if(param2 == EquipType.T_SBUGLE && !param3)
            {
               SocketManager.Instance.out.sendSBugle(param1);
            }
            else if(param2 == EquipType.T_BBUGLE)
            {
               SocketManager.Instance.out.sendBBugle(param1,param2);
            }
            else if(param2 == EquipType.T_CBUGLE)
            {
               SocketManager.Instance.out.sendCBugle(param1);
            }
            else if(param3)
            {
               SocketManager.Instance.out.sendFastInviteCall();
            }
         }
      }
      
      public function sendFastAuctionBugle(param1:int, param2:int = 11101) : void
      {
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(param2,true) <= 0)
         {
            this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
            if(!this._shopBugle || !this._shopBugle.info)
            {
               this._shopBugle = new NewShopBugleView(param2);
            }
            else if(this._shopBugle.type != param2)
            {
               this._shopBugle.dispose();
               this._shopBugle = null;
               this._shopBugle = new NewShopBugleView(param2);
            }
         }
         else
         {
            SocketManager.Instance.out.sendFastAuctionBugle(param1);
         }
      }
      
      public function sendChat(param1:ChatData) : void
      {
         var _loc2_:int = 0;
         if(param1.msg == "showDebugStatus -fps")
         {
            if(!this.fpsContainer)
            {
               this.fpsContainer = new DebugStats();
               LayerManager.Instance.addToLayer(this.fpsContainer,LayerManager.STAGE_TOP_LAYER);
            }
            else
            {
               if(Boolean(this.fpsContainer.parent))
               {
                  this.fpsContainer.parent.removeChild(this.fpsContainer);
               }
               this.fpsContainer = null;
            }
            return;
         }
         if(param1.msg == "updateFlashP2PKey")
         {
            _loc2_ = 0;
            while(_loc2_ < PlayerManager.Instance.onlineFriendList.length)
            {
               SocketManager.Instance.out.sendPeerID(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.onlineFriendList[_loc2_].ID,"");
               _loc2_++;
            }
         }
         if(GameManager.GAME_CAN_NOT_EXIT_SEND_LOG == 1 && param1.msg == "发_送_日_志")
         {
            GameManager.Instance.gameView.logTimeHandler();
         }
         if(this.chatDisabled)
         {
            return;
         }
         if(param1.channel == ChatInputView.PRIVATE)
         {
            if(param1.zoneID == -1 || param1.zoneID == PlayerManager.Instance.Self.ZoneID)
            {
               this.sendPrivateMessage(param1.receiver,param1.msg,param1.receiverID,false);
            }
            else
            {
               this.sendAreaPrivateMessage(param1.receiver,param1.msg,param1.zoneID);
            }
         }
         else if(param1.channel == ChatInputView.CROSS_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_CBUGLE);
         }
         else if(param1.channel == ChatInputView.BIG_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_BBUGLE);
         }
         else if(param1.channel == ChatInputView.SMALL_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_SBUGLE);
         }
         else if(param1.channel == ChatInputView.CONSORTIA)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
            dispatchEvent(new ChatEvent(ChatEvent.SEND_CONSORTIA));
         }
         else if(param1.channel == ChatInputView.TEAM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,true);
         }
         else if(param1.channel == ChatInputView.CURRENT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.CHURCH_CHAT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.HOTSPRING_ROOM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.WORLDBOSS_ROOM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.CHRISTMAS_CHAT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.SUPERWINNER_CHAT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
      }
      
      public function sendFace(param1:int) : void
      {
         SocketManager.Instance.out.sendFace(param1);
      }
      
      public function setFocus() : void
      {
         this._chatView.input.inputField.setFocus();
      }
      
      public function releaseFocus() : void
      {
         StageReferance.stage.focus = StageReferance.stage;
      }
      
      public function setup() : void
      {
         if(this._firstsetup)
         {
            this.initView();
            this.initEvent();
         }
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
         this._chatView.state = this._state;
      }
      
      public function switchVisible() : void
      {
         if(this._visibleSwitchEnable)
         {
            if(Boolean(this._chatView.input.parent))
            {
               this._chatView.input.parent.removeChild(this._chatView.input);
               this._chatView.output.functionEnabled = false;
               this._chatView.input.fastReplyPanel.isEditing = false;
               StageReferance.stage.focus = null;
            }
            else
            {
               this._chatView.addChild(this.input);
               this._chatView.output.functionEnabled = true;
               this._chatView.input.inputField.setFocus();
            }
         }
         this._chatView.input.hidePanel();
      }
      
      public function sysChatRed(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.SYS_NOTICE;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function sysChatYellow(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.SYS_TIP;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function sysChatLinkYellow(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.type = ChatFormats.CLICK_EFFORT;
         _loc2_.channel = ChatInputView.SYS_TIP;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function sysChatAmaranth(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.GM_NOTICE;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function get view() : ChatView
      {
         return this._chatView;
      }
      
      public function get visibleSwitchEnable() : Boolean
      {
         return this._visibleSwitchEnable;
      }
      
      public function set visibleSwitchEnable(param1:Boolean) : void
      {
         if(this._visibleSwitchEnable == param1)
         {
            return;
         }
         this._visibleSwitchEnable = param1;
      }
      
      private function __bBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.bigBuggleType = _loc2_.readInt();
         _loc3_.channel = ChatInputView.BIG_BUGLE;
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __bugleBuyHandler(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         if(_loc4_ == 3 && _loc3_ == 1)
         {
            if(!this._isFastInvite)
            {
               this.input.sendCurrentText();
            }
            else
            {
               this.sendBugle("",EquipType.T_SBUGLE,true);
            }
         }
         else if(_loc4_ == 5 && _loc3_ >= 1)
         {
            dispatchEvent(new Event(CrazyTankSocketEvent.BUY_BEAD));
         }
      }
      
      private function __cBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.CROSS_BUGLE;
         _loc3_.zoneID = _loc2_.readInt();
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.zoneName = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __consortiaChat(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         if(_loc2_.clientId != PlayerManager.Instance.Self.ID)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = new ChatData();
            _loc4_.channel = ChatInputView.CONSORTIA;
            _loc4_.senderID = _loc2_.clientId;
            _loc4_.receiver = "";
            _loc4_.sender = _loc2_.readUTF();
            _loc4_.msg = _loc2_.readUTF();
            this.chatCheckSelf(_loc4_);
         }
      }
      
      private function __defyAffiche(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.channel = ChatInputView.DEFY_AFFICHE;
         this.chatCheckSelf(_loc3_);
      }
      
      private function __getItemMsgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc12_:String = null;
         var _loc17_:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Boolean = _loc2_.readBoolean();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         if(_loc4_ == 0)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.unexpectedBattle");
         }
         else if(_loc4_ == 2)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.RouletteBattle");
         }
         else if(_loc4_ == 1)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.dungeonBattle");
         }
         else if(_loc4_ == 3)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.CaddyBattle");
         }
         else if(_loc4_ == 4)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.beadBattle");
         }
         else if(_loc4_ == 5)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
         }
         else if(_loc4_ == 11)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.BlessBattle");
         }
         else if(_loc4_ == 14)
         {
            _loc10_ = LanguageMgr.GetTranslation("tank.game.GameView.celebrationBattle");
         }
         if(_loc7_ == 1)
         {
            _loc9_ = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast","[" + _loc3_ + "]",_loc10_);
         }
         else if(_loc7_ == 2)
         {
            _loc9_ = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip",_loc3_,_loc10_);
         }
         else if(_loc7_ == 3)
         {
            _loc17_ = _loc2_.readUTF();
            _loc9_ = LanguageMgr.GetTranslation("tank.manager.congratulateGain","[" + _loc3_ + "]",_loc17_);
            CaddyModel.instance.appendAwardsInfo(_loc3_,_loc5_,false,"",-1,_loc4_);
         }
         var _loc11_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc5_);
         if(_loc11_.Property1 != "31")
         {
            _loc12_ = "[" + _loc11_.Name + "]";
         }
         else
         {
            _loc12_ = "[" + _loc11_.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(_loc5_).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(_loc5_).BaseLevel + "]";
         }
         var _loc13_:ChatData = new ChatData();
         _loc13_.channel = ChatInputView.SYS_NOTICE;
         _loc13_.msg = _loc9_ + _loc12_ + "x" + _loc8_;
         var _loc14_:Array = ChatFormats.getTagsByChannel(_loc13_);
         _loc9_ = StringHelper.rePlaceHtmlTextField(_loc9_);
         var _loc15_:String = ChatFormats.creatBracketsTag(_loc9_,ChatFormats.CLICK_USERNAME);
         var _loc16_:String = ChatFormats.creatGoodTag("[" + _loc11_.Name + "]" + "x" + _loc8_,ChatFormats.CLICK_GOODS,_loc11_.TemplateID,_loc11_.Quality,_loc6_,_loc13_);
         _loc13_.htmlMessage = _loc14_[0] + _loc15_ + _loc16_ + _loc14_[1] + "<BR>";
         _loc13_.htmlMessage = Helpers.deCodeString(_loc13_.htmlMessage);
         this._model.addChat(_loc13_);
      }
      
      private function __goodLinkGetHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:GrooveInfo = null;
         var _loc7_:String = null;
         var _loc8_:CardInfo = null;
         var _loc9_:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         if(_loc4_ == 4)
         {
            _loc6_ = new GrooveInfo();
            _loc7_ = _loc3_.readUTF();
            _loc6_.CardId = _loc3_.readInt();
            _loc6_.Place = _loc3_.readInt();
            _loc6_.Type = _loc3_.readInt();
            _loc6_.Level = _loc3_.readInt();
            _loc6_.GP = _loc3_.readInt();
            if(Boolean(CardControl.Instance.model.GrooveInfoVector))
            {
               CardControl.Instance.model.GrooveInfoVector[_loc6_.Place] = _loc6_;
            }
            else
            {
               CardControl.Instance.model.tempCardGroove = _loc6_;
            }
            this.model.addCardGrooveLink(_loc7_,_loc6_);
            this.output.contentField.chat_system::showCardGrooveLinkGoodsInfo(_loc6_,1);
            return;
         }
         if(_loc4_ == 5)
         {
            _loc8_ = new CardInfo();
            _loc9_ = _loc3_.readUTF();
            _loc8_.TemplateID = _loc3_.readInt();
            _loc8_.CardType = _loc3_.readInt();
            _loc8_.Attack = _loc3_.readInt();
            _loc8_.Defence = _loc3_.readInt();
            _loc8_.Agility = _loc3_.readInt();
            _loc8_.Luck = _loc3_.readInt();
            _loc8_.Damage = _loc3_.readInt();
            _loc8_.Guard = _loc3_.readInt();
            _loc8_.Place = 6;
            this.model.addCardInfoLink(_loc9_,_loc8_);
            this.output.contentField.chat_system::showCardInfoLinkGoodsInfo(_loc8_,1);
            return;
         }
         var _loc5_:String = _loc3_.readUTF();
         _loc2_.TemplateID = _loc3_.readInt();
         _loc2_.ItemID = _loc3_.readInt();
         _loc2_.StrengthenLevel = _loc3_.readInt();
         _loc2_.AttackCompose = _loc3_.readInt();
         _loc2_.AgilityCompose = _loc3_.readInt();
         _loc2_.LuckCompose = _loc3_.readInt();
         _loc2_.DefendCompose = _loc3_.readInt();
         _loc2_.ValidDate = _loc3_.readInt();
         _loc2_.IsBinds = _loc3_.readBoolean();
         _loc2_.IsJudge = _loc3_.readBoolean();
         _loc2_.IsUsed = _loc3_.readBoolean();
         if(_loc2_.IsUsed)
         {
            _loc2_.BeginDate = _loc3_.readUTF();
         }
         _loc2_.Hole1 = _loc3_.readInt();
         _loc2_.Hole2 = _loc3_.readInt();
         _loc2_.Hole3 = _loc3_.readInt();
         _loc2_.Hole4 = _loc3_.readInt();
         _loc2_.Hole5 = _loc3_.readInt();
         _loc2_.Hole6 = _loc3_.readInt();
         _loc2_.Hole = _loc3_.readUTF();
         ItemManager.fill(_loc2_);
         _loc2_.Pic = _loc3_.readUTF();
         _loc2_.RefineryLevel = _loc3_.readInt();
         _loc2_.DiscolorValidDate = _loc3_.readDateString();
         _loc2_.Hole5Level = _loc3_.readByte();
         _loc2_.Hole5Exp = _loc3_.readInt();
         _loc2_.Hole6Level = _loc3_.readByte();
         _loc2_.Hole6Exp = _loc3_.readInt();
         _loc2_.isGold = _loc3_.readBoolean();
         if(_loc2_.isGold)
         {
            _loc2_.goldValidDate = _loc3_.readInt();
            _loc2_.goldBeginTime = _loc3_.readDateString();
         }
         this.model.addLink(_loc5_,_loc2_);
         this.output.contentField.chat_system::showLinkGoodsInfo(_loc2_,1);
      }
      
      private function __p2pPrivateChat(param1:StreamEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:ByteArray = param1.readByteArray;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.PRIVATE;
         _loc3_.receiverID = _loc2_.readInt();
         _loc3_.receiver = _loc2_.readUTF();
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.isAutoReply = _loc2_.readBoolean();
         this.chatCheckSelf(_loc3_);
         if(_loc3_.senderID != PlayerManager.Instance.Self.ID)
         {
            IMController.Instance.saveRecentContactsID(_loc3_.senderID);
         }
         else if(_loc3_.receiverID != PlayerManager.Instance.Self.ID)
         {
            IMController.Instance.saveRecentContactsID(_loc3_.receiverID);
         }
      }
      
      private function __privateChat(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         if(Boolean(_loc2_.clientId))
         {
            _loc3_ = new ChatData();
            _loc3_.channel = ChatInputView.PRIVATE;
            _loc3_.receiverID = _loc2_.readInt();
            _loc3_.senderID = _loc2_.clientId;
            _loc3_.receiver = _loc2_.readUTF();
            _loc3_.sender = _loc2_.readUTF();
            _loc3_.msg = _loc2_.readUTF();
            _loc3_.isAutoReply = _loc2_.readBoolean();
            this.chatCheckSelf(_loc3_);
            if(_loc3_.senderID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(_loc3_.senderID);
            }
            else if(_loc3_.receiverID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(_loc3_.receiverID);
            }
         }
      }
      
      private function __areaPrivateChat(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.PRIVATE;
         _loc3_.zoneName = _loc2_.readUTF();
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.zoneID = _loc2_.readInt();
         if(SharedManager.Instance.transregionalblackList[_loc3_.sender] != null)
         {
            return;
         }
         this.chatCheckSelf(_loc3_);
      }
      
      private function __receiveFace(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:Object = {};
         _loc2_.playerid = param1.pkg.clientId;
         _loc2_.faceid = param1.pkg.readInt();
         _loc2_.delay = param1.pkg.readInt();
         dispatchEvent(new ChatEvent(ChatEvent.SHOW_FACE,_loc2_));
      }
      
      private function __sBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.SMALL_BUGLE;
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __fastInviteCall(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.type = ChatFormats.CLICK_FASTINVITE;
         _loc3_.channel = ChatInputView.SMALL_BUGLE;
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.roomId = _loc2_.readInt();
         _loc3_.password = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __fastAuctionBugle(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.type = ChatFormats.CLICK_FASTAUCTION;
         _loc3_.channel = ChatInputView.SMALL_BUGLE;
         _loc3_.receiver = "";
         _loc3_.playerCharacterID = _loc2_.readInt();
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.auctionID = _loc2_.readInt();
         _loc3_.teamplateID = _loc2_.readInt();
         _loc3_.itemCount = _loc2_.readInt();
         _loc3_.mouthful = _loc2_.readInt();
         _loc3_.payType = _loc2_.readInt();
         _loc3_.price = _loc2_.readInt();
         _loc3_.rise = _loc2_.readInt();
         _loc3_.validDate = _loc2_.readInt();
         _loc3_.auctionGoodName = ItemManager.Instance.getTemplateById(_loc3_.teamplateID).Name;
         _loc3_.msg = "【" + _loc3_.sender + "】" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.bugleTxt",_loc3_.price,_loc3_.mouthful,_loc3_.auctionGoodName,_loc3_.itemCount);
         this.chat(_loc3_);
      }
      
      private function __sceneChat(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.zoneID = _loc2_.readInt();
         _loc3_.channel = _loc2_.readByte();
         if(_loc2_.readBoolean())
         {
            _loc3_.channel = ChatInputView.TEAM;
         }
         _loc3_.senderID = _loc2_.clientId;
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chatCheckSelf(_loc3_);
         this.addRecentContacts(_loc3_.senderID);
      }
      
      private function addRecentContacts(param1:int) : void
      {
         if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            if(RoomManager.Instance.isIdenticalRoom(param1))
            {
               IMController.Instance.saveRecentContactsID(param1);
            }
         }
         else if(StateManager.currentStateType == StateType.FIGHTING)
         {
            if(GameManager.Instance.isIdenticalGame(param1))
            {
               IMController.Instance.saveRecentContactsID(param1);
            }
         }
      }
      
      private function __sysNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc5_:ChatData = new ChatData();
         var _loc6_:Boolean = false;
         switch(_loc2_)
         {
            case 0:
               _loc5_.channel = ChatInputView.GM_NOTICE;
               break;
            case 1:
            case 5:
            case 20:
            case 21:
               _loc6_ = true;
            case 2:
            case 6:
            case 7:
               _loc5_.channel = ChatInputView.SYS_TIP;
               break;
            case 3:
               _loc5_.channel = ChatInputView.SYS_NOTICE;
               break;
            case 8:
               _loc5_.channel = ChatInputView.CONSORTIA;
               break;
            case 10:
            case 11:
            case 18:
            case 19:
               _loc6_ = true;
            case 13:
               _loc5_.zoneID = param1.pkg.readInt();
               _loc5_.channel = ChatInputView.CROSS_NOTICE;
               break;
            case 12:
               _loc5_.zoneID = param1.pkg.readInt();
               _loc5_.channel = ChatInputView.CROSS_NOTICE;
               break;
            case 9:
               _loc5_.channel = ChatInputView.SYS_TIP;
               break;
            default:
               _loc5_.channel = ChatInputView.SYS_TIP;
         }
         if(Boolean(param1) && Boolean(param1.pkg.bytesAvailable))
         {
            _loc4_ = ChatHelper.chat_system::readGoodsLinks(param1.pkg,_loc6_);
         }
         _loc5_.type = _loc2_;
         _loc5_.zoneName = PlayerManager.Instance.getAreaNameByAreaID(_loc5_.zoneID);
         _loc5_.msg = StringHelper.rePlaceHtmlTextField(_loc3_);
         _loc5_.link = _loc4_;
         this.chat(_loc5_);
         if(_loc2_ == 12 && Boolean(param1.pkg.bytesAvailable))
         {
            _loc7_ = param1.pkg.readInt();
            if(_loc7_ > 0)
            {
               _loc8_ = param1.pkg.readUTF();
               _loc9_ = param1.pkg.readInt();
               _loc10_ = param1.pkg.readUTF();
               if(_loc8_ != PlayerManager.Instance.Self.NickName)
               {
                  CaddyModel.instance.appendAwardsInfo(_loc8_,_loc9_,true,_loc10_,_loc5_.zoneID,_loc7_);
               }
            }
         }
      }
      
      private function chatCheckSelf(param1:ChatData) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:PlayerInfo = null;
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CHAT) && TaskManager.instance.getQuestDataByID(344) && param1.channel == ChatInputView.CONSORTIA)
         {
            SocketManager.Instance.out.sendQuestCheck(344,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CHAT);
         }
         if(param1.zoneID != -1 && param1.zoneID != PlayerManager.Instance.Self.ZoneID)
         {
            if(param1.sender != PlayerManager.Instance.Self.NickName || param1.zoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this.chat(param1);
               return;
            }
         }
         else if(param1.sender != PlayerManager.Instance.Self.NickName)
         {
            if(param1.channel == ChatInputView.CONSORTIA)
            {
               _loc2_ = PlayerManager.Instance.blackList;
               for each(_loc3_ in _loc2_)
               {
                  if(_loc3_.NickName == param1.sender)
                  {
                     return;
                  }
               }
            }
            this.chat(param1);
         }
      }
      
      private function initEvent() : void
      {
         if(!SHIELD_NOTICE)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FAST_INVITE_CALL,this.__fastInviteCall);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.S_BUGLE,this.__sBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FAST_AUCTION_BUGLE,this.__fastAuctionBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.B_BUGLE,this.__bBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.C_BUGLE,this.__cBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_ITEM_MESS,this.__getItemMsgHandler);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_PERSONAL,this.__privateChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AREA_CHAT,this.__areaPrivateChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_CHAT,this.__sceneChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAT,this.__consortiaChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_FACE,this.__receiveFace);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_NOTICE,this.__sysNotice);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEFY_AFFICHE,this.__defyAffiche);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__bugleBuyHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LINKGOODSINFO_GET,this.__goodLinkGetHandler);
         FlashP2PManager.Instance.addEventListener(StreamEvent.PRIVATE_MSG,this.__p2pPrivateChat);
      }
      
      private function initView() : void
      {
         ChatFormats.setup();
         this._model = new ChatModel();
         this._chatView = ComponentFactory.Instance.creatCustomObject("chat.View");
         this.state = CHAT_HALL_STATE;
         this.inputChannel = ChatInputView.CURRENT;
         this.outputChannel = ChatOutputView.CHAT_OUPUT_CURRENT;
      }
      
      private function sendMessage(param1:int, param2:String, param3:String, param4:Boolean) : void
      {
         param3 = Helpers.enCodeString(param3);
         var _loc5_:PackageOut = new PackageOut(ePackageType.SCENE_CHAT);
         _loc5_.writeByte(param1);
         _loc5_.writeBoolean(param4);
         _loc5_.writeUTF(param2);
         _loc5_.writeUTF(param3);
         SocketManager.Instance.out.sendPackage(_loc5_);
      }
      
      public function sendPrivateMessage(param1:String, param2:String, param3:Number = 0, param4:Boolean = false) : void
      {
         var _loc5_:PackageOut = null;
         if(PathManager.flashP2PEbable && PlayerManager.Instance.findPlayer(param3).peerID != "")
         {
            param2 = Helpers.enCodeString(param2);
            FlashP2PManager.Instance.sendPlivateMsg(PlayerManager.Instance.findPlayer(param3).peerID,param1,param2,param3,param4);
         }
         else
         {
            param2 = Helpers.enCodeString(param2);
            _loc5_ = new PackageOut(ePackageType.CHAT_PERSONAL);
            _loc5_.writeInt(param3);
            _loc5_.writeUTF(param1);
            _loc5_.writeUTF(PlayerManager.Instance.Self.NickName);
            _loc5_.writeUTF(param2);
            _loc5_.writeBoolean(param4);
            SocketManager.Instance.out.sendPackage(_loc5_);
         }
         if(Boolean(RoomManager.Instance.current) && !RoomManager.Instance.current.isCrossZone)
         {
            IMController.Instance.saveRecentContactsID(param3);
         }
      }
      
      public function sendAreaPrivateMessage(param1:String, param2:String, param3:int = -1) : void
      {
         param2 = Helpers.enCodeString(param2);
         var _loc4_:PackageOut = new PackageOut(ePackageType.AREA_CHAT);
         _loc4_.writeInt(param3);
         _loc4_.writeUTF(param2);
         _loc4_.writeUTF(param1);
         SocketManager.Instance.out.sendPackage(_loc4_);
      }
      
      public function sendOldPlayerLoginPrompt(param1:PackageIn) : void
      {
         var _loc2_:String = param1.readUTF();
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.COMPLEX_NOTICE;
         _loc3_.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
         _loc3_.type = ChatFormats.CLICK_INVITE_OLD_PLAYER;
         _loc3_.msg = LanguageMgr.GetTranslation("oldPlayer.login.promptTxt",_loc2_);
         _loc3_.receiver = _loc2_;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._2_Invite))
         {
            _loc3_.msg += "|" + LanguageMgr.GetTranslation("oldPlayer.login.promptTxt2");
         }
         this.chat(_loc3_);
      }
   }
}

