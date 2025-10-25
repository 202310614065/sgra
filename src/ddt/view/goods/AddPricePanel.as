package ddt.view.goods
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextFormat;
   
   public class AddPricePanel extends Frame
   {
      
      private static var _instance:AddPricePanel;
      
      private var _infoLabel:FilterFrameText;
      
      private var _payButton:TextButton;
      
      private var _cancelButton:TextButton;
      
      private var _leftLabel:Bitmap;
      
      private var _moneyButton:SelectedButton;
      
      private var _giftButton:SelectedButton;
      
      private var _radioGroup:SelectedButtonGroup;
      
      private var _payComBox:ComboBox;
      
      private var _isDress:Boolean;
      
      private var _info:InventoryItemInfo;
      
      private var _blueTF:TextFormat;
      
      private var _yellowTF:TextFormat;
      
      private var _grayFilter:ColorMatrixFilter;
      
      private var _currentAlert:BaseAlerFrame;
      
      private var _currentPayType:int;
      
      protected var _cartItemGroup:SelectedButtonGroup;
      
      protected var _cartItemSelectVBox:VBox;
      
      private var _bgLeft:ScaleBitmapImage;
      
      private var _bgRight:ScaleBitmapImage;
      
      private var _textI:FilterFrameText;
      
      private var _textII:FilterFrameText;
      
      private var _textIII:FilterFrameText;
      
      private var _textImg:Image;
      
      private var _dianquanBg:ScaleBitmapImage;
      
      private var _lijinBg:ScaleBitmapImage;
      
      private var _dianquanLogo:Bitmap;
      
      private var _lijinLogo:Bitmap;
      
      private var _dianquanFFT:FilterFrameText;
      
      private var _lijinFFT:FilterFrameText;
      
      private var _shopItems:Array;
      
      private var _currentShopItem:ShopCarItemInfo;
      
      private var _type:int = 1;
      
      public function AddPricePanel()
      {
         super();
         if(_instance != null)
         {
            return;
         }
         this.configUI();
      }
      
      public static function get Instance() : AddPricePanel
      {
         if(_instance == null)
         {
            _instance = ComponentFactory.Instance.creatCustomObject("reNewPricePanel");
         }
         return _instance;
      }
      
      private function configUI() : void
      {
         this._textImg = ComponentFactory.Instance.creat("reNew.TipsTextBg");
         addToContent(this._textImg);
         this._bgLeft = ComponentFactory.Instance.creat("renew.selectBtnbgI");
         addToContent(this._bgLeft);
         PositionUtils.setPos(this._bgLeft,"renew.leftPos");
         this._bgRight = ComponentFactory.Instance.creat("renew.selectBtnbg");
         addToContent(this._bgRight);
         PositionUtils.setPos(this._bgRight,"renew.rightPos");
         this._grayFilter = ComponentFactory.Instance.model.getSet("grayFilter");
         this._blueTF = ComponentFactory.Instance.model.getSet("bagAndInfo.AddPrice.BlueTF");
         this._yellowTF = ComponentFactory.Instance.model.getSet("bagAndInfo.AddPrice.YellowTF");
         titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._textI = ComponentFactory.Instance.creat("renew.TextI");
         addToContent(this._textI);
         this._textI.text = LanguageMgr.GetTranslation("ddt.bagandinfo.renew.txtI");
         PositionUtils.setPos(this._textI,"renew.txtPos1");
         this._textII = ComponentFactory.Instance.creat("renew.TextII");
         addToContent(this._textII);
         this._textII.text = LanguageMgr.GetTranslation("ddt.bagandinfo.renew.txtII");
         PositionUtils.setPos(this._textII,"renew.txtPos2");
         this._textIII = ComponentFactory.Instance.creat("renew.TextIII");
         addToContent(this._textIII);
         this._textIII.text = LanguageMgr.GetTranslation("ddt.bagandinfo.renew.txtIII");
         PositionUtils.setPos(this._textIII,"renew.txtPos3");
         this._moneyButton = ComponentFactory.Instance.creatComponentByStylename("AddPricePanel.RenewalDianJuan");
         addToContent(this._moneyButton);
         this._giftButton = ComponentFactory.Instance.creatComponentByStylename("AddPricePanel.RenewalGift");
         addToContent(this._giftButton);
         this._dianquanBg = ComponentFactory.Instance.creat("bagAndInfo.moneyViewBG");
         addToContent(this._dianquanBg);
         PositionUtils.setPos(this._dianquanBg,"bagAndInfo.moneyViewBGPos1");
         this._lijinBg = ComponentFactory.Instance.creat("bagAndInfo.moneyViewBG");
         addToContent(this._lijinBg);
         PositionUtils.setPos(this._lijinBg,"bagAndInfo.moneyViewBGPos2");
         this._dianquanLogo = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.PointCoupon");
         addToContent(this._dianquanLogo);
         PositionUtils.setPos(this._dianquanLogo,"renew.dianquanPos");
         this._lijinLogo = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.ddtMoney1");
         addToContent(this._lijinLogo);
         PositionUtils.setPos(this._lijinLogo,"renew.lijinPos");
         this._dianquanFFT = ComponentFactory.Instance.creat("renew.dianquanFFT");
         addToContent(this._dianquanFFT);
         this._dianquanFFT.text = LanguageMgr.GetTranslation("money");
         this._lijinFFT = ComponentFactory.Instance.creat("renew.lijinFFT");
         addToContent(this._lijinFFT);
         this._lijinFFT.text = LanguageMgr.GetTranslation("ddtMoney");
         this._radioGroup = new SelectedButtonGroup();
         this._radioGroup.addSelectItem(this._moneyButton);
         this._radioGroup.addSelectItem(this._giftButton);
         this._radioGroup.selectIndex = 0;
         this._payButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.AddPrice.PayButton");
         this._payButton.text = LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu");
         addToContent(this._payButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.AddPrice.CancelButton");
         this._cancelButton.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._cancelButton);
         this._cartItemGroup = new SelectedButtonGroup();
         this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("renew.CartItemSelectVBox");
         addToContent(this._cartItemSelectVBox);
      }
      
      public function setInfo(param1:InventoryItemInfo, param2:Boolean) : void
      {
         this._info = param1;
         this._isDress = param2;
         this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(this._info.TemplateID);
         this._currentShopItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._shopItems.length)
         {
            if(Boolean(this._shopItems[_loc3_].getItemPrice(1).IsMoneyType))
            {
               this._currentShopItem = this.fillToShopCarInfo(this._shopItems[_loc3_]);
               this._currentPayType = Price.MONEY;
               break;
            }
            _loc3_++;
         }
         if(this._currentShopItem == null)
         {
            this._currentShopItem = this.fillToShopCarInfo(this._shopItems[0]);
         }
         this._radioGroup.selectIndex = 0;
         this.resetRadioBtn();
         this.cartItemSelectVBoxInit();
      }
      
      protected function cartItemSelectVBoxInit() : void
      {
         var _loc2_:SelectedCheckButton = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(Boolean(this._cartItemGroup))
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         this._cartItemGroup = new SelectedButtonGroup();
         this._cartItemGroup.addEventListener(Event.CHANGE,this.__cartItemGroupChange);
         this._cartItemSelectVBox.disposeAllChildren();
         var _loc1_:int = 1;
         while(_loc1_ < 4)
         {
            if(this._currentShopItem.getItemPrice(_loc1_).IsValid)
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("reNewSelectBtn");
               _loc3_ = this._currentShopItem.getTimeToString(_loc1_) != LanguageMgr.GetTranslation("ddt.shop.buyTime1") ? this._currentShopItem.getTimeToString(_loc1_) : LanguageMgr.GetTranslation("ddt.shop.buyTime2");
               _loc4_ = this._currentShopItem.getItemPrice(_loc1_).toStringI();
               _loc2_.text = _loc4_ + "/" + _loc3_;
               this._cartItemSelectVBox.addChild(_loc2_);
               this._cartItemGroup.addSelectItem(_loc2_);
            }
            _loc1_++;
         }
         this._cartItemGroup.selectIndex = this._cartItemSelectVBox.numChildren - 1;
      }
      
      protected function __cartItemGroupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._currentShopItem.currentBuyType = this._cartItemGroup.selectIndex + 1;
      }
      
      private function fillToShopCarInfo(param1:ShopItemInfo) : ShopCarItemInfo
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ShopCarItemInfo = new ShopCarItemInfo(param1.GoodsID,param1.TemplateID,this._info.CategoryID);
         ObjectUtils.copyProperties(_loc2_,param1);
         return _loc2_;
      }
      
      private function resetRadioBtn() : void
      {
         this._moneyButton.enable = this._moneyButton.selected = false;
         this._moneyButton.filters = [this._grayFilter];
         this._dianquanFFT.filters = [this._grayFilter];
         this._dianquanLogo.filters = [this._grayFilter];
         this._dianquanBg.filters = [this._grayFilter];
         this._giftButton.enable = this._giftButton.selected = false;
         this._giftButton.filters = [this._grayFilter];
         this._lijinFFT.filters = [this._grayFilter];
         this._lijinLogo.filters = [this._grayFilter];
         this._lijinBg.filters = [this._grayFilter];
         var _loc1_:int = 0;
         while(_loc1_ < this._shopItems.length)
         {
            if(!(Boolean(this._shopItems[_loc1_].getItemPrice(1).IsMixed) || Boolean(this._shopItems[_loc1_].getItemPrice(2).IsMixed) || Boolean(this._shopItems[_loc1_].getItemPrice(3).IsMixed)))
            {
               if(Boolean(this._shopItems[_loc1_].getItemPrice(1).IsMoneyType))
               {
                  this._moneyButton.enable = true;
                  this._moneyButton.filters = null;
                  this._dianquanFFT.filters = null;
                  this._dianquanLogo.filters = null;
                  this._dianquanBg.filters = null;
               }
               else if(Boolean(this._shopItems[_loc1_].getItemPrice(1).IsBandDDTMoneyType) && this._info.IsBinds)
               {
                  this._giftButton.enable = true;
                  this._giftButton.filters = null;
                  if(Boolean(this._lijinFFT))
                  {
                     this._lijinFFT.dispose();
                  }
                  this._lijinFFT = ComponentFactory.Instance.creat("renew.lijinFFT");
                  addToContent(this._lijinFFT);
                  this._lijinFFT.text = LanguageMgr.GetTranslation("gift");
                  this._lijinLogo.filters = null;
                  this._lijinBg.filters = null;
               }
            }
            _loc1_++;
         }
         if(this._currentShopItem.getItemPrice(1).IsMoneyType)
         {
            this._moneyButton.selected = true;
         }
         else if(this._currentShopItem.getItemPrice(1).IsBandDDTMoneyType && this._info.IsBinds)
         {
            this._giftButton.selected = true;
         }
      }
      
      public function show() : void
      {
         this.addEvent();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onSelectRadioBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.currentTarget == this._moneyButton && this._currentPayType != Price.MONEY)
         {
            this.updateCurrentShopItem(Price.MONEY);
         }
         else if(param1.currentTarget == this._giftButton && this._currentPayType != Price.DDT_MONEY)
         {
            this.updateCurrentShopItem(Price.DDT_MONEY);
         }
         this.cartItemSelectVBoxInit();
      }
      
      private function updateCurrentShopItem(param1:int) : void
      {
         this._currentPayType = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._shopItems.length)
         {
            if(this._shopItems[_loc2_].getItemPrice(1).PriceType == param1)
            {
               this._currentShopItem = this.fillToShopCarInfo(this._shopItems[_loc2_]);
               break;
            }
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         this._moneyButton.addEventListener(MouseEvent.CLICK,this.__onSelectRadioBtn);
         this._giftButton.addEventListener(MouseEvent.CLICK,this.__onSelectRadioBtn);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCancelClick);
         this._payButton.addEventListener(MouseEvent.CLICK,this.__onPay);
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.close();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__onPay(null);
         }
      }
      
      private function removeEvent() : void
      {
         this._moneyButton.removeEventListener(MouseEvent.CLICK,this.__onSelectRadioBtn);
         this._giftButton.removeEventListener(MouseEvent.CLICK,this.__onSelectRadioBtn);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCancelClick);
         this._payButton.addEventListener(MouseEvent.CLICK,this.__onPay);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._currentAlert == _loc2_)
               {
                  this._currentAlert = null;
               }
               _loc2_.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._currentAlert == _loc2_)
               {
                  this._currentAlert = null;
               }
               LeavePageManager.leaveToFillPath();
               _loc2_.dispose();
         }
      }
      
      private function __onPay(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._currentShopItem.getItemPrice(this._cartItemGroup.selectIndex + 1).moneyValue > PlayerManager.Instance.Self.Money)
         {
            this._type = 1;
            this._currentAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._currentAlert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
         else if(this._currentShopItem.getItemPrice(this._cartItemGroup.selectIndex + 1).bandDdtMoneyValue > PlayerManager.Instance.Self.BandMoney)
         {
            this._type = 2;
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         }
         else
         {
            this.close();
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onPayResponse);
         }
      }
      
      private function __onPayResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onPayResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.doPay();
         }
      }
      
      private function __onCancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
         super.__onCloseClick(param1);
      }
      
      private function doPay() : void
      {
         var _loc1_:Array = null;
         if(Boolean(this._info))
         {
            _loc1_ = [];
            _loc1_.push([this._info.BagType,this._info.Place,this._currentShopItem.GoodsID,this._cartItemGroup.selectIndex + 1,this._isDress,this._type]);
            SocketManager.Instance.out.sendGoodsContinue(_loc1_);
            this.close();
         }
      }
      
      public function close() : void
      {
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

