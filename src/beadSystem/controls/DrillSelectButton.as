package beadSystem.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.list.IDropListTarget;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.BaseLayer;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class DrillSelectButton extends Component implements IDropListTarget
   {
      
      private var _btn:BaseButton;
      
      private var _itemInfo:DrillItemInfo;
      
      private var _data:InventoryItemInfo;
      
      private var _frameText:FilterFrameText;
      
      private var _dataIcon:BitmapLoaderProxy;
      
      public function DrillSelectButton()
      {
         super();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.selectDrillBtn");
         addChild(this._btn);
         this._frameText = ComponentFactory.Instance.creatComponentByStylename("beadSystem.drillItemText");
         PositionUtils.setPos(this._frameText,"beadSystem.DrillSelectBtnTextPos");
         this._frameText.text = LanguageMgr.GetTranslation("ddt.beadSystem.chooseDrill");
         addChild(this._frameText);
         tipDirctions = "5,4,2,1,7,6,3,0,6";
         tipGapV = 10;
         tipGapH = 10;
         tipStyle = "core.GoodsTip";
         ShowTipManager.Instance.addTip(this);
      }
      
      public function setCursor(param1:int) : void
      {
      }
      
      public function get caretIndex() : int
      {
         return 0;
      }
      
      public function setValue(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc4_:GoodTipInfo = null;
         var _loc2_:InventoryItemInfo = this._data;
         this._itemInfo = param1;
         this._data = Boolean(this._itemInfo) ? this._itemInfo.itemInfo : null;
         if(this._data != null)
         {
            if(this._data != _loc2_)
            {
               ObjectUtils.disposeObject(this._dataIcon);
               this._dataIcon = null;
               _loc3_ = PathManager.solveGoodsPath(this._data.CategoryID,this._data.Pic,this._data.NeedSex == 1,BaseLayer.ICON,"A","1",this._data.Level,false,this._data.type);
               this._dataIcon = new BitmapLoaderProxy(_loc3_,new Rectangle(0,0,24,24));
               PositionUtils.setPos(this._dataIcon,"beadSystem.DrillItemIconPos");
               addChild(this._dataIcon);
               _loc4_ = new GoodTipInfo();
               _loc4_.itemInfo = ItemManager.Instance.getTemplateById(this._data.TemplateID);
               tipData = _loc4_;
            }
            PositionUtils.setPos(this._frameText,"beadSystem.DrillItemTextPos");
            this._frameText.text = this._itemInfo.amount.toString();
         }
         else
         {
            ObjectUtils.disposeObject(this._dataIcon);
            this._dataIcon = null;
            PositionUtils.setPos(this._frameText,"beadSystem.DrillSelectBtnTextPos");
            this._frameText.text = LanguageMgr.GetTranslation("ddt.beadSystem.chooseDrill");
            tipData = null;
         }
      }
      
      public function get DrillItem() : InventoryItemInfo
      {
         if(Boolean(this._data))
         {
            this._frameText.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._data.TemplateID).toString();
            return this._data;
         }
         return null;
      }
      
      public function getValueLength() : int
      {
         return 0;
      }
      
      override public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._frameText);
         this._frameText = null;
         ObjectUtils.disposeObject(this._dataIcon);
         this._dataIcon = null;
      }
   }
}

