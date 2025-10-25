package beadSystem.tips
{
   import beadSystem.views.BeadUpgradeTipView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BeadTemplateManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   
   public class BeadUpgradeTip extends GoodTip
   {
      
      private var _upgradeBeadTip:BeadUpgradeTipView;
      
      public function BeadUpgradeTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(param1:Object) : void
      {
         super.tipData = param1;
         this.beadUpgradeTip(param1 as GoodTipInfo);
      }
      
      override public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         super.showTip(param1,param2);
      }
      
      private function beadUpgradeTip(param1:GoodTipInfo) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:GoodTipInfo = null;
         var _loc4_:InventoryItemInfo = null;
         if(Boolean(param1))
         {
            _loc4_ = param1.itemInfo as InventoryItemInfo;
         }
         if(Boolean(_loc4_) && _loc4_.Hole1 < 19)
         {
            _loc3_ = new GoodTipInfo();
            _loc2_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc2_,_loc4_);
            _loc2_.Hole1 += 1;
            _loc2_.TemplateID = BeadTemplateManager.Instance.GetBeadTemplateIDByLv(_loc2_.Hole1,_loc4_.TemplateID);
            _loc3_.itemInfo = _loc2_;
            _loc3_.beadName = _loc2_.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(_loc2_.TemplateID).Name + "Lv" + _loc2_.Hole1;
            if(!this._upgradeBeadTip)
            {
               this._upgradeBeadTip = new BeadUpgradeTipView();
            }
            this._upgradeBeadTip.x = _tipbackgound.x + _tipbackgound.width + 35;
            if(!this.contains(this._upgradeBeadTip))
            {
               addChild(this._upgradeBeadTip);
            }
            this._upgradeBeadTip.tipData = _loc3_;
         }
         else
         {
            if(Boolean(this._upgradeBeadTip))
            {
               ObjectUtils.disposeObject(this._upgradeBeadTip);
            }
            this._upgradeBeadTip = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._upgradeBeadTip))
         {
            ObjectUtils.disposeObject(this._upgradeBeadTip);
         }
         this._upgradeBeadTip = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

