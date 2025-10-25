package auctionHouse.view
{
   import auctionHouse.controller.AuctionHouseController;
   import auctionHouse.model.AuctionHouseModel;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import shop.view.ShopPresentClearingFrame;
   
   public class FastAuctionView extends Frame
   {
      
      private var _view:Sprite = new Sprite();
      
      private var _controller:AuctionHouseController;
      
      private var _model:AuctionHouseModel;
      
      private var _data:AuctionGoodsInfo;
      
      private var _bidMoney:BidMoneyView;
      
      private var _mouthfulBtn:BaseButton;
      
      private var _bidBtn:BaseButton;
      
      private var _askBtn:BaseButton;
      
      private var _givingBtn:BaseButton;
      
      private var giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _friendInfo:Object;
      
      private var _btClickLock:Boolean;
      
      private var _isUpdating:Boolean;
      
      private var _isAsk:Boolean;
      
      public function FastAuctionView(param1:AuctionGoodsInfo, param2:AuctionHouseController, param3:AuctionHouseModel)
      {
         this._data = param1;
         this._controller = param2;
         this._model = param3;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:BagCell = null;
         addToContent(this._view);
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.fastAuctionBg");
         this._view.addChild(_loc1_);
         _loc2_ = this._data.BagItemInfo as ItemTemplateInfo;
         _loc3_ = new BagCell(0,_loc2_,false,null,false);
         _loc3_.setContentSize(72,72);
         _loc3_.setBgVisible(false);
         _loc3_._tbxCount.x = 54;
         _loc3_._tbxCount.y = 52;
         this._view.addChild(_loc3_);
         PositionUtils.setPos(_loc3_,"asset.ddtauction.fastAuctionItemPos");
         var _loc4_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.itemName");
         _loc4_.text = _loc2_.Name;
         this._view.addChild(_loc4_);
         var _loc5_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.endTimeTxt");
         _loc5_.text = this._data.getSithTimeDescription();
         this._view.addChild(_loc5_);
         this._givingBtn = ComponentFactory.Instance.creat("ddtauction.FastAuction.givingBtn");
         this._view.addChild(this._givingBtn);
         this._askBtn = ComponentFactory.Instance.creat("ddtauction.FastAuction.askBtn");
         this._view.addChild(this._askBtn);
         this._bidBtn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
         PositionUtils.setPos(this._bidBtn,"asset.ddtauction.fastAuctionbidBtn");
         this._view.addChild(this._bidBtn);
         this._mouthfulBtn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
         PositionUtils.setPos(this._mouthfulBtn,"asset.ddtauction.fastAuctionMouthfulBtn");
         this._view.addChild(this._mouthfulBtn);
         var _loc6_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.money");
         _loc6_.text = String(PlayerManager.Instance.Self.Money);
         this._view.addChild(_loc6_);
         titleText = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.fastAuctionTitle");
         var _loc7_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         _loc7_.text = this._data.BagItemInfo.Count + "";
         PositionUtils.setPos(_loc7_,"asset.ddtauction.fastAuctionNumber");
         this._view.addChild(_loc7_);
         var _loc8_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         _loc8_.text = this._data.Price + "";
         PositionUtils.setPos(_loc8_,"asset.ddtauction.fastAuctionPrice");
         this._view.addChild(_loc8_);
         var _loc9_:FilterFrameText = ComponentFactory.Instance.creat("ddtauction.FastAuction.numberTxt");
         _loc9_.text = this._data.Mouthful + "";
         PositionUtils.setPos(_loc9_,"asset.ddtauction.fastAuctionMouthful");
         this._view.addChild(_loc9_);
         this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
         this.initialiseBtn();
         this.init_FUL_BID_btnStatue();
         this._mouthfulBtn.addEventListener(MouseEvent.CLICK,this.__mouthFull);
         this._bidBtn.addEventListener(MouseEvent.CLICK,this.__bid);
         this._askBtn.addEventListener(MouseEvent.CLICK,this.askHander);
         this._givingBtn.addEventListener(MouseEvent.CLICK,this.sendHander);
      }
      
      private function initialiseBtn() : void
      {
         this._mouthfulBtn.enable = false;
         this._bidBtn.enable = false;
         this._bidMoney.cannotBid();
      }
      
      private function getMouthful() : int
      {
         return Boolean(this._data.Mouthful) ? this._data.Mouthful : 0;
      }
      
      private function __mouthFull(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this.getMouthful() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthfulBtn.enable = false;
               this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               BaglockedManager.Instance.show();
               return;
            }
            this._mouthfulBtn.enable = false;
            this._bidBtn.enable = false;
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _responseIV(param1:FrameEvent) : void
      {
         this._checkResponse(param1.responseCode,this.__mouthFullOk,this.__cancel);
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         ObjectUtils.disposeObject(param1.target);
         this._isUpdating = false;
      }
      
      private function __mouthFullOk() : void
      {
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
               this._bidBtn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Your") + String(this.getMouthful()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               return;
            }
            var _loc1_:AuctionGoodsInfo = this._data;
            if(_loc1_ && _loc1_.AuctionID && Boolean(_loc1_.Mouthful))
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,_loc1_.Mouthful);
               IMController.Instance.saveRecentContactsID(_loc1_.AuctioneerID);
               this._bidMoney.cannotBid();
               this.dispose();
            }
            return;
         }
      }
      
      private function __cancel() : void
      {
         this.init_FUL_BID_btnStatue();
      }
      
      private function init_FUL_BID_btnStatue() : void
      {
         this._bidBtn.enable = false;
         this._bidBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._mouthfulBtn.enable = false;
         this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(this._isUpdating)
         {
            return;
         }
         var _loc1_:AuctionGoodsInfo = this._data;
         if(_loc1_ == null || _loc1_.AuctioneerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            return;
         }
         if(_loc1_.BuyerID == PlayerManager.Instance.Self.ID)
         {
            this.initialiseBtn();
            this._givingBtn.enable = this._askBtn.enable = this._mouthfulBtn.enable = this._mouthfulBtn.enable = _loc1_.Mouthful == 0 ? false : true;
            this._askBtn.filters = this._givingBtn.filters = this._mouthfulBtn.filters = _loc1_.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
            return;
         }
         this._givingBtn.enable = this._askBtn.enable = this._mouthfulBtn.enable = this._mouthfulBtn.enable = _loc1_.Mouthful == 0 ? false : true;
         this._askBtn.filters = this._givingBtn.filters = this._mouthfulBtn.filters = _loc1_.Mouthful == 0 ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter");
         this._bidBtn.enable = true;
         if(_loc1_.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
      }
      
      private function getBidPrice() : int
      {
         var _loc1_:AuctionGoodsInfo = this._data;
         if(Boolean(_loc1_))
         {
            return _loc1_.BuyerName == "" ? _loc1_.Price : _loc1_.Price + _loc1_.Rise;
         }
         return 0;
      }
      
      private function _checkResponse(param1:int, param2:Function = null, param3:Function = null, param4:Function = null) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               param2();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               param3();
         }
      }
      
      private function checkPlayerMoney() : void
      {
         var _loc1_:AuctionGoodsInfo = this._data;
         this._bidBtn.enable = false;
         this._mouthfulBtn.enable = false;
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.Mouthful != 0 && this.getMouthful() <= PlayerManager.Instance.Self.Money)
         {
            this._mouthfulBtn.enable = true;
         }
      }
      
      private function __bid(param1:MouseEvent) : void
      {
         var alert1:AuctionInputFrame = null;
         var _bidKeyUp:Function = null;
         var _responseII:Function = null;
         var event:MouseEvent = param1;
         SoundManager.instance.play("047");
         this._btClickLock = true;
         if(this._data.PayType == 0)
         {
            this._bidMoney.canGoldBid(this.getBidPrice());
         }
         else
         {
            this._bidMoney.canMoneyBid(this.getBidPrice());
         }
         if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            _bidKeyUp = function(param1:Event):void
            {
               SoundManager.instance.play("008");
               __bidOk();
               alert1.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(alert1);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            _responseII = function(param1:FrameEvent):void
            {
               SoundManager.instance.play("008");
               _checkResponse(param1.responseCode,__bidOk,__cancel);
               var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
               _loc2_.removeEventListener(FrameEvent.RESPONSE,_responseII);
               _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP,_bidKeyUp);
               ObjectUtils.disposeObject(param1.target);
               _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
               _isUpdating = false;
            };
            this.checkPlayerMoney();
            this._bidBtn.enable = false;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               this._mouthfulBtn.enable = false;
               this._mouthfulBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._bidBtn.enable = true;
               BaglockedManager.Instance.show();
               return;
            }
            alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
            LayerManager.Instance.addToLayer(alert1,1,alert1.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            alert1.addToContent(this._bidMoney);
            this._bidMoney.money.setFocus();
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE,_responseII);
            this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP,_bidKeyUp);
         }
      }
      
      private function __bidOk() : void
      {
         this._isUpdating = true;
         if(this._btClickLock)
         {
            this._btClickLock = false;
            if(this.getBidPrice() > this._bidMoney.getData())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.Auction") + String(this.getBidPrice()) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple"));
               this._bidBtn.enable = true;
               return;
            }
            if(this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
               this._bidBtn.enable = true;
               LeavePageManager.showFillFrame();
               return;
            }
            if(this.getMouthful() != 0 && this._bidMoney.getData() >= this.getMouthful())
            {
               this._btClickLock = true;
               this._mouthfulBtn.enable = false;
               this._bidBtn.enable = false;
               this.__mouthFullOk();
               return;
            }
            var _loc1_:AuctionGoodsInfo = this._data;
            if(Boolean(_loc1_))
            {
               SocketManager.Instance.out.auctionBid(_loc1_.AuctionID,this._bidMoney.getData());
               IMController.Instance.saveRecentContactsID(_loc1_.AuctioneerID);
               _loc1_ = null;
               this.dispose();
            }
            return;
         }
      }
      
      protected function sendHander(param1:MouseEvent) : void
      {
         if(Boolean(this.giveFriendOpenFrame))
         {
            this.giveFriendOpenFrame.dispose();
            this.giveFriendOpenFrame = null;
         }
         this._isAsk = false;
         this.giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this.giveFriendOpenFrame.nameInput.enable = true;
         this.giveFriendOpenFrame.titleTxt.visible = false;
         this.giveFriendOpenFrame.setType();
         this.giveFriendOpenFrame.show();
         this.giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick,false,0,true);
         this.giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
      }
      
      private function responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this;
         }
      }
      
      protected function askHander(param1:MouseEvent) : void
      {
         if(Boolean(this.giveFriendOpenFrame))
         {
            this.giveFriendOpenFrame.dispose();
            this.giveFriendOpenFrame = null;
         }
         this._isAsk = true;
         this.giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this.giveFriendOpenFrame.nameInput.enable = true;
         this.giveFriendOpenFrame.titleTxt.visible = false;
         this.giveFriendOpenFrame.setType(ShopPresentClearingFrame.FPAYTYPE_PAIMAI);
         this.giveFriendOpenFrame.show();
         this.giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.presentBtnClick,false,0,true);
         this.giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
      }
      
      private function presentBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this.giveFriendOpenFrame.nameInput.text;
         var _loc3_:AuctionGoodsInfo = this._data;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(_loc2_ == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(_loc2_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         if(this._isAsk)
         {
            SocketManager.Instance.out.requestAuctionPay(_loc3_.AuctionID,this.giveFriendOpenFrame.Name,this.giveFriendOpenFrame.textArea.text);
         }
         else if(!BuriedManager.Instance.checkMoney(false,_loc3_.Mouthful))
         {
            SocketManager.Instance.out.sendForAuction(_loc3_.AuctionID,this.giveFriendOpenFrame.Name);
         }
         this._friendInfo = {};
         this._friendInfo["id"] = this.giveFriendOpenFrame.selectPlayerId;
         this._friendInfo["name"] = _loc2_;
         this._friendInfo["msg"] = FilterWordManager.filterWrod(this.giveFriendOpenFrame.textArea.text);
         this.giveFriendOpenFrame.dispose();
         this.giveFriendOpenFrame = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._controller))
         {
            this._controller.disposeMe();
            this._controller = null;
         }
         this._model = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeAllChildren(this._view);
         }
         this._view = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

