package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import beadSystem.views.PlayerBeadInfoView;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.view.GiftInfoView;
   import petsBag.view.PetsBagOtherView;
   import room.RoomManager;
   import texpSystem.view.TexpInfoView;
   import totem.TotemManager;
   import totem.view.TotemInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
      
      private var _BG:ScaleBitmapImage;
      
      private var _view:PlayerInfoView;
      
      private var _texpView:TexpInfoView;
      
      private var _giftView:GiftInfoView;
      
      private var _cardEquip:CardEquipView;
      
      private var _info:*;
      
      private var _petsView:PetsBagOtherView;
      
      private var _beadInfoView:PlayerBeadInfoView;
      
      private var _totemView:TotemInfoView;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _giftBtn:SelectedButton;
      
      private var _cardBtn:SelectedButton;
      
      private var _petBtn:SelectedButton;
      
      private var _beadBtn:SelectedButton;
      
      private var _totemBtn:SelectedButton;
      
      private var _hBox:HBox;
      
      private var _openTexp:Boolean;
      
      private var _openGift:Boolean;
      
      private var _openCard:Boolean;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.playerInfoBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftInfoBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardInfoBtn");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.petInfoBtn");
         this._beadBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.beadInfoBtn");
         this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemInfoBtn");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._petBtn);
         addToContent(this._giftBtn);
         addToContent(this._cardBtn);
         addToContent(this._beadBtn);
         addToContent(this._totemBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.addSelectItem(this._petBtn);
         this._btnGroup.addSelectItem(this._beadBtn);
         this._btnGroup.addSelectItem(this._totemBtn);
         this._btnGroup.selectIndex = 0;
         if(Boolean(RoomManager.Instance.current) && PlayerInfoViewControl._isBattle)
         {
            this._infoBtn.visible = false;
            this._petBtn.visible = false;
            this._giftBtn.visible = false;
            this._cardBtn.visible = false;
            this._beadBtn.visible = false;
            this._totemBtn.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._beadBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      private function __soundPlayer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case BagAndGiftFrame.GIFTVIEW:
               if(!this._openGift)
               {
                  if(this._info.ID != PlayerManager.Instance.Self.ID)
                  {
                     SocketManager.Instance.out.sendPlayerGift(this._info.ID);
                  }
                  this._openGift = true;
               }
               this.showGiftFrame();
               break;
            case BagAndGiftFrame.CARDVIEW:
               if(!this._openCard)
               {
                  SocketManager.Instance.out.getPlayerCardInfo(this._info.ID);
                  this._openCard = true;
               }
               this.showCardEquip();
               break;
            case BagAndGiftFrame.PETVIEW - 2:
               PlayerInfoViewControl.isOpenFromBag = false;
               this.showPetsView();
               break;
            case BagAndGiftFrame.BEADVIEW - 17:
               this.showBeadInfoView();
               break;
            case 5:
               this.showTotem();
         }
      }
      
      private function showTotem() : void
      {
         if(!this._totemView)
         {
            TotemManager.instance.loadTotemModule(this.doShowTotem);
         }
         else
         {
            this.setVisible(BagAndGiftFrame.TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = new TotemInfoView(this._info);
         addToContent(this._totemView);
         this.setVisible(BagAndGiftFrame.TOTEMVIEW);
      }
      
      private function setVisible(param1:int) : void
      {
         if(Boolean(this._view))
         {
            this._view.visible = param1 == BagAndGiftFrame.BAGANDINFO || param1 == BagAndGiftFrame.CARDVIEW;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.visible = param1 == BagAndGiftFrame.TEXPVIEW;
         }
         if(Boolean(this._giftView))
         {
            this._giftView.visible = param1 == BagAndGiftFrame.GIFTVIEW;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.visible = param1 == BagAndGiftFrame.PETVIEW;
         }
         if(Boolean(this._view) && this._view.visible)
         {
            this._view.switchShowII(param1 == BagAndGiftFrame.CARDVIEW);
         }
         if(Boolean(this._beadInfoView))
         {
            this._beadInfoView.visible = param1 == BagAndGiftFrame.BEADVIEW;
         }
         if(Boolean(this._totemView))
         {
            this._totemView.visible = param1 == BagAndGiftFrame.TOTEMVIEW;
         }
      }
      
      private function showBeadInfoView() : void
      {
         try
         {
            if(!this._beadInfoView)
            {
               this._beadInfoView = ComponentFactory.Instance.creatCustomObject("playerBeadInfoView");
               this._beadInfoView.playerInfo = this._info;
               addChild(this._beadInfoView);
            }
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTBEAD);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__showBeadInfoView);
         }
         this.setVisible(BagAndGiftFrame.BEADVIEW);
      }
      
      protected function __showBeadInfoView(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTBEAD)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showBeadInfoView();
         }
      }
      
      private function showCardEquip() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.CARDVIEW);
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showTexpFrame() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoView.main");
               addToContent(this._texpView);
            }
            if(this._info)
            {
               this._texpView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.TEXPVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
         }
      }
      
      private function __createTexp(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpFrame();
         }
      }
      
      private function showPetsView() : void
      {
         try
         {
            if(this._petsView == null)
            {
               this._petsView = ComponentFactory.Instance.creatCustomObject("petsBagOtherPnl.other");
               addToContent(this._petsView);
            }
            if(this._info)
            {
               this._petsView.infoPlayer = this._info;
            }
            this.setVisible(BagAndGiftFrame.PETVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createPets);
         }
      }
      
      private function __createPets(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            this.showPetsView();
         }
      }
      
      private function showGiftFrame() : void
      {
         try
         {
            if(this._giftView == null)
            {
               this._giftView = new GiftInfoView();
               PositionUtils.setPos(this._giftView,"PlayerInfoFrame.giftViewPos");
               addToContent(this._giftView);
            }
            GiftController.Instance.canActive = false;
            if(this._info)
            {
               this._giftView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.GIFTVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_GIFT_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createGift);
         }
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_GIFT_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            this.showGiftFrame();
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this._infoBtn))
         {
            this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         if(Boolean(this._giftBtn))
         {
            this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         if(Boolean(this._cardBtn))
         {
            this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         if(Boolean(this._petBtn))
         {
            this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         if(Boolean(this._beadBtn))
         {
            this._beadBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         if(Boolean(this._totemBtn))
         {
            this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info(param1:*) : void
      {
         this._info = param1;
         if(PlayerInfoViewControl._isBattle)
         {
            if(Boolean(this._view))
            {
               this._view.info = this._info;
            }
            return;
         }
         if(Boolean(this._view))
         {
            this._view.info = this._info;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.info = this._info;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.infoPlayer = this._info;
         }
         if(Boolean(this._giftView))
         {
            this._giftView.info = this._info;
         }
         if(this._info.Grade < 25 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 25 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 16 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._giftBtn.enable = false;
         }
         else
         {
            this._giftBtn.enable = true;
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._cardBtn.enable = false;
         }
         else
         {
            this._cardBtn.enable = true;
         }
         if(this._info.Grade < 10 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._beadBtn.enable = false;
         }
         else
         {
            this._beadBtn.enable = true;
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._totemBtn.enable = false;
         }
         else
         {
            this._totemBtn.enable = true;
         }
      }
      
      public function setAchivEnable(param1:Boolean) : void
      {
         this._view.setAchvEnable(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._infoBtn))
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(Boolean(this._giftBtn))
         {
            ObjectUtils.disposeObject(this._giftBtn);
         }
         this._giftBtn = null;
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._petBtn))
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(Boolean(this._totemBtn))
         {
            ObjectUtils.disposeObject(this._totemBtn);
            this._totemBtn = null;
         }
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this._texpView))
         {
            this._texpView.dispose();
         }
         this._texpView = null;
         if(Boolean(this._giftView))
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         if(Boolean(this._petsView))
         {
            this._petsView.dispose();
            this._petsView = null;
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

