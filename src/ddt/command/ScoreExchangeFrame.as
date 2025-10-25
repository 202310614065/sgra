package ddt.command
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ScoreExchangeFrame extends BaseAlerFrame
   {
      
      private var _sprite:Sprite;
      
      private var _number:NumberSelecter;
      
      private var _totalTipText:FilterFrameText;
      
      private var totalText:FilterFrameText;
      
      private var _cell:BaseCell;
      
      private var _shopItem:ShopItemInfo;
      
      private var _stoneNumber:int = 1;
      
      private var _price:int;
      
      private var _totalPrice:int;
      
      public var type:int;
      
      public function ScoreExchangeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:Image = null;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.dragonBoat.shopBuyFrame.titleTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc1_.moveEnable = false;
         _loc1_.autoDispose = false;
         _loc1_.sound = "008";
         info = _loc1_;
         this._sprite = new Sprite();
         PositionUtils.setPos(this._sprite,"scoreExchangeFrame.contentPos");
         addToContent(this._sprite);
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         this._sprite.addChild(_loc2_);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         this._sprite.addChild(this._number);
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         this._sprite.addChild(this._totalTipText);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         this._sprite.addChild(this.totalText);
         this._cell = new BaseCell(_loc3_);
         this._cell.x = _loc2_.x + 4;
         this._cell.y = _loc2_.y + 4;
         this._cell.tipDirctions = "7,0";
         this._sprite.addChild(this._cell);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._number.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         this.doBuy();
         this.dispose();
      }
      
      private function _numberClose(param1:Event) : void
      {
         this.dispose();
      }
      
      private function responseHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.doBuy();
               this.dispose();
         }
      }
      
      private function doBuy() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         switch(this.type)
         {
            case 0:
               _loc1_ = [];
               _loc2_ = [];
               _loc3_ = [];
               _loc4_ = [];
               _loc5_ = [];
               _loc6_ = [];
               _loc7_ = [];
               _loc8_ = 0;
               while(_loc8_ < this._stoneNumber)
               {
                  _loc1_.push(this._shopItem.GoodsID);
                  _loc2_.push(1);
                  _loc3_.push("");
                  _loc4_.push(false);
                  _loc5_.push("");
                  _loc6_.push(-1);
                  _loc7_.push(false);
                  _loc8_++;
               }
               SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc6_,_loc4_,_loc5_,0,null,_loc7_);
               break;
            case 1:
               SocketManager.Instance.out.sendDragonBoatExchange(this._shopItem.GoodsID,this._stoneNumber);
         }
      }
      
      private function selectHandler(param1:Event) : void
      {
         this._stoneNumber = this._number.number;
         this.refreshNumText();
      }
      
      public function set shopItem(param1:ShopItemInfo) : void
      {
         this._shopItem = param1;
         this._cell.info = ItemManager.Instance.getTemplateById(this._shopItem.TemplateID);
         switch(this.type)
         {
            case 0:
               this._price = this._shopItem == null ? 0 : this._shopItem.getItemPrice(1).scoreValue;
               this._number.maximum = PlayerManager.Instance.Self.Score / this._price;
               break;
            case 1:
               this._price = this._shopItem == null ? 0 : this._shopItem.AValue1;
               this._number.maximum = DragonBoatManager.instance.useableScore / this._price;
         }
         this.refreshNumText();
      }
      
      private function refreshNumText() : void
      {
         this._totalPrice = this._stoneNumber * this._price;
         this.totalText.text = this._totalPrice + Price.SCORETOSTRING;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._number.removeEventListener(Event.CHANGE,this.selectHandler);
         this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._number.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._sprite);
         super.dispose();
         this._sprite = null;
         this._number = null;
         this._totalTipText = null;
         this.totalText = null;
         this._cell = null;
         this._shopItem = null;
      }
   }
}

