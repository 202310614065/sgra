package ddt.view.bossbox
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BoxAwardsCell extends BaseCell implements IListCell
   {
      
      protected var _itemName:FilterFrameText;
      
      protected var count_txt:FilterFrameText;
      
      private var di:ScaleBitmapImage;
      
      public function BoxAwardsCell()
      {
         super(ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectCellBGAsset"));
         this.initII();
         this.addEvent();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(5,5);
      }
      
      protected function initII() : void
      {
         this.di = ComponentFactory.Instance.creat("Vip.GetAwardsItemBG");
         var _loc1_:* = ComponentFactory.Instance.creat("Vip.GetAwardsItemCellBG");
         addChild(this.di);
         addChild(_loc1_);
         this._itemName = ComponentFactory.Instance.creat("roulette.GoodsCellName");
         this._itemName.mouseEnabled = false;
         this._itemName.multiline = false;
         this._itemName.wordWrap = true;
         addChild(this._itemName);
         this.count_txt = ComponentFactory.Instance.creat("bossbox.boxCellCount");
         addChild(this.count_txt);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
      }
      
      public function setCellValue(param1:*) : void
      {
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.CHANGE,this.__setItemName);
      }
      
      public function set count(param1:int) : void
      {
         this.count_txt.parent.removeChild(this.count_txt);
         addChild(this.count_txt);
         if(param1 <= 1)
         {
            this.count_txt.text = "";
            return;
         }
         this.count_txt.text = String(param1);
      }
      
      public function __setItemName(param1:Event) : void
      {
         this.itemName = _info.Name;
      }
      
      public function set itemName(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._itemName.text = param1;
         this._itemName.y = (44 - this._itemName.textHeight) / 2 + 5;
         if(this._itemName.numLines > 3)
         {
            _loc2_ = this._itemName.getLineText(3);
            _loc3_ = this._itemName.getLineText(1) + this._itemName.getLineText(2) + _loc2_;
            if(_loc2_.length > 10)
            {
               this._itemName.text = _loc3_.substring(0,_loc3_.length - 3) + "...";
            }
            else
            {
               this._itemName.text = _loc3_ + "...";
            }
            this._itemName.y = 4.5;
         }
      }
      
      override public function get height() : Number
      {
         return this.di.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(Event.CHANGE,this.__setItemName);
         if(Boolean(this._itemName))
         {
            ObjectUtils.disposeObject(this._itemName);
         }
         if(Boolean(this.di))
         {
            ObjectUtils.disposeObject(this.di);
         }
         this.di = null;
         this._itemName = null;
         if(Boolean(this.count_txt))
         {
            ObjectUtils.disposeObject(this.count_txt);
         }
         this.count_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

