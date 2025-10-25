package ddt.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddtBuried.items.BuriedCardItem;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TransactionsFrame extends BaseAlerFrame
   {
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      public var buyFunction:Function;
      
      public var clickFunction:Function;
      
      private var _txt:FilterFrameText;
      
      private var _target:Sprite;
      
      public var autoClose:Boolean = true;
      
      public function TransactionsFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function set target(param1:Sprite) : void
      {
         this._target = param1;
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = _loc1_;
         this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("core.TransactionsFrame.selectBtn");
         this._selectedCheckButton.text = LanguageMgr.GetTranslation("labyrinth.view.buyFrame.SelectedCheckButtonText");
         addToContent(this._selectedCheckButton);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("core.alert.txt");
         this._txt.autoSize = "none";
         this._txt.wordWrap = true;
         this._txt.multiline = true;
         this._txt.height = 100;
         this._txt.textFormatStyle = "alertTF3";
         addToContent(this._txt);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
         this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function mouseClickHander(param1:MouseEvent) : void
      {
         if(this.clickFunction != null)
         {
            this.clickFunction(this._selectedCheckButton.selected);
         }
      }
      
      private function removeEvnets() : void
      {
         this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function responseHander(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.buyFunction != null)
            {
               this.buyFunction(false);
            }
            if(this.autoClose)
            {
               this.dispose();
            }
         }
         else if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            if(Boolean(this._target))
            {
               if(this._target is BuriedCardItem)
               {
                  BuriedCardItem(this._target).isPress = false;
               }
            }
            this.dispose();
         }
      }
      
      public function get isBind() : Boolean
      {
         return false;
      }
      
      public function setTxt(param1:String) : void
      {
         this._txt.width = width - 35;
         this._txt.text = param1;
         this._txt.x = (width - this._txt.width) / 2;
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
      }
   }
}

