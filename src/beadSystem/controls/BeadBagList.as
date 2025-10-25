package beadSystem.controls
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.model.BeadModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class BeadBagList extends BagListView
   {
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      private var _toPlace:int;
      
      private var _beadInfo:InventoryItemInfo;
      
      public function BeadBagList(param1:int, param2:int = 32, param3:int = 80, param4:int = 7)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         super(param1,param4);
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = (param1.currentTarget as BeadCell).itemInfo;
         this._beadInfo = _loc2_;
         if(Boolean(_loc2_) && !_loc2_.IsBinds)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         }
         else
         {
            this.doBeadEquip();
         }
      }
      
      private function doBeadEquip() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._beadInfo))
         {
            if(this._beadInfo.Property1 == "31")
            {
               if(this._beadInfo.IsBinds)
               {
               }
               _loc1_ = beadSystemManager.Instance.getEquipPlace(this._beadInfo);
               if(Boolean(PlayerManager.Instance.Self.BeadBag.getItemAt(4)) && _loc1_ == 4)
               {
                  if(!PlayerManager.Instance.Self.BeadBag.getItemAt(13) && BeadModel._BeadCells[13].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[13].HoleLv))
                  {
                     _loc1_ = 13;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(14) && BeadModel._BeadCells[14].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[14].HoleLv))
                  {
                     _loc1_ = 14;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(15) && BeadModel._BeadCells[15].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[15].HoleLv))
                  {
                     _loc1_ = 15;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(16) && BeadModel._BeadCells[16].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[16].HoleLv))
                  {
                     _loc1_ = 16;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(17) && BeadModel._BeadCells[17].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[17].HoleLv))
                  {
                     _loc1_ = 17;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(18) && BeadModel._BeadCells[18].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[18].HoleLv))
                  {
                     _loc1_ = 18;
                  }
               }
               SocketManager.Instance.out.sendBeadEquip(this._beadInfo.Place,_loc1_);
            }
         }
      }
      
      protected function __onBindRespones(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.doBeadEquip();
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function get BeadCells() : Dictionary
      {
         return _cells;
      }
      
      override protected function createCells() : void
      {
         var _loc2_:BeadCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = this._startIndex;
         while(_loc1_ <= this._stopIndex)
         {
            _loc2_ = BeadCell(CellFactory.instance.createBeadCell(_loc1_));
            addChild(_loc2_);
            _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.beadPlace] = _loc2_;
            _cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:String = null;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         clearDataCells();
         _bagdata = param1;
         for(_loc2_ in _bagdata.items)
         {
            if(_cells[_loc2_] != null)
            {
               _bagdata.items[_loc2_].isMoveSpace = true;
               _cells[_loc2_].itemInfo = _bagdata.items[_loc2_];
               _cells[_loc2_].info = _bagdata.items[_loc2_];
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _bagdata.getItemAt(_loc3_.Place);
            if(Boolean(_loc4_))
            {
               this.setCellInfo(_loc4_.Place,_loc4_);
            }
            else
            {
               this.setCellInfo(_loc3_.Place,null);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BeadCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param1 >= this._startIndex && param1 <= this._stopIndex)
         {
            if(param2 == null)
            {
               _cells[String(param1)].info = null;
               _cells[String(param1)].itemInfo = null;
               return;
            }
            if(param2.Count == 0)
            {
               _cells[String(param1)].info = null;
               _cells[String(param1)].itemInfo = null;
            }
            else
            {
               _cells[String(param1)].itemInfo = param2;
               _cells[String(param1)].info = param2;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:BeadCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc1_.locked = false;
            _loc1_.dispose();
         }
         _cells = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

