package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class PropResetFrame extends BaseAlerFrame
   {
      
      private var _cardInfo:CardInfo;
      
      private var _cardCell:ResetCardCell;
      
      private var _newProperty:Bitmap;
      
      private var _oldProperty:Bitmap;
      
      private var _inputSmallBg1:Vector.<ScaleLeftRightImage>;
      
      private var _inputSmallBg2:Vector.<ScaleLeftRightImage>;
      
      private var _basicPropVec1:Vector.<FilterFrameText>;
      
      private var _oldPropVec:Vector.<FilterFrameText>;
      
      private var _newPropVec:Vector.<FilterFrameText>;
      
      private var _upAndDownVec:Vector.<ScaleFrameImage>;
      
      private var _smallinputPropContainer1:VBox;
      
      private var _smallinputPropContainer2:VBox;
      
      private var _basePropContainer1:VBox;
      
      private var _oldPropContainer:VBox;
      
      private var _newPropContainer:VBox;
      
      private var _upAndDownContainer:VBox;
      
      private var _canReplace:Boolean;
      
      private var _isFirst:Boolean = true;
      
      private var _headBg1:ScaleBitmapImage;
      
      private var _headBg2:ScaleBitmapImage;
      
      private var _headTextBg1:ScaleLeftRightImage;
      
      private var _headTextBg2:ScaleLeftRightImage;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bg4:ScaleBitmapImage;
      
      private var _resetArrow:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _helpButton:BaseButton;
      
      private var _needSoul:FilterFrameText;
      
      private var _needSoulText:FilterFrameText;
      
      private var _ownSoul:FilterFrameText;
      
      private var _ownSoulText:FilterFrameText;
      
      private var _resetAlert:BaseAlerFrame;
      
      private var _cancelAlert:BaseAlerFrame;
      
      private var _propertyPool:Object = new Object();
      
      private var _strArray:Object = new Object();
      
      private var _newArray:Array = new Array();
      
      private var _propertys:Vector.<PropertyEmu>;
      
      private var _sendReplace:Boolean = false;
      
      private var _resetNeedSoul:int;
      
      public function PropResetFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc4_:ScaleLeftRightImage = null;
         var _loc5_:ScaleLeftRightImage = null;
         var _loc6_:ScaleFrameImage = null;
         var _loc7_:FilterFrameText = null;
         this._headBg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.headBG1");
         this._headBg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.headBG2");
         addToContent(this._headBg1);
         addToContent(this._headBg2);
         this._headTextBg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.numBg1");
         addToContent(this._headTextBg1);
         this._headTextBg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.numBg2");
         addToContent(this._headTextBg2);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG3");
         this._bg4 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG4");
         addToContent(this._bg1);
         addToContent(this._bg2);
         addToContent(this._bg3);
         addToContent(this._bg4);
         this._resetArrow = ComponentFactory.Instance.creatBitmap("asset.cardSystem.resetArrow");
         addToContent(this._resetArrow);
         this._helpButton = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.Help");
         addToContent(this._helpButton);
         this._oldProperty = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.oldProperty");
         addToContent(this._oldProperty);
         this._newProperty = ComponentFactory.Instance.creatBitmap("asset.ddtcardSystem.newProperty");
         addToContent(this._newProperty);
         this._needSoul = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.needSoul");
         this._needSoul.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.needSoul");
         addToContent(this._needSoul);
         this._needSoulText = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.needSoulText");
         this._needSoulText.text = ServerConfigManager.instance.CardRestSoulValue;
         addToContent(this._needSoulText);
         this._ownSoul = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.ownSoul");
         this._ownSoul.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.ownSoul");
         addToContent(this._ownSoul);
         this._ownSoulText = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.ownSoulText");
         this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
         addToContent(this._ownSoulText);
         escEnable = true;
         this._inputSmallBg1 = new Vector.<ScaleLeftRightImage>(4);
         this._inputSmallBg2 = new Vector.<ScaleLeftRightImage>(4);
         this._basicPropVec1 = new Vector.<FilterFrameText>(4);
         this._oldPropVec = new Vector.<FilterFrameText>(4);
         this._newPropVec = new Vector.<FilterFrameText>(4);
         this._upAndDownVec = new Vector.<ScaleFrameImage>(4);
         this._cardCell = ComponentFactory.Instance.creatCustomObject("PropResetCell");
         this._smallinputPropContainer1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.smallinputPropContainer1");
         this._smallinputPropContainer2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.smallinputPropContainer2");
         this._basePropContainer1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.basePropContainer1");
         this._oldPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.oldPropContainer");
         this._newPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.newPropContainer");
         this._upAndDownContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.upAndDownContainer");
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.preNumBg");
            this._inputSmallBg1[_loc1_] = _loc4_;
            this._smallinputPropContainer1.addChild(this._inputSmallBg1[_loc1_]);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.newNumBg");
            this._inputSmallBg2[_loc2_] = _loc5_;
            this._smallinputPropContainer2.addChild(this._inputSmallBg2[_loc2_]);
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("asset.cardSystem.upAndDown");
            _loc6_.setFrame(1);
            _loc6_.visible = false;
            this._upAndDownVec[_loc2_] = _loc6_;
            this._upAndDownContainer.addChild(this._upAndDownVec[_loc2_]);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 12)
         {
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.PropText");
            if(_loc3_ < 4)
            {
               this._basicPropVec1[_loc3_] = _loc7_;
               this._basePropContainer1.addChild(this._basicPropVec1[_loc3_]);
            }
            else if(_loc3_ < 8)
            {
               this._oldPropVec[_loc3_ % 4] = _loc7_;
               this._oldPropContainer.addChild(this._oldPropVec[_loc3_ % 4]);
            }
            else
            {
               this._newPropVec[_loc3_ % 4] = _loc7_;
               this._newPropContainer.addChild(this._newPropVec[_loc3_ % 4]);
            }
            _loc3_++;
         }
         addToContent(this._cardCell);
         addToContent(this._smallinputPropContainer1);
         addToContent(this._smallinputPropContainer2);
         addToContent(this._basePropContainer1);
         addToContent(this._oldPropContainer);
         addToContent(this._newPropContainer);
         addToContent(this._upAndDownContainer);
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.title");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.reset");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.replace");
         this._alertInfo.moveEnable = false;
         this._alertInfo.enterEnable = false;
         this._alertInfo.cancelEnabled = false;
         info = this._alertInfo;
         this.checkSoul();
      }
      
      public function checkSoul() : void
      {
         if(PlayerManager.Instance.Self.CardSoul < int(ServerConfigManager.instance.CardRestSoulValue))
         {
            this._alertInfo.submitEnabled = false;
         }
      }
      
      public function show(param1:CardInfo) : void
      {
         var _loc3_:int = 0;
         this._cardInfo = param1;
         this._cardCell.cardInfo = this._cardInfo;
         this._cardCell.Visibles = false;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._propertys.length)
         {
            this._basicPropVec1[_loc2_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[_loc2_].key + "1");
            _loc2_++;
         }
         this.UpdateStrArray();
         if(this._strArray != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this._propertys.length)
            {
               this._oldPropVec[_loc3_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._strArray[this._propertys[_loc3_].key] == null || this._strArray[this._propertys[_loc3_].key] == "" ? "0" : this._strArray[this._propertys[_loc3_].key]);
               _loc3_++;
            }
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function UpdateStrArray() : void
      {
         var _loc1_:CardTemplateInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(this._cardInfo.TemplateID),String(this._cardInfo.CardType));
         var _loc2_:String = this._cardInfo.Attack.toString();
         var _loc3_:String = this._cardInfo.Defence.toString();
         var _loc4_:String = this._cardInfo.Agility.toString();
         var _loc5_:String = this._cardInfo.Luck.toString();
         var _loc6_:String = this._cardInfo.Damage.toString();
         var _loc7_:String = this._cardInfo.Guard.toString();
         this._strArray = {
            "Attack":_loc2_,
            "Defence":_loc3_,
            "Agility":_loc4_,
            "Luck":_loc5_
         };
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         this._cardInfo = param1;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         CardControl.Instance.model.addEventListener(CardEvent.CHANGE_SOUL,this.__changeSoul);
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.addEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               this.__resethandler(null);
               break;
            case FrameEvent.CANCEL_CLICK:
               this.__replaceHandler(null);
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._alertInfo.cancelEnabled == true)
               {
                  this.__cancelHandel();
                  break;
               }
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         CardControl.Instance.model.removeEventListener(CardEvent.CHANGE_SOUL,this.__changeSoul);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.removeEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      protected function __replaceHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = LanguageMgr.GetTranslation("tank.view.card.resetAlertMsg");
         this._resetAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._resetAlert.moveEnable = false;
         this._resetAlert.addEventListener(FrameEvent.RESPONSE,this.__replaceAlert);
      }
      
      private function __replaceAlert(param1:FrameEvent) : void
      {
         if(Boolean(this._resetAlert))
         {
            this._resetAlert.removeEventListener(FrameEvent.RESPONSE,this.__replaceAlert);
         }
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submitReplace();
         }
         this._resetAlert.dispose();
         if(Boolean(this._resetAlert.parent))
         {
            this._resetAlert.parent.removeChild(this._resetAlert);
         }
         this._resetAlert = null;
      }
      
      private function submitReplace() : void
      {
         SoundManager.instance.play("008");
         if(this._canReplace)
         {
            SocketManager.Instance.out.sendReplaceCardProp(this._cardInfo.Place);
            this.setReplaceAbled(false);
            this._alertInfo.cancelEnabled = false;
            this._sendReplace = true;
            this.updateText();
         }
      }
      
      private function __changeSoul(param1:CardEvent) : void
      {
         this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
      }
      
      private function updateText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._sendReplace)
         {
            this._ownSoulText.text = PlayerManager.Instance.Self.CardSoul.toString();
            if(this._strArray != null)
            {
               _loc2_ = 0;
               while(_loc2_ < this._propertys.length)
               {
                  this._oldPropVec[_loc2_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._newArray[_loc2_].toString());
                  this._strArray[this._propertys[_loc2_].key] = this._newArray[_loc2_];
                  _loc2_++;
               }
            }
            _loc1_ = 0;
            while(_loc1_ < this._newPropVec.length)
            {
               this._upAndDownVec[_loc1_].visible = false;
               this._newPropVec[_loc1_].text = "";
               _loc1_++;
            }
            this._sendReplace = false;
            this._alertInfo.submitEnabled = true;
            this.checkSoul();
         }
      }
      
      protected function __resethandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.CardSoul -= int(ServerConfigManager.instance.CardRestSoulValue);
         CardControl.Instance.model.dispatchEvent(new CardEvent(CardEvent.CHANGE_SOUL));
         SocketManager.Instance.out.sendCardReset(this._cardInfo.Place);
         this.setReplaceAbled(true);
         this.checkSoul();
      }
      
      private function __cancelHandel() : void
      {
         SoundManager.instance.play("008");
         var _loc1_:String = LanguageMgr.GetTranslation("tank.view.card.cancelAlertMsg");
         this._cancelAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc1_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._cancelAlert.moveEnable = false;
         this._cancelAlert.addEventListener(FrameEvent.RESPONSE,this.__cancelResponse);
      }
      
      private function __cancelResponse(param1:FrameEvent) : void
      {
         if(Boolean(this._cancelAlert))
         {
            this._cancelAlert.removeEventListener(FrameEvent.RESPONSE,this.__cancelResponse);
         }
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               if(Boolean(this._cancelAlert))
               {
                  ObjectUtils.disposeObject(this._cancelAlert);
               }
               this._cancelAlert = null;
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.dispose();
         }
      }
      
      private function setReplaceAbled(param1:Boolean) : void
      {
         this._alertInfo.cancelEnabled = param1;
      }
      
      private function __reset(param1:CrazyTankSocketEvent) : void
      {
         this._newArray = new Array();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._newArray.push(_loc2_.readInt());
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._propertys.length)
         {
            this._newPropVec[_loc5_].text = String(this._newArray[_loc5_]);
            if(this._newArray[_loc5_] != int(this._strArray[this._propertys[_loc5_].key]))
            {
               this._upAndDownVec[_loc5_].visible = true;
               if(this._newArray[_loc5_] < int(this._strArray[this._propertys[_loc5_].key]))
               {
                  this._upAndDownVec[_loc5_].setFrame(2);
               }
               else
               {
                  this._upAndDownVec[_loc5_].setFrame(1);
               }
            }
            else
            {
               this._upAndDownVec[_loc5_].visible = false;
            }
            _loc5_++;
         }
         this._canReplace = true;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._cardCell))
         {
            this._cardCell.dispose();
         }
         this._cardCell = null;
         super.dispose();
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._basicPropVec1[_loc1_] = null;
            this._oldPropVec[_loc1_] = null;
            this._newPropVec[_loc1_] = null;
            this._inputSmallBg1[_loc1_] = null;
            this._inputSmallBg2[_loc1_] = null;
            _loc1_++;
         }
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._headBg1 = null;
         this._headBg2 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bg4 = null;
         this._basePropContainer1 = null;
         this._oldPropContainer = null;
         this._newPropContainer = null;
         this._smallinputPropContainer1 = null;
         this._smallinputPropContainer2 = null;
         this._upAndDownContainer = null;
         this._helpButton = null;
         this._resetArrow = null;
         this._propertyPool = null;
         this._propertys = null;
         this._oldProperty = null;
         this._newProperty = null;
         this._upAndDownVec = null;
         this._needSoul = null;
         this._ownSoul = null;
         this._needSoulText = null;
         this._ownSoulText = null;
         if(Boolean(this._resetAlert))
         {
            ObjectUtils.disposeObject(this._resetAlert);
         }
         this._resetAlert = null;
         if(Boolean(this._cancelAlert))
         {
            ObjectUtils.disposeObject(this._cancelAlert);
         }
         this._cancelAlert = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __helpOpen(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:DisplayObject = ComponentFactory.Instance.creatComponentByStylename("Scale9CornerImage17");
         var _loc3_:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.resetFrame.help");
         PositionUtils.setPos(_loc3_,"resetFrame.help.contentPos");
         var _loc4_:AlertInfo = new AlertInfo();
         _loc4_.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.help.title");
         _loc4_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc4_.showCancel = false;
         _loc4_.moveEnable = false;
         var _loc5_:BaseAlerFrame = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.HelpFrame");
         _loc5_.info = _loc4_;
         _loc5_.addToContent(_loc2_);
         _loc5_.addToContent(_loc3_);
         _loc5_.addEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __helpResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         _loc2_.dispose();
         SoundManager.instance.play("008");
         StageReferance.stage.focus = this;
      }
   }
}

class PropertyEmu
{
   
   public var key:String;
   
   public var idx:int;
   
   public function PropertyEmu(param1:String, param2:int)
   {
      super();
      this.key = param1;
      this.idx = param2;
   }
}
