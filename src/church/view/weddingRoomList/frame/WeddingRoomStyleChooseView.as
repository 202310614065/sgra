package church.view.weddingRoomList.frame
{
   import church.controller.WeddingStyleController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class WeddingRoomStyleChooseView extends BaseAlerFrame
   {
      
      private var _controller:WeddingStyleController;
      
      private var _alertInfo:AlertInfo;
      
      private var _btnWestern:SelectedButton;
      
      private var _btnSimple:SelectedButton;
      
      private var _styleGroup:SelectedButtonGroup;
      
      private var _styleDescImage:ScaleFrameImage;
      
      public function WeddingRoomStyleChooseView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("church.weddingStyle.title");
         this._alertInfo.moveEnable = false;
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("confirm");
         info = this._alertInfo;
         this.escEnable = true;
         this._btnWestern = ComponentFactory.Instance.creatComponentByStylename("church.room.weddingStyleChoose.btnWestern");
         addToContent(this._btnWestern);
         this._btnSimple = ComponentFactory.Instance.creatComponentByStylename("church.room.weddingStyleChoose.btnSimple");
         addToContent(this._btnSimple);
         this._styleGroup = new SelectedButtonGroup();
         this._styleGroup.addSelectItem(this._btnWestern);
         this._styleGroup.addSelectItem(this._btnSimple);
         this._styleDescImage = ComponentFactory.Instance.creatComponentByStylename("church.weddingStyleChoose.styleDesc");
         addToContent(this._styleDescImage);
         this._styleDescImage.setFrame(1);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onFrameResponse);
         this._styleGroup.addEventListener(Event.CHANGE,this.__onStyleChange);
      }
      
      public function setController(param1:WeddingStyleController) : void
      {
         this._controller = param1;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function confirmSubmit() : void
      {
         this._controller.chooseWeddingStyle(this._styleGroup.selectIndex);
         this.dispose();
      }
      
      private function __onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
         }
      }
      
      private function __onStyleChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._styleDescImage.setFrame(this._styleGroup.selectIndex + 1);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__onFrameResponse);
         if(Boolean(this._styleGroup))
         {
            this._styleGroup.removeEventListener(Event.CHANGE,this.__onStyleChange);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         if(Boolean(this._btnWestern))
         {
            this._btnWestern.dispose();
         }
         this._btnWestern = null;
         if(Boolean(this._btnSimple))
         {
            this._btnSimple.dispose();
         }
         this._btnSimple = null;
         if(Boolean(this._styleGroup))
         {
            this._styleGroup.dispose();
         }
         this._styleGroup = null;
         if(Boolean(this._styleDescImage))
         {
            ObjectUtils.disposeObject(this._styleDescImage);
         }
         this._styleDescImage = null;
         super.dispose();
      }
   }
}

