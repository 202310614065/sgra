package bagAndInfo
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.view.AvatarCollectionMainView;
   import bagAndInfo.info.PlayerInfoViewControl;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.data.BeadEvent;
   import cardSystem.CardEvent;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.tips.OneLineTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import giftSystem.GiftController;
   import giftSystem.view.GiftView;
   import magicStone.MagicStoneManager;
   import magicStone.views.MagicStoneMainView;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.view.item.AddPetItem;
   import powerUp.PowerUpMovieManager;
   import road7th.comm.PackageIn;
   import totem.TotemManager;
   import totem.view.TotemMainView;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class BagAndGiftFrame extends Frame
   {
      
      public static const BAGANDINFO:int = 0;
      
      public static const GIFTVIEW:int = 1;
      
      public static const CARDVIEW:int = 2;
      
      public static const TEXPVIEW:int = 3;
      
      public static const EFFORT:int = 4;
      
      public static const PETVIEW:int = 5;
      
      public static const BEADVIEW:int = 21;
      
      public static const TOTEMVIEW:int = 6;
      
      public static const AVATARCOLLECTIONVIEW:int = 7;
      
      public static const DRESSVIEW:int = 8;
      
      public static const MAGICSTONEVIEW:int = 9;
      
      public static const BEAD_CHANGE:String = "beadChanged";
      
      private static const TEXP_OPEN_LEVEL:int = 30;
      
      private static const GIFT_OPEN_LEVEL:int = 16;
      
      private static const CARD_OPEN_LEVEL:int = 20;
      
      private static const PET_OPEN_LEVEL:int = 25;
      
      private static const TOTEM_OPEN_LEVEL:int = 20;
      
      private static const BEAD_OPEN_LEVEL:int = 10;
      
      private static const AVATAR_COLLECTION_OPEN_LEVEL:int = 10;
      
      private static const MAGIC_STONE_LEVEL:int = 40;
      
      private static var _firstOpenCard:Boolean = true;
      
      private static var _isFirstEfforOpen:Boolean = true;
      
      private static var _firstOpenGift:Boolean = true;
      
      private static var _isFirstOpenBead:Boolean = true;
      
      private var _infoFrame:BagAndInfoFrame;
      
      private var _giftView:GiftView;
      
      private var _totemView:TotemMainView;
      
      private var _avatarCollView:AvatarCollectionMainView;
      
      private var _magicStoneMainView:MagicStoneMainView;
      
      private var _BG:ScaleBitmapImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _texpBtnTip:OneLineTip;
      
      private var _texpBtnSprite:Sprite;
      
      private var _texpBtnShine:IEffect;
      
      private var _giftBtn:SelectedButton;
      
      private var _giftBtnShine:IEffect;
      
      private var _giftBtnTip:OneLineTip;
      
      private var _giftBtnSprite:Sprite;
      
      private var _petBtn:SelectedButton;
      
      private var _petBtnSprite:Sprite;
      
      private var _petBtnShine:IEffect;
      
      private var _petBtnTip:OneLineTip;
      
      private var _totemBtn:SelectedButton;
      
      private var _totemBtnSprite:Sprite;
      
      private var _totemBtnShine:IEffect;
      
      private var _totemBtnTip:OneLineTip;
      
      private var _beadBtn:SelectedButton;
      
      private var _beadBtnSprite:Sprite;
      
      private var _beadBtnShine:IEffect;
      
      private var _beadBtnTip:OneLineTip;
      
      private var _cardBtn:SelectedButton;
      
      private var _cardBtnSprite:Sprite;
      
      private var _cardBtnTip:OneLineTip;
      
      private var _avatarCollBtn:SelectedButton;
      
      private var _avatarCollBtnSprite:Sprite;
      
      private var _avatarCollBtnShine:IEffect;
      
      private var _avatarCollBtnTip:OneLineTip;
      
      private var _gemstoneBtn:SelectedButton;
      
      private var _magicStoneBtn:SelectedButton;
      
      private var _magicStoneBtnSprite:Sprite;
      
      private var _magicStoneBtnShine:IEffect;
      
      private var _magicStoneBtnTip:OneLineTip;
      
      private var _frame:BaseAlerFrame;
      
      private var _fightPower:int;
      
      private var isCardFirstLoad:Boolean = true;
      
      public function BagAndGiftFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.bag");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("bagAndInfoFrame.bg1");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn1");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn1");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardBtn");
         this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemBtn1");
         this._beadBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.BeadBtn");
         this._avatarCollBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.avatarCollBtn1");
         this._magicStoneBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.magicStoneBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftBtn1");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.PetBtn");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._texpBtn);
         addToContent(this._cardBtn);
         addToContent(this._totemBtn);
         addToContent(this._beadBtn);
         addToContent(this._avatarCollBtn);
         addToContent(this._magicStoneBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.addSelectItem(this._petBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.addSelectItem(this._totemBtn);
         this._btnGroup.addSelectItem(this._beadBtn);
         this._btnGroup.addSelectItem(this._avatarCollBtn);
         this._btnGroup.addSelectItem(this._magicStoneBtn);
         if(PathManager.solveGemstoneSwitch)
         {
            this._gemstoneBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.GemstoneBtn");
            this._btnGroup.addSelectItem(this._gemstoneBtn);
            if(PlayerManager.Instance.Self.Grade < 30)
            {
               this._gemstoneBtn.visible = false;
            }
         }
         this.texpBtnEnable();
         this.petBtnEnable();
         this.cardBtnEnable();
         this.totemBtnEnable();
         this.beadBtnEnable();
         this.avatarCollBtnEnable();
         this.magicStoneBtnEnable();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_BAG);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_PET_LABEL,-150,"farmTrainer.openPetLabelArrowPos","asset.farmTrainer.clickHere","farmTrainer.openPetLabelTipPos");
         }
         if(SharedManager.Instance.beadLeadTaskStep == 1 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(-1);
               SharedManager.Instance.beadLeadTaskStep = 2;
               SharedManager.Instance.save();
               BeadLeadManager.Instance.leadOpenBeadSurface(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
      }
      
      public function get btnGroup() : SelectedButtonGroup
      {
         return this._btnGroup;
      }
      
      private function magicStoneBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= MAGIC_STONE_LEVEL)
         {
            this._magicStoneBtn.enable = true;
            ObjectUtils.disposeObject(this._magicStoneBtnSprite);
            this._magicStoneBtnSprite = null;
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.MAGIC_STONE_SHINE) && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._magicStoneBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._magicStoneBtn,_loc1_);
               this._magicStoneBtnShine.play();
            }
         }
         else
         {
            this._magicStoneBtn.enable = false;
            if(this._magicStoneBtnSprite == null)
            {
               this._magicStoneBtnSprite = new Sprite();
               this._magicStoneBtnSprite.graphics.beginFill(0,0);
               this._magicStoneBtnSprite.graphics.drawRect(0,0,this._magicStoneBtn.displayWidth,this._magicStoneBtn.displayHeight);
               this._magicStoneBtnSprite.graphics.endFill();
               this._magicStoneBtnSprite.x = this._magicStoneBtn.x + 49;
               this._magicStoneBtnSprite.y = this._magicStoneBtn.y + 3;
               addToContent(this._magicStoneBtnSprite);
               this._magicStoneBtnTip = new OneLineTip();
               this._magicStoneBtnTip.tipData = LanguageMgr.GetTranslation("ddt.magicStoneSystem.openMagicStoneBtn.text",MAGIC_STONE_LEVEL);
               this._magicStoneBtnTip.visible = false;
               this._magicStoneBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__magicStoneOverHandler);
               this._magicStoneBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__magicStoneOutHandler);
            }
         }
      }
      
      private function __magicStoneOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         this._magicStoneBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._magicStoneBtnTip,LayerManager.GAME_TOP_LAYER);
         _loc2_ = this._magicStoneBtn.localToGlobal(new Point(0,0));
         this._magicStoneBtnTip.x = _loc2_.x - 100;
         this._magicStoneBtnTip.y = _loc2_.y + this._magicStoneBtn.height;
      }
      
      private function __magicStoneOutHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._magicStoneBtnTip))
         {
            this._magicStoneBtnTip.visible = false;
         }
      }
      
      private function avatarCollBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= AVATAR_COLLECTION_OPEN_LEVEL)
         {
            this._avatarCollBtn.enable = true;
            if(Boolean(this._avatarCollBtnSprite))
            {
               ObjectUtils.disposeObject(this._avatarCollBtnSprite);
               this._avatarCollBtnSprite = null;
            }
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.AVATAR_COLLECTION_OPEN_SHINE) && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._avatarCollBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._avatarCollBtn,_loc1_);
               this._avatarCollBtnShine.play();
            }
         }
         else
         {
            this._avatarCollBtn.enable = false;
            if(!this._avatarCollBtnSprite)
            {
               this._avatarCollBtnSprite = new Sprite();
               this._avatarCollBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__avatarCollBtnOverHandler);
               this._avatarCollBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__avatarCollBtnOutHandler);
               this._avatarCollBtnSprite.graphics.beginFill(0,0);
               this._avatarCollBtnSprite.graphics.drawRect(0,0,this._avatarCollBtn.displayWidth,this._avatarCollBtn.displayHeight);
               this._avatarCollBtnSprite.graphics.endFill();
               this._avatarCollBtnSprite.x = this._avatarCollBtn.x - 1;
               this._avatarCollBtnSprite.y = this._avatarCollBtn.y + 3;
               addToContent(this._avatarCollBtnSprite);
               this._avatarCollBtnTip = new OneLineTip();
               this._avatarCollBtnTip.tipData = LanguageMgr.GetTranslation("ddt.avatarCollSystem.openAvatarCollBtn.text",AVATAR_COLLECTION_OPEN_LEVEL);
               this._avatarCollBtnTip.visible = false;
            }
         }
      }
      
      private function __avatarCollBtnOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         this._avatarCollBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._avatarCollBtnTip,LayerManager.GAME_TOP_LAYER);
         _loc2_ = this._avatarCollBtn.localToGlobal(new Point(0,0));
         this._avatarCollBtnTip.x = _loc2_.x - 9;
         this._avatarCollBtnTip.y = _loc2_.y + this._avatarCollBtn.height;
      }
      
      private function __avatarCollBtnOutHandler(param1:MouseEvent) : void
      {
         this._avatarCollBtnTip.visible = false;
      }
      
      private function GiftbtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= GIFT_OPEN_LEVEL || GiftController.Instance.inChurch == true)
         {
            this._giftBtn.enable = true;
            if(Boolean(this._giftBtnSprite))
            {
               ObjectUtils.disposeObject(this._giftBtnSprite);
            }
            this._giftBtnSprite = null;
            if(SharedManager.Instance.giftFirstShow)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._giftBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._giftBtn,_loc1_);
               this._giftBtnShine.play();
            }
         }
         else
         {
            this._giftBtn.enable = false;
            if(this._giftBtnSprite == null)
            {
               this._giftBtnSprite = new Sprite();
               this._giftBtnSprite.graphics.beginFill(0,0);
               this._giftBtnSprite.graphics.drawRect(0,0,this._giftBtn.displayWidth,this._giftBtn.displayHeight);
               this._giftBtnSprite.graphics.endFill();
               this._giftBtnSprite.x = this._giftBtn.x + 49;
               this._giftBtnSprite.y = this._giftBtn.y + 3;
               addToContent(this._giftBtnSprite);
               this._giftBtnTip = new OneLineTip();
               this._giftBtnTip.tipData = LanguageMgr.GetTranslation("ddt.giftSystem.openGiftBtn.text");
               this._giftBtnTip.visible = false;
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
         }
      }
      
      private function texpBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= TEXP_OPEN_LEVEL)
         {
            this._texpBtn.enable = true;
            if(Boolean(this._texpBtnSprite))
            {
               ObjectUtils.disposeObject(this._texpBtnSprite);
               this._texpBtnSprite = null;
            }
            if(SharedManager.Instance.texpSystemShow && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._texpBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._texpBtn,_loc1_);
               this._texpBtnShine.play();
            }
         }
         else
         {
            this._texpBtn.enable = false;
            if(!this._texpBtnSprite)
            {
               this._texpBtnSprite = new Sprite();
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
               this._texpBtnSprite.graphics.beginFill(0,0);
               this._texpBtnSprite.graphics.drawRect(0,0,this._texpBtn.displayWidth,this._texpBtn.displayHeight);
               this._texpBtnSprite.graphics.endFill();
               this._texpBtnSprite.x = this._texpBtn.x;
               this._texpBtnSprite.y = this._texpBtn.y + 3;
               addToContent(this._texpBtnSprite);
               this._texpBtnTip = new OneLineTip();
               this._texpBtnTip.tipData = LanguageMgr.GetTranslation("ddt.texpSystem.openTexpBtn.text",TEXP_OPEN_LEVEL);
               this._texpBtnTip.visible = false;
            }
         }
      }
      
      private function cardBtnEnable() : void
      {
         if(PlayerManager.Instance.Self.Grade >= CARD_OPEN_LEVEL)
         {
            this._cardBtn.enable = true;
            if(Boolean(this._cardBtnSprite))
            {
               ObjectUtils.disposeObject(this._cardBtnSprite);
               this._cardBtnSprite = null;
            }
         }
         else
         {
            this._cardBtn.enable = false;
            if(!this._cardBtnSprite)
            {
               this._cardBtnSprite = new Sprite();
               this._cardBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__cardBtnOverHandler);
               this._cardBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__cardBtnOutHandler);
               this._cardBtnSprite.graphics.beginFill(0,0);
               this._cardBtnSprite.graphics.drawRect(0,0,this._cardBtn.displayWidth,this._cardBtn.displayHeight);
               this._cardBtnSprite.graphics.endFill();
               this._cardBtnSprite.x = this._cardBtn.x + 46;
               this._cardBtnSprite.y = this._cardBtn.y + 6;
               addToContent(this._cardBtnSprite);
               this._cardBtnTip = new OneLineTip();
               this._cardBtnTip.tipData = LanguageMgr.GetTranslation("ddt.giftSystem.openCardBtn.text");
               this._cardBtnTip.visible = false;
            }
         }
      }
      
      private function __cardBtnOverHandler(param1:MouseEvent) : void
      {
         this._cardBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._cardBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._cardBtn.localToGlobal(new Point(0,0));
         this._cardBtnTip.x = _loc2_.x;
         this._cardBtnTip.y = _loc2_.y + this._cardBtn.height;
      }
      
      private function __cardBtnOutHandler(param1:MouseEvent) : void
      {
         this._cardBtnTip.visible = false;
      }
      
      private function petBtnEnable() : void
      {
         if(PlayerManager.Instance.Self.Grade >= PET_OPEN_LEVEL)
         {
            this._petBtn.enable = true;
            if(Boolean(this._petBtnSprite))
            {
               ObjectUtils.disposeObject(this._petBtnSprite);
               this._petBtnSprite = null;
            }
         }
         else
         {
            this._petBtn.enable = false;
            if(!this._petBtnSprite)
            {
               this._petBtnSprite = new Sprite();
               this._petBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__petBtnOverHandler);
               this._petBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__petBtnOutHandler);
               this._petBtnSprite.graphics.beginFill(0,0);
               this._petBtnSprite.graphics.drawRect(0,0,this._petBtn.displayWidth,this._petBtn.displayHeight);
               this._petBtnSprite.graphics.endFill();
               this._petBtnSprite.x = this._petBtn.x + 38;
               this._petBtnSprite.y = this._petBtn.y + 8;
               this._petBtnTip = new OneLineTip();
               this._petBtnTip.tipData = LanguageMgr.GetTranslation("ddt.petSystem.openPetBtn.text");
               this._petBtnTip.visible = false;
            }
         }
      }
      
      private function totemBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= TOTEM_OPEN_LEVEL)
         {
            this._totemBtn.enable = true;
            if(Boolean(this._totemBtnSprite))
            {
               ObjectUtils.disposeObject(this._totemBtnSprite);
               this._totemBtnSprite = null;
            }
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.TOTEM_OPEN_SHINE) && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._totemBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._totemBtn,_loc1_);
               this._totemBtnShine.play();
            }
         }
         else
         {
            this._totemBtn.enable = false;
            if(!this._totemBtnSprite)
            {
               this._totemBtnSprite = new Sprite();
               this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
               this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
               this._totemBtnSprite.graphics.beginFill(0,0);
               this._totemBtnSprite.graphics.drawRect(0,0,this._totemBtn.displayWidth,this._totemBtn.displayHeight);
               this._totemBtnSprite.graphics.endFill();
               this._totemBtnSprite.x = this._totemBtn.x - 1;
               this._totemBtnSprite.y = this._totemBtn.y + 3;
               addToContent(this._totemBtnSprite);
               this._totemBtnTip = new OneLineTip();
               this._totemBtnTip.tipData = LanguageMgr.GetTranslation("ddt.totemSystem.openTotemBtn.text",TOTEM_OPEN_LEVEL);
               this._totemBtnTip.visible = false;
            }
         }
      }
      
      private function beadBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= BEAD_OPEN_LEVEL)
         {
            this._beadBtn.enable = true;
            if(Boolean(this._beadBtnSprite))
            {
               ObjectUtils.disposeObject(this._beadBtnSprite);
               this._beadBtnSprite = null;
            }
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.BEAD_OPEN_SHINE) && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._beadBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._beadBtn,_loc1_);
               this._beadBtnShine.play();
            }
         }
         else
         {
            this._beadBtn.enable = false;
            if(!this._beadBtnSprite)
            {
               this._beadBtnSprite = new Sprite();
               this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__beadBtnOverHandler);
               this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__beadBtnOutHandler);
               this._beadBtnSprite.graphics.beginFill(0,0);
               this._beadBtnSprite.graphics.drawRect(0,0,this._beadBtn.displayWidth,this._beadBtn.displayHeight);
               this._beadBtnSprite.graphics.endFill();
               this._beadBtnSprite.x = this._beadBtn.x + 8;
               this._beadBtnSprite.y = this._beadBtn.y + 3;
               addToContent(this._beadBtnSprite);
               this._beadBtnTip = new OneLineTip();
               this._beadBtnTip.tipData = LanguageMgr.GetTranslation("ddt.giftSystem.openBeadBtn.text",BEAD_OPEN_LEVEL);
               this._beadBtnTip.visible = false;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._beadBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._avatarCollBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._magicStoneBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         if(Boolean(this._gemstoneBtn))
         {
            this._gemstoneBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.addEventListener(BagEvent.QUICK_BUG_CARDS,this.__quickBuyCards);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               SoundManager.instance.play("008");
               (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               (param1.currentTarget as BaseAlerFrame).dispose();
               SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      private function __quickBuyCards(param1:BagEvent) : void
      {
         this._btnGroup.selectIndex = 0;
      }
      
      public function __addPet(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:AddPetItem = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:AlertInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:PetInfo = new PetInfo();
         _loc5_.TemplateID = _loc3_;
         PetInfoManager.fillPetInfo(_loc5_);
         if(Boolean(_loc5_))
         {
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename("bagandinfo.bagAndInfo.itemOpenUpTxt");
            _loc7_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.bagAndInfo.itemOpenUpTxt");
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame2");
            _loc6_ = ComponentFactory.Instance.creat("bagAndInfo.petAddItem",[_loc5_]);
            _loc8_ = new AlertInfo(_loc5_.Name);
            _loc8_.showCancel = false;
            _loc8_.moveEnable = false;
            this._frame.info = _loc8_;
            this._frame.addToContent(_loc7_);
            this._frame.addToContent(_loc6_);
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._infoFrame.clearTexpInfo();
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._texpBtnSprite))
         {
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
         }
         if(Boolean(this._petBtnSprite))
         {
            this._petBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__petBtnOverHandler);
            this._petBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__petBtnOutHandler);
         }
         if(Boolean(this._cardBtnSprite))
         {
         }
         if(Boolean(this._totemBtnSprite))
         {
            this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
            this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
         }
         if(Boolean(this._beadBtnSprite))
         {
            this._beadBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__beadBtnOverHandler);
            this._beadBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__beadBtnOutHandler);
         }
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._beadBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._avatarCollBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._magicStoneBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         if(Boolean(this._gemstoneBtn))
         {
            this._gemstoneBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.removeEventListener(BagEvent.QUICK_BUG_CARDS,this.__quickBuyCards);
         if(Boolean(this._infoFrame))
         {
            this._infoFrame._bagView.removeEventListener(CardEvent.SETSELECTCARD_COMPLETE,this.__setSelectCardComplete);
         }
      }
      
      protected function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["Grade"]))
         {
            if(PlayerManager.Instance.Self.Grade == TEXP_OPEN_LEVEL)
            {
               this.texpBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == CARD_OPEN_LEVEL)
            {
               this.cardBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == PET_OPEN_LEVEL)
            {
               this.petBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == TOTEM_OPEN_LEVEL)
            {
               this.totemBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == MAGIC_STONE_LEVEL)
            {
               this.magicStoneBtnEnable();
            }
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         PlayerInfoViewControl.isOpenFromBag = true;
         SoundManager.instance.play("008");
         if((param1.target as SelectedButton).selectedStyle == "asset.infoBtn2")
         {
            this.showInfoFrame(BAGANDINFO);
         }
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
      }
      
      private function __texpBtnOverHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._texpBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._texpBtn.localToGlobal(new Point(0,0));
         this._texpBtnTip.x = _loc2_.x;
         this._texpBtnTip.y = _loc2_.y + this._texpBtn.height;
      }
      
      private function __texpBtnOutHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = false;
      }
      
      private function __petBtnOverHandler(param1:MouseEvent) : void
      {
         this._petBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._petBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._petBtn.localToGlobal(new Point(0,0));
         this._petBtnTip.x = _loc2_.x;
         this._petBtnTip.y = _loc2_.y + this._petBtn.height + 5;
      }
      
      private function __petBtnOutHandler(param1:MouseEvent) : void
      {
         this._petBtnTip.visible = false;
      }
      
      private function __totemBtnOverHandler(param1:MouseEvent) : void
      {
         this._totemBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._totemBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._totemBtn.localToGlobal(new Point(0,0));
         this._totemBtnTip.x = _loc2_.x - 9;
         this._totemBtnTip.y = _loc2_.y + this._totemBtn.height;
      }
      
      private function __totemBtnOutHandler(param1:MouseEvent) : void
      {
         this._totemBtnTip.visible = false;
      }
      
      private function __beadBtnOverHandler(param1:MouseEvent) : void
      {
         this._beadBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._beadBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._beadBtn.localToGlobal(new Point(0,0));
         this._beadBtnTip.x = _loc2_.x + 10;
         this._beadBtnTip.y = _loc2_.y + this._beadBtn.height;
      }
      
      private function __beadBtnOutHandler(param1:MouseEvent) : void
      {
         this._beadBtnTip.visible = false;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         if(Boolean(this._infoFrame))
         {
            this._infoFrame.clearTexpInfo();
         }
         if(SharedManager.Instance.beadLeadTaskStep != 2)
         {
            BeadLeadManager.Instance.disposeBeadLeadArrows();
         }
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._fightPower = PlayerManager.Instance.Self.FightPower;
               this.showInfoFrame(BAGANDINFO);
               break;
            case 1:
               this.showGiftFrame();
               break;
            case 2:
               this.showInfoFrame(TEXPVIEW);
               break;
            case 3:
               this.showInfoFrame(PETVIEW);
               break;
            case 4:
               this.showCard();
               break;
            case 5:
               this.showTotem();
               break;
            case 6:
               this._fightPower = PlayerManager.Instance.Self.FightPower;
               this.showBeadView();
               break;
            case 7:
               this.showAvatarCollection();
               break;
            case 8:
               this._fightPower = PlayerManager.Instance.Self.FightPower;
               this.showMagicStone();
         }
         beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.AUTOOPENBEAD,3));
      }
      
      private function showMagicStone() : void
      {
         if(Boolean(this._magicStoneBtnShine))
         {
            this._magicStoneBtnShine.stop();
            SocketManager.Instance.out.syncWeakStep(Step.MAGIC_STONE_SHINE);
         }
         if(!this._magicStoneMainView)
         {
            MagicStoneManager.instance.loadResModule(this.doShowMagicStone);
         }
         else
         {
            this.setVisible(MAGICSTONEVIEW);
            SocketManager.Instance.out.getMagicStoneScore();
         }
      }
      
      private function doShowMagicStone() : void
      {
         this._magicStoneMainView = ComponentFactory.Instance.creatCustomObject("magicStoneMainView");
         addToContent(this._magicStoneMainView);
         this.setVisible(MAGICSTONEVIEW);
         SocketManager.Instance.out.getMagicStoneScore();
      }
      
      private function showBeadView() : void
      {
         if(Boolean(this._beadBtnShine))
         {
            this._beadBtnShine.stop();
            SocketManager.Instance.out.syncWeakStep(Step.BEAD_OPEN_SHINE);
         }
         this.beadLead();
         this.showInfoFrame(BagAndGiftFrame.BEADVIEW);
      }
      
      private function beadLead() : void
      {
         if(SharedManager.Instance.beadLeadTaskStep == 2 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_OPENBEADSURFACE);
               if(Boolean(this._infoFrame))
               {
                  this._infoFrame._bagView.leadBeadSPaling();
               }
               BeadLeadManager.Instance.leadPutBeadToUpdateslot(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),BeadLeadManager.Instance.arrowPos,BeadLeadManager.Instance.txtPos);
               SharedManager.Instance.beadLeadTaskStep = 3;
               SharedManager.Instance.save();
            }
         }
         else if(SharedManager.Instance.beadLeadTaskStep == 3 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_OPENBEADSURFACE);
               if(Boolean(this._infoFrame))
               {
                  this._infoFrame._bagView.leadBeadSPaling();
               }
               BeadLeadManager.Instance.leadPutBeadToUpdateslot(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),BeadLeadManager.Instance.arrowPos,BeadLeadManager.Instance.txtPos);
            }
         }
         else if(SharedManager.Instance.beadLeadTaskStep == 4 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_BEADUPDATESLOT);
               BeadLeadManager.Instance.upLevelCellSpaling = false;
               BeadLeadManager.Instance.leadClickCombinBnt(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
      }
      
      private function setVisible(param1:int) : void
      {
         var _loc2_:Boolean = true;
         if(Boolean(this._infoFrame))
         {
            if(param1 == BAGANDINFO || param1 == CARDVIEW)
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
            this._infoFrame.visible = _loc2_;
            if(param1 == BAGANDINFO)
            {
               this._infoFrame._infoView.switchShow(false);
            }
            if(param1 == CARDVIEW)
            {
               this._infoFrame._infoView.x = 12;
               this._infoFrame._infoView.y = 2;
               this._infoFrame._bagView.x = 475;
               this._infoFrame._bagView.y = -21;
            }
            else
            {
               this._infoFrame._infoView.x = -9;
               this._infoFrame._infoView.y = 2;
               this._infoFrame._bagView.x = 442;
               this._infoFrame._bagView.y = -16;
            }
         }
         if(Boolean(this._giftView))
         {
            this._giftView.visible = param1 == GIFTVIEW ? true : false;
         }
         if(Boolean(this._totemView))
         {
            this._totemView.visible = param1 == TOTEMVIEW ? true : false;
         }
         if(Boolean(this._avatarCollView))
         {
            this._avatarCollView.visible = param1 == AVATARCOLLECTIONVIEW ? true : false;
         }
         if(Boolean(this._magicStoneMainView))
         {
            this._magicStoneMainView.visible = param1 == MAGICSTONEVIEW;
         }
      }
      
      private function showCard() : void
      {
         if(this.isCardFirstLoad)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__LoadCard);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadCardInProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CARD_SYSTEM);
         }
         else
         {
            this.switchCardView();
         }
      }
      
      private function __LoadCard(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__LoadCard);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadCardInProgress);
            UIModuleSmallLoading.Instance.hide();
            this.isCardFirstLoad = false;
            this.showCard();
         }
      }
      
      private function __onLoadCardInProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__LoadCard);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onLoadCardInProgress);
      }
      
      private function switchCardView() : void
      {
         SocketManager.Instance.out.getPlayerCardInfo(PlayerManager.Instance.Self.ID);
         if(this._infoFrame == null)
         {
            this._infoFrame = ComponentFactory.Instance.creatCustomObject("bagAndInfoFrame");
            addToContent(this._infoFrame);
         }
         this._infoFrame._bagView.addEventListener(CardEvent.SETSELECTCARD_COMPLETE,this.__setSelectCardComplete);
         this._infoFrame.switchShow(BAGANDINFO);
         this.setVisible(CARDVIEW);
         this._infoFrame._bagView.createCard();
      }
      
      private function __setSelectCardComplete(param1:CardEvent) : void
      {
         this._infoFrame._infoView.switchShow(true);
      }
      
      private function showTotem() : void
      {
         if(Boolean(this._totemBtnShine))
         {
            this._totemBtnShine.stop();
            SocketManager.Instance.out.syncWeakStep(Step.TOTEM_OPEN_SHINE);
         }
         if(!this._totemView)
         {
            TotemManager.instance.loadTotemModule(this.doShowTotem);
         }
         else
         {
            this.setVisible(TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = ComponentFactory.Instance.creatCustomObject("totemView");
         addToContent(this._totemView);
         this.setVisible(TOTEMVIEW);
      }
      
      private function showAvatarCollection() : void
      {
         if(Boolean(this._avatarCollBtnShine))
         {
            this._avatarCollBtnShine.stop();
            SocketManager.Instance.out.syncWeakStep(Step.AVATAR_COLLECTION_OPEN_SHINE);
         }
         if(!this._avatarCollView)
         {
            AvatarCollectionManager.instance.loadResModule(this.doShowAvatarCollection);
         }
         else
         {
            this.setVisible(AVATARCOLLECTIONVIEW);
         }
      }
      
      private function doShowAvatarCollection() : void
      {
         this._avatarCollView = new AvatarCollectionMainView();
         addToContent(this._avatarCollView);
         this.setVisible(AVATARCOLLECTIONVIEW);
      }
      
      private function showGiftFrame() : void
      {
         if(_firstOpenGift)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_GIFT_SYSTEM);
         }
         else
         {
            if(!this._giftView)
            {
               this._giftView = ComponentFactory.Instance.creatCustomObject("giftView");
               addToContent(this._giftView);
            }
            GiftController.Instance.canActive = true;
            SocketManager.Instance.out.sendUpdateGoodsCount();
            this._giftView.info = PlayerManager.Instance.Self;
            this.setVisible(GIFTVIEW);
         }
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_GIFT_SYSTEM)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
            _firstOpenGift = false;
            this.showGiftFrame();
         }
      }
      
      protected function __onGiftSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onGiftSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onGiftUIProgress);
      }
      
      protected function __onGiftUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_GIFT_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function showInfoFrame(param1:int) : void
      {
         if(param1 == TEXPVIEW && Boolean(this._texpBtnShine))
         {
            this._texpBtnShine.stop();
            SharedManager.Instance.texpSystemShow = false;
            SharedManager.Instance.save();
         }
         if(this._infoFrame == null)
         {
            this._infoFrame = ComponentFactory.Instance.creatCustomObject("bagAndInfoFrame");
            addToContent(this._infoFrame);
         }
         if(param1 == PETVIEW)
         {
            this._infoFrame.isScreenFood = true;
         }
         else
         {
            this._infoFrame.isScreenFood = false;
         }
         this._infoFrame.switchShow(param1);
         this.setVisible(BAGANDINFO);
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
            if(this._btnGroup.selectIndex == 0 || this._btnGroup.selectIndex == 6 || this._btnGroup.selectIndex == 8)
            {
               if(this._fightPower < PlayerManager.Instance.Self.FightPower)
               {
                  PowerUpMovieManager.powerNum = this._fightPower;
                  PowerUpMovieManager.addedPowerNum = PlayerManager.Instance.Self.FightPower - this._fightPower;
                  PowerUpMovieManager.Instance.dispatchEvent(new Event(PowerUpMovieManager.POWER_UP));
               }
            }
            if(PlayerManager.Instance.Self.Grade == 3)
            {
               MainToolBar.Instance.tipTask();
            }
         }
      }
      
      public function show(param1:int, param2:String = "") : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(param1 == BagAndGiftFrame.BEADVIEW)
         {
            this._btnGroup.selectIndex = 6;
         }
         else
         {
            this._btnGroup.selectIndex = param1;
         }
         if(GiftController.Instance.inChurch == true)
         {
            this._infoBtn.enable = false;
            this._texpBtn.enable = false;
            this._petBtn.enable = false;
            this._cardBtn.enable = false;
            this._totemBtn.enable = false;
            this._beadBtn.enable = false;
            this._avatarCollBtn.enable = false;
         }
         if(param1 == GIFTVIEW && param2 != "")
         {
            setTimeout(GiftController.Instance.RebackClick,300,param2);
         }
         if(StateManager.isInGame(StateManager.currentStateType))
         {
            this._infoBtn.enable = false;
            this._texpBtn.enable = false;
            this._petBtn.enable = false;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._texpBtnShine))
         {
            EffectManager.Instance.removeEffect(this._texpBtnShine);
         }
         this._texpBtnShine = null;
         if(Boolean(this._totemBtnShine))
         {
            EffectManager.Instance.removeEffect(this._totemBtnShine);
         }
         this._totemBtnShine = null;
         if(Boolean(this._beadBtnShine))
         {
            EffectManager.Instance.removeEffect(this._beadBtnShine);
         }
         this._beadBtnShine = null;
         BagAndInfoManager.Instance.clearReference();
         this.removeEvent();
         if(Boolean(this._petBtn))
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
            this._frame.dispose();
            this._frame = null;
         }
         if(Boolean(this._infoBtn))
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(Boolean(this._texpBtn))
         {
            ObjectUtils.disposeObject(this._texpBtn);
         }
         this._texpBtn = null;
         if(Boolean(this._texpBtnTip))
         {
            ObjectUtils.disposeObject(this._texpBtnTip);
         }
         this._texpBtnTip = null;
         if(Boolean(this._texpBtnSprite))
         {
            ObjectUtils.disposeObject(this._texpBtnSprite);
         }
         this._texpBtnSprite = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._giftBtnSprite))
         {
            ObjectUtils.disposeObject(this._giftBtnSprite);
         }
         this._giftBtnSprite = null;
         if(Boolean(this._totemBtnSprite))
         {
            ObjectUtils.disposeObject(this._totemBtnSprite);
         }
         this._totemBtnSprite = null;
         if(Boolean(this._beadBtnSprite))
         {
            ObjectUtils.disposeObject(this._beadBtnSprite);
         }
         this._beadBtnSprite = null;
         if(Boolean(this._giftBtnTip))
         {
            ObjectUtils.disposeObject(this._giftBtnTip);
         }
         this._giftBtnTip = null;
         if(Boolean(this._petBtnTip))
         {
            ObjectUtils.disposeObject(this._petBtnTip);
         }
         this._petBtnTip = null;
         if(Boolean(this._cardBtnTip))
         {
            ObjectUtils.disposeObject(this._cardBtnTip);
         }
         this._cardBtnTip = null;
         if(Boolean(this._totemBtnTip))
         {
            ObjectUtils.disposeObject(this._totemBtnTip);
         }
         this._totemBtnTip = null;
         if(Boolean(this._beadBtnTip))
         {
            ObjectUtils.disposeObject(this._beadBtnTip);
         }
         this._beadBtnTip = null;
         if(Boolean(this._infoFrame))
         {
            this._infoFrame.dispose();
         }
         this._infoFrame = null;
         if(Boolean(this._giftView))
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         if(Boolean(this._totemBtn))
         {
            ObjectUtils.disposeObject(this._totemBtn);
         }
         this._totemBtn = null;
         if(Boolean(this._avatarCollBtn))
         {
            ObjectUtils.disposeObject(this._avatarCollBtn);
         }
         this._avatarCollBtn = null;
         ObjectUtils.disposeObject(this._magicStoneBtn);
         this._magicStoneBtn = null;
         ObjectUtils.disposeObject(this._magicStoneBtnShine);
         this._magicStoneBtnShine = null;
         ObjectUtils.disposeObject(this._magicStoneBtnSprite);
         this._magicStoneBtnSprite = null;
         ObjectUtils.disposeObject(this._magicStoneBtnTip);
         this._magicStoneBtnTip = null;
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_LABEL);
         BeadLeadManager.Instance.disposeBeadLeadArrows();
         BeadLeadManager.Instance.removeSpalingUpLevelCell();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

