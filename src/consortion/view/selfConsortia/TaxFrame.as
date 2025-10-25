package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class TaxFrame extends Frame
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _ownMoney:FilterFrameText;
      
      private var _moneyForRiches:FilterFrameText;
      
      private var _taxMoney:TextInput;
      
      private var _confirm:TextButton;
      
      private var _cancel:TextButton;
      
      private var leaveToFillAlert:BaseAlerFrame;
      
      private var confirmAlert:BaseAlerFrame;
      
      private var _textWord1:FilterFrameText;
      
      private var _textWord1_1:FilterFrameText;
      
      private var _textWord2:FilterFrameText;
      
      public function TaxFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         enterEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.TaxFrame.titleText");
         this._textWord1 = ComponentFactory.Instance.creat("consortion.taskFrame.textWordI");
         this._textWord1.text = LanguageMgr.GetTranslation("consortion.taskFrame.textWordI.text");
         this._textWord2 = ComponentFactory.Instance.creat("consortion.taskFrame.textWordII");
         this._textWord2.text = LanguageMgr.GetTranslation("consortion.taskFrame.textWordII.text");
         this._bg = ComponentFactory.Instance.creat("consortion.MyConsortiaTax.taxBG");
         this._ownMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalTicketTxt2");
         this._moneyForRiches = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.totalMoneyTxt");
         this._taxMoney = ComponentFactory.Instance.creatComponentByStylename("core.MyConsortiaTax.input");
         this._confirm = ComponentFactory.Instance.creatComponentByStylename("core.TaxFrame.okBtn");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("core.TaxFrame.cancelBtn");
         addToContent(this._textWord1);
         addToContent(this._textWord2);
         addToContent(this._bg);
         addToContent(this._ownMoney);
         addToContent(this._moneyForRiches);
         addToContent(this._taxMoney);
         addToContent(this._confirm);
         addToContent(this._cancel);
         this._taxMoney.textField.restrict = "0-9";
         this._taxMoney.textField.maxChars = 8;
         this._confirm.text = LanguageMgr.GetTranslation("ok");
         this._cancel.text = LanguageMgr.GetTranslation("cancel");
         this._confirm.enable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responseHanlder);
         this._confirm.addEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMoney.addEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMoney.addEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHanlder);
         this._confirm.removeEventListener(MouseEvent.CLICK,this.__confirmHanlder);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxMoney.removeEventListener(Event.CHANGE,this.__taxChangeHandler);
         this._taxMoney.removeEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._taxMoney.setFocus();
         this._ownMoney.text = String(PlayerManager.Instance.Self.Money);
         this._moneyForRiches.text = "0";
         this._taxMoney.text = "";
      }
      
      private function __responseHanlder(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.dispose();
         }
      }
      
      private function __confirmHanlder(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = int(this._taxMoney.text);
         if(BuriedManager.Instance.checkMoney(false,_loc2_))
         {
            return;
         }
         if(Number(this._taxMoney.text) < 2)
         {
            this._taxMoney.text = "";
            this._confirm.enable = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.input"));
         }
         else
         {
            this.confirmAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.confirmAlert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_loc2_ == this.leaveToFillAlert)
            {
               LeavePageManager.leaveToFillPath();
            }
            else if(_loc2_ == this.confirmAlert)
            {
               this.sendSocketData();
            }
         }
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         ObjectUtils.disposeObject(_loc2_);
         if(Boolean(_loc2_.parent))
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function sendSocketData() : void
      {
         var _loc1_:int = 0;
         if(this._taxMoney != null)
         {
            _loc1_ = int(this._taxMoney.text);
            SocketManager.Instance.out.sendConsortiaRichOffer(_loc1_);
            this.dispose();
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __taxChangeHandler(param1:Event) : void
      {
         if(this._taxMoney.text == "")
         {
            this._confirm.enable = false;
            this._moneyForRiches.text = "0";
            return;
         }
         if(this._taxMoney.text == String(0))
         {
            this._taxMoney.text = "";
            return;
         }
         this._confirm.enable = true;
         var _loc2_:int = int(this._taxMoney.text);
         if(Number(this._taxMoney.text) > PlayerManager.Instance.Self.Money)
         {
            this._taxMoney.text = PlayerManager.Instance.Self.Money.toString();
         }
         this._moneyForRiches.text = this._taxMoney.text;
      }
      
      private function __enterHanlder(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__confirmHanlder(null);
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._textWord1 = null;
         this._textWord2 = null;
         this._bg.dispose();
         this._bg = null;
         this._ownMoney = null;
         this._moneyForRiches = null;
         this._taxMoney = null;
         this._confirm = null;
         this._cancel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

