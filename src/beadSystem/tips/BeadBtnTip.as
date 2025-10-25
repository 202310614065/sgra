package beadSystem.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   
   public class BeadBtnTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _discTxt:FilterFrameText;
      
      private var _beadTipData:Object;
      
      private var _nameList:Array;
      
      private var _priceList:Array;
      
      public function BeadBtnTip()
      {
         super();
         this.initView();
         this.initData();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.bg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.name");
         this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.disc");
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._discTxt);
      }
      
      private function initData() : void
      {
         var _loc1_:String = LanguageMgr.GetTranslation("ddt.beadSystem.requestBeadNames");
         this._nameList = _loc1_.split(",");
         this._priceList = ServerConfigManager.instance.getRequestBeadPrice();
      }
      
      override public function get tipData() : Object
      {
         return this._beadTipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         this._beadTipData = param1;
         var _loc2_:int = int(param1);
         switch(_loc2_)
         {
            case 0:
               _loc3_ = this._nameList[0];
               _loc4_ = int(this._priceList[0]);
               break;
            case 1:
               _loc3_ = this._nameList[1];
               _loc4_ = int(this._priceList[1]);
               break;
            case 2:
               _loc3_ = this._nameList[2];
               _loc4_ = int(this._priceList[2]);
               break;
            case 3:
               _loc3_ = this._nameList[3];
               _loc4_ = int(this._priceList[3]);
               break;
            default:
               _loc3_ = "";
               _loc4_ = 0;
         }
         this._nameTxt.text = _loc3_;
         this._discTxt.text = LanguageMgr.GetTranslation("ddt.beadSystem.price") + ":" + _loc4_.toString();
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         this._bg.width = this._discTxt.x + this._discTxt.width + 15;
         this._bg.height = this._discTxt.y + this._discTxt.height + 10;
      }
      
      override public function dispose() : void
      {
         this._beadTipData = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._discTxt))
         {
            ObjectUtils.disposeObject(this._discTxt);
         }
         this._discTxt = null;
         super.dispose();
      }
   }
}

