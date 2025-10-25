package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class GrowHelpBuffButton extends BuffButton
   {
      
      private var _growHelpBtn:ScaleFrameImage;
      
      private var _helpViewShow:Boolean = true;
      
      private var _growHelpTipView:GrowHelpTipView;
      
      public var buffArray:Array;
      
      public function GrowHelpBuffButton()
      {
         super("asset.core.growHelp");
         this.initView();
      }
      
      private function initView() : void
      {
         info = new BuffInfo(BuffInfo.GROW_HELP);
         info.description = LanguageMgr.GetTranslation("ddt.buffinfo.growhelp");
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      override protected function __onclick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         super.__onclick(param1);
         if(this._helpViewShow)
         {
            param1.stopImmediatePropagation();
            if(!this._growHelpTipView)
            {
               this._growHelpTipView = new GrowHelpTipView();
               this._growHelpTipView.addBuff(this.buffArray);
            }
            this._growHelpTipView.visible = true;
            _loc2_ = this.localToGlobal(new Point(this.x + this.width,this.y + this.height));
            PositionUtils.setPos(this._growHelpTipView,_loc2_);
            LayerManager.Instance.addToLayer(this._growHelpTipView,LayerManager.GAME_DYNAMIC_LAYER);
            stage.addEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
         }
         else if(Boolean(this._growHelpTipView))
         {
            this._growHelpTipView.visible = false;
         }
         this._helpViewShow = this._helpViewShow ? false : true;
      }
      
      protected function __closeChairChnnel(param1:MouseEvent) : void
      {
         if(!this._growHelpTipView)
         {
            return;
         }
         if(param1.target != this._growHelpTipView.viewBg)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
            if(Boolean(this._growHelpTipView))
            {
               this._growHelpTipView.visible = false;
               this._helpViewShow = true;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._growHelpBtn))
         {
            this._growHelpBtn.dispose();
            this._growHelpBtn = null;
         }
         if(Boolean(this._growHelpTipView))
         {
            this._growHelpTipView.dispose();
            this._growHelpTipView = null;
         }
         super.dispose();
      }
   }
}

