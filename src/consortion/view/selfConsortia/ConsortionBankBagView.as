package consortion.view.selfConsortia
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   
   public class ConsortionBankBagView extends BagView
   {
      
      private static var LIST_WIDTH:int = 330;
      
      private static var LIST_HEIGHT:int = 320;
      
      private var _bank:ConsortionBankListView;
      
      private var _titleBitmap:Bitmap;
      
      private var _titleText2:FilterFrameText;
      
      private const MAX_HEIGHT:int = 455;
      
      public function ConsortionBankBagView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.setInit();
         this.setData(PlayerManager.Instance.Self);
      }
      
      private function setInit() : void
      {
         _tabBtn3.buttonMode = false;
         _tabBtn3.mouseEnabled = false;
         _tabBtn3.mouseChildren = false;
         _bagLockBtn.visible = false;
      }
      
      override public function setBagType(param1:int) : void
      {
         super.setBagType(param1);
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(Boolean(_keySortBtn) && _isSkillCanUse())
         {
            _keySortBtn.enable = true;
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._bank.addEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.addEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,this.__listChange);
         _proplist.addEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._bank.removeEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.removeEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         _proplist.removeEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
      }
      
      override protected function initBackGround() : void
      {
         super.initBackGround();
         this._bank = new ConsortionBankListView(11,PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
         PositionUtils.setPos(this._bank,"consortion.bank.Pos");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.consortiaii.bag.bagTitle");
         this._titleText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBagView.titleText2");
         this._titleText2.text = LanguageMgr.GetTranslation("consortion.bankBagView.titleText2");
         addChild(this._bank);
      }
      
      override protected function __listChange(param1:Event) : void
      {
         if(Boolean(_dressbagView) && _dressbagView.visible == true)
         {
            return;
         }
         if(param1.currentTarget == _equiplist)
         {
            this.setBagType(BagInfo.EQUIPBAG);
         }
         else
         {
            this.setBagType(BagInfo.PROPBAG);
         }
      }
      
      override protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._bank.checkConsortiaStoreCell();
         if(_loc2_ > 0)
         {
            if(_loc2_ == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
            }
            else if(_loc2_ == 2 || _loc2_ == 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick.msg"));
            }
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc3_:BagCell = param1.data as BagCell;
         var _loc4_:InventoryItemInfo = _loc3_.info as InventoryItemInfo;
         if(this.checkDressSaved(_loc4_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
            return;
         }
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
         var _loc6_:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(!_loc3_.locked)
         {
            SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,BagInfo.CONSORTIA,-1);
         }
      }
      
      private function __bankCellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               _loc2_.dragStart();
            }
         }
      }
      
      private function __bankCellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BagCell = param1.data as BagCell;
         var _loc3_:InventoryItemInfo = _loc2_.itemInfo;
         SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this.getItemBagType(_loc3_),-1,_loc3_.Count);
      }
      
      private function getItemBagType(param1:InventoryItemInfo) : int
      {
         if(EquipType.isBelongToPropBag(param1))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
      
      private function __upConsortiaStroeLevel(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["StoreLevel"]))
         {
            this.__addToStageHandler(null);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._bank.upLevel(PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
      }
      
      public function setData(param1:SelfInfo) : void
      {
         _equiplist.setData(param1.Bag);
         _proplist.setData(param1.PropBag);
         this._bank.setData(param1.ConsortiaBag);
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(!DressUtils.isDress(_loc3_) && (_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_)))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 77);
               }
               else
               {
                  if(this.checkDressSaved(_loc3_))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
                     return;
                  }
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      override protected function __cellMove(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         if(this.checkDressSaved(_loc3_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
            return;
         }
         super.__cellMove(param1);
      }
      
      private function checkDressSaved(param1:InventoryItemInfo) : Boolean
      {
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:DressVo = null;
         if(!DressUtils.isDress(param1))
         {
            return false;
         }
         var _loc2_:BagInfo = PlayerManager.Instance.Self.Bag;
         var _loc3_:int = 0;
         while(_loc3_ <= DressModel.DRESS_LEN - 1)
         {
            _loc6_ = _loc2_.items[DressUtils.getBagItems(_loc3_)];
            if(Boolean(_loc6_) && param1.ItemID == _loc6_.ItemID)
            {
               return true;
            }
            _loc3_++;
         }
         var _loc4_:Array = PlayerDressManager.instance.modelArr;
         var _loc5_:int = 0;
         while(_loc5_ <= _loc4_.length - 1)
         {
            _loc7_ = _loc4_[_loc5_];
            if(Boolean(_loc7_))
            {
               _loc8_ = 0;
               while(_loc8_ <= _loc7_.length - 1)
               {
                  _loc9_ = _loc7_[_loc8_];
                  if(param1.ItemID == _loc9_.itemId)
                  {
                     return true;
                  }
                  _loc8_++;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      override protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.CONSORTIA);
         PlayerManager.Instance.Self.PropBag.sortBag(CONSORTION,_loc2_,0,100,_bagArrangeSprite.arrangeAdd);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bank))
         {
            this._bank.dispose();
         }
         this._bank = null;
         if(Boolean(this._titleBitmap))
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         if(Boolean(this._titleText2))
         {
            ObjectUtils.disposeObject(this._titleText2);
         }
         this._titleText2 = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

