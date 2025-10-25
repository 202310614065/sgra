package church.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFieldAutoSize;
   
   public class ChurchAlertFrame extends BaseAlerFrame
   {
      
      private var _txt:FilterFrameText;
      
      public function ChurchAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo("离婚支付请求",LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = _loc1_;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("FrameTitleTextStyle");
         this._txt.autoSize = TextFieldAutoSize.NONE;
         this._txt.width = 300;
         this._txt.height = 150;
         this._txt.x = 48;
         this._txt.y = 48;
         this._txt.wordWrap = true;
         this._txt.multiline = true;
         addToContent(this._txt);
      }
      
      public function setTxt(param1:String) : void
      {
         this._txt.text = param1;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         super.dispose();
      }
   }
}

