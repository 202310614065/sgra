package calendar.view.goodsExchange
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import wonderfulActivity.event.ActivityEvent;
   
   public class GoodsExchangeCell extends BaseCell
   {
      
      private var _gooodsExchangeInfo:GoodsExchangeInfo;
      
      private var _countText:FilterFrameText;
      
      private var _type:Boolean;
      
      private var _haveCount:int;
      
      private var _needCount:int;
      
      private var _haveCountTemp:int;
      
      private var _id:int;
      
      public function GoodsExchangeCell(param1:GoodsExchangeInfo, param2:int = -1, param3:Boolean = true, param4:int = -1)
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:int = 0;
         this.intEvent();
         this._gooodsExchangeInfo = param1;
         this._type = param3;
         this._id = param4;
         if(Boolean(param1) && (param2 == 3 || param2 == 4))
         {
            if(param2 == 4)
            {
               if(this._type)
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.wordBg");
               }
               else
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
               }
               _bg.alpha = 0;
            }
            else
            {
               _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
            }
         }
         else
         {
            _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
         }
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
         if(this._gooodsExchangeInfo == null)
         {
            _info = null;
            this._countText.text = "";
         }
         else
         {
            _loc5_ = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.TemplateID);
            _loc6_ = new InventoryItemInfo();
            _loc6_.TemplateID = _loc5_.TemplateID;
            ItemManager.fill(_loc6_);
            _loc6_.StrengthenLevel = this._gooodsExchangeInfo.LimitValue;
            _loc6_.IsBinds = true;
            _loc6_.isShowBind = this._type != true;
            _info = _loc6_;
            if(this._type)
            {
               _loc7_ = param1.TemplateID;
               if(_loc6_.CanStrengthen)
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc7_,this._gooodsExchangeInfo.LimitValue);
               }
               else
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc7_);
               }
               if(this._haveCount == 0)
               {
                  this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc7_);
               }
               if(this._haveCount == 0)
               {
                  this._haveCount = PlayerManager.Instance.Self.BeadBag.getItemCountByTemplateId(_loc7_);
               }
               this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.ItemCount * this._gooodsExchangeInfo.Num).toString();
            }
            else
            {
               this._countText.text = (this._gooodsExchangeInfo.ItemCount * this._gooodsExchangeInfo.Num).toString();
            }
         }
         this._haveCountTemp = this._haveCount;
         super(_bg,_info);
         addChild(this._countText);
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         var _loc1_:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(this._gooodsExchangeInfo.TemplateID);
         if(_loc1_.length == 0)
         {
            _loc1_ = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(this._gooodsExchangeInfo.TemplateID);
         }
         if(_loc1_.length == 0)
         {
            _loc1_ = PlayerManager.Instance.Self.BeadBag.findItemsByTempleteID(this._gooodsExchangeInfo.TemplateID);
         }
         return _loc1_[0];
      }
      
      private function intEvent() : void
      {
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
      }
      
      private function __updateCount(param1:BagEvent) : void
      {
         var _loc5_:ActivityEvent = null;
         if(!this._gooodsExchangeInfo)
         {
            return;
         }
         var _loc2_:int = this._gooodsExchangeInfo.TemplateID;
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.TemplateID);
         var _loc4_:InventoryItemInfo = new InventoryItemInfo();
         _loc4_.TemplateID = _loc3_.TemplateID;
         ItemManager.fill(_loc4_);
         _loc4_.StrengthenLevel = this._gooodsExchangeInfo.LimitValue;
         _loc4_.IsBinds = true;
         _loc4_.isShowBind = this._type != true;
         if(_loc4_.CanStrengthen)
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc2_,this._gooodsExchangeInfo.LimitValue);
         }
         else
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc2_);
         }
         if(this._haveCount == 0)
         {
            this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc2_);
         }
         if(this._haveCount == 0)
         {
            this._haveCount = PlayerManager.Instance.Self.BeadBag.getItemCountByTemplateId(_loc2_);
         }
         if(!this._countText)
         {
            this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
            addChild(this._countText);
         }
         if(this._haveCountTemp != this._haveCount)
         {
            this._haveCountTemp = this._haveCount;
            _loc5_ = new ActivityEvent(ActivityEvent.UPDATE_COUNT);
            _loc5_.id = this._id;
            dispatchEvent(_loc5_);
         }
         if(this._type)
         {
            this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.ItemCount * 1).toString();
         }
         else
         {
            this._countText.text = (this._gooodsExchangeInfo.ItemCount * 1).toString();
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function get needCount() : int
      {
         return this._needCount = int(this.haveCount / this._gooodsExchangeInfo.ItemCount);
      }
      
      public function get gooodsExchangeInfo() : GoodsExchangeInfo
      {
         return this._gooodsExchangeInfo;
      }
      
      override public function dispose() : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         super.dispose();
         if(Boolean(this._countText))
         {
            ObjectUtils.disposeObject(this._countText);
         }
         this._countText = null;
      }
   }
}

