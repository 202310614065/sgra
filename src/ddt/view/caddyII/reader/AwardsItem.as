package ddt.view.caddyII.reader
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatNamePanel;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import im.IMController;
   import im.IMView;
   
   public class AwardsItem extends Sprite implements Disposeable
   {
      
      public static const GOODSCLICK:String = "goods_click_awardsItem";
      
      private var _contentField:TextField;
      
      private var _info:AwardsInfo;
      
      private var _nameTip:ChatNamePanel;
      
      public function AwardsItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._contentField = ComponentFactory.Instance.creatCustomObject("caddy.readAward.ContentField");
         this._contentField.defaultTextFormat = ComponentFactory.Instance.model.getSet("caddy.readAward.ContentFieldTF");
         this._contentField.filters = [ComponentFactory.Instance.model.getSet("timebox.GF_22")];
         this._contentField.styleSheet = ChatFormats.styleSheet;
         addChild(this._contentField);
      }
      
      private function initEvents() : void
      {
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function removeEvents() : void
      {
         this._contentField.removeEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function createMessage() : void
      {
         var _loc6_:String = null;
         var _loc9_:String = null;
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.TemplateId);
         var _loc2_:ChatData = new ChatData();
         var _loc3_:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsPoint") + " ";
         var _loc4_:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsGong");
         var _loc5_:String = " <font color=\'#ffffff\'>" + ChatFormats.creatBracketsTag("[" + this._info.name + "] ",ChatFormats.CLICK_USERNAME) + "</font>";
         var _loc7_:String = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
         var _loc8_:String = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.card");
         if(CaddyModel.instance.type == CaddyModel.CARD_TYPE || CaddyModel.instance.type == CaddyModel.MY_CARDBOX || CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX)
         {
            if(this._info.zoneID == 0)
            {
               _loc2_.htmlMessage = " <font color=\'#ffad1b\'>" + _loc3_ + _loc4_ + _loc7_ + this._info.name;
               if(this._info.channel == 1)
               {
                  _loc2_.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.jin") + _loc8_;
               }
               else if(this._info.channel == 2)
               {
                  _loc2_.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.yin") + _loc8_;
               }
               else if(this.info.channel == 4)
               {
                  _loc2_.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.baijin") + _loc8_;
               }
               else
               {
                  _loc2_.htmlMessage += LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.tong") + _loc8_;
               }
               _loc2_.htmlMessage += "</font>";
            }
            else
            {
               _loc2_.htmlMessage = _loc3_ + _loc7_ + "(" + this._info.zoneID + ")" + LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText1");
            }
         }
         else
         {
            if(CaddyModel.instance.type == CaddyModel.BEAD_TYPE)
            {
               if(int(_loc1_.Property2) == 1)
               {
                  _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Attack");
               }
               else if(int(_loc1_.Property2) == 2)
               {
                  _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Defense");
               }
               else
               {
                  _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Attribute");
               }
            }
            else
            {
               _loc6_ = CaddyModel.instance.AwardsBuff;
            }
            _loc9_ = " " + ChatFormats.creatGoodTag("[" + _loc1_.Name + "]",ChatFormats.CLICK_GOODS,_loc1_.TemplateID,_loc1_.Quality,true,_loc2_);
            if(this._info.isLong)
            {
               _loc2_.htmlMessage = _loc3_ + _loc4_ + LanguageMgr.GetTranslation("tank.view.award.Player") + _loc5_ + _loc6_ + _loc9_ + "x" + this._info.count + "(" + this._info.zone + ")";
            }
            else
            {
               _loc2_.htmlMessage = _loc3_ + _loc4_ + _loc5_ + _loc6_ + _loc9_ + "x" + this._info.count;
            }
         }
         this.setChats(_loc2_);
      }
      
      private function setChats(param1:ChatData) : void
      {
         var _loc2_:String = "";
         _loc2_ += Helpers.deCodeString(param1.htmlMessage);
         this._contentField.htmlText = "<a>" + _loc2_ + "</a>";
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc4_:Point = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RegExp = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Point = null;
         var _loc16_:int = 0;
         var _loc17_:Rectangle = null;
         var _loc18_:Point = null;
         var _loc19_:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:Object = {};
         var _loc3_:Array = param1.text.split("|");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(Boolean(_loc3_[_loc5_].indexOf(":")))
            {
               _loc6_ = _loc3_[_loc5_].split(":");
               _loc2_[_loc6_[0]] = _loc6_[1];
            }
            _loc5_++;
         }
         if(int(_loc2_.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            _loc7_ = PlayerManager.Instance.Self.ZoneID;
            _loc8_ = this._info.zoneID;
            if(_loc8_ > 0 && _loc8_ != _loc7_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,_loc2_.tagname));
            }
            else if(IMController.Instance.isFriend(String(_loc2_.tagname)))
            {
               IMEManager.enable();
               ChatManager.Instance.output.functionEnabled = true;
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
            }
            else
            {
               if(this._nameTip == null)
               {
                  this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
               }
               _loc9_ = new RegExp(String(_loc2_.tagname),"g");
               _loc10_ = this._contentField.text;
               _loc11_ = _loc9_.exec(_loc10_);
               while(_loc11_ != null)
               {
                  _loc13_ = int(_loc11_.index);
                  _loc14_ = _loc13_ + String(_loc2_.tagname).length;
                  _loc15_ = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
                  _loc16_ = this._contentField.getCharIndexAtPoint(_loc15_.x,_loc15_.y);
                  if(_loc16_ >= _loc13_ && _loc16_ <= _loc14_)
                  {
                     this._contentField.setSelection(_loc13_,_loc14_);
                     _loc17_ = this._contentField.getCharBoundaries(_loc14_);
                     _loc18_ = this._contentField.localToGlobal(new Point(_loc17_.x,_loc17_.y));
                     this._nameTip.x = _loc18_.x + _loc17_.width;
                     this._nameTip.y = _loc18_.y - this._nameTip.getHeight;
                     break;
                  }
                  _loc11_ = _loc9_.exec(_loc10_);
               }
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
               this._nameTip.playerName = String(_loc2_.tagname);
               _loc12_ = ChatFormats.Channel_Set[int(_loc2_.channel)];
               if(_loc12_ == "null" || _loc12_ == null)
               {
                  this._nameTip.channel = " ";
               }
               else
               {
                  this._nameTip.channel = _loc12_;
               }
               this._nameTip.message = String(_loc2_.message);
               this._nameTip.setVisible = true;
            }
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_GOODS)
         {
            _loc4_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            _loc19_ = ItemManager.Instance.getTemplateById(_loc2_.templeteIDorItemID);
            _loc19_.BindType = _loc2_.isBind == "true" ? 0 : 1;
            this._showLinkGoodsInfo(_loc19_);
         }
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function _showLinkGoodsInfo(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Point = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
         var _loc3_:CaddyEvent = new CaddyEvent(AwardsItem.GOODSCLICK);
         _loc3_.itemTemplateInfo = param1;
         _loc3_.point = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      public function set info(param1:AwardsInfo) : void
      {
         this._info = param1;
         this.createMessage();
      }
      
      public function get info() : AwardsInfo
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this._contentField.textHeight + 5;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._info = null;
         if(Boolean(this._contentField))
         {
            ObjectUtils.disposeObject(this._contentField);
         }
         this._contentField = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

