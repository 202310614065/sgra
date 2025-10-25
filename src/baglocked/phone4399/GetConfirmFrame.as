package baglocked.phone4399
{
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class GetConfirmFrame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _confirmMap:Bitmap;
      
      private var _getConfirmBtn:TextButton;
      
      public function GetConfirmFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.resetQuestion");
         this._confirmMap = ComponentFactory.Instance.creat("baglocked.notice_4399");
         addToContent(this._confirmMap);
         this._getConfirmBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.getConfirmBtn");
         this._getConfirmBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.getConfirm");
         addToContent(this._getConfirmBtn);
         this.addEvent();
      }
      
      protected function __getConfirmBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BaglockedManager.Instance.requestConfirm(1);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.close();
         }
      }
      
      public function set bagLockedController(param1:BagLockedController) : void
      {
         this._bagLockedController = param1;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._getConfirmBtn.addEventListener(MouseEvent.CLICK,this.__getConfirmBtnClick);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._getConfirmBtn.removeEventListener(MouseEvent.CLICK,this.__getConfirmBtnClick);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._confirmMap);
         this._confirmMap = null;
         ObjectUtils.disposeObject(this._getConfirmBtn);
         this._getConfirmBtn = null;
         super.dispose();
      }
   }
}

