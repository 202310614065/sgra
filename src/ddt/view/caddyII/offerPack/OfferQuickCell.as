package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class OfferQuickCell extends BaseCell implements ISelectable
   {
      
      private var _mcBg:ScaleBitmapImage;
      
      private var _selected:Boolean;
      
      private var _selecetedShin:Scale9CornerImage;
      
      public function OfferQuickCell()
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("offer.quickCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         super(_loc2_);
         tipDirctions = "7,0";
         this.initView();
      }
      
      private function initView() : void
      {
         this._mcBg = ComponentFactory.Instance.creatComponentByStylename("offer.StoreShortcutCellBg");
         addChildAt(this._mcBg,0);
         this._selecetedShin = ComponentFactory.Instance.creatComponentByStylename("offer.oferQuickBuyShin");
         addChild(this._selecetedShin);
         this._selecetedShin.visible = this._selecetedShin.mouseChildren = this._selecetedShin.mouseEnabled = false;
         buttonMode = true;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         if(this._selected)
         {
            this._selecetedShin.visible = true;
            setChildIndex(this._selecetedShin,numChildren - 1);
         }
         else
         {
            this._selecetedShin.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      override public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function showBg() : void
      {
         this._mcBg.visible = true;
      }
      
      public function hideBg() : void
      {
         this._mcBg.visible = false;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._mcBg))
         {
            ObjectUtils.disposeObject(this._mcBg);
         }
         this._mcBg = null;
         if(Boolean(this._selecetedShin))
         {
            ObjectUtils.disposeObject(this._selecetedShin);
         }
         this._selecetedShin = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

