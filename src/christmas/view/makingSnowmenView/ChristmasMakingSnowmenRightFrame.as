package christmas.view.makingSnowmenView
{
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.items.ChristmasListItem;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import road7th.comm.PackageIn;
   
   public class ChristmasMakingSnowmenRightFrame extends Sprite implements Disposeable
   {
      
      public static var packsReceiveOK:Boolean;
      
      public static var specialItemId:int = 201156;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Array;
      
      private var SHOP_ITEM_NUM:int = 9;
      
      private var CURRENT_PAGE:int = 1;
      
      private var _shopItemArr:Array;
      
      public function ChristmasMakingSnowmenRightFrame()
      {
         super();
         this.initView();
         this.loadList();
         this.initEvent();
      }
      
      public function get shopItemArr() : Array
      {
         return this._shopItemArr;
      }
      
      public function set itemList(param1:Array) : void
      {
         this._itemList = param1;
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         var _loc2_:ChristmasListItem = null;
         var _loc3_:int = 0;
         this._list = ComponentFactory.Instance.creatComponentByStylename("christmas.goodsListBox");
         this._list.spacing = 5;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("christmas.right.scrollpanel");
         this._panel.x = 286;
         this._panel.y = 133;
         this._panel.width = 400;
         this._panel.height = 260;
         this._shopItemArr = new Array();
         this.SHOP_ITEM_NUM = ChristmasManager.instance.model.packsLen;
         this.itemList = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this.SHOP_ITEM_NUM)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("christmas.view.christmasShopItem");
            this.itemList.push(_loc2_);
            this.itemList[_loc1_].initView(_loc1_);
            if(_loc1_ <= this.SHOP_ITEM_NUM - 2)
            {
               if(ChristmasManager.instance.CanGetGift(_loc1_) && ChristmasManager.instance.model.count >= ChristmasManager.instance.model.snowPackNum[_loc1_])
               {
                  this.itemList[_loc1_].specialButton();
               }
            }
            else if(ChristmasManager.instance.model.lastPacks > ChristmasManager.instance.model.count)
            {
               this.itemList[_loc1_].grayButton();
            }
            else
            {
               this.itemList[_loc1_].specialButton();
               if(ChristmasManager.instance.model.count - ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 2] >= ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * (ChristmasManager.instance.model.packsNumber + 1))
               {
                  this.itemList[_loc1_]._poorTxt.text = LanguageMgr.GetTranslation("christmas.poortTxt.OK.LG");
               }
               else
               {
                  _loc3_ = ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] - (ChristmasManager.instance.model.count - (ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] + ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * ChristmasManager.instance.model.packsNumber));
                  this.itemList[_loc1_]._poorTxt.text = LanguageMgr.GetTranslation("christmas.list.poorTxt.LG",_loc3_);
               }
            }
            this.itemList[_loc1_].initText(ChristmasManager.instance.model.snowPackNum[_loc1_],_loc1_);
            this.itemList[_loc1_].y = (this.itemList[_loc1_].height + 1) * _loc1_;
            this._shopItemArr.push(this.itemList[_loc1_]);
            this._list.addChild(this.itemList[_loc1_]);
            _loc1_++;
         }
         this._panel.setView(this._list);
         addChild(this._panel);
         this._panel.invalidateViewport();
      }
      
      public function loadList() : void
      {
         this.setList(ChristmasManager.instance.model.myGiftData);
      }
      
      public function setList(param1:Vector.<ChristmasSystemItemsInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < this.SHOP_ITEM_NUM)
         {
            if(!param1)
            {
               break;
            }
            if(_loc2_ < param1.length && Boolean(param1[_loc2_]))
            {
               this.itemList[_loc2_].shopItemInfo = param1[_loc2_];
               this.itemList[_loc2_].itemID = param1[_loc2_].TemplateID;
            }
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         ChristmasManager.instance.addEventListener(CrazyTankSocketEvent.CHRISTMAS_PACKS,this.playerIsReceivePacks);
      }
      
      private function playerIsReceivePacks(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         ChristmasManager.instance.model.awardState = _loc2_.readInt();
         ChristmasManager.instance.model.packsNumber = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < this.SHOP_ITEM_NUM)
         {
            if(this.itemList[_loc4_].itemID == _loc3_ && _loc4_ < this.SHOP_ITEM_NUM - 1)
            {
               this.itemList[_loc4_].receiveOK();
               packsReceiveOK = true;
               break;
            }
            if(this.itemList[_loc4_].itemID == specialItemId && ChristmasManager.instance.model.lastPacks <= ChristmasManager.instance.model.count)
            {
               this.itemList[_loc4_].specialButton();
               if(ChristmasManager.instance.model.count - ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 2] >= ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * (ChristmasManager.instance.model.packsNumber + 1))
               {
                  this.itemList[_loc4_]._poorTxt.text = LanguageMgr.GetTranslation("christmas.poortTxt.OK.LG");
               }
               else
               {
                  _loc5_ = ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] - (ChristmasManager.instance.model.count - (ChristmasManager.instance.model.snowPackNum[ChristmasManager.instance.model.packsLen - 2] + ChristmasManager.instance.model.snowPackNum[this.SHOP_ITEM_NUM - 1] * ChristmasManager.instance.model.packsNumber));
                  this.itemList[_loc4_]._poorTxt.text = LanguageMgr.GetTranslation("christmas.list.poorTxt.LG",_loc5_);
               }
            }
            _loc4_++;
         }
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.SHOP_ITEM_NUM)
         {
            this.itemList[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         ChristmasManager.instance.removeEventListener(CrazyTankSocketEvent.CHRISTMAS_PACKS,this.playerIsReceivePacks);
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.itemList))
         {
            _loc1_ = 0;
            while(_loc1_ < this.itemList.length)
            {
               ObjectUtils.disposeObject(this.itemList[_loc1_]);
               this.itemList[_loc1_] = null;
               _loc1_++;
            }
            this.itemList = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

