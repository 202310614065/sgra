package cardSystem.view.cardEquip
{
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.elements.CardCell;
   import cardSystem.view.CardPropress;
   import cardSystem.view.CardSelect;
   import cardSystem.view.CardSmallPropress;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryEvent;
   
   public class CardEquipView extends Sprite implements Disposeable
   {
      
      private var _background:Bitmap;
      
      private var _background1:ScaleBitmapImage;
      
      private var _title:Bitmap;
      
      public var _equipCells:Vector.<CardCell>;
      
      private var _playerInfo:PlayerInfo;
      
      private var _viceCardBit:Vector.<Bitmap>;
      
      private var _mainCardBit:Bitmap;
      
      private var _clickEnable:Boolean = true;
      
      private var _cell3MouseSprite:Sprite;
      
      private var _cell4MouseSprite:Sprite;
      
      private var _open3Btn:TextButton;
      
      private var _open4Btn:TextButton;
      
      private var _dragArea:CardEquipDragArea;
      
      private var _collectBtn:TextButton;
      
      private var _resetSoulBtn:TextButton;
      
      private var _cardBtn:TextButton;
      
      private var _buyCardBoxBtn:TextButton;
      
      private var _cardList:CardSelect;
      
      private var _attackBg:Bitmap;
      
      private var _agilityBg:Bitmap;
      
      private var _defenceBg:Bitmap;
      
      private var _luckBg:Bitmap;
      
      private var _background2:MovieImage;
      
      private var _line:MovieImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textBg1:Scale9CornerImage;
      
      private var _textBg2:Scale9CornerImage;
      
      private var _textBg3:Scale9CornerImage;
      
      private var _levelPorgress:CardPropress;
      
      private var _levelPorgress1:CardSmallPropress;
      
      private var _levelPorgress2:CardSmallPropress;
      
      private var _levelPorgress3:CardSmallPropress;
      
      private var _levelPorgress4:CardSmallPropress;
      
      private var _CardGrove:GrooveInfo;
      
      private var _HunzhiBg:Bitmap;
      
      private var _ballPlay:MovieClip;
      
      private var _ballPlaySp:Component;
      
      private var _ballPlaySpTip:OneLineTip;
      
      private var _ballPlayCountTxt:FilterFrameText;
      
      private var _levelTxt1:FilterFrameText;
      
      private var _levelTxt2:FilterFrameText;
      
      private var _levelTxt3:FilterFrameText;
      
      private var _levelTxt4:FilterFrameText;
      
      private var _levelTxt5:FilterFrameText;
      
      private var _levelNumTxt1:FilterFrameText;
      
      private var _levelNumTxt2:FilterFrameText;
      
      private var _levelNumTxt3:FilterFrameText;
      
      private var _levelNumTxt4:FilterFrameText;
      
      private var _levelNumTxt5:FilterFrameText;
      
      private var _GrooveTxt:FilterFrameText;
      
      private var _btnHelp:BaseButton;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      private var _show3:Boolean;
      
      private var _resetAlert:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      private var _openFrame:BaseAlerFrame;
      
      private var _configFrame:BaseAlerFrame;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      public function CardEquipView()
      {
         super();
         this.initView();
      }
      
      public function set clickEnable(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._clickEnable == param1)
         {
            return;
         }
         this._clickEnable = param1;
         if(this._clickEnable)
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               if(Boolean(this._equipCells[_loc2_]))
               {
                  this._equipCells[_loc2_].addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[_loc2_].addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
                  this._equipCells[_loc3_].setBtnVisible(true);
               }
               _loc2_++;
            }
            if(this._equipCells[3].open)
            {
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(this._equipCells[4].open)
            {
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               if(Boolean(this._equipCells[_loc3_]))
               {
                  this._equipCells[_loc3_].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[_loc3_].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               }
               _loc3_++;
            }
            if(!this._equipCells[3].open)
            {
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(!this._equipCells[4].open)
            {
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         this._collectBtn.visible = false;
         this._resetSoulBtn.visible = false;
         this._cardBtn.visible = false;
         this._ballPlaySp.visible = false;
         this._GrooveTxt.visible = false;
         this._HunzhiBg.visible = false;
         this._buyCardBoxBtn.visible = false;
         this.setCardsVisible(false);
      }
      
      private function createQuickBuyFrame() : void
      {
         this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quickBuyFrame.itemID = EquipType.MYSTICAL_CARDBOX;
         this._quickBuyFrame.buyFrom = 0;
      }
      
      private function initView() : void
      {
         var _loc3_:CardCell = null;
         this._equipCells = new Vector.<CardCell>(5);
         this._CardGrove = new GrooveInfo();
         this._background = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.BG");
         this._background1 = ComponentFactory.Instance.creatComponentByStylename("cardEquipView.BG1");
         this._background2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.view.bgTwo");
         this._line = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystem.line");
         this._dragArea = new CardEquipDragArea(this);
         this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.collectBtn");
         this._collectBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsRecordText");
         this._resetSoulBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.resetSoulBtn");
         this._resetSoulBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.resetCardSoul");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.CardBtn");
         this._cardBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardsText");
         this._buyCardBoxBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.BuyCardBoxBtn");
         this._buyCardBoxBtn.text = LanguageMgr.GetTranslation("ddt.cardSystem.BuyCardBox");
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView1");
         this._textBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView2");
         this._textBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView3");
         this._textBg3 = ComponentFactory.Instance.creatComponentByStylename("ddtcardSystemTextView4");
         this._attackBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.gongji");
         this._agilityBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.minjie");
         this._defenceBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.fangyu");
         this._luckBg = ComponentFactory.Instance.creatBitmap("asset.playerinfo.luck");
         this._HunzhiBg = ComponentFactory.Instance.creatBitmap("asset.ddtcardsytems.hunzhi");
         this._levelTxt1 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText1");
         this._levelTxt2 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText2");
         this._levelTxt3 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText3");
         this._levelTxt4 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText4");
         this._levelTxt5 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelText5");
         this._levelNumTxt1 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText1");
         this._levelNumTxt2 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText2");
         this._levelNumTxt3 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText3");
         this._levelNumTxt4 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText4");
         this._levelNumTxt5 = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelNumerText5");
         this.__onUpdateProperty(null);
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdateProperty);
         this._GrooveTxt = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.GrooveText");
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._btnHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.texpSystem.btnHelp");
         addChild(this._btnHelp);
         this._levelTxt1.text = this._levelTxt2.text = this._levelTxt3.text = this._levelTxt4.text = this._levelTxt5.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText");
         this._levelNumTxt1.text = this._levelNumTxt2.text = this._levelNumTxt3.text = this._levelNumTxt4.text = this._levelNumTxt5.text = "0";
         if(!this._ballPlay)
         {
            this._ballPlay = ComponentFactory.Instance.creat("asset.cardSystem.ballPlay");
         }
         this._ballPlayCountTxt = ComponentFactory.Instance.creatComponentByStylename("cardSystem.ballPlayCountTxt");
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
         this._ballPlaySp = new Component();
         this._ballPlaySpTip = new OneLineTip();
         PositionUtils.setPos(this._ballPlaySpTip,"cardSystem.ballPlaySpTipPos");
         this._ballPlaySpTip.tipData = LanguageMgr.GetTranslation("ddt.cardSystem.buyCardSoulButtonTipsMsg");
         this._ballPlaySp.buttonMode = true;
         this._ballPlaySp.addEventListener(MouseEvent.ROLL_OVER,this.__ballPlaySpMouseOver);
         this._ballPlaySp.addEventListener(MouseEvent.ROLL_OUT,this.__ballPlaySpMouseOut);
         this._ballPlaySp.addChild(this._ballPlay);
         this._ballPlaySp.addChild(this._ballPlayCountTxt);
         this._HunzhiBg.x = 109;
         this._HunzhiBg.y = 175;
         this._attackBg.x = -9;
         this._attackBg.y = 316;
         this._agilityBg.x = 104;
         this._agilityBg.y = 315;
         this._defenceBg.x = -16;
         this._defenceBg.y = 342;
         this._luckBg.x = 104;
         this._luckBg.y = 343;
         addChild(this._background);
         addChild(this._background1);
         addChild(this._background2);
         addChild(this._line);
         addChild(this._dragArea);
         addChild(this._collectBtn);
         addChild(this._resetSoulBtn);
         addChild(this._cardBtn);
         addChild(this._buyCardBoxBtn);
         addChild(this._textBg);
         addChild(this._textBg1);
         addChild(this._textBg2);
         addChild(this._textBg3);
         addChild(this._attackBg);
         addChild(this._agilityBg);
         addChild(this._defenceBg);
         addChild(this._luckBg);
         addChild(this._HunzhiBg);
         this._cardList = new CardSelect();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ == 0)
            {
               _loc3_ = new CardCell(ComponentFactory.Instance.creatBitmap("asset.cardEquipView.mainCard"),_loc1_);
               _loc3_.setContentSize(110,155);
               _loc3_.setStarPos(59,154);
               this._levelPorgress = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress");
            }
            else
            {
               _loc3_ = new CardCell(ComponentFactory.Instance.creatComponentByStylename("CardEquipView.viceCardBG" + _loc1_),_loc1_);
               _loc3_.setContentSize(94,133);
               this._levelPorgress1 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress1");
               this._levelPorgress2 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress2");
               this._levelPorgress3 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress3");
               this._levelPorgress4 = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.levelProgress4");
            }
            if(this._clickEnable)
            {
               _loc3_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               _loc3_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            }
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            DoubleClickManager.Instance.enableDoubleClick(_loc3_);
            this._equipCells[_loc1_] = _loc3_;
            addChild(_loc3_);
            _loc1_++;
         }
         this._viceCardBit = new Vector.<Bitmap>(4);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._viceCardBit[_loc2_] = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.viceCardBG");
            _loc2_++;
         }
         this._mainCardBit = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.mainCardBorder");
         this.setCellPos();
         addChild(this._levelPorgress);
         addChild(this._levelPorgress1);
         addChild(this._levelPorgress2);
         addChild(this._levelPorgress3);
         addChild(this._levelPorgress4);
         addChild(this._levelTxt1);
         addChild(this._levelTxt2);
         addChild(this._levelTxt3);
         addChild(this._levelTxt4);
         addChild(this._levelTxt5);
         addChild(this._levelNumTxt1);
         addChild(this._levelNumTxt2);
         addChild(this._levelNumTxt3);
         addChild(this._levelNumTxt4);
         addChild(this._levelNumTxt5);
         addChild(this._GrooveTxt);
         addChild(this._ballPlaySp);
         this._ballPlaySp.x = 160;
         this._ballPlaySp.y = 162;
         addChild(this._ballPlaySpTip);
         this.isBallPlaySpTip();
      }
      
      private function setCardsVisible(param1:Boolean) : void
      {
         var _loc2_:CardCell = null;
         for each(_loc2_ in this._equipCells)
         {
            if(Boolean(_loc2_))
            {
               _loc2_.updatebtnVible = param1;
            }
         }
      }
      
      protected function __onUpdateProperty(param1:Event) : void
      {
         var _loc2_:PlayerInfo = this._playerInfo;
         if(this._playerInfo == null || _loc2_.propertyAddition == null)
         {
            return;
         }
      }
      
      private function createSprite(param1:CardCell) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
         return _loc2_;
      }
      
      private function removeSprite(param1:Sprite, param2:BaseButton) : void
      {
         if(Boolean(param1))
         {
            param1.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
            param1.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            param2.removeEventListener(MouseEvent.CLICK,this._openHandler);
            ObjectUtils.disposeObject(param1);
            ObjectUtils.disposeObject(param2);
         }
         param1 = null;
         param2 = null;
      }
      
      private function __showOpenBtn(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         if(_loc2_ == this._cell3MouseSprite)
         {
            this._show3 = true;
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
         else
         {
            this._show3 = false;
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
      }
      
      private function __hideOpenBtn(param1:MouseEvent) : void
      {
         if(this._show3)
         {
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
         else
         {
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
      }
      
      public function shineMain() : void
      {
         this._equipCells[0].shine();
      }
      
      public function shineVice() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(this._equipCells[_loc1_].open)
            {
               this._equipCells[_loc1_].shine();
            }
            _loc1_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._equipCells[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         if(this._playerInfo == param1)
         {
            return;
         }
         this._playerInfo = param1;
         this.initEvent();
         this.setCellsData();
         this.__onUpdateProperty(null);
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      private function setCellsData() : void
      {
         var _loc1_:CardInfo = null;
         for each(_loc1_ in this.playerInfo.cardEquipDic)
         {
            if(_loc1_.Count <= -1)
            {
               this._equipCells[_loc1_.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[_loc1_.Place].cardInfo = _loc1_;
            }
         }
      }
      
      private function setCellPos() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            PositionUtils.setPos(this._equipCells[_loc1_],"CardCell.Pos" + _loc1_);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            PositionUtils.setPos(this._viceCardBit[_loc2_],"CardCell.viceBorder.Pos" + _loc2_);
            _loc2_++;
         }
         PositionUtils.setPos(this._mainCardBit,"CardCell.mainBorder.Pos");
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_CARD,this.__GetCard);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeSoul);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._resetSoulBtn.addEventListener(MouseEvent.CLICK,this.__resetSoulHandler);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__cardHandler);
         this._buyCardBoxBtn.addEventListener(MouseEvent.CLICK,this.__buyCardBoxHandler);
         this._btnHelp.addEventListener(MouseEvent.CLICK,this.__helpClick);
         this._ballPlaySp.addEventListener(MouseEvent.CLICK,this.__ballPlaySpClickHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
      }
      
      protected function __buyCardBoxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.createQuickBuyFrame();
         LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __changeSoul(param1:PlayerPropertyEvent) : void
      {
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
         this.isBallPlaySpTip();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_CARD,this.__GetCard);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeSoul);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._resetSoulBtn.removeEventListener(MouseEvent.CLICK,this.__resetSoulHandler);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__cardHandler);
         this._buyCardBoxBtn.removeEventListener(MouseEvent.CLICK,this.__buyCardBoxHandler);
         this._btnHelp.removeEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      private function __GetCard(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:GrooveInfo = null;
         var _loc8_:CardGrooveInfo = null;
         var _loc9_:CardGrooveInfo = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         CardControl.Instance.model.PlayerId = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Vector.<GrooveInfo> = null;
         if(Boolean(CardControl.Instance.model.GrooveInfoVector))
         {
            _loc5_ = CardControl.Instance.model.GrooveInfoVector;
         }
         else
         {
            _loc5_ = new Vector.<GrooveInfo>(5);
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = new GrooveInfo();
            _loc7_.Place = _loc2_.readInt();
            _loc7_.Type = _loc2_.readInt();
            _loc7_.Level = _loc2_.readInt();
            _loc7_.GP = _loc2_.readInt();
            _loc8_ = GrooveInfoManager.instance.getInfoByLevel(String(_loc7_.Level),String(_loc7_.Type));
            _loc9_ = GrooveInfoManager.instance.getInfoByLevel(String(_loc7_.Level + 1),String(_loc7_.Type));
            if(_loc4_ == 1)
            {
               if(_loc7_.Level > _loc5_[_loc7_.Place].Level)
               {
                  if(_loc7_.Place == 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.MainUpdateCard",String(_loc7_.Level)));
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.UpdateCard",String(_loc7_.Place),String(_loc7_.Level)));
                  }
               }
            }
            if(_loc7_.Level == 40)
            {
               if(_loc7_.Place == 0)
               {
                  this._levelNumTxt1.text = _loc7_.Level.toString();
                  this._levelPorgress.setProgress(0,0);
                  this._levelPorgress.labelText = "0%";
                  _loc5_[0] = _loc7_;
               }
               else if(_loc7_.Place == 1)
               {
                  this._levelNumTxt2.text = _loc7_.Level.toString();
                  this._levelPorgress1.setProgress(0,0);
                  this._levelPorgress1.labelText = "0%";
                  _loc5_[1] = _loc7_;
               }
               else if(_loc7_.Place == 2)
               {
                  this._levelNumTxt3.text = _loc7_.Level.toString();
                  this._levelPorgress2.setProgress(0,0);
                  this._levelPorgress2.labelText = "0%";
                  _loc5_[2] = _loc7_;
               }
               else if(_loc7_.Place == 3)
               {
                  this._levelNumTxt4.text = _loc7_.Level.toString();
                  this._levelPorgress3.setProgress(0,0);
                  this._levelPorgress3.labelText = "0%";
                  _loc5_[3] = _loc7_;
               }
               if(_loc7_.Place == 4)
               {
                  this._levelNumTxt5.text = _loc7_.Level.toString();
                  this._levelPorgress4.setProgress(0,0);
                  this._levelPorgress4.labelText = "0%";
                  _loc5_[4] = _loc7_;
               }
            }
            else
            {
               _loc10_ = _loc7_.GP - int(_loc8_.Exp);
               _loc11_ = int(_loc9_.Exp) - int(_loc8_.Exp);
               if(_loc10_ >= _loc11_)
               {
                  if(Boolean(this._playerInfo))
                  {
                     if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
                     {
                        SocketManager.Instance.out.sendUpdateSLOT(_loc7_.Place,0);
                     }
                  }
               }
               if(_loc7_.Place == 0)
               {
                  this._levelNumTxt1.text = _loc7_.Level.toString();
                  if(_loc7_.GP == 0)
                  {
                     this._levelPorgress.setProgress(0,Number(_loc11_));
                  }
                  else
                  {
                     this._levelPorgress.setProgress(_loc10_,Number(_loc11_));
                  }
                  _loc5_[0] = _loc7_;
               }
               if(_loc7_.Place == 1)
               {
                  this._levelNumTxt2.text = _loc7_.Level.toString();
                  if(_loc7_.GP == 0)
                  {
                     this._levelPorgress1.setProgress(0,Number(_loc11_));
                  }
                  else
                  {
                     this._levelPorgress1.setProgress(_loc10_,Number(_loc11_));
                  }
                  _loc5_[1] = _loc7_;
               }
               if(_loc7_.Place == 2)
               {
                  this._levelNumTxt3.text = _loc7_.Level.toString();
                  if(_loc7_.GP == 0)
                  {
                     this._levelPorgress2.setProgress(0,Number(_loc11_));
                  }
                  else
                  {
                     this._levelPorgress2.setProgress(_loc10_,Number(_loc11_));
                  }
                  _loc5_[2] = _loc7_;
               }
               if(_loc7_.Place == 3)
               {
                  this._levelNumTxt4.text = _loc7_.Level.toString();
                  if(_loc7_.GP == 0)
                  {
                     this._levelPorgress3.setProgress(0,Number(_loc11_));
                  }
                  else
                  {
                     this._levelPorgress3.setProgress(_loc10_,Number(_loc11_));
                  }
                  _loc5_[3] = _loc7_;
               }
               if(_loc7_.Place == 4)
               {
                  this._levelNumTxt5.text = _loc7_.Level.toString();
                  if(_loc7_.GP == 0)
                  {
                     this._levelPorgress4.setProgress(0,Number(_loc11_));
                  }
                  else
                  {
                     this._levelPorgress4.setProgress(_loc10_,Number(_loc11_));
                  }
                  _loc5_[4] = _loc7_;
               }
            }
            _loc6_++;
         }
         CardControl.Instance.model.GrooveInfoVector = _loc5_;
         PlayerManager.Instance.Self.CardSoul = _loc3_;
      }
      
      private function __collectHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CardControl.Instance.showCollectView();
      }
      
      private function __resetSoulHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Vector.<GrooveInfo> = CardControl.Instance.model.GrooveInfoVector;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ += _loc2_[_loc4_].GP;
            _loc4_++;
         }
         if(_loc3_ <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.resetCardSoulNo"));
            return;
         }
         var _loc5_:String = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
         var _loc6_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("CardSystem.resetCardSoul.alertText");
         var _loc7_:String = ServerConfigManager.instance.cardResetCardSoulMoney;
         _loc6_.htmlText = LanguageMgr.GetTranslation("tank.view.card.resetCardSoulText1") + " " + LanguageMgr.GetTranslation("tank.view.card.resetCardSoulText2",_loc3_,_loc7_);
         this._resetAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc5_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._resetAlert.height = 170;
         this._resetAlert.containerX = 50;
         this._resetAlert.containerY = 73;
         this._resetAlert.addChild(_loc6_);
         this._resetAlert.mouseEnabled = false;
         this._resetAlert.addEventListener(FrameEvent.RESPONSE,this.__resetAlertResponse);
      }
      
      private function __resetAlertResponse(param1:FrameEvent) : void
      {
         if(this._resetAlert.hasEventListener(FrameEvent.RESPONSE))
         {
            this._resetAlert.removeEventListener(FrameEvent.RESPONSE,this.__resetAlertResponse);
         }
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(BuriedManager.Instance.checkMoney(this._resetAlert.isBand,int(ServerConfigManager.instance.cardResetCardSoulMoney)))
               {
                  this._resetAlert.dispose();
                  return;
               }
               SocketManager.Instance.out.sendResetCardSoul(this._resetAlert.isBand);
               this.__resetAllText();
         }
         if(Boolean(this._resetAlert))
         {
            this._resetAlert.dispose();
         }
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         this._moneyConfirm.dispose();
         this._moneyConfirm = null;
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __resetAllText() : void
      {
         this._levelNumTxt1.text = "0";
         this._levelPorgress.setProgress(0,0);
         this._levelPorgress.labelText = "0%";
         this._levelNumTxt2.text = "0";
         this._levelPorgress1.setProgress(0,0);
         this._levelPorgress1.labelText = "0%";
         this._levelNumTxt3.text = "0";
         this._levelPorgress2.setProgress(0,0);
         this._levelPorgress2.labelText = "0%";
         this._levelNumTxt4.text = "0";
         this._levelPorgress3.setProgress(0,0);
         this._levelPorgress3.labelText = "0%";
         this._levelNumTxt5.text = "0";
         this._levelPorgress4.setProgress(0,0);
         this._levelPorgress4.labelText = "0%";
         this._GrooveTxt.text = PlayerManager.Instance.Self.CardSoul.toString();
         this._ballPlayCountTxt.text = PlayerManager.Instance.Self.GetSoulCount.toString();
      }
      
      private function __ballPlaySpClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.buyCardSoulValueMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(CardTemplateInfoManager.instance.isShowBuyFrameSelectedCheck)
         {
            this.showBuyCardSoulTips();
         }
         else
         {
            if(PlayerManager.Instance.Self.GetSoulCount != 0)
            {
               CardTemplateInfoManager.instance.isBuyCardsSoul = true;
            }
            CardTemplateInfoManager.instance.isBuyCardsSoul = true;
            SocketManager.Instance.out.sendGetCardSoul();
         }
      }
      
      private function showBuyCardSoulTips() : void
      {
         var _loc1_:Number = ServerConfigManager.instance.buyCardSoulValueMoney;
         this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.cardSystem.getCardSoulMoneyMsg",_loc1_),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("cardSystem.buyFrameSelectedCheckButton");
         this._selectedCheckButton.text = LanguageMgr.GetTranslation("worldboss.buyBuff.NotAgain");
         this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
         this._tipsframe.addToContent(this._selectedCheckButton);
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.tipsDispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.GetSoulCount != 0)
            {
               CardTemplateInfoManager.instance.isBuyCardsSoul = true;
            }
            SocketManager.Instance.out.sendGetCardSoul();
         }
      }
      
      private function __onselectedCheckButtoClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         CardTemplateInfoManager.instance.isShowBuyFrameSelectedCheck = !this._selectedCheckButton.selected;
      }
      
      private function tipsDispose() : void
      {
         if(Boolean(this._selectedCheckButton))
         {
            this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
            ObjectUtils.disposeObject(this._selectedCheckButton);
            this._selectedCheckButton = null;
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      private function __cardHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._cardBtn.localToGlobal(new Point(0,0));
         this._cardList.x = _loc2_.x + this._cardBtn.width;
         this._cardList.y = 440;
         this._cardList.setVisible = true;
      }
      
      private function _openHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice4");
         var _loc3_:String = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open4");
         this._openFrame = AlertManager.Instance.simpleAlert(_loc2_,_loc3_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._openFrame.addEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
      }
      
      private function __openFramehandler(param1:FrameEvent) : void
      {
         this._openFrame.removeEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.openActive();
         }
         this._openFrame.dispose();
         this._openFrame = null;
      }
      
      private function openActive() : void
      {
         var _loc1_:String = null;
         if(this._show3 && CardControl.Instance.model.fourIsOpen() || !this._show3 && (CardControl.Instance.model.fiveIsOpen() || CardControl.Instance.model.fiveIsOpen2()))
         {
            if(this._show3)
            {
               this._equipCells[3].open = true;
               SocketManager.Instance.out.sendOpenViceCard(3);
               this.removeSprite(this._cell3MouseSprite,this._open3Btn);
            }
            else
            {
               this._equipCells[4].open = true;
               SocketManager.Instance.out.sendOpenViceCard(4);
               this.removeSprite(this._cell4MouseSprite,this._open4Btn);
            }
         }
         else
         {
            _loc1_ = this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen4");
            this._configFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc1_,LanguageMgr.GetTranslation("ok"),"",false,false,true,LayerManager.BLCAK_BLOCKGOUND);
            this._configFrame.addEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         }
      }
      
      private function __configResponseHandler(param1:FrameEvent) : void
      {
         this._configFrame.removeEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         this._configFrame.dispose();
         this._configFrame = null;
      }
      
      private function __remove(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(Boolean(this._equipCells[_loc2_.Place]))
         {
            this._equipCells[_loc2_.Place].cardInfo = null;
         }
      }
      
      private function __upData(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(Boolean(_loc2_) && Boolean(this._equipCells[_loc2_.Place]))
         {
            if(_loc2_.Count <= -1)
            {
               this._equipCells[_loc2_.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[_loc2_.Place].cardInfo = _loc2_;
               this._equipCells[_loc2_.Place].playerInfo = this._playerInfo;
            }
         }
      }
      
      private function __getSoul(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         if(!CardTemplateInfoManager.instance.isBuyCardsSoul)
         {
            return;
         }
         CardTemplateInfoManager.instance.isBuyCardsSoul = false;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = _loc2_.readInt();
            PlayerManager.Instance.Self.CardSoul += _loc4_;
            PlayerManager.Instance.Self.GetSoulCount = _loc2_.readInt();
         }
      }
      
      private function isBallPlaySpTip() : void
      {
         this._ballPlaySpTip.visible = false;
         if(this.playerInfo && this.playerInfo.ID == PlayerManager.Instance.Self.ID && PlayerManager.Instance.Self.GetSoulCount > 0)
         {
            this._ballPlaySpTip.visible = true;
            if(PlayerManager.Instance.Self.GetSoulCount > 0)
            {
               this._ballPlaySpTip.visible = true;
            }
            if(PlayerManager.Instance.Self.isViewOther)
            {
               this._ballPlaySpTip.visible = false;
            }
         }
         if(PlayerManager.Instance.Self.isViewOther)
         {
            this._ballPlaySpTip.visible = false;
         }
      }
      
      private function __ballPlaySpMouseOver(param1:MouseEvent) : void
      {
         this._ballPlaySpTip.visible = true;
      }
      
      private function __ballPlaySpMouseOut(param1:MouseEvent) : void
      {
         this.isBallPlaySpTip();
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.isViewOther = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARDS_SOUL,this.__getSoul);
         this.tipsDispose();
         TweenLite.killTweensOf(this._open3Btn);
         TweenLite.killTweensOf(this._open4Btn);
         this.removeEvent();
         this.removeSprite(this._cell3MouseSprite,this._open3Btn);
         this.removeSprite(this._cell4MouseSprite,this._open4Btn);
         this._cell3MouseSprite = null;
         this._cell3MouseSprite = null;
         this._open3Btn = null;
         this._open4Btn = null;
         this._playerInfo = null;
         if(Boolean(this._dragArea))
         {
            this._dragArea.dispose();
         }
         this._dragArea = null;
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(Boolean(this._background1))
         {
            ObjectUtils.disposeObject(this._background1);
         }
         this._background1 = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._mainCardBit))
         {
            ObjectUtils.disposeObject(this._mainCardBit);
         }
         this._mainCardBit = null;
         if(Boolean(this._collectBtn))
         {
            ObjectUtils.disposeObject(this._collectBtn);
         }
         this._collectBtn = null;
         if(Boolean(this._resetSoulBtn))
         {
            ObjectUtils.disposeObject(this._resetSoulBtn);
         }
         this._resetSoulBtn = null;
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._buyCardBoxBtn))
         {
            ObjectUtils.disposeObject(this._buyCardBoxBtn);
         }
         this._buyCardBoxBtn = null;
         if(Boolean(this._btnHelp))
         {
            ObjectUtils.disposeObject(this._btnHelp);
         }
         this._btnHelp = null;
         if(Boolean(this._textBg))
         {
            ObjectUtils.disposeObject(this._textBg);
         }
         this._textBg = null;
         if(Boolean(this._textBg1))
         {
            ObjectUtils.disposeObject(this._textBg1);
         }
         this._textBg1 = null;
         if(Boolean(this._textBg2))
         {
            ObjectUtils.disposeObject(this._textBg2);
         }
         this._textBg2 = null;
         if(Boolean(this._textBg3))
         {
            ObjectUtils.disposeObject(this._textBg3);
         }
         this._textBg3 = null;
         if(Boolean(this._agilityBg))
         {
            ObjectUtils.disposeObject(this._agilityBg);
         }
         this._agilityBg = null;
         if(Boolean(this._attackBg))
         {
            ObjectUtils.disposeObject(this._attackBg);
         }
         this._attackBg = null;
         if(Boolean(this._defenceBg))
         {
            ObjectUtils.disposeObject(this._defenceBg);
         }
         this._defenceBg = null;
         if(Boolean(this._luckBg))
         {
            ObjectUtils.disposeObject(this._luckBg);
         }
         this._luckBg = null;
         if(Boolean(this._GrooveTxt))
         {
            ObjectUtils.disposeObject(this._GrooveTxt);
         }
         this._GrooveTxt = null;
         if(Boolean(this._levelNumTxt1))
         {
            ObjectUtils.disposeObject(this._levelNumTxt1);
         }
         this._levelNumTxt1 = null;
         if(Boolean(this._levelNumTxt2))
         {
            ObjectUtils.disposeObject(this._levelNumTxt2);
         }
         this._levelNumTxt2 = null;
         if(Boolean(this._levelNumTxt3))
         {
            ObjectUtils.disposeObject(this._levelNumTxt3);
         }
         this._levelNumTxt3 = null;
         if(Boolean(this._levelNumTxt4))
         {
            ObjectUtils.disposeObject(this._levelNumTxt4);
         }
         this._levelNumTxt4 = null;
         if(Boolean(this._levelNumTxt5))
         {
            ObjectUtils.disposeObject(this._levelNumTxt5);
         }
         this._levelNumTxt5 = null;
         if(Boolean(this._levelPorgress))
         {
            ObjectUtils.disposeObject(this._levelPorgress);
         }
         this._levelPorgress = null;
         if(Boolean(this._levelPorgress1))
         {
            ObjectUtils.disposeObject(this._levelPorgress1);
         }
         this._levelPorgress1 = null;
         if(Boolean(this._levelPorgress2))
         {
            ObjectUtils.disposeObject(this._levelPorgress2);
         }
         this._levelPorgress2 = null;
         if(Boolean(this._levelPorgress3))
         {
            ObjectUtils.disposeObject(this._levelPorgress3);
         }
         this._levelPorgress3 = null;
         if(Boolean(this._levelPorgress4))
         {
            ObjectUtils.disposeObject(this._levelPorgress4);
         }
         this._levelPorgress4 = null;
         if(Boolean(this._levelTxt1))
         {
            ObjectUtils.disposeObject(this._levelTxt1);
         }
         this._levelTxt1 = null;
         if(Boolean(this._levelTxt2))
         {
            ObjectUtils.disposeObject(this._levelTxt2);
         }
         this._levelTxt2 = null;
         if(Boolean(this._levelTxt3))
         {
            ObjectUtils.disposeObject(this._levelTxt3);
         }
         this._levelTxt3 = null;
         if(Boolean(this._levelTxt4))
         {
            ObjectUtils.disposeObject(this._levelTxt4);
         }
         this._levelTxt4 = null;
         if(Boolean(this._levelTxt5))
         {
            ObjectUtils.disposeObject(this._levelTxt5);
         }
         this._levelTxt5 = null;
         if(Boolean(this._HunzhiBg))
         {
            ObjectUtils.disposeObject(this._HunzhiBg);
         }
         this._HunzhiBg = null;
         if(Boolean(this._ballPlaySp))
         {
            this._ballPlaySp.removeEventListener(MouseEvent.CLICK,this.__ballPlaySpClickHandler);
            this._ballPlaySp.removeEventListener(MouseEvent.ROLL_OVER,this.__ballPlaySpMouseOver);
            this._ballPlaySp.removeEventListener(MouseEvent.ROLL_OUT,this.__ballPlaySpMouseOut);
            ObjectUtils.disposeObject(this._ballPlaySp);
            this._ballPlaySp = null;
         }
         if(Boolean(this._ballPlay))
         {
            ObjectUtils.disposeObject(this._ballPlay);
         }
         this._ballPlay = null;
         if(Boolean(this._ballPlaySpTip))
         {
            ObjectUtils.disposeObject(this._ballPlaySpTip);
         }
         this._ballPlaySpTip = null;
         if(Boolean(this._moneyConfirm))
         {
            ObjectUtils.disposeObject(this._moneyConfirm);
         }
         this._moneyConfirm = null;
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdateProperty);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(Boolean(this._equipCells[_loc1_]))
            {
               this._equipCells[_loc1_].dispose();
               this._equipCells[_loc1_].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               this._equipCells[_loc1_].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               this._equipCells[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
               this._equipCells[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
               this._equipCells[_loc1_] = null;
            }
            _loc1_++;
         }
         this._equipCells = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._viceCardBit.length)
         {
            if(Boolean(this._viceCardBit[_loc2_]))
            {
               ObjectUtils.disposeObject(this._viceCardBit[_loc2_]);
            }
            this._viceCardBit[_loc2_] = null;
            _loc2_++;
         }
         this._viceCardBit = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._btnOk.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            ObjectUtils.disposeObject(this._bgHelp);
            ObjectUtils.disposeObject(this._content);
            ObjectUtils.disposeObject(this._btnOk);
            this._bgHelp = null;
            this._content = null;
            this._btnOk = null;
            this._helpFrame.dispose();
            this._helpFrame = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __clickHandler(param1:Event) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         param1.stopImmediatePropagation();
         if(param1.target is BaseButton)
         {
            return;
         }
         var _loc2_:CardCell = param1.currentTarget as CardCell;
         if(Boolean(_loc2_))
         {
            _loc3_ = _loc2_.info as ItemTemplateInfo;
         }
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            SoundManager.instance.play("008");
            _loc2_.dragStart();
         }
      }
      
      protected function __doubleClickHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CardCell = param1.currentTarget as CardCell;
         if(Boolean(_loc2_.cardInfo))
         {
            param1.stopImmediatePropagation();
            if(Boolean(_loc2_) && !_loc2_.locked)
            {
               SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,_loc2_.cardInfo.Place);
            }
         }
      }
      
      protected function _cellOverEff(param1:MouseEvent) : void
      {
      }
      
      protected function _cellOutEff(param1:MouseEvent) : void
      {
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("cardSystem.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("cardSystem.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
   }
}

