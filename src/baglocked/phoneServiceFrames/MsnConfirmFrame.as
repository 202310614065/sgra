package baglocked.phoneServiceFrames
{
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class MsnConfirmFrame extends Frame
   {
      
      public static const MSN_MONEY:int = 50;
      
      private var _bagLockedController:BagLockedController;
      
      private var _phoneNum:FilterFrameText;
      
      private var _confirmTxt:FilterFrameText;
      
      private var _confirmInput:TextInput;
      
      private var _getConfirmBtn:TextButton;
      
      private var _tips:FilterFrameText;
      
      private var _nextBtn:TextButton;
      
      private var type:int;
      
      public function MsnConfirmFrame()
      {
         super();
      }
      
      public function init2(param1:int) : void
      {
         this.type = param1;
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changePhoneTxt");
         this._phoneNum = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._phoneNum,"bagLocked.phoneNumPos");
         addToContent(this._phoneNum);
         this._confirmTxt = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         PositionUtils.setPos(this._confirmTxt,"bagLocked.confirmTxtPos");
         this._confirmTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.confirmNum");
         addToContent(this._confirmTxt);
         this._confirmInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.confirmTextInput");
         this._confirmInput.textField.restrict = "0-9";
         addToContent(this._confirmInput);
         this._getConfirmBtn = ComponentFactory.Instance.creatComponentByStylename("baglocked.getConfirmNum");
         this._getConfirmBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.getConfirmNum");
         addToContent(this._getConfirmBtn);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         PositionUtils.setPos(this._tips,"bagLocked.phoneTipPos");
         addToContent(this._tips);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos2");
         addToContent(this._nextBtn);
         var _loc2_:String = BaglockedManager.Instance.phoneNum;
         switch(this.type)
         {
            case 0:
               this._phoneNum.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.formerNum",_loc2_.substr(0,3),_loc2_.substr(6));
               this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip2");
               this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
               break;
            case 1:
            case 2:
               this._phoneNum.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.bindedNum",_loc2_.substr(0,3),_loc2_.substr(6));
               this._tips.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tip4");
               this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.complete");
         }
         this.addEvent();
      }
      
      protected function __getConfirmBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         switch(this.type)
         {
            case 0:
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.bagII.baglocked.confirmNeedMoney"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertGetConfirmNum);
               break;
            case 1:
            case 2:
               this.getConfirmMsn();
         }
      }
      
      protected function __alertGetConfirmNum(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertGetConfirmNum);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Money < MSN_MONEY)
               {
                  _loc2_.dispose();
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               this.getConfirmMsn();
         }
         _loc2_.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function getConfirmMsn() : void
      {
         switch(this.type)
         {
            case 0:
               SocketManager.Instance.out.getBackLockPwdByPhone(2);
               break;
            case 1:
               SocketManager.Instance.out.getBackLockPwdByPhone(5);
               break;
            case 2:
               SocketManager.Instance.out.getBackLockPwdByQuestion(3);
         }
      }
      
      protected function __nextBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._confirmInput.text.length != 6)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.msnLengthWrong"));
            return;
         }
         switch(this.type)
         {
            case 0:
               SocketManager.Instance.out.getBackLockPwdByPhone(3,this._confirmInput.text);
               break;
            case 1:
               SocketManager.Instance.out.getBackLockPwdByPhone(6,this._confirmInput.text);
               break;
            case 2:
               SocketManager.Instance.out.getBackLockPwdByQuestion(4,this._confirmInput.text);
         }
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
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._getConfirmBtn.removeEventListener(MouseEvent.CLICK,this.__getConfirmBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._phoneNum))
         {
            ObjectUtils.disposeObject(this._phoneNum);
         }
         this._phoneNum = null;
         if(Boolean(this._confirmTxt))
         {
            ObjectUtils.disposeObject(this._confirmTxt);
         }
         this._confirmTxt = null;
         if(Boolean(this._confirmInput))
         {
            ObjectUtils.disposeObject(this._confirmInput);
         }
         this._confirmInput = null;
         if(Boolean(this._getConfirmBtn))
         {
            ObjectUtils.disposeObject(this._getConfirmBtn);
         }
         this._getConfirmBtn = null;
         if(Boolean(this._tips))
         {
            ObjectUtils.disposeObject(this._tips);
         }
         this._tips = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         super.dispose();
      }
   }
}

