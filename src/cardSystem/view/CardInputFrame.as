package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class CardInputFrame extends BaseAlerFrame
   {
      
      public static const RESTRICT:String = "0-9";
      
      public static const DEFAULT:String = "0";
      
      private var _alertInfo:AlertInfo;
      
      private var _needSoulText:FilterFrameText;
      
      private var _SellText:FilterFrameText;
      
      private var _SellText1:FilterFrameText;
      
      private var _SellText2:FilterFrameText;
      
      private var _InputTxt:FilterFrameText;
      
      private var _sellInputBg:Scale9CornerImage;
      
      private var _place:int;
      
      private var _cardtype:int;
      
      public function CardInputFrame()
      {
         super();
         this.setView();
         this.setEvent();
      }
      
      public function set place(param1:int) : void
      {
         this._place = param1;
         this._needSoulText.text = String(this.getNeedSoul());
         this._SellText1.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText5",this._needSoulText.text);
         var _loc2_:int = PlayerManager.Instance.Self.CardSoul;
         var _loc3_:int = this.getNeedSoul();
         if(_loc3_ > _loc2_)
         {
            this._InputTxt.text = String(_loc2_);
         }
         else
         {
            this._InputTxt.text = String(this.getNeedSoul());
         }
      }
      
      public function set cardtype(param1:int) : void
      {
         this._cardtype = param1;
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._needSoulText = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellNeedSoulText");
         this._SellText = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText2");
         this._SellText.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText1");
         this._SellText1 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText3");
         this._SellText1.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText5",this._needSoulText.text);
         this._SellText2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText5");
         this._SellText2.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText4");
         this._sellInputBg = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellInputBg");
         this._InputTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.SellLeftAlerText4");
         this._InputTxt.maxChars = 8;
         this._InputTxt.restrict = RESTRICT;
         this._InputTxt.text = DEFAULT;
         addToContent(this._SellText);
         addToContent(this._SellText1);
         addToContent(this._SellText2);
         addToContent(this._sellInputBg);
         addToContent(this._InputTxt);
      }
      
      private function getNeedSoul(param1:String = null) : int
      {
         if(param1 == null)
         {
            param1 = String(CardControl.Instance.model.GrooveInfoVector[this._place].Level + 1);
         }
         var _loc2_:GrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
         var _loc3_:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(param1,String(_loc2_.Type));
         var _loc4_:int = _loc2_.GP;
         var _loc5_:int = int(_loc3_.Exp);
         return _loc5_ - _loc4_;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__Response);
         this._InputTxt.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         this._InputTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._InputTxt.addEventListener(Event.CHANGE,this._change);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__Response);
         this._InputTxt.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.__focusOut);
         this._InputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._InputTxt.removeEventListener(Event.CHANGE,this._change);
      }
      
      private function _change(param1:Event) : void
      {
         var _loc2_:String = "40";
         var _loc3_:int = int(this._InputTxt.text);
         var _loc4_:int = PlayerManager.Instance.Self.CardSoul;
         var _loc5_:String = this._InputTxt.text.toString();
         var _loc6_:int = this.getNeedSoul(_loc2_);
         if(_loc3_ > _loc4_)
         {
            this._InputTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         }
         else if(_loc5_ == "00")
         {
            this._InputTxt.text = "0";
         }
         else if(_loc5_ == "01")
         {
            this._InputTxt.text = "1";
         }
         else if(_loc5_ == "02")
         {
            this._InputTxt.text = "2";
         }
         else if(_loc5_ == "03")
         {
            this._InputTxt.text = "3";
         }
         else if(_loc5_ == "04")
         {
            this._InputTxt.text = "4";
         }
         else if(_loc5_ == "05")
         {
            this._InputTxt.text = "5";
         }
         else if(_loc5_ == "06")
         {
            this._InputTxt.text = "6";
         }
         else if(_loc5_ == "07")
         {
            this._InputTxt.text = "7";
         }
         else if(_loc5_ == "08")
         {
            this._InputTxt.text = "8";
         }
         else if(_loc5_ == "09")
         {
            this._InputTxt.text = "9";
         }
      }
      
      private function __Response(param1:FrameEvent) : void
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
      
      private function confirmSubmit() : void
      {
         var _loc1_:String = "40";
         var _loc2_:int = PlayerManager.Instance.Self.CardSoul;
         var _loc3_:int = int(this._InputTxt.text);
         var _loc4_:int = this.getNeedSoul(_loc1_);
         if(_loc3_ == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText2"));
         }
         else if(_loc3_ > _loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardSell.SellText3"));
         }
         else if(_loc3_ > _loc4_)
         {
            this._InputTxt.text = _loc4_.toString();
            SocketManager.Instance.out.sendUpdateSLOT(this._place,int(this._InputTxt.text));
            CardControl.Instance.model.inputSoul = int(this._InputTxt.text);
            this.dispose();
         }
         else
         {
            SocketManager.Instance.out.sendUpdateSLOT(this._place,int(this._InputTxt.text));
            CardControl.Instance.model.inputSoul = int(this._InputTxt.text);
            this.dispose();
         }
      }
      
      private function checkSoul() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.CardSoul;
         var _loc2_:int = int(this._InputTxt.text);
         if(_loc2_ >= _loc1_)
         {
            _loc2_ = _loc1_;
         }
         this._InputTxt.text = String(_loc2_);
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            param1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.confirmSubmit();
         }
      }
      
      private function __focusOut(param1:FocusEvent) : void
      {
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._needSoulText))
         {
            ObjectUtils.disposeObject(this._needSoulText);
            this._needSoulText = null;
         }
         super.dispose();
         this.removeEvent();
      }
   }
}

