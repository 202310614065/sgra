package consortion.view.selfConsortia
{
   import bagAndInfo.cell.BaseCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionShopItem extends Sprite implements Disposeable
   {
      
      private var _info:ShopItemInfo;
      
      private var _enable:Boolean;
      
      private var _time:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _cellBG:DisplayObject;
      
      private var _cell:BaseCell;
      
      private var _limitCount:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _selfRichBg:MutipleImage;
      
      private var _selfRichText:FilterFrameText;
      
      private var _selfRichTxt:FilterFrameText;
      
      private var _btnArr:Vector.<ConsortionShopItemBtn>;
      
      private var _line:MutipleImage;
      
      public function ConsortionShopItem(param1:Boolean)
      {
         super();
         this._enable = param1;
         this.initView();
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("shopFrame.ItemBG1");
         this._cellBG = ComponentFactory.Instance.creatCustomObject("shopFrame.ItemCellBG");
         this._nameTxt = ComponentFactory.Instance.creat("consortion.shopItem.name");
         this._selfRichBg = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.selfRichOfferInputBG");
         this._selfRichText = ComponentFactory.Instance.creat("consortion.shop.selfRichOfferTxt");
         this._selfRichText.text = LanguageMgr.GetTranslation("consortion.shop.selfRichOfferTxt.text");
         this._selfRichTxt = ComponentFactory.Instance.creat("consortion.shop.selfRichOffer");
         this._line = ComponentFactory.Instance.creatComponentByStylename("consortion.shopFrame.VerticalLine");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,48,48);
         _loc1_.graphics.endFill();
         this._cell = new BaseCell(_loc1_);
         PositionUtils.setPos(this._cell,"consortion.shopItem.CellPos");
         this._limitCount = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItem.limitCount");
         addChild(this._bg);
         addChild(this._cellBG);
         addChild(this._cell);
         addChild(this._limitCount);
         addChild(this._nameTxt);
         addChild(this._selfRichBg);
         addChild(this._selfRichText);
         this._selfRichBg.visible = false;
         this._selfRichText.visible = false;
         addChild(this._selfRichTxt);
         addChild(this._line);
         this._selfRichTxt.visible = false;
         this._btnArr = new Vector.<ConsortionShopItemBtn>(3);
         this.setFilters = this._enable;
         this._limitCount.visible = false;
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(Boolean(this._btnArr[_loc1_]))
            {
               this._btnArr[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            }
            _loc1_++;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(Event.CHANGE,this.__limitChange);
         }
      }
      
      private function __limitChange(param1:Event) : void
      {
         this._limitCount.text = String(this._info.LimitCount);
      }
      
      public function set setFilters(param1:Boolean) : void
      {
         if(param1)
         {
            this._bg.filters = null;
         }
         else
         {
            this._bg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set info(param1:ShopItemInfo) : void
      {
         if(this._info == param1 || !param1)
         {
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(Event.CHANGE,this.__limitChange);
         }
         this._info = param1;
         this._info.addEventListener(Event.CHANGE,this.__limitChange);
         this.upView();
      }
      
      public function set neededRich(param1:int) : void
      {
         this._selfRichTxt.text = String(param1);
      }
      
      private function upView() : void
      {
         this._cell.info = this._info.TemplateInfo;
         this._nameTxt.text = this._info.TemplateInfo.Name;
         if(this._nameTxt.numLines > 1)
         {
            this._nameTxt.y = 3;
         }
         this._limitCount.text = String(this._info.LimitCount);
         this._limitCount.visible = this._info.TemplateInfo.CategoryID == EquipType.NECKLACE ? (this._info.TemplateID == 14011 ? false : true) : false;
         this._limitCount.visible = this._info.LimitCount > -1;
         this._selfRichBg.visible = true;
         this._selfRichText.visible = true;
         this._selfRichTxt.visible = true;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this._info.getItemPrice(_loc1_ + 1).IsValid)
            {
               this._btnArr[_loc1_] = new ConsortionShopItemBtn();
               addChild(this._btnArr[_loc1_]);
               PositionUtils.setPos(this._btnArr[_loc1_],"consortion.shopItem.btnPos" + _loc1_);
               this._btnArr[_loc1_].setValue(this._info.getItemPrice(_loc1_ + 1).toString(),this._info.getTimeToString(_loc1_ + 1));
               this._btnArr[_loc1_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            }
            _loc1_++;
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:QuickBuyFrame = null;
         var _loc5_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:ConsortionShopItemBtn = param1.currentTarget as ConsortionShopItemBtn;
         this._time = this._btnArr.indexOf(_loc2_) + 1;
         if(this.checkMoney())
         {
            if(this._info.getItemPrice(this._time).goldValue > 0)
            {
               _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc5_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return;
            }
            if(this._info.getItemPrice(this._time).moneyValue > 0)
            {
               _loc3_ = 3;
            }
            else if(this._info.getItemPrice(this._time).bandDdtMoneyValue > 0)
            {
               _loc3_ = 4;
            }
            else
            {
               _loc3_ = 2;
            }
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc4_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc4_.setItemID(this._info.TemplateID,_loc3_,this._time);
            _loc4_.buyFrom = 0;
            _loc4_.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            _loc4_.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(param1.ItemID,param1.ItemNum));
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(Boolean(_loc2_.parent))
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         ObjectUtils.disposeObject(_loc2_);
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(Boolean(this._info))
            {
               this.sendConsortiaShop();
            }
         }
      }
      
      private function sendConsortiaShop() : void
      {
         var _loc1_:Array = [this._info.GoodsID];
         var _loc2_:Array = [this._time];
         var _loc3_:Array = [""];
         var _loc4_:Array = [false];
         var _loc5_:Array = [""];
         var _loc6_:Array = [-1];
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc6_,_loc4_,_loc5_);
      }
      
      private function checkMoney() : Boolean
      {
         var _loc1_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         if(this._info.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return false;
         }
         if(!this._enable)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.checkMoney"));
            return false;
         }
         if(PlayerManager.Instance.Self.Gold < this._info.getItemPrice(this._time).goldValue)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return false;
         }
         if(PlayerManager.Instance.Self.Offer < this._info.getItemPrice(this._time).gesteValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongXunbuzu"));
            return false;
         }
         return true;
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         var _loc3_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         _loc2_.dispose();
         if(Boolean(_loc2_.parent))
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc3_.itemID = EquipType.GOLD_BOX;
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(Boolean(this._btnArr[_loc1_]))
            {
               ObjectUtils.disposeObject(this._btnArr[_loc1_]);
            }
            this._btnArr[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._cellBG = null;
         this._limitCount = null;
         this._cell = null;
         this._nameTxt = null;
         this._selfRichBg = null;
         this._selfRichText = null;
         this._selfRichTxt = null;
         this._line = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

