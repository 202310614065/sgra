package ddt.view.chat
{
   import DDPlay.DDPlayManaer;
   import auctionHouse.controller.AuctionHouseController;
   import bagAndInfo.BagAndInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.AreaInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.CardsTipPanel;
   import ddt.view.tips.EquipmentCardsTips;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import ddt.view.tips.LaterEquipmentGoodView;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import growthPackage.GrowthPackageManager;
   import im.IMView;
   import lanternriddles.LanternRiddlesManager;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActivityManager;
   import worldBossHelper.WorldBossHelperManager;
   
   use namespace chat_system;
   
   public class ChatOutputField extends Sprite
   {
      
      public static const GAME_STYLE:String = "GAME_STYLE";
      
      public static const GAME_WIDTH:int = 288;
      
      public static const GAME_HEIGHT:int = 106;
      
      public static const NORMAL_WIDTH:int = 440;
      
      public static const NORMAL_HEIGHT:int = 128;
      
      public static const NORMAL_STYLE:String = "NORMAL_STYLE";
      
      private static var _style:String = "";
      
      private var _contentField:TextField;
      
      private var _nameTip:ChatNamePanel;
      
      private var _transregionalNameTip:ChatTransregionalNamePanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardboxTip:CardBoxTipPanel;
      
      private var _cardTip:EquipmentCardsTips;
      
      private var _grooveTip:CardsTipPanel;
      
      private var _cardInfotTips:EquipmentCardsTips;
      
      private var _goodTipPos:Sprite = new Sprite();
      
      private var _srcollRect:Rectangle;
      
      private var _tipStageClickCount:int = 0;
      
      private var isStyleChange:Boolean = false;
      
      private var t_text:String;
      
      private var _functionEnabled:Boolean;
      
      public function ChatOutputField()
      {
         super();
         this.chat_system::style = NORMAL_STYLE;
      }
      
      public function set functionEnabled(param1:Boolean) : void
      {
         this._functionEnabled = param1;
      }
      
      public function set contentWidth(param1:Number) : void
      {
         this._contentField.width = param1;
         this.updateScrollRect(param1,NORMAL_HEIGHT);
      }
      
      public function set contentHeight(param1:Number) : void
      {
         this._contentField.height = param1;
         this.updateScrollRect(NORMAL_WIDTH,param1);
      }
      
      public function isBottom() : Boolean
      {
         return this._contentField.scrollV == this._contentField.maxScrollV;
      }
      
      public function get scrollOffset() : int
      {
         return this._contentField.maxScrollV - this._contentField.scrollV;
      }
      
      public function set scrollOffset(param1:int) : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV - param1;
         this.onScrollChanged();
      }
      
      public function setChats(param1:Array) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_].htmlMessage;
            _loc3_++;
         }
         if(Boolean(this._contentField))
         {
            this._contentField.htmlText = _loc2_;
         }
      }
      
      public function toBottom() : void
      {
         Helpers.delayCall(this.__delayCall);
         this._contentField.scrollV = int.MAX_VALUE;
         this.onScrollChanged();
      }
      
      chat_system function get goodTipPos() : Point
      {
         return new Point(this._goodTipPos.x,this._goodTipPos.y);
      }
      
      chat_system function showLinkGoodsInfo(param1:ItemTemplateInfo, param2:uint = 0) : void
      {
         var _loc3_:GoodTipInfo = null;
         if(param1.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardboxTip == null)
            {
               this._cardboxTip = new CardBoxTipPanel();
            }
            this._cardboxTip.tipData = param1;
            this.setTipPos(this._cardboxTip);
            StageReferance.stage.addChild(this._cardboxTip);
         }
         else
         {
            if(this._goodTip == null)
            {
               this._goodTip = new GoodTip();
            }
            _loc3_ = new GoodTipInfo();
            if(param1.Property1 == "31")
            {
               _loc3_.beadName = param1.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).BaseLevel;
               _loc3_.exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).BaseLevel];
               _loc3_.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).BaseLevel + 1];
            }
            _loc3_.itemInfo = param1;
            this._goodTip.tipData = _loc3_;
            ItemManager.Instance.playerInfo = PlayerManager.Instance.Self;
            this._goodTip.showTip(param1);
            if(PathManager.suitEnable)
            {
               LaterEquipmentGoodView.isShow = false;
               this._goodTip.showSuitTip(param1);
            }
            this.setTipPos(this._goodTip);
            StageReferance.stage.addChild(this._goodTip);
         }
         if(Boolean(this._nameTip) && Boolean(this._nameTip.parent))
         {
            this._nameTip.parent.removeChild(this._nameTip);
         }
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = param2;
      }
      
      chat_system function showBeadTip(param1:ItemTemplateInfo, param2:int, param3:int) : void
      {
         if(this._goodTip == null)
         {
            this._goodTip = new GoodTip();
         }
         var _loc4_:GoodTipInfo = new GoodTipInfo();
         _loc4_.beadName = param1.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).Name + "Lv" + param2;
         _loc4_.upExp = ServerConfigManager.instance.getBeadUpgradeExp()[param2 + 1];
         _loc4_.exp = param3;
         _loc4_.itemInfo = param1;
         this._goodTip.tipData = _loc4_;
         this._goodTip.showTip(param1);
         this.setTipPos(this._goodTip);
         StageReferance.stage.addChild(this._goodTip);
      }
      
      chat_system function showCardGrooveLinkGoodsInfo(param1:GrooveInfo, param2:uint = 0) : void
      {
         this._grooveTip = new CardsTipPanel();
         this._grooveTip.tipData = param1.Place;
         this._grooveTip.tipDirctions = "7,0";
         this.setTipPos2(this._grooveTip);
         StageReferance.stage.addChild(this._grooveTip);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = param2;
      }
      
      chat_system function showCardInfoLinkGoodsInfo(param1:CardInfo, param2:uint = 0) : void
      {
         this._cardInfotTips = new EquipmentCardsTips();
         this._cardInfotTips.tipData = param1;
         this._cardInfotTips.tipDirctions = "7,0";
         this.setTipPos2(this._cardInfotTips);
         StageReferance.stage.addChild(this._cardInfotTips);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = param2;
      }
      
      private function setTipPos(param1:Object) : void
      {
         param1.x = this._goodTipPos.x;
         param1.y = this._goodTipPos.y - param1.height - 10;
         if(param1.y < 0)
         {
            param1.y = 10;
         }
      }
      
      private function setTipPos2(param1:Object) : void
      {
         param1.tipGapH = 218;
         param1.tipGapV = 245;
         param1.x = 218;
         param1.y = 245;
      }
      
      chat_system function set style(param1:String) : void
      {
         if(_style != param1)
         {
            _style = param1;
            this.disposeView();
            this.initView();
            this.initEvent();
            switch(param1)
            {
               case NORMAL_STYLE:
                  this._contentField.styleSheet = ChatFormats.styleSheet;
                  this._contentField.width = NORMAL_WIDTH;
                  this._contentField.height = NORMAL_HEIGHT;
                  break;
               case GAME_STYLE:
                  this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                  this._contentField.width = GAME_WIDTH;
                  this._contentField.height = GAME_HEIGHT;
            }
            this._contentField.htmlText = this.t_text || "";
         }
      }
      
      private function __delayCall() : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV;
         this.onScrollChanged();
         removeEventListener(Event.ENTER_FRAME,this.__delayCall);
      }
      
      private function __onScrollChanged(param1:Event) : void
      {
         this.onScrollChanged();
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var allProperties:Array;
         var i:int;
         var data:Object = null;
         var tipPos:Point = null;
         var props:Array = null;
         var selfZone:int = 0;
         var other:int = 0;
         var input:String = null;
         var specialIdx:int = 0;
         var pattern:RegExp = null;
         var str:String = null;
         var result:Object = null;
         var rect:Rectangle = null;
         var areaInfo:AreaInfo = null;
         var startIdx:int = 0;
         var endIdx:int = 0;
         var pos:Point = null;
         var legalIdx:int = 0;
         var nameTipPos:Point = null;
         var itemInfo:ItemTemplateInfo = null;
         var info:ItemTemplateInfo = null;
         var areaInfoII:AreaInfo = null;
         var event:TextEvent = param1;
         SoundManager.instance.play("008");
         this.__stageClickHandler();
         data = {};
         allProperties = event.text.split("|");
         i = 0;
         while(i < allProperties.length)
         {
            if(Boolean(allProperties[i].indexOf(":")))
            {
               props = allProperties[i].split(":");
               data[props[0]] = props[1];
            }
            i++;
         }
         if(Boolean(data.jumptype))
         {
            switch(int(data.jumptype))
            {
               case 1:
                  if(StateManager.currentStateType != StateType.MAIN)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
                     return;
                  }
                  GrowthPackageManager.instance.loadUIModule(GrowthPackageManager.instance.showFrame);
                  break;
               case 2:
                  if(DDPlayManaer.Instance.isOpen)
                  {
                     DDPlayManaer.Instance.show();
                     break;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.end"));
                  break;
               case 3:
                  if(WitchBlessingManager.Instance.isOpen())
                  {
                     WitchBlessingManager.Instance.onClickIcon();
                     break;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.StartNot"));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_CHANNEL)
         {
            ChatManager.Instance.inputChannel = int(data.channel);
            ChatManager.Instance.output.functionEnabled = true;
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               IMEManager.enable();
               areaInfo = new AreaInfo();
               areaInfo.areaID = data.zoneID;
               areaInfo.areaName = data.zoneName;
               ChatManager.Instance.output.functionEnabled = true;
               if(PathManager.crossServerChatSwitch)
               {
                  ChatManager.Instance.privateChatTo(data.tagname,0,areaInfo);
               }
               else
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               }
               if(this._transregionalNameTip == null)
               {
                  this._transregionalNameTip = ComponentFactory.Instance.creatCustomObject("chat.ChatTransregionalNamePanel");
               }
               this._transregionalNameTip.NickName = data["tagname"];
               this._transregionalNameTip.setVisible = true;
               PositionUtils.setPos(this._transregionalNameTip,this.getPos(data,this._transregionalNameTip));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,data.tagname));
            }
            if(this._nameTip == null)
            {
               this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
            }
            input = String(data.tagname);
            specialIdx = int(input.indexOf("$"));
            if(specialIdx > -1)
            {
               input = input.substr(0,specialIdx);
            }
            pattern = new RegExp(input,"g");
            str = this._contentField.text;
            result = pattern.exec(str);
            while(result != null)
            {
               startIdx = int(result.index);
               endIdx = startIdx + String(data.tagname).length;
               pos = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
               legalIdx = this._contentField.getCharIndexAtPoint(pos.x,pos.y);
               if(legalIdx >= startIdx && legalIdx <= endIdx)
               {
                  this._contentField.setSelection(startIdx,endIdx);
                  rect = this._contentField.getCharBoundaries(endIdx);
                  nameTipPos = this._contentField.localToGlobal(new Point(rect.x,rect.y));
                  this._nameTip.x = nameTipPos.x + rect.width;
                  this._nameTip.y = nameTipPos.y - this._nameTip.getHeight - (this._contentField.scrollV - 1) * 18;
                  break;
               }
               result = pattern.exec(str);
            }
            this._nameTip.playerName = String(data.tagname);
            if(Boolean(data.channel))
            {
               this._nameTip.channel = ChatFormats.Channel_Set[int(data.channel)];
            }
            else
            {
               this._nameTip.channel = null;
            }
            this._nameTip.message = String(data.message);
            if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            this._nameTip.setVisible = true;
            ChatManager.Instance.privateChatTo(data.tagname);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_GOODS)
         {
            tipPos = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = tipPos.x;
            this._goodTipPos.y = tipPos.y;
            itemInfo = ItemManager.Instance.getTemplateById(data.templeteIDorItemID);
            itemInfo.BindType = data.isBind == "true" ? 0 : 1;
            this.chat_system::showLinkGoodsInfo(itemInfo);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            tipPos = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = tipPos.x;
            this._goodTipPos.y = tipPos.y;
            if(data.key != "null")
            {
               info = ChatManager.Instance.model.getLink(data.key);
            }
            else
            {
               info = ChatManager.Instance.model.getLink(data.templeteIDorItemID);
            }
            if(Boolean(info))
            {
               this.chat_system::showLinkGoodsInfo(info);
            }
            else if(data.key != "null")
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(3,String(data.key),String(data.templeteIDorItemID));
            }
            else
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(2,String(data.templeteIDorItemID));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
         {
            areaInfoII = new AreaInfo();
            areaInfoII.areaID = data.zoneID;
            if(!data.zoneName || data.zoneName == "")
            {
               data.zoneName = PlayerManager.Instance.getAreaNameByAreaID(data.zoneID);
            }
            areaInfoII.areaName = data.zoneName;
            if(!areaInfoII.areaName)
            {
               areaInfoII.areaName = PlayerManager.Instance.getAreaNameByAreaID(areaInfoII.areaID);
            }
            ChatManager.Instance.output.functionEnabled = true;
            ChatManager.Instance.privateChatTo(data.tagname,0,areaInfoII);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_EFFORT)
         {
            if(!EffortManager.Instance.getMainFrameVisible())
            {
               EffortManager.Instance.isSelf = true;
               EffortManager.Instance.switchVisible();
            }
         }
         else if(int(data.clicktype) == ChatFormats.CARD_CAO)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            SocketManager.Instance.out.sendGetLinkGoodsInfo(4,String(data.key));
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_CARD_INFO)
         {
            selfZone = PlayerManager.Instance.Self.ZoneID;
            other = int(data.zoneID);
            if(other > 0 && other != selfZone)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            SocketManager.Instance.out.sendGetLinkGoodsInfo(5,String(data.key));
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_LANTERN_BEGIN)
         {
            if(StateManager.currentStateType == StateType.MAIN)
            {
               if(LanternRiddlesManager.instance.isBegin)
               {
                  LanternRiddlesManager.instance.show();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.openTips"));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_FASTINVITE)
         {
            if(StateManager.currentStateType == StateType.FIGHTING || WorldBossHelperManager.Instance.isInWorldBossHelperFrame)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.FastInvite.cannotInvite"));
               return;
            }
            if(StateManager.currentStateType != StateType.ROOM_LIST && StateManager.currentStateType != StateType.DUNGEON_LIST && StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.FastInvite.cannotInvite2"));
               return;
            }
            if(StateManager.currentStateType == StateType.ROOM_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(1,-1,data.roomId,data.password,true);
            }
            else if(StateManager.currentStateType == StateType.DUNGEON_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(2,-1,data.roomId,data.password,true);
            }
            else
            {
               SocketManager.Instance.out.sendGameLogin(4,-1,data.roomId,data.password,true);
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_FASTAUCTION)
         {
            StateManager.createStateAsync(StateType.AUCTION,function(param1:*):void
            {
               new AuctionHouseController(true,data.auctionID);
            });
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_ENTERHUIKUI_ACTIVITY)
         {
            if(StateManager.currentStateType != StateType.MAIN)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
               return;
            }
            WonderfulActivityManager.Instance.clickWonderfulActView = true;
            WonderfulActivityManager.Instance.isSkipFromHall = true;
            WonderfulActivityManager.Instance.skipType = data.rewardType;
            SocketManager.Instance.out.requestWonderfulActInit(1);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_INVITE_OLD_PLAYER)
         {
            SocketManager.Instance.out.sendConsortiaInvate(data.tagname);
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_LANTERN_BEGIN)
         {
            if(StateManager.currentStateType == StateType.MAIN)
            {
               if(LanternRiddlesManager.instance.isBegin)
               {
                  LanternRiddlesManager.instance.show();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.openTips"));
            }
         }
         else if(int(data.clicktype) == ChatFormats.CLICK_TIME_GIFTPACK)
         {
            if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST)
            {
               BagAndInfoManager.Instance.showBagAndInfo();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
            }
         }
      }
      
      private function getPos(param1:Object, param2:ChatTransregionalNamePanel) : Point
      {
         var _loc8_:Rectangle = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc14_:Point = null;
         var _loc3_:String = String(param1.tagname);
         var _loc4_:int = int(_loc3_.indexOf("$"));
         if(_loc4_ > -1)
         {
            _loc3_ = _loc3_.substr(0,_loc4_);
         }
         var _loc5_:RegExp = new RegExp(_loc3_,"g");
         var _loc6_:String = this._contentField.text;
         var _loc7_:Object = _loc5_.exec(_loc6_);
         while(_loc7_ != null)
         {
            _loc9_ = int(_loc7_.index);
            _loc10_ = _loc9_ + String(param1.tagname).length;
            _loc11_ = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
            _loc12_ = this._contentField.getCharIndexAtPoint(_loc11_.x,_loc11_.y);
            if(_loc12_ >= _loc9_ && _loc12_ <= _loc10_)
            {
               this._contentField.setSelection(_loc9_,_loc10_);
               _loc8_ = this._contentField.getCharBoundaries(_loc10_);
               _loc13_ = this._contentField.localToGlobal(new Point(_loc8_.x,_loc8_.y));
               _loc14_ = new Point();
               _loc14_.x = _loc13_.x + _loc8_.width;
               _loc14_.y = _loc13_.y - param2.getHight() - (this._contentField.scrollV - 1) * 18;
               break;
            }
            _loc7_ = _loc5_.exec(_loc6_);
         }
         return _loc14_;
      }
      
      private function __stageClickHandler(param1:MouseEvent = null) : void
      {
         if(Boolean(param1))
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
            {
               this._goodTip.parent.removeChild(this._goodTip);
               LaterEquipmentGoodView.isShow = true;
            }
            if(Boolean(this._cardboxTip) && Boolean(this._cardboxTip.parent))
            {
               this._cardboxTip.parent.removeChild(this._cardboxTip);
            }
            if(Boolean(this._cardTip) && Boolean(this._cardTip.parent))
            {
               this._cardTip.parent.removeChild(this._cardTip);
            }
            if(Boolean(this._grooveTip) && Boolean(this._grooveTip.parent))
            {
               this._grooveTip.parent.removeChild(this._grooveTip);
            }
            if(Boolean(this._cardInfotTips) && Boolean(this._cardInfotTips.parent))
            {
               this._cardInfotTips.parent.removeChild(this._cardInfotTips);
            }
            if(Boolean(StageReferance.stage))
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function disposeView() : void
      {
         if(Boolean(this._contentField))
         {
            this.t_text = this._contentField.htmlText;
            removeChild(this._contentField);
         }
      }
      
      private function initEvent() : void
      {
         this._contentField.addEventListener(Event.SCROLL,this.__onScrollChanged);
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function initView() : void
      {
         this._contentField = new TextField();
         PositionUtils.setPos(this._contentField,"chat.outputfieldPos");
         this._contentField.multiline = true;
         this._contentField.wordWrap = true;
         this._contentField.filters = [new GlowFilter(0,1,4,4,8)];
         this._contentField.mouseWheelEnabled = false;
         Helpers.setTextfieldFormat(this._contentField,{
            "size":11,
            "leading":-1
         });
         this.updateScrollRect(NORMAL_WIDTH,NORMAL_HEIGHT);
         addChild(this._contentField);
      }
      
      private function onScrollChanged() : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
      }
      
      private function updateScrollRect(param1:Number, param2:Number) : void
      {
         this._srcollRect = new Rectangle(0,0,param1,param2);
         this._contentField.scrollRect = this._srcollRect;
      }
   }
}

