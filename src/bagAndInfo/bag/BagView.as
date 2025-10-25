package bagAndInfo.bag
{
   import bagAndInfo.ReworkName.ReworkNameConsortia;
   import bagAndInfo.ReworkName.ReworkNameFrame;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.changeSex.ChangeSexAlertFrame;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadBagList;
   import beadSystem.controls.BeadCell;
   import beadSystem.controls.BeadFeedButton;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.controls.BeadLockButton;
   import beadSystem.data.BeadEvent;
   import beadSystem.data.BeadLeadEvent;
   import beadSystem.model.BeadModel;
   import beadSystem.views.BeadFeedInfoFrame;
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.ConsortionBankBagView;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.chat.ChatBugleInputFrame;
   import ddt.view.goods.AddPricePanel;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   import petsBag.controller.PetBagController;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   import playerDress.views.DressBagView;
   import quest.TrusteeshipManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.DateUtils;
   import setting.view.KeySetFrame;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   import texpSystem.controller.TexpManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import wonderfulActivity.WonderfulActivityManager;
   
   [Event(name="sellstop")]
   [Event(name="sellstart")]
   public class BagView extends Sprite implements Disposeable
   {
      
      public static const FIRST_GET_CARD:String = "firstGetCard";
      
      public static const TABCHANGE:String = "tabChange";
      
      public static const SHOWBEAD:String = "showBeadFrame";
      
      public static const EQUIP:int = 0;
      
      public static const PROP:int = 1;
      
      public static const CARD:int = 2;
      
      public static const CONSORTION:int = 3;
      
      public static const PET:int = 5;
      
      public static const BEAD:int = 21;
      
      public static const DRESS:int = 8;
      
      public static var isShowCardBag:Boolean = false;
      
      private static const UseColorShellLevel:int = 10;
      
      private var _index:int = 0;
      
      private const STATE_SELL:uint = 1;
      
      private const STATE_BEADFEED:uint = 1;
      
      private var bead_state:uint = 0;
      
      protected var _bgShape:Shape;
      
      protected var _bgShapeII:MovieImage;
      
      private var state:uint = 0;
      
      private var _info:SelfInfo;
      
      protected var _equiplist:BagEquipListView;
      
      protected var _proplist:BagListView;
      
      protected var _petlist:PetBagListView;
      
      protected var _beadList:BeadBagList;
      
      protected var _beadList2:BeadBagList;
      
      protected var _beadList3:BeadBagList;
      
      protected var _dressbagView:DressBagView;
      
      protected var _currIndex:int = 1;
      
      protected var _sellBtn:SellGoodsBtn;
      
      protected var _continueBtn:ContinueGoodsBtn;
      
      protected var _lists:Array;
      
      protected var _currentList:BagListView;
      
      protected var _currentBeadList:BeadBagList;
      
      protected var _breakBtn:BreakGoodsBtn;
      
      protected var _keySortBtn:TextButton;
      
      private var _keySetFrame:KeySetFrame;
      
      private var _chatBugleInputFrame:ChatBugleInputFrame;
      
      protected var _bagType:int;
      
      protected var _settedLockBtn:TextButton;
      
      protected var _settingLockBtn:TextButton;
      
      private var _bagLocked:Boolean;
      
      protected var _sortBagBtn:TextButton;
      
      protected var _trieveBtn:TextButton;
      
      private var _trieveBtnSprite:Sprite;
      
      private var _trieveBtnTip:OneLineTip;
      
      private var _self:SelfInfo = PlayerManager.Instance.Self;
      
      private var _beadFeedBtn:BeadFeedButton;
      
      private var _beadLockBtn:BeadLockButton;
      
      private var _beadOneKeyBtn:SimpleBitmapButton;
      
      protected var _goldText:FilterFrameText;
      
      protected var _moneyText:FilterFrameText;
      
      protected var _giftText:FilterFrameText;
      
      protected var _goldButton:RichesButton;
      
      protected var _giftButton:RichesButton;
      
      protected var _moneyButton:RichesButton;
      
      protected var _bg:MutipleImage;
      
      protected var _bg1:MovieImage;
      
      protected var _tabBtn1:Sprite;
      
      protected var _tabBtn2:Sprite;
      
      protected var _tabBtn3:Sprite;
      
      protected var _tabBtn4:Sprite;
      
      protected var _cardEnbleFlase:Bitmap;
      
      protected var _itemtabBtn:ScaleFrameImage;
      
      protected var _goodsNumInfoBg:Bitmap;
      
      protected var _goodsNumInfoText:FilterFrameText;
      
      protected var _goodsNumTotalText:FilterFrameText;
      
      protected var _moneyBg:ScaleBitmapImage;
      
      protected var _moneyBg1:ScaleBitmapImage;
      
      protected var _moneyBg2:ScaleBitmapImage;
      
      protected var _moneyBg3:ScaleBitmapImage;
      
      protected var _PointCouponBitmap:Bitmap;
      
      protected var _LiJinBitmap:Bitmap;
      
      protected var _MoneyBitmap:Bitmap;
      
      private var _changeColorController:ChangeColorController;
      
      private var _reworknameView:ReworkNameFrame;
      
      private var _consortaiReworkName:ReworkNameConsortia;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _openBagLock:Boolean = false;
      
      private var _isScreenFood:Boolean = false;
      
      private var _bagList:OutMainListPanel;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pgdn:BaseButton;
      
      private var _pgup:BaseButton;
      
      private var _pageTxtBg:Bitmap;
      
      private var _beadSortBtn:SimpleBitmapButton;
      
      protected var _equipEnbleFlase:Bitmap;
      
      protected var _propEnbleFlase:Bitmap;
      
      protected var _beadEnbleFlase:Bitmap;
      
      private var _disEnabledFilters:Array;
      
      private var _oneKeyFeedMC:MovieClip;
      
      protected var _buttonContainer:Sprite;
      
      protected var _bagArrangeSprite:BagArrangeTipSprite;
      
      protected var _equipSelectedBtn:SelectedButton;
      
      protected var _propSelectedBtn:SelectedButton;
      
      protected var _beadSelectedBtn:SelectedButton;
      
      protected var _dressSelectedBtn:SelectedButton;
      
      public var _bagLockBtn:SimpleBitmapButton;
      
      private var _isTimePack:Boolean;
      
      private var _allExp:int;
      
      private var _feedVec:Vector.<Vector.<BeadCell>>;
      
      private var _bindVec:Vector.<Boolean>;
      
      private var _feedID:int = 0;
      
      private var _frame:BaseAlerFrame;
      
      private var clickSign:int = 0;
      
      private var temInfo:InventoryItemInfo;
      
      private var _currentCell:BagCell;
      
      private var _tmpCell:BagCell;
      
      private var getNewCardMovie:MovieClip;
      
      private var _soundControl:SoundTransform;
      
      public function BagView()
      {
         super();
         this._buttonContainer = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bagView.buttonContainer");
         this.init();
         this.initEvent();
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      protected function init() : void
      {
         this.initBackGround();
         this.initBagList();
         this.initMoneyTexts();
         this.initButtons();
         this.initTabButtons();
         this.initGoodsNumInfo();
         this.set_breakBtn_enable();
         this.set_text_location();
         this.set_btn_location();
         this.setBagType(EQUIP);
      }
      
      protected function initBackGround() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset4");
         addChild(this._bg);
         this._itemtabBtn = ComponentFactory.Instance.creat("bagView.itemTabButton");
         this._equipSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.equipTabBtn");
         this._equipSelectedBtn.mouseEnabled = false;
         this._equipSelectedBtn.mouseChildren = false;
         this._equipSelectedBtn.selected = true;
         addChild(this._equipSelectedBtn);
         this._propSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.propTabBtn");
         this._propSelectedBtn.mouseEnabled = false;
         this._propSelectedBtn.mouseChildren = false;
         addChild(this._propSelectedBtn);
         this._beadSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.beadTabBtn");
         this._beadSelectedBtn.mouseEnabled = false;
         this._beadSelectedBtn.mouseChildren = false;
         this._beadSelectedBtn.visible = false;
         addChild(this._beadSelectedBtn);
         this._dressSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.dressTabBtn");
         this._dressSelectedBtn.mouseEnabled = false;
         this._dressSelectedBtn.mouseChildren = false;
         addChild(this._dressSelectedBtn);
         this._itemtabBtn.setFrame(1);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bgIII");
         this._buttonContainer.addChild(this._bg1);
         this._moneyBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBG");
         this._buttonContainer.addChild(this._moneyBg);
         this._moneyBg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGI");
         this._buttonContainer.addChild(this._moneyBg1);
         this._moneyBg2 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.moneyViewBGII");
         this._buttonContainer.addChild(this._moneyBg2);
         this._bgShape = new Shape();
         this._bgShape.graphics.beginFill(15262671,1);
         this._bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         this._bgShape.graphics.endFill();
         this._bgShape.x = 11;
         this._bgShape.y = 50;
         this._bgShapeII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcardCell.BG");
         addChild(this._bgShapeII);
         this._bgShapeII.visible = false;
         this._bagLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.lockBtn");
         addChild(this._bagLockBtn);
      }
      
      protected function initBagList() : void
      {
         this._equiplist = new BagEquipListView(0);
         this._proplist = new BagListView(1);
         this._petlist = new PetBagListView(1);
         PositionUtils.setPos(this._petlist,"bagAndInfo.bagView.petBag.pos18");
         this._beadList = new BeadBagList(21,32,80);
         this._beadList2 = new BeadBagList(21,81,129);
         this._beadList3 = new BeadBagList(21,130,178);
         this._equiplist.x = this._proplist.x = this._beadList.x = this._beadList2.x = this._beadList3.x = 14;
         this._equiplist.y = this._proplist.y = this._beadList.y = this._beadList2.y = this._beadList3.y = 48;
         this._equiplist.width = this._proplist.width = this._beadList.width = this._beadList2.width = this._beadList3.width = this._petlist.width = 330;
         this._equiplist.height = this._proplist.height = this._beadList.height = this._beadList2.height = this._beadList3.height = this._petlist.height = 320;
         this._proplist.visible = false;
         this._petlist.visible = false;
         this._beadList.visible = false;
         this._beadList2.visible = false;
         this._beadList3.visible = false;
         this._lists = [this._equiplist,this._proplist,this._petlist,this._beadList,this._beadList2,this._beadList3];
         this._currentList = this._equiplist;
         addChild(this._equiplist);
         addChild(this._proplist);
         addChild(this._petlist);
         addChild(this._beadList);
         addChild(this._beadList2);
         addChild(this._beadList3);
      }
      
      private function initMoneyTexts() : void
      {
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("BagMoneyInfoText");
         this._goldText = ComponentFactory.Instance.creatComponentByStylename("BagGoldInfoText");
         this._giftText = ComponentFactory.Instance.creatComponentByStylename("BagGiftInfoText");
         this._buttonContainer.addChild(this._goldText);
         this._buttonContainer.addChild(this._moneyText);
         this._buttonContainer.addChild(this._giftText);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         this._buttonContainer.addChild(this._goldButton);
         var _loc1_:int = 60000;
         var _loc2_:int = int(ServerConfigManager.instance.VIPExtraBindMoneyUpper[PlayerManager.Instance.Self.VIPLevel - 1]);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",(_loc1_ + _loc2_).toString());
         }
         else
         {
            this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",_loc1_.toString());
         }
         this._buttonContainer.addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         this._buttonContainer.addChild(this._moneyButton);
      }
      
      protected function initButtons() : void
      {
         this._sellBtn = ComponentFactory.Instance.creatComponentByStylename("bagSellButton1");
         this._sellBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSell");
         this._buttonContainer.addChild(this._sellBtn);
         this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton1");
         this._continueBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagContinue");
         this._buttonContainer.addChild(this._continueBtn);
         this._breakBtn = ComponentFactory.Instance.creatComponentByStylename("bagBreakButton1");
         this._breakBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
         this._buttonContainer.addChild(this._breakBtn);
         this._keySortBtn = ComponentFactory.Instance.creatComponentByStylename("bagKeySetButton1");
         this._keySortBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSortTxt");
         this._buttonContainer.addChild(this._keySortBtn);
         this._keySortBtn.enable = this._isSkillCanUse();
         this._PointCouponBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.PointCoupon");
         this._buttonContainer.addChild(this._PointCouponBitmap);
         this._LiJinBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.ddtMoney1");
         this._buttonContainer.addChild(this._LiJinBitmap);
         this._MoneyBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.money");
         this._buttonContainer.addChild(this._MoneyBitmap);
      }
      
      public function set sortBagEnable(param1:Boolean) : void
      {
         this._keySortBtn.enable = param1;
      }
      
      public function set breakBtnEnable(param1:Boolean) : void
      {
         this._breakBtn.enable = param1;
      }
      
      public function set cardbtnVible(param1:Boolean) : void
      {
         this._cardEnbleFlase.visible = param1;
      }
      
      public function set cardbtnFilter(param1:Array) : void
      {
         this._cardEnbleFlase.filters = param1;
      }
      
      public function set itemtabBtn(param1:int) : void
      {
         this._itemtabBtn.setFrame(param1);
      }
      
      public function set sortBagFilter(param1:Array) : void
      {
         this._keySortBtn.filters = param1;
      }
      
      public function set breakBtnFilter(param1:Array) : void
      {
         this._breakBtn.filters = param1;
      }
      
      public function set tableEnable(param1:Boolean) : void
      {
         this._tabBtn3.mouseEnabled = param1;
      }
      
      public function switchButtomVisible(param1:Boolean) : void
      {
         this._bg1.visible = param1;
         this._sellBtn.visible = param1;
         this._breakBtn.visible = param1;
         this._continueBtn.visible = param1;
         this._keySortBtn.visible = param1;
         this._goldText.visible = param1;
         this._giftButton.visible = param1;
         this._giftText.visible = param1;
         this._moneyButton.visible = param1;
         if(Boolean(this._pgup))
         {
            this._pgup.visible = !param1;
         }
         if(Boolean(this._pgdn))
         {
            this._pgdn.visible = !param1;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.visible = !param1;
         }
         if(Boolean(this._pageTxtBg))
         {
            this._pageTxtBg.visible = !param1;
         }
         if(Boolean(this._beadFeedBtn))
         {
            this._beadFeedBtn.visible = !param1;
         }
         if(Boolean(this._beadLockBtn))
         {
            this._beadLockBtn.visible = !param1;
         }
         if(Boolean(this._beadOneKeyBtn))
         {
            this._beadOneKeyBtn.visible = !param1;
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.visible = !param1;
         }
         this.enableBeadFunctionBtns(!param1);
         if(Boolean(this._moneyBg1))
         {
            this._moneyBg1.visible = param1;
         }
         if(Boolean(this._moneyBg2))
         {
            this._moneyBg2.visible = param1;
         }
         if(Boolean(this._LiJinBitmap))
         {
            this._LiJinBitmap.visible = param1;
         }
         if(Boolean(this._MoneyBitmap))
         {
            this._MoneyBitmap.visible = param1;
         }
      }
      
      public function enableBeadFunctionBtns(param1:Boolean) : void
      {
         if(Boolean(this._beadFeedBtn))
         {
            this._beadFeedBtn.enable = param1;
         }
         if(Boolean(this._beadLockBtn))
         {
            this._beadLockBtn.enable = param1;
         }
         if(Boolean(this._beadOneKeyBtn))
         {
            this._beadOneKeyBtn.enable = param1;
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.enable = param1;
         }
      }
      
      public function initBeadButton() : void
      {
         this._pgup = ComponentFactory.Instance.creatComponentByStylename("beadSystem.prePageBtn");
         addChild(this._pgup);
         this._pgdn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.nextPageBtn");
         addChild(this._pgdn);
         this._pageTxtBg = ComponentFactory.Instance.creatBitmap("beadSystem.pageTxt.bg");
         addChild(this._pageTxtBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.pageTxt");
         addChild(this._pageTxt);
         this._pageTxt.text = "1/3";
         this._pgup.addEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.addEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this._beadSortBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.sortBtn");
         this._beadSortBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick,false,0,true);
         addChild(this._beadSortBtn);
         this._beadFeedBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedbtn1");
         this._beadFeedBtn.width = 106;
         this._beadFeedBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadFeedBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadTip");
         addChild(this._beadFeedBtn);
         this._beadLockBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.lockbtn1");
         this._beadLockBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadLockBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadLockTip");
         addChild(this._beadLockBtn);
         this._beadOneKeyBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedAllBtn");
         this._beadOneKeyBtn.tipStyle = "ddtstore.StoreEmbedBG.MultipleLineTip";
         this._beadOneKeyBtn.tipData = LanguageMgr.GetTranslation("ddt.bagandinfo.beadOneKeyTip");
         addChild(this._beadOneKeyBtn);
         this._beadOneKeyBtn.addEventListener(MouseEvent.CLICK,this.__oneKeyFeedClick);
      }
      
      public function adjustBeadBagPage(param1:Boolean) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc2_:int = int.MAX_VALUE;
         for each(_loc3_ in this._info.BeadBag.items)
         {
            if(_loc3_.Place < _loc2_ && _loc3_.Place > 31 && (!param1 || !_loc3_.IsBinds))
            {
               _loc2_ = _loc3_.Place;
            }
         }
         _loc4_ = (_loc2_ - 32) / 49 + 1;
         if(_loc4_ <= 0 || _loc4_ > 3)
         {
            _loc4_ = 1;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.text = _loc4_ + "/3";
         }
         this._beadList.visible = _loc4_ == 1;
         this._beadList2.visible = _loc4_ == 2;
         this._beadList3.visible = _loc4_ == 3;
         this._currentBeadList = [this._beadList,this._beadList2,this._beadList3][_loc4_ - 1];
      }
      
      public function __oneKeyFeedClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:BeadCell = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         SoundManager.instance.play("008");
         if(BeadModel.beadCanUpgrade)
         {
            if(int(PlayerManager.Instance.Self.embedUpLevelCell.itemInfo.Hole1) == 19)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
               return;
            }
            _loc2_ = 0;
            _loc3_ = false;
            this._feedID = 0;
            if(!this._feedVec)
            {
               this._feedVec = new Vector.<Vector.<BeadCell>>(8);
               this._bindVec = new Vector.<Boolean>(8);
            }
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               if(!this._feedVec[_loc4_])
               {
                  this._feedVec[_loc4_] = new Vector.<BeadCell>();
                  this._bindVec[_loc4_] = false;
               }
               else
               {
                  this._feedVec[_loc4_].length = 0;
               }
               _loc4_++;
            }
            for each(_loc5_ in this._currentBeadList.BeadCells)
            {
               if(Boolean(_loc5_.info) && !_loc5_.itemInfo.IsUsed)
               {
                  if(_loc5_.itemInfo.Hole1 < 13)
                  {
                     this._feedVec[0].push(_loc5_);
                     _loc2_ += _loc5_.itemInfo.Hole2;
                     _loc5_.locked = true;
                     if(!this._bindVec[0] && _loc5_.itemInfo.IsBinds)
                     {
                        this._bindVec[0] = true;
                     }
                  }
                  else if(_loc5_.itemInfo.Hole1 == 13)
                  {
                     this._feedVec[1].push(_loc5_);
                  }
                  else if(_loc5_.itemInfo.Hole1 == 14)
                  {
                     this._feedVec[2].push(_loc5_);
                  }
                  else if(_loc5_.itemInfo.Hole1 == 15)
                  {
                     this._feedVec[3].push(_loc5_);
                  }
                  else if(_loc5_.itemInfo.Hole1 == 16)
                  {
                     this._feedVec[4].push(_loc5_);
                  }
                  else if(_loc5_.itemInfo.Hole1 == 17)
                  {
                     this._feedVec[5].push(_loc5_);
                  }
                  else if(_loc5_.itemInfo.Hole1 == 18)
                  {
                     this._feedVec[6].push(_loc5_);
                  }
               }
            }
            if(_loc2_ == 0)
            {
               _loc6_ = true;
               _loc7_ = 1;
               while(_loc7_ < 8)
               {
                  if(this._feedVec[_loc7_].length > 0)
                  {
                     _loc6_ = false;
                     break;
                  }
                  _loc7_++;
               }
               if(_loc6_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.noBeadToFeed"));
               }
               else
               {
                  this._feedID = _loc7_;
                  this.checkBoxPrompts(this._feedID);
               }
               return;
            }
            this._allExp = _loc2_;
            this.boxPrompts(this._bindVec[0]);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoFeedBead"));
         }
      }
      
      private function checkNextBox() : void
      {
         ++this._feedID;
         if(this._feedID < 5)
         {
            this.checkBoxPrompts(this._feedID);
         }
      }
      
      private function checkBoxPrompts(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BeadFeedInfoFrame = null;
         this._allExp = 0;
         var _loc2_:int = int(this._feedVec[param1].length);
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._allExp += this._feedVec[param1][_loc3_].itemInfo.Hole2;
               this._feedVec[param1][_loc3_].locked = true;
               if(!this._bindVec[param1] && this._feedVec[param1][_loc3_].itemInfo.IsBinds)
               {
                  this._bindVec[param1] = true;
               }
               _loc3_++;
            }
            _loc4_ = ComponentFactory.Instance.creat("BeadFeedInfoFrame");
            _loc4_.setBeadName(this._feedVec[param1][0].tipData["beadName"]);
            LayerManager.Instance.addToLayer(_loc4_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc4_.textInput.setFocus();
            _loc4_.isBind = this._bindVec[param1];
            _loc4_.addEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
         }
         else
         {
            ++this._feedID;
            if(this._feedID < 5)
            {
               this.checkBoxPrompts(this._feedID);
            }
            else
            {
               this._feedID = 0;
            }
         }
      }
      
      private function boxPrompts(param1:Boolean) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         var _loc4_:FilterFrameText = null;
         if(param1 && !BeadModel.isBeadCellIsBind)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         }
         else
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._allExp) + "," + LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm") + "\n\n" + LanguageMgr.GetTranslation("ddt.beadSystem.oneKeyFeedTipdata"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadWarningText");
            _loc4_.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.oneKeyFeedTipdata");
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
      }
      
      protected function __onConfigResponse(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:BeadFeedInfoFrame = param1.currentTarget as BeadFeedInfoFrame;
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(_loc2_.textInput.text == "YES" || _loc2_.textInput.text == "yes")
               {
                  this.boxPrompts(_loc2_.isBind);
                  _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
                  ObjectUtils.disposeObject(_loc2_);
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadPromptInfo"));
               break;
            default:
               _loc3_ = int(this._feedVec[this._feedID].length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  this._feedVec[this._feedID][_loc4_].locked = false;
                  _loc4_++;
               }
               _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
               ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      protected function __onBindRespones(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BaseAlerFrame = null;
         var _loc5_:FilterFrameText = null;
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               _loc2_ = int(this._feedVec[this._feedID].length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this._feedVec[this._feedID][_loc3_].locked = false;
                  _loc3_++;
               }
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._allExp) + "," + LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm") + "\n\n" + LanguageMgr.GetTranslation("ddt.beadSystem.oneKeyFeedTipdata"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc5_ = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadWarningText");
               _loc5_.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.oneKeyFeedTipdata");
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function __onFeedResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               _loc2_ = int(this._feedVec[this._feedID].length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this._feedVec[this._feedID][_loc3_].locked = false;
                  _loc3_++;
               }
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._feedVec[this._feedID].length > 0)
               {
                  if(!this._oneKeyFeedMC)
                  {
                     this._oneKeyFeedMC = ClassUtils.CreatInstance("beadSystem.oneKeyFeed.MC");
                     this._oneKeyFeedMC.gotoAndPlay(1);
                     this._oneKeyFeedMC.scaleX = this._oneKeyFeedMC.scaleY = 0.9;
                     this._oneKeyFeedMC.x = 707;
                     this._oneKeyFeedMC.y = 295;
                     this._oneKeyFeedMC.addEventListener("oneKeyComplete",this.__disposeOneKeyMC);
                     LayerManager.Instance.addToLayer(this._oneKeyFeedMC,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,true);
                  }
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoBead"));
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __disposeOneKeyMC(param1:Event) : void
      {
         var _loc3_:BeadCell = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._feedVec[this._feedID])
         {
            if(Boolean(_loc3_.info) && !_loc3_.itemInfo.IsUsed)
            {
               _loc2_.push(_loc3_.beadPlace);
            }
         }
         SocketManager.Instance.out.sendBeadUpgrade(_loc2_);
         _loc4_ = int(this._feedVec[this._feedID].length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this._feedVec[this._feedID][_loc5_].locked = false;
            _loc5_++;
         }
         this._oneKeyFeedMC.removeEventListener("oneKeyComplete",this.__disposeOneKeyMC);
         this._oneKeyFeedMC.stop();
         ObjectUtils.disposeObject(this._oneKeyFeedMC);
         this._oneKeyFeedMC = null;
         if(this._allExp + BeadModel.upgradeCellInfo.Hole2 >= ServerConfigManager.instance.getBeadUpgradeExp()[BeadModel.upgradeCellInfo.Hole1 + 1])
         {
            beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.PLAYUPGRADEMC));
         }
         this.checkNextBox();
         if(SharedManager.Instance.beadLeadTaskStep == 4 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_COMBINCLICK);
               BeadLeadManager.Instance.leadEquipBead(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               SharedManager.Instance.beadLeadTaskStep = 5;
               BeadLeadManager.Instance.taskComplete = true;
               TaskManager.instance.checkQuest(1579,1,0);
               SharedManager.Instance.save();
            }
         }
      }
      
      protected function initTabButtons() : void
      {
         this._tabBtn1 = new Sprite();
         this._tabBtn1.graphics.beginFill(255,1);
         this._tabBtn1.graphics.drawRoundRect(348,39,51,131,15,15);
         this._tabBtn1.graphics.endFill();
         this._tabBtn1.alpha = 0;
         this._tabBtn1.buttonMode = true;
         addChild(this._tabBtn1);
         this._tabBtn2 = new Sprite();
         this._tabBtn2.graphics.beginFill(255,1);
         this._tabBtn2.graphics.drawRoundRect(349,183,51,131,15,15);
         this._tabBtn2.graphics.endFill();
         this._tabBtn2.alpha = 0;
         this._tabBtn2.buttonMode = true;
         addChild(this._tabBtn2);
         this._tabBtn3 = new Sprite();
         this._tabBtn3.graphics.beginFill(255,1);
         this._tabBtn3.graphics.drawRoundRect(349,327,51,131,15,15);
         this._tabBtn3.graphics.endFill();
         this._tabBtn3.alpha = 0;
         this._tabBtn3.buttonMode = true;
         this._tabBtn3.visible = false;
         addChild(this._tabBtn3);
         this._tabBtn4 = new Sprite();
         this._tabBtn4.graphics.beginFill(255,1);
         this._tabBtn4.graphics.drawRoundRect(349,327,51,131,15,15);
         this._tabBtn4.graphics.endFill();
         this._tabBtn4.alpha = 0;
         this._tabBtn4.buttonMode = true;
         addChild(this._tabBtn4);
         this._cardEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.cardbtn.enblefalse");
         this._cardEnbleFlase.visible = false;
         addChild(this._buttonContainer);
      }
      
      private function initGoodsNumInfo() : void
      {
         this._goodsNumInfoText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumText");
         this._goodsNumTotalText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumTotalText");
         this._goodsNumTotalText.text = "/ " + String(BagInfo.MAXPROPCOUNT + 1);
      }
      
      private function updateView() : void
      {
         this.updateMoney();
         this.updateBagList();
      }
      
      protected function updateBagList() : void
      {
         if(Boolean(this._info))
         {
            this._equiplist.currentBagType = this._bagType;
            this._equiplist.setData(this._info.Bag);
            if(this._isScreenFood)
            {
               this._petlist.setData(this._info.PropBag);
            }
            else
            {
               this._proplist.setData(this._info.PropBag);
            }
            if(this._bagType != PET)
            {
               if(Boolean(this._beadList))
               {
                  this._beadList.setData(this._info.BeadBag);
               }
               if(Boolean(this._beadList2))
               {
                  this._beadList2.setData(this._info.BeadBag);
               }
               if(Boolean(this._beadList3))
               {
                  this._beadList3.setData(this._info.BeadBag);
               }
            }
         }
         else
         {
            this._equiplist.setData(null);
            this._proplist.setData(null);
            this._petlist.setData(null);
         }
      }
      
      private function __showBead(param1:BagEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadToBeadBag"));
      }
      
      public function createCard() : void
      {
         if(!isShowCardBag)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CARD_SYSTEM);
            SocketManager.Instance.out.getPlayerCardInfo(PlayerManager.Instance.Self.ID);
         }
         else
         {
            if(this._bagList == null)
            {
               this._bagList = ComponentFactory.Instance.creatComponentByStylename("cardSyste.cardBagList");
               addChild(this._bagList);
               this._bagList.vectorListModel.appendAll(CardControl.Instance.model.getBagListData());
               DragManager.ListenWheelEvent(this._bagList.onMouseWheel);
               DragManager.changeCardState(CardControl.Instance.setSignLockedCardNone);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
            }
            this.setBagType(CARD);
            dispatchEvent(new CardEvent(CardEvent.SETSELECTCARD_COMPLETE));
         }
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            isShowCardBag = true;
            this.createCard();
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __upData(param1:DictionaryEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(_loc2_.Place / 4 - 2) : int(_loc2_.Place / 4 - 1);
         var _loc4_:int = _loc2_.Place % 4 == 0 ? 4 : int(_loc2_.Place % 4);
         if(this._bagList.vectorListModel.elements[_loc3_] == null)
         {
            _loc5_ = new Array();
            _loc5_[0] = _loc3_ + 1;
            _loc5_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.append(_loc5_);
         }
         else
         {
            _loc6_ = this._bagList.vectorListModel.elements[_loc3_] as Array;
            _loc6_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.replaceAt(_loc3_,_loc6_);
         }
      }
      
      private function __remove(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(_loc2_.Place / 4 - 2) : int(_loc2_.Place / 4 - 1);
         var _loc4_:int = _loc2_.Place % 4 == 0 ? 4 : int(_loc2_.Place % 4);
         var _loc5_:Array = this._bagList.vectorListModel.elements[_loc3_] as Array;
         _loc5_[_loc4_] = null;
         this._bagList.vectorListModel.replaceAt(_loc3_,_loc5_);
      }
      
      protected function initEvent() : void
      {
         this._sellBtn.addEventListener(MouseEvent.CLICK,this.__sellClick);
         this._breakBtn.addEventListener(MouseEvent.CLICK,this.__breakClick);
         this._equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist.addEventListener(Event.CHANGE,this.__listChange);
         this._proplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         if(Boolean(this._petlist))
         {
            this._petlist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._beadList2.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._beadList3.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         this._tabBtn1.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.addEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.addEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.addEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         CellMenu.instance.addEventListener(CellMenu.COLOR_CHANGE,this.__cellColorChange);
         CellMenu.instance.addEventListener(CellMenu.SELL,this.__cellSell);
         this._keySortBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick);
         this._keySortBtn.addEventListener(MouseEvent.ROLL_OVER,this.__bagArrangeOver);
         this._keySortBtn.addEventListener(MouseEvent.ROLL_OUT,this.__bagArrangeOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
         beadSystemManager.Instance.addEventListener(BeadEvent.AUTOOPENBEAD,this.__onAutoOpenBeadChanged);
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.addEventListener(MouseEvent.CLICK,this.bagLockHandler,false,0,true);
         }
         this.adjustEvent();
      }
      
      protected function bagLockHandler(param1:MouseEvent) : void
      {
         this.__openSettingLock(null);
      }
      
      protected function __bagArrangeOut(param1:MouseEvent) : void
      {
         if(this._bagType == BEAD)
         {
            return;
         }
         if(Boolean(this._bagArrangeSprite) && !this.containPoint(param1.localX,param1.localY))
         {
            removeChild(this._bagArrangeSprite);
         }
      }
      
      private function containPoint(param1:int, param2:int) : Boolean
      {
         if(param1 > 0 && param1 < this._bagArrangeSprite.width && param2 <= 3 && param2 > -this._bagArrangeSprite.height)
         {
            return true;
         }
         return false;
      }
      
      private function __onAutoOpenBeadChanged(param1:BeadEvent) : void
      {
         if(!this._beadOneKeyBtn || !this._beadLockBtn || !this._beadFeedBtn)
         {
            return;
         }
         if(param1.CellId == 0)
         {
            this._beadOneKeyBtn.enable = true;
            this._beadLockBtn.enable = true;
            this._beadFeedBtn.enable = true;
         }
         else if(param1.CellId == 1)
         {
            this._beadOneKeyBtn.enable = false;
            this._beadLockBtn.enable = false;
            this._beadFeedBtn.enable = false;
         }
      }
      
      private function isInBag(param1:InventoryItemInfo, param2:BeadBagList) : Boolean
      {
         if(param1.Place >= param2._startIndex && param1.Place <= param2._stopIndex)
         {
            return true;
         }
         return false;
      }
      
      protected function __onBeadBagChanged(param1:DictionaryEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._bagType != BEAD)
         {
            return;
         }
         var _loc2_:Array = [this._beadList,this._beadList2,this._beadList3];
         var _loc3_:int = 1;
         var _loc4_:InventoryItemInfo = InventoryItemInfo(param1.data);
         if(_loc4_.Place < 32)
         {
            return;
         }
         if(Boolean(this._info.BeadBag.getItemAt(_loc4_.Place)))
         {
            _loc5_ = 1;
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               if(this.isInBag(_loc4_,_loc2_[_loc6_]))
               {
                  _loc5_ = _loc6_ + 1;
                  break;
               }
               _loc6_++;
            }
            _loc3_ = _loc5_ > _loc3_ ? _loc5_ : _loc3_;
         }
         if(_loc3_ > 3 || _loc3_ < 1)
         {
            _loc3_ = 1;
         }
         if(this._currIndex == _loc3_)
         {
            return;
         }
         this._currIndex = _loc3_;
         this._beadList.visible = _loc3_ == 1;
         this._beadList2.visible = _loc3_ == 2;
         this._beadList3.visible = _loc3_ == 3;
         this._pageTxt.text = _loc3_ + "/3";
         this._currentBeadList = _loc2_[_loc3_ - 1];
      }
      
      private function __pgupHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currIndex == 1)
         {
            this._currIndex = 3;
            this._beadList.visible = false;
            this._beadList2.visible = false;
            this._beadList3.visible = true;
            this._pageTxt.text = "3/3";
            this._currentBeadList = this._beadList3;
         }
         else if(this._currIndex == 2)
         {
            this._currIndex = 1;
            this._beadList.visible = true;
            this._beadList2.visible = false;
            this._beadList3.visible = false;
            this._pageTxt.text = "1/3";
            this._currentBeadList = this._beadList;
         }
         else if(this._currIndex == 3)
         {
            this._currIndex = 2;
            this._beadList.visible = false;
            this._beadList2.visible = true;
            this._beadList3.visible = false;
            this._pageTxt.text = "2/3";
            this._currentBeadList = this._beadList2;
         }
      }
      
      private function setCurrPage(param1:int) : void
      {
      }
      
      public function __pgdnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currIndex == 1)
         {
            this._currIndex = 2;
            this._beadList.visible = false;
            this._beadList2.visible = true;
            this._beadList3.visible = false;
            this._pageTxt.text = "2/3";
            this._currentBeadList = this._beadList2;
         }
         else if(this._currIndex == 2)
         {
            this._currIndex = 3;
            this._beadList.visible = false;
            this._beadList2.visible = false;
            this._beadList3.visible = true;
            this._pageTxt.text = "3/3";
            this._currentBeadList = this._beadList3;
         }
         else if(this._currIndex == 3)
         {
            this._currIndex = 1;
            this._beadList.visible = true;
            this._beadList2.visible = false;
            this._beadList3.visible = false;
            this._pageTxt.text = "1/3";
            this._currentBeadList = this._beadList;
         }
      }
      
      protected function adjustEvent() : void
      {
      }
      
      protected function __openPreviewListFrame(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = int(_loc2_.readByte());
         var _loc5_:Array = [];
         while(Boolean(_loc2_.bytesAvailable))
         {
            _loc9_ = new InventoryItemInfo();
            _loc9_.TemplateID = _loc2_.readInt();
            _loc9_ = ItemManager.fill(_loc9_);
            _loc9_.Count = _loc2_.readInt();
            _loc9_.IsBinds = _loc2_.readBoolean();
            _loc9_.ValidDate = _loc2_.readInt();
            _loc9_.StrengthenLevel = _loc2_.readInt();
            _loc9_.AttackCompose = _loc2_.readInt();
            _loc9_.DefendCompose = _loc2_.readInt();
            _loc9_.AgilityCompose = _loc2_.readInt();
            _loc9_.LuckCompose = _loc2_.readInt();
            if(EquipType.isMagicStone(_loc9_.CategoryID))
            {
               _loc9_.Attack = _loc9_.AttackCompose;
               _loc9_.Defence = _loc9_.DefendCompose;
               _loc9_.Agility = _loc9_.AgilityCompose;
               _loc9_.Luck = _loc9_.LuckCompose;
               _loc9_.Level = _loc9_.StrengthenLevel;
               _loc9_.MagicAttack = _loc2_.readInt();
               _loc9_.MagicDefence = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc2_.readInt();
            }
            _loc5_.push(_loc9_);
         }
         var _loc6_:AwardsView = new AwardsView();
         _loc6_.goodsList = _loc5_;
         _loc6_.boxType = 4;
         var _loc7_:FilterFrameText = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
         if(this._isTimePack)
         {
            _loc7_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle2");
            _loc7_.x = 54;
         }
         else
         {
            _loc7_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
            _loc7_.x = 74;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var _loc8_:AlertInfo = new AlertInfo(_loc3_);
         _loc8_.showCancel = false;
         _loc8_.moveEnable = false;
         this._frame.info = _loc8_;
         this._frame.addToContent(_loc6_);
         this._frame.addToContent(_loc7_);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
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
      
      protected function __useColorShell(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            SoundManager.instance.play("063");
         }
      }
      
      protected function removeEvents() : void
      {
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._equiplist))
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(Boolean(this._proplist))
         {
            this._proplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._proplist))
         {
            this._proplist.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._petlist))
         {
            this._petlist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList2))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._beadList3))
         {
            this._beadList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         if(Boolean(this._beadList))
         {
            this._beadList.removeEventListener(Event.CHANGE,this.__listChange);
         }
         if(Boolean(this._tabBtn1))
         {
            this._tabBtn1.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn2))
         {
            this._tabBtn2.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn3))
         {
            this._tabBtn3.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         }
         if(Boolean(this._pgup))
         {
            this._pgup.removeEventListener(MouseEvent.CLICK,this.__pgupHandler);
         }
         if(Boolean(this._pgdn))
         {
            this._pgdn.removeEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         }
         if(Boolean(this._beadSortBtn))
         {
            this._beadSortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
         }
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.removeEventListener(CellMenu.OPEN,this.__cellOpen);
         CellMenu.instance.removeEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.removeEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         CellMenu.instance.removeEventListener(CellMenu.COLOR_CHANGE,this.__cellColorChange);
         CellMenu.instance.removeEventListener(CellMenu.SELL,this.__cellSell);
         if(Boolean(this._keySortBtn))
         {
            this._keySortBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
            this._keySortBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__bagArrangeOver);
            this._keySortBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__bagArrangeOut);
         }
         PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.removeEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
         }
         BagLockedController.Instance.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
         beadSystemManager.Instance.removeEventListener(BeadEvent.AUTOOPENBEAD,this.__onAutoOpenBeadChanged);
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.removeEventListener(MouseEvent.CLICK,this.bagLockHandler);
         }
      }
      
      protected function __itemtabBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._tabBtn1:
               if(this._bagType == EQUIP)
               {
                  return;
               }
               this._itemtabBtn.setFrame(1);
               this.setBagType(EQUIP);
               this.refreshSelectedButton(1);
               break;
            case this._tabBtn2:
               if(this._bagType == PROP || this._bagType == PET)
               {
                  return;
               }
               this._itemtabBtn.setFrame(2);
               this.setBagType(this._isScreenFood ? PET : PROP);
               this.refreshSelectedButton(2);
               break;
            case this._tabBtn3:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.openBeadBtn.text"));
                  return;
               }
               if(this._bagType == BEAD)
               {
                  return;
               }
               this.setBagType(BEAD);
               this._itemtabBtn.setFrame(3);
               this.refreshSelectedButton(3);
               if(SharedManager.Instance.beadLeadTaskStep == 2 && !BeadLeadManager.Instance.taskComplete)
               {
                  if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
                  {
                     NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_OPENBEADSURFACE);
                     this.leadBeadSPaling();
                     BeadLeadManager.Instance.leadPutBeadToUpdateslot(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),BeadLeadManager.Instance.arrowPos,BeadLeadManager.Instance.txtPos);
                     SharedManager.Instance.beadLeadTaskStep = 3;
                     SharedManager.Instance.save();
                  }
                  break;
               }
               if(SharedManager.Instance.beadLeadTaskStep == 3 && !BeadLeadManager.Instance.taskComplete)
               {
                  if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
                  {
                     NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_OPENBEADSURFACE);
                     this.leadBeadSPaling();
                     BeadLeadManager.Instance.leadPutBeadToUpdateslot(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),BeadLeadManager.Instance.arrowPos,BeadLeadManager.Instance.txtPos);
                  }
                  break;
               }
               if(SharedManager.Instance.beadLeadTaskStep == 4 && !BeadLeadManager.Instance.taskComplete)
               {
                  if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
                  {
                     NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_BEADUPDATESLOT);
                     BeadLeadManager.Instance.upLevelCellSpaling = false;
                     BeadLeadManager.Instance.leadClickCombinBnt(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                  }
               }
               break;
            case this._tabBtn4:
               this.setBagType(DRESS);
               this.refreshSelectedButton(4);
         }
      }
      
      public function leadBeadSPaling() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc2_:int = int.MAX_VALUE;
         for each(_loc3_ in this._info.BeadBag.items)
         {
            if(_loc3_.TemplateID == BeadLeadManager.BEAD_ID && _loc3_.Hole1 == 3)
            {
               _loc2_ = _loc3_.Place;
               _loc1_ = _loc3_;
               break;
            }
         }
         if(_loc1_ == null)
         {
            return;
         }
         var _loc4_:int = (_loc2_ - 32) / 49 + 1;
         if(_loc4_ <= 0 || _loc4_ > 3)
         {
            _loc4_ = 1;
         }
         this._currentBeadList = [this._beadList,this._beadList2,this._beadList3][_loc4_ - 1];
         var _loc5_:BeadCell = this._currentBeadList.BeadCells[_loc1_.Place] as BeadCell;
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:int = (_loc1_.Place - 32) / 7 + 1;
         var _loc7_:int = (_loc1_.Place - 32) % 7 + 1;
         var _loc8_:Point = new Point();
         _loc8_.x = 508 + 46 * _loc7_;
         _loc8_.y = 60 + 46 * _loc6_;
         var _loc9_:Point = new Point(_loc8_.x - 137,_loc8_.y - 92);
         BeadLeadManager.Instance.arrowPos = _loc8_;
         BeadLeadManager.Instance.txtPos = _loc9_;
         BeadLeadManager.Instance.upLevelCellSpaling = true;
         BeadLeadManager.Instance.dispatchEvent(new BeadLeadEvent(BeadLeadEvent.SPALINGUPLEVELCELL));
      }
      
      public function enableOrdisableSB(param1:Boolean) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.enable = param1;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.enable = param1;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.enable = param1;
         }
         if(Boolean(this._tabBtn1))
         {
            this._tabBtn1.visible = param1;
         }
         if(Boolean(this._tabBtn2))
         {
            this._tabBtn2.visible = param1;
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.visible = param1;
         }
      }
      
      public function enableOrdisableSB2(param1:Boolean) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.enable = param1;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.enable = param1;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.enable = false;
         }
         if(Boolean(this._tabBtn1))
         {
            this._tabBtn1.visible = param1;
         }
         if(Boolean(this._tabBtn2))
         {
            this._tabBtn2.visible = param1;
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.visible = false;
         }
      }
      
      public function enableDressSelectedBtn(param1:Boolean) : void
      {
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.enable = param1;
         }
         if(Boolean(this._tabBtn4))
         {
            this._tabBtn4.visible = param1;
         }
      }
      
      public function showOrHideSB(param1:Boolean) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.visible = param1;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.visible = param1;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.visible = param1;
         }
      }
      
      private function refreshSelectedButton(param1:int) : void
      {
         if(Boolean(this._equipSelectedBtn))
         {
            this._equipSelectedBtn.selected = param1 == 1;
         }
         if(Boolean(this._propSelectedBtn))
         {
            this._propSelectedBtn.selected = param1 == 2;
         }
         if(Boolean(this._beadSelectedBtn))
         {
            this._beadSelectedBtn.selected = param1 == 3;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.selected = param1 == 4;
         }
      }
      
      public function setBagType(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 != BEAD)
         {
            this._currIndex = 1;
            if(Boolean(this._beadList))
            {
               this._currentBeadList = this._beadList;
            }
            if(Boolean(this._pageTxt))
            {
               this._pageTxt.text = "1/3";
            }
         }
         if(Boolean(this._equipEnbleFlase))
         {
            this.btnReable();
         }
         if(this._bagType == param1)
         {
            return;
         }
         this._bagType = param1;
         dispatchEvent(new Event(TABCHANGE));
         if(param1 == PET)
         {
            this._itemtabBtn.setFrame(PROP + 1);
            this.refreshSelectedButton(2);
         }
         if(param1 == EQUIP)
         {
            this._itemtabBtn.setFrame(1);
            this.refreshSelectedButton(1);
         }
         else if(param1 == PROP)
         {
            this._itemtabBtn.setFrame(PROP + 1);
            this.refreshSelectedButton(2);
         }
         else if(param1 == CARD)
         {
            param1 = 0;
            this._itemtabBtn.setFrame(param1 + 1);
            this.refreshSelectedButton(1);
         }
         else if(param1 == BEAD)
         {
            this._itemtabBtn.setFrame(3);
            this.refreshSelectedButton(3);
            this.switchButtomVisible(false);
         }
         else if(param1 == DRESS)
         {
            PlayerDressManager.instance.loadPlayerDressModule(this.showDressBagView);
            this.refreshSelectedButton(4);
         }
         dispatchEvent(new Event(TABCHANGE));
         this._buttonContainer.visible = this._bagType != DRESS;
         this._bgShape.visible = this._bagType == EQUIP || this._bagType == PROP || this._bagType == PET;
         this._equiplist.visible = this._bagType == EQUIP;
         this._proplist.visible = this._bagType == PROP;
         if(Boolean(this._dressbagView))
         {
            this._dressbagView.visible = this._bagType == DRESS;
         }
         if(Boolean(this._petlist))
         {
            this._petlist.visible = this._bagType == PET;
         }
         if(Boolean(this._beadList))
         {
            this._beadList.visible = this._bagType == BEAD;
            if(this._beadList.visible)
            {
               this._beadList2.visible = this._bagType == BEAD;
               this._beadList3.visible = this._bagType == BEAD;
               this._currentBeadList = this._beadList;
               this._beadList2.visible = false;
               this._beadList3.visible = false;
            }
            else
            {
               this._beadList2.visible = this._bagType == BEAD;
               this._beadList3.visible = this._bagType == BEAD;
               this._currentBeadList = null;
            }
         }
         if(Boolean(this._bagList))
         {
            this._bagList.visible = this._bgShapeII.visible = this._bagType == CARD;
         }
         this.set_breakBtn_enable();
         this._sellBtn.enable = this._continueBtn.enable = this._bagType != CARD;
         if(this._bagType == EQUIP || this._bagType == PROP || this._bagType == PET)
         {
            this._sellBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            this._continueBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         if(Boolean(this._itemtabBtn))
         {
            this._itemtabBtn.visible = true;
         }
         if(this._bagType == CARD)
         {
            this._sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this.btnUnable();
            this._itemtabBtn.visible = false;
            this.showOrHideSB(false);
            if(Boolean(this._bagLockBtn))
            {
               this._bagLockBtn.x = 304;
               this._bagLockBtn.y = -19;
            }
         }
         else
         {
            this.showOrHideSB(true);
            _loc2_ = getQualifiedClassName(this);
            if(Boolean(this._bagLockBtn) && _loc2_ != "email.view::EmailBagView")
            {
               this._bagLockBtn.x = 337;
               this._bagLockBtn.y = -24;
            }
         }
         if(this._bagType == EQUIP)
         {
         }
         if(this._bagType == BEAD)
         {
            PositionUtils.setPos(this._moneyText,"bead.moneyTextPosUnderBeadBag");
            this._moneyBg.width = this._goldButton.width = PositionUtils.creatPoint("moneyTextBgWidth").x;
            PositionUtils.setPos(this._PointCouponBitmap,"PointCouponBitmapPosUnderBeadBag");
            PositionUtils.setPos(this._goldButton,"goldButtonBitmapPosUnderBeadBag");
            PositionUtils.setPos(this._moneyBg,"goldButtonBitmapPosUnderBeadBag");
            this.adjustBeadBagPage(false);
         }
         else
         {
            PositionUtils.setPos(this._moneyText,"moneyTextPosUnderCommonBag");
            this._moneyBg.width = this._goldButton.width = PositionUtils.creatPoint("moneyTextBgWidth").x;
            this._moneyBg.x = 18;
            this._PointCouponBitmap.x = 18;
         }
      }
      
      protected function showDressBagView() : void
      {
         if(!this._dressbagView)
         {
            this._dressbagView = ComponentFactory.Instance.creatCustomObject("playerDress.dressBagView");
            addChild(this._dressbagView);
            this._dressbagView.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
            this._dressbagView.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._dressbagView.visible = true;
            this._dressbagView.updateBagList();
         }
      }
      
      private function btnUnable() : void
      {
         this._tabBtn1.buttonMode = false;
         this._tabBtn1.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.buttonMode = false;
         this._tabBtn2.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.buttonMode = false;
         this._tabBtn3.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.buttonMode = false;
         this._tabBtn4.removeEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._disEnabledFilters = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
         this._equipEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.equipbtn.enblefalse");
         this._equipEnbleFlase.visible = false;
         addChild(this._equipEnbleFlase);
         this._equipEnbleFlase.filters = this._disEnabledFilters;
         this._propEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.propbtn.enblefalse");
         this._propEnbleFlase.visible = false;
         addChild(this._propEnbleFlase);
         this._propEnbleFlase.filters = this._disEnabledFilters;
         this._beadEnbleFlase = ComponentFactory.Instance.creatBitmap("asset.cardbtn.enblefalse");
         this._beadEnbleFlase.visible = false;
         addChild(this._beadEnbleFlase);
         this._beadEnbleFlase.filters = this._disEnabledFilters;
         PositionUtils.setPos(this._equipEnbleFlase,"equipEnbleFlasePos");
         PositionUtils.setPos(this._propEnbleFlase,"propEnbleFlasePos");
         PositionUtils.setPos(this._beadEnbleFlase,"beadEnbleFlasePos");
      }
      
      private function btnReable() : void
      {
         this._tabBtn1.buttonMode = true;
         this._tabBtn1.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn2.buttonMode = true;
         this._tabBtn2.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn3.buttonMode = true;
         this._tabBtn3.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._tabBtn4.buttonMode = true;
         this._tabBtn4.addEventListener(MouseEvent.CLICK,this.__itemtabBtnClick);
         this._disEnabledFilters = null;
         removeChild(this._equipEnbleFlase);
         this._equipEnbleFlase = null;
         removeChild(this._propEnbleFlase);
         this._propEnbleFlase = null;
         removeChild(this._beadEnbleFlase);
         this._beadEnbleFlase = null;
      }
      
      public function isNeedCard(param1:Boolean) : void
      {
      }
      
      protected function set_breakBtn_enable() : void
      {
      }
      
      protected function set_text_location() : void
      {
      }
      
      protected function set_btn_location() : void
      {
      }
      
      private function __onBagUpdateEQUIPBAG(param1:BagEvent) : void
      {
         if(!(Boolean(this._dressbagView) && this._dressbagView.visible == true))
         {
            this.setBagCountShow(BagInfo.EQUIPBAG);
         }
      }
      
      private function __onBagUpdatePROPBAG(param1:BagEvent) : void
      {
         if(this.bagType != 21 && !this._isScreenFood && this.bagType != 2)
         {
            this.setBagCountShow(BagInfo.PROPBAG);
         }
      }
      
      private function __openSettingLock(param1:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         this._openBagLock = true;
         BagLockedController.Instance.show();
         BagLockedController.Instance.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __onLockComplete(param1:Event) : void
      {
         BagLockedController.Instance.removeEventListener(Event.COMPLETE,this.__onLockComplete);
         this._openBagLock = false;
      }
      
      protected function __bagArrangeOver(param1:MouseEvent) : void
      {
         if(this._bagType == BEAD)
         {
            return;
         }
         if(!this._bagArrangeSprite)
         {
            this._bagArrangeSprite = ComponentFactory.Instance.creatCustomObject("bagArrangeTipSprite");
         }
         this._bagArrangeSprite.y = this._keySortBtn.y + this._buttonContainer.y - 24;
         addChild(this._bagArrangeSprite);
      }
      
      protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._bagType != BEAD)
         {
            PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,this._bagArrangeSprite.arrangeAdd);
         }
         else
         {
            PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),32,178,true);
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc2_.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._bagType != BEAD)
               {
                  PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,true);
                  break;
               }
               PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),32,178,true);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._bagType != BEAD)
               {
                  PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,false);
               }
         }
      }
      
      private function __keySetFrameClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         if(this._keySetFrame == null)
         {
            this._keySetFrame = ComponentFactory.Instance.creatComponentByStylename("keySetFrame");
            this._keySetFrame.addEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         }
         this._keySetFrame.show();
      }
      
      private function __onKeySetResponse(param1:FrameEvent) : void
      {
         this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
         this._keySetFrame.dispose();
         this._keySetFrame = null;
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties[PlayerInfo.BandMONEY]) || Boolean(param1.changedProperties[PlayerInfo.MONEY]) || Boolean(param1.changedProperties[PlayerInfo.GOLD]) || Boolean(param1.changedProperties[PlayerInfo.DDT_MONEY]))
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         if(Boolean(this._info))
         {
            this._goldText.text = String(this._info.Gold);
            this._moneyText.text = String(this._info.Money);
            this._giftText.text = String(this._info.BandMoney);
         }
         else
         {
            this._goldText.text = this._moneyText.text = this._giftText.text = "";
         }
      }
      
      protected function __listChange(param1:Event) : void
      {
         if(!(Boolean(this._dressbagView) && this._dressbagView.visible == true))
         {
            this.setBagType(BagInfo.EQUIPBAG);
         }
      }
      
      private function __feedClick(param1:MouseEvent) : void
      {
         if(!(this.bead_state & this.STATE_BEADFEED))
         {
            this.bead_state |= this.STATE_BEADFEED;
            SoundManager.instance.play("008");
            this._beadFeedBtn.dragStart(param1.stageX,param1.stageY);
            this._beadFeedBtn.addEventListener(BeadFeedButton.stopFeed,this.__stopFeed);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
            param1.stopImmediatePropagation();
         }
         else
         {
            this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
            this._beadFeedBtn.stopDrag();
         }
      }
      
      private function __stopFeed(param1:Event) : void
      {
         this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
         this._beadFeedBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("stopfeed"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
         }
      }
      
      private function __onStageClick_FeedBtn(param1:Event) : void
      {
         this.bead_state = ~this.STATE_BEADFEED & this.bead_state;
         dispatchEvent(new Event("stopfeed"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_FeedBtn);
         }
      }
      
      private function __sellClick(param1:MouseEvent) : void
      {
         if(!(this.state & this.STATE_SELL))
         {
            this.state |= this.STATE_SELL;
            SoundManager.instance.play("008");
            this._sellBtn.dragStart(param1.stageX,param1.stageY);
            this._sellBtn.addEventListener(SellGoodsBtn.StopSell,this.__stopSell);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
            param1.stopImmediatePropagation();
         }
         else
         {
            this.state = ~this.STATE_SELL & this.state;
            this._sellBtn.stopDrag();
         }
      }
      
      private function __stopSell(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("sellstop"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __onStageClick_SellBtn(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         dispatchEvent(new Event("sellstop"));
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __breakClick(param1:MouseEvent) : void
      {
         if(this._breakBtn.enable)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
            }
            else
            {
               this._breakBtn.dragStart(param1.stageX,param1.stageY);
            }
         }
      }
      
      public function resetMouse() : void
      {
         this.state = ~this.STATE_SELL & this.state;
         LayerManager.Instance.clearnStageDynamic();
         Mouse.show();
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.stopDrag();
         }
      }
      
      private function isOnlyGivingGoods(param1:InventoryItemInfo) : Boolean
      {
         return param1.IsBinds == false && EquipType.isPackage(param1) && param1.Property2 == "10";
      }
      
      protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
         if(!this._sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            if(param1.data is BagCell)
            {
               _loc2_ = param1.data as BagCell;
            }
            else
            {
               _loc2_ = param1.data as BeadCell;
            }
            if(_loc2_)
            {
               _loc3_ = _loc2_.itemInfo as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(!this.isOnlyGivingGoods(_loc3_) && (_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || _loc3_.TemplateID == 11955 || EquipType.canBeUsed(_loc3_) || DressUtils.isDress(_loc3_)))
               {
                  _loc4_ = _loc2_.parent.localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 20,_loc4_.y + 20);
               }
               else
               {
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      public function set cellDoubleClickEnable(param1:Boolean) : void
      {
         if(param1)
         {
            this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         var _loc6_:BaseAlerFrame = null;
         var _loc7_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = param1.data as BagCell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         var _loc5_:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(_loc3_.getRemainDate() <= 0)
         {
            return;
         }
         if(_loc4_.NeedSex != _loc5_ && _loc4_.NeedSex != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.object"));
            return;
         }
         if(!_loc2_.locked)
         {
            if((_loc2_.info.BindType == 1 || _loc2_.info.BindType == 2 || _loc2_.info.BindType == 3) && _loc2_.itemInfo.IsBinds == false)
            {
               _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc6_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               this.temInfo = _loc3_;
            }
            else
            {
               SoundManager.instance.play("008");
               if(PlayerManager.Instance.Self.canEquip(_loc3_))
               {
                  if(_loc3_.CategoryID == 50 || _loc3_.CategoryID == 51 || _loc3_.CategoryID == 52)
                  {
                     if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
                     {
                        if(!PetBagController.instance().petModel.currentPetInfo)
                        {
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petEquipNo"));
                           return;
                        }
                        SocketManager.Instance.out.addPetEquip(_loc2_.place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
                     }
                     return;
                  }
                  _loc7_ = PlayerManager.Instance.getDressEquipPlace(_loc3_);
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc7_,_loc3_.Count);
               }
            }
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var _loc1_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            if(this.temInfo.CategoryID == 50 || this.temInfo.CategoryID == 51 || this.temInfo.CategoryID == 52)
            {
               if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
               {
                  if(!PetBagController.instance().petModel.currentPetInfo)
                  {
                     return;
                  }
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               return;
            }
            _loc1_ = PlayerManager.Instance.getDressEquipPlace(this.temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc1_,this.temInfo.Count);
         }
      }
      
      private function __cellAddPrice(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(Boolean(_loc2_))
         {
            if(ShopManager.Instance.canAddPrice(_loc2_.itemInfo.TemplateID))
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               AddPricePanel.Instance.setInfo(_loc2_.itemInfo,false);
               AddPricePanel.Instance.show();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            }
         }
      }
      
      protected function __cellMove(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(Boolean(_loc2_))
         {
            _loc2_.dragStart();
         }
      }
      
      protected function __cellOpenBatch(param1:Event) : void
      {
         var _loc3_:OpenBatchView = null;
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("bag.OpenBatchView");
            _loc3_.item = _loc2_.itemInfo;
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function __cellOpen(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BaseAlerFrame = null;
         var _loc9_:BaseAlerFrame = null;
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         this._currentCell = _loc2_;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._isTimePack = _loc2_.itemInfo.Property2 == "9";
            _loc3_ = PlayerManager.Instance.Self.Sex ? 1 : 2;
            if(_loc2_.info.NeedSex != 0 && _loc3_ != _loc2_.info.NeedSex)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
               return;
            }
            if(PlayerManager.Instance.Self.Grade >= _loc2_.info.NeedLevel)
            {
               if(_loc2_.info.TemplateID == EquipType.VIP_COIN)
               {
                  if(PlayerManager.Instance.Self.IsVIP)
                  {
                     RouletteManager.instance.useVipBox(_loc2_);
                  }
                  else
                  {
                     param1.stopImmediatePropagation();
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipIcon.notVip"));
                  }
               }
               else if(_loc2_.info.TemplateID == EquipType.ROULETTE_BOX)
               {
                  RouletteManager.instance.useRouletteBox(_loc2_);
               }
               else if(_loc2_.info.TemplateID == EquipType.SURPRISE_ROULETTE_BOX)
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useSurpriseRoulette(_loc2_);
               }
               else if(EquipType.isCaddy(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useCaddy(_loc2_);
               }
               else if(_loc2_.info.TemplateID == EquipType.BOMB_KING_BLESS || _loc2_.info.TemplateID == EquipType.SILVER_BLESS || _loc2_.info.TemplateID == EquipType.GOLD_BLESS)
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useBless(_loc2_);
               }
               else if(EquipType.isBeadNeedOpen(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useBead(_loc2_.info.TemplateID);
               }
               else if(_loc2_.info.TemplateID == EquipType.CELEBRATION_BOX)
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useCelebrationBox();
               }
               else if(_loc2_.info.TemplateID == EquipType.BATTLE_COMPANION && !_loc2_.itemInfo.IsBinds)
               {
                  param1.stopImmediatePropagation();
                  WonderfulActivityManager.Instance.useBattleCompanion(_loc2_.itemInfo);
               }
               else if(EquipType.isOfferPackage(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useOfferPack(_loc2_);
               }
               else if(EquipType.isTimeBox(_loc2_.info))
               {
                  _loc4_ = DateUtils.getDateByStr(InventoryItemInfo(_loc2_.info).BeginDate);
                  _loc5_ = int(_loc2_.info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc4_.getTime()) / 1000;
                  if(_loc5_ <= 0)
                  {
                     SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_["place"]);
                  }
                  else
                  {
                     _loc6_ = _loc5_ / 3600;
                     _loc7_ = _loc5_ % 3600 / 60;
                     _loc7_ = _loc7_ > 0 ? _loc7_ : 1;
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc6_,_loc7_));
                  }
               }
               else if(_loc2_.info.CategoryID == EquipType.CARDBOX)
               {
                  param1.stopImmediatePropagation();
                  SocketManager.Instance.out.sendOpenCardBox(_loc2_["place"],1);
               }
               else if(_loc2_.info.TemplateID == EquipType.MYSTICAL_CARDBOX)
               {
                  SocketManager.Instance.out.sendOpenRandomBox(_loc2_["place"],1);
               }
               else if(_loc2_.info.TemplateID == EquipType.MY_CARDBOX)
               {
                  SocketManager.Instance.out.sendOpenRandomBox(_loc2_["place"],1);
               }
               else if(EquipType.isSpecilPackage(_loc2_.info))
               {
                  if(PlayerManager.Instance.Self.BandMoney >= Number(_loc2_.info.Property3))
                  {
                     _loc8_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag",_loc2_.info.Property3,_loc2_.info.Name),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                     _loc8_.addEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII",_loc2_.info.Property3));
                  }
               }
               else if(EquipType.PET_EGG == _loc2_.info.CategoryID)
               {
                  SocketManager.Instance.out.sendAddPet(_loc2_.itemInfo.Place,_loc2_.itemInfo.BagType);
               }
               else if(_loc2_.info.Property2 == "8")
               {
                  _loc9_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("bagView.consumePack.openTxt",_loc2_.info.Property3),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
                  _loc9_.addEventListener(FrameEvent.RESPONSE,this.onConsumePackResponse);
               }
               else if(_loc2_.itemInfo.Property5 == "-1")
               {
                  SocketManager.Instance.out.treasurePuzzle_usePice(this._currentCell.place);
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_.itemInfo.Place);
               }
            }
            else if(_loc2_.info.CategoryID == EquipType.CARDBOX)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.bagView.openCardBox.level"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
            }
         }
      }
      
      protected function onConsumePackResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onConsumePackResponse);
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            _loc2_.dispose();
            return;
         }
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(_loc2_.isBand)
            {
               if(PlayerManager.Instance.Self.BandMoney < int(this._currentCell.info.Property3))
               {
                  this.initAlertFarme();
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,_loc2_.isBand);
               }
            }
            else if(PlayerManager.Instance.Self.Money < int(this._currentCell.info.Property3))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,_loc2_.isBand);
            }
         }
         _loc2_.dispose();
      }
      
      private function initAlertFarme() : void
      {
         var _loc1_:BaseAlerFrame = null;
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
      }
      
      protected function onResponseHander(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < int(this._currentCell.info.Property3))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell.itemInfo.Place,1,false);
            }
         }
         param1.currentTarget.dispose();
      }
      
      private function __GiftBagframeClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._currentCell) && Boolean(this._currentCell.itemInfo))
               {
                  SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType,this._currentCell["place"]);
               }
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__GiftBagframeClose);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __cellUse(param1:Event) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc4_:StoreMainView = null;
         var _loc5_:StoreMainView = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         if(!_loc2_ || _loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.WISHBEAD_ATTACK || _loc2_.info.TemplateID == EquipType.WISHBEAD_DEFENSE || _loc2_.info.TemplateID == EquipType.WISHBEAD_AGILE)
         {
            if(this is ConsortionBankBagView)
            {
               BagStore.instance.isFromConsortionBankFrame = true;
            }
            else
            {
               BagStore.instance.isFromBagFrame = true;
            }
            BagStore.instance.show(BagStore.FORGE_STORE,1);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.REWORK_NAME)
         {
            this.startReworkName(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "5" && _loc2_.info.Property2 != "0")
         {
            this.showChatBugleInputFrame(_loc2_.info.TemplateID);
            return;
         }
         if(_loc2_.info.CategoryID == EquipType.TEXP_TASK)
         {
            if(PlayerManager.Instance.Self.Grade < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.noGrade"));
               return;
            }
            if(TexpManager.Instance.getLv(TexpManager.Instance.getExp(int(_loc2_.info.Property1))) >= PlayerManager.Instance.Self.Grade + 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.lvToplimit"));
               return;
            }
            if(TaskManager.instance.texpQuests.length > 0)
            {
               this._tmpCell = _loc2_;
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("texpSystem.view.TexpView.refreshTaskTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__texpResponse);
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,_loc2_.info.TemplateID,1,_loc2_.place);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
         {
            if(PlayerManager.Instance.Self.ConsortiaID == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
               return;
            }
            if(PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
               return;
            }
            this.startupConsortiaReworkName(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CHANGE_SEX)
         {
            this.startupChangeSex(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 37)
         {
            if(!Boolean(PlayerManager.Instance.Self.Bag.getItemAt(6)))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
               return;
            }
            if(PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
            {
               SocketManager.Instance.out.sendUseChangeColorShell(_loc2_.bagType,_loc2_.place);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
         }
         if(_loc2_.info.TemplateID == EquipType.COLORCARD)
         {
            ChangeColorController.instance.changeColorModel.place = _loc2_.place;
            ChangeColorController.instance.changeColorModel.getColorEditableThings();
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
         else if(_loc2_.info.TemplateID != EquipType.TRANSFER_PROP)
         {
            if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 24)
            {
               if(TrusteeshipManager.instance.spiritValue >= TrusteeshipManager.instance.maxSpiritValue)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.maxSpiritCannotUseTxt"));
                  return;
               }
               SocketManager.Instance.out.sendTrusteeshipUseSpiritItem(_loc2_.place,_loc2_.bagType);
            }
            else if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 39)
            {
               SocketManager.Instance.out.sendUseItemKingBless(_loc2_.place,_loc2_.bagType);
            }
            else if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 101)
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,0);
            }
            else if(EquipType.isStrengthStone(_loc2_.info))
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
            }
            else if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 45)
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc4_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc4_.skipFromWantStrong(StoreMainView.EXALT);
            }
            else if(EquipType.isComposeStone(_loc2_.info))
            {
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc5_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc5_.skipFromWantStrong(StoreMainView.COMPOSE);
            }
            else if(_loc2_.info.TemplateID == EquipType.GEMSTONE)
            {
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
                  return;
               }
               if(this is ConsortionBankBagView)
               {
                  BagStore.instance.isFromConsortionBankFrame = true;
               }
               else
               {
                  BagStore.instance.isFromBagFrame = true;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,3);
            }
            else
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               if(_loc2_.info.CategoryID == 11 && (int(_loc2_.info.Property1) == 100 || int(_loc2_.info.Property1) == 110))
               {
                  this.useProp(_loc2_.itemInfo);
               }
               else
               {
                  this.useCard(_loc2_.itemInfo);
               }
            }
         }
      }
      
      protected function __cellColorChange(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(Boolean(_loc2_))
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(_loc2_.itemInfo.CategoryID == EquipType.SUITS || _loc2_.itemInfo.CategoryID == EquipType.WING)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.suitAndWingCannotChange"));
               return;
            }
            if(this.checkDress(_loc2_))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.canNotChangeColor"));
               return;
            }
            ChangeColorController.instance.changeColorModel.place = -1;
            ChangeColorController.instance.addOneThing(_loc2_);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
      }
      
      private function __alertChangeColor(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < ShopManager.Instance.getGiftShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
               return;
            }
         }
      }
      
      protected function __cellSell(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(this.checkDress(_loc2_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.canNotSell"));
            return;
         }
         if(Boolean(_loc2_))
         {
            _loc2_.sellItem(_loc2_.itemInfo);
         }
      }
      
      private function checkDress(param1:BagCell) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:DressModel = null;
         var _loc5_:int = 0;
         var _loc6_:DressVo = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc2_:Array = PlayerDressManager.instance.modelArr;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ <= _loc3_.length - 1)
            {
               _loc6_ = _loc3_[_loc5_];
               if(_loc6_.itemId == param1.itemInfo.ItemID)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         _loc4_ = PlayerDressManager.instance.dressView.currentModel;
         if(Boolean(_loc4_))
         {
            for each(_loc7_ in _loc4_.model.Bag.items)
            {
               if(Boolean(_loc7_) && _loc7_.ItemID == param1.itemInfo.ItemID)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function __texpResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__texpResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 10)
            {
               LeavePageManager.showFillFrame();
               this._tmpCell = null;
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,this._tmpCell.info.TemplateID,1,this._tmpCell.place);
            this._tmpCell = null;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
      }
      
      private function __changeColorProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __changeColorComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleSmallLoading.Instance.hide();
            ChangeColorController.instance.show();
         }
      }
      
      private function useCard(param1:InventoryItemInfo) : void
      {
         if(param1.TemplateID == EquipType.FREE_PROP_CARD || param1.TemplateID == EquipType.DOUBLE_EXP_CARD || param1.TemplateID == EquipType.DOUBLE_GESTE_CARD || param1.TemplateID == EquipType.PREVENT_KICK || param1.TemplateID.toString().substring(0,3) == "119" || param1.TemplateID == EquipType.VIPCARD || param1.TemplateID == EquipType.CARDSOUL_BOX || param1.TemplateID == EquipType.CHRISTMAS_TIMER)
         {
            if(this._self.Grade < 3 && (param1.TemplateID == EquipType.VIPCARD || param1.TemplateID == EquipType.VIPCARD_TEST))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
            SocketManager.Instance.out.sendUseCard(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
         }
      }
      
      private function useProp(param1:InventoryItemInfo) : void
      {
         if(!param1)
         {
            return;
         }
         SocketManager.Instance.out.sendUseProp(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
      }
      
      private function createBreakWin(param1:BagCell) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BreakGoodsView = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         this._currentList.setCellInfo(param1,param2);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._oneKeyFeedMC))
         {
            this._oneKeyFeedMC.removeEventListener("oneKeyComplete",this.__disposeOneKeyMC);
            this._oneKeyFeedMC.stop();
            ObjectUtils.disposeObject(this._oneKeyFeedMC);
         }
         this.removeEvents();
         this.resetMouse();
         this._info = null;
         this._lists = null;
         this._tmpCell = null;
         this._self.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
         this._self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
         if(Boolean(this._pgup))
         {
            ObjectUtils.disposeObject(this._pgup);
         }
         this._pgup = null;
         if(Boolean(this._pgdn))
         {
            ObjectUtils.disposeObject(this._pgdn);
         }
         this._pgdn = null;
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         this._pageTxt = null;
         if(Boolean(this._pageTxtBg))
         {
            ObjectUtils.disposeObject(this._pageTxtBg);
         }
         this._pageTxtBg = null;
         if(Boolean(this._beadSortBtn))
         {
            ObjectUtils.disposeObject(this._beadSortBtn);
         }
         this._beadSortBtn = null;
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         }
         if(Boolean(this._sellBtn))
         {
            this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         }
         if(Boolean(this._breakBtn))
         {
            this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         }
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
            this._frame.dispose();
            this._frame = null;
            SocketManager.Instance.out.sendClearStoreBag();
         }
         if(Boolean(this._goodsNumInfoBg))
         {
            ObjectUtils.disposeObject(this._goodsNumInfoBg);
         }
         this._goodsNumInfoBg = null;
         if(Boolean(this._goodsNumInfoText))
         {
            ObjectUtils.disposeObject(this._goodsNumInfoText);
         }
         this._goodsNumInfoText = null;
         if(Boolean(this._goodsNumTotalText))
         {
            ObjectUtils.disposeObject(this._goodsNumTotalText);
         }
         this._goodsNumTotalText = null;
         if(Boolean(this._tabBtn1))
         {
            ObjectUtils.disposeObject(this._tabBtn1);
         }
         this._tabBtn1 = null;
         if(Boolean(this._tabBtn2))
         {
            ObjectUtils.disposeObject(this._tabBtn2);
         }
         this._tabBtn2 = null;
         if(Boolean(this._tabBtn3))
         {
            ObjectUtils.disposeObject(this._tabBtn3);
         }
         this._tabBtn3 = null;
         if(Boolean(this._tabBtn4))
         {
            ObjectUtils.disposeObject(this._tabBtn4);
         }
         this._tabBtn4 = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._goldText))
         {
            ObjectUtils.disposeObject(this._goldText);
         }
         this._goldText = null;
         if(Boolean(this._moneyText))
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(Boolean(this._giftText))
         {
            ObjectUtils.disposeObject(this._giftText);
         }
         this._giftText = null;
         if(Boolean(this._keySortBtn))
         {
            ObjectUtils.disposeObject(this._keySortBtn);
         }
         this._keySortBtn = null;
         if(Boolean(this._breakBtn))
         {
            ObjectUtils.disposeObject(this._breakBtn);
         }
         this._breakBtn = null;
         if(Boolean(this._currentList))
         {
            ObjectUtils.disposeObject(this._currentList);
         }
         this._currentList = null;
         if(Boolean(this._sellBtn))
         {
            ObjectUtils.disposeObject(this._sellBtn);
         }
         this._sellBtn = null;
         if(Boolean(this._proplist))
         {
            ObjectUtils.disposeObject(this._proplist);
         }
         this._proplist = null;
         if(Boolean(this._petlist))
         {
            ObjectUtils.disposeObject(this._petlist);
         }
         this._petlist = null;
         if(Boolean(this._equiplist))
         {
            ObjectUtils.disposeObject(this._equiplist);
         }
         this._equiplist = null;
         if(Boolean(this._beadList))
         {
            ObjectUtils.disposeObject(this._beadList);
         }
         this._beadList = null;
         if(Boolean(this._beadList2))
         {
            ObjectUtils.disposeObject(this._beadList2);
         }
         this._beadList2 = null;
         if(Boolean(this._beadList3))
         {
            ObjectUtils.disposeObject(this._beadList3);
         }
         this._beadList3 = null;
         if(Boolean(this._bgShape))
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         if(Boolean(this._goldButton))
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(Boolean(this._giftButton))
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(Boolean(this._moneyButton))
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(Boolean(this._continueBtn))
         {
            ObjectUtils.disposeObject(this._continueBtn);
         }
         this._continueBtn = null;
         if(Boolean(this._chatBugleInputFrame))
         {
            ObjectUtils.disposeObject(this._chatBugleInputFrame);
         }
         this._chatBugleInputFrame = null;
         if(Boolean(this._bgShapeII))
         {
            ObjectUtils.disposeObject(this._bgShapeII);
         }
         this._bgShapeII = null;
         if(Boolean(this._bagList))
         {
            ObjectUtils.disposeObject(this._bagList);
         }
         this._bagList = null;
         if(Boolean(this._PointCouponBitmap))
         {
            ObjectUtils.disposeObject(this._PointCouponBitmap);
         }
         this._PointCouponBitmap = null;
         if(Boolean(this._LiJinBitmap))
         {
            ObjectUtils.disposeObject(this._LiJinBitmap);
         }
         this._LiJinBitmap = null;
         if(Boolean(this._MoneyBitmap))
         {
            ObjectUtils.disposeObject(this._MoneyBitmap);
         }
         this._MoneyBitmap = null;
         if(Boolean(this._currentBeadList))
         {
            ObjectUtils.disposeObject(this._currentBeadList);
         }
         this._currentBeadList = null;
         ObjectUtils.disposeObject(this._bagLockBtn);
         this._bagLockBtn = null;
         ObjectUtils.disposeObject(this._equipSelectedBtn);
         this._equipSelectedBtn = null;
         ObjectUtils.disposeObject(this._propSelectedBtn);
         this._propSelectedBtn = null;
         ObjectUtils.disposeObject(this._beadSelectedBtn);
         this._beadSelectedBtn = null;
         ObjectUtils.disposeObject(this._dressSelectedBtn);
         this._dressSelectedBtn = null;
         ObjectUtils.disposeObject(this._cardEnbleFlase);
         this._cardEnbleFlase = null;
         ObjectUtils.disposeObject(this._itemtabBtn);
         this._itemtabBtn = null;
         ObjectUtils.disposeObject(this._moneyBg);
         this._moneyBg = null;
         ObjectUtils.disposeObject(this._moneyBg1);
         this._moneyBg1 = null;
         ObjectUtils.disposeObject(this._moneyBg2);
         this._moneyBg2 = null;
         ObjectUtils.disposeObject(this._buttonContainer);
         this._buttonContainer = null;
         ObjectUtils.disposeObject(this._bagArrangeSprite);
         this._bagArrangeSprite = null;
         ObjectUtils.disposeObject(this._dressbagView);
         this._dressbagView = null;
         if(Boolean(this._oneKeyFeedMC))
         {
            ObjectUtils.disposeObject(this._oneKeyFeedMC);
         }
         this._oneKeyFeedMC = null;
         if(Boolean(this._keySetFrame))
         {
            this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
            this._keySetFrame.dispose();
            this._keySetFrame = null;
         }
         if(Boolean(this._reworknameView))
         {
            this.shutdownReworkName();
         }
         if(Boolean(this._consortaiReworkName))
         {
            this.shutdownConsortiaReworkName();
         }
         if(CellMenu.instance.showed)
         {
            CellMenu.instance.hide();
         }
         AddPricePanel.Instance.close();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setBagCountShow(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GlowFilter = null;
         var _loc4_:uint = 0;
         switch(param1)
         {
            case BagInfo.EQUIPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(this._equiplist._startIndex,this._equiplist._stopIndex);
               if(_loc2_ >= 49)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
                  break;
               }
               _loc4_ = 1310468;
               _loc3_ = new GlowFilter(876032,0.5,3,3,10);
               break;
            case BagInfo.PROPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(0,BagInfo.MAXPROPCOUNT);
               if(_loc2_ >= BagInfo.MAXPROPCOUNT + 1)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
                  break;
               }
               _loc4_ = 1310468;
               _loc3_ = new GlowFilter(876032,0.5,3,3,10);
         }
         this._goodsNumInfoText.textColor = _loc4_;
         this._goodsNumInfoText.text = _loc2_.toString();
         this.setBagType(param1);
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(param1:SelfInfo) : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.removeEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this._info = param1;
         if(Boolean(this._info))
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            this._info.BeadBag.items.addEventListener(DictionaryEvent.ADD,this.__onBeadBagChanged);
            PlayerManager.Instance.Self.addEventListener(BagEvent.SHOW_BEAD,this.__showBead);
         }
         this.updateView();
      }
      
      private function startReworkName(param1:int, param2:int) : void
      {
         this._reworknameView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameFrame");
         LayerManager.Instance.addToLayer(this._reworknameView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._reworknameView.initialize(param1,param2);
         this._reworknameView.addEventListener(Event.COMPLETE,this.__onRenameComplete);
      }
      
      private function shutdownReworkName() : void
      {
         this._reworknameView.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._reworknameView);
         this._reworknameView = null;
      }
      
      private function __onRenameComplete(param1:Event) : void
      {
         this.shutdownReworkName();
      }
      
      private function startupConsortiaReworkName(param1:int, param2:int) : void
      {
         this._consortaiReworkName = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameConsortia");
         LayerManager.Instance.addToLayer(this._consortaiReworkName,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._consortaiReworkName.initialize(param1,param2);
         this._consortaiReworkName.addEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
      }
      
      private function shutdownConsortiaReworkName() : void
      {
         this._consortaiReworkName.removeEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
         ObjectUtils.disposeObject(this._consortaiReworkName);
         this._consortaiReworkName = null;
      }
      
      private function showChatBugleInputFrame(param1:int) : void
      {
         if(this._chatBugleInputFrame == null)
         {
            this._chatBugleInputFrame = ComponentFactory.Instance.creat("chat.BugleInputFrame");
         }
         this._chatBugleInputFrame.templateID = param1;
         LayerManager.Instance.addToLayer(this._chatBugleInputFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onConsortiaRenameComplete(param1:Event) : void
      {
         this.shutdownConsortiaReworkName();
      }
      
      public function hide() : void
      {
         if(Boolean(this._reworknameView))
         {
            this.shutdownReworkName();
         }
         if(Boolean(this._consortaiReworkName))
         {
            this.shutdownConsortiaReworkName();
         }
         if(Boolean(this._keySetFrame))
         {
            this._keySetFrame.removeEventListener(FrameEvent.RESPONSE,this.__onKeySetResponse);
            this._keySetFrame.dispose();
            this._keySetFrame = null;
         }
      }
      
      private function judgeAndPlayCardMovie() : void
      {
         var _loc3_:CardInfo = null;
         var _loc4_:Sprite = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         var _loc7_:GradientText = null;
         var _loc1_:ItemTemplateInfo = this._currentCell.info;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.TemplateID == int(_loc1_.Property5))
            {
               return;
            }
         }
         SocketManager.Instance.out.sendFirstGetCards();
         dispatchEvent(new Event(FIRST_GET_CARD,true));
         this.getNewCardMovie = ClassUtils.CreatInstance("asset.getNecCard.movie") as MovieClip;
         PositionUtils.setPos(this.getNewCardMovie,"BagView.NewCardMovie.Pos");
         _loc4_ = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,113,156);
         _loc4_.graphics.endFill();
         _loc5_ = ItemManager.Instance.getTemplateById(int(_loc1_.Property5));
         _loc6_ = new BaseCell(_loc4_,_loc5_);
         this.getNewCardMovie["card"].addChild(_loc6_);
         _loc7_ = ComponentFactory.Instance.creatComponentByStylename("getNewCardMovie.text");
         _loc7_.text = LanguageMgr.GetTranslation("ddt.cardSystem.getNewCard.name",_loc5_.Name);
         _loc7_.x -= (_loc7_.textWidth - _loc6_.width) / 6;
         this.getNewCardMovie["word"].addChild(_loc7_);
         LayerManager.Instance.addToLayer(this.getNewCardMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         this.getNewCardMovie.gotoAndPlay(1);
         this.getNewCardMovie.addEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl = new SoundTransform();
         if(SoundManager.instance.allowSound)
         {
            this._soundControl.volume = 1;
         }
         else
         {
            this._soundControl.volume = 0;
         }
         this.getNewCardMovie.soundTransform = this._soundControl;
      }
      
      private function __showOver(param1:Event) : void
      {
         this.getNewCardMovie.removeEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl.volume = 0;
         this.getNewCardMovie.soundTransform = this._soundControl;
         this._soundControl = null;
         ObjectUtils.disposeObject(this.getNewCardMovie);
         this.getNewCardMovie = null;
      }
      
      protected function _isSkillCanUse() : Boolean
      {
         var _loc1_:Boolean = false;
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function startupChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:ChangeSexAlertFrame = ComponentFactory.Instance.creat("bagAndInfo.bag.changeSexAlert");
         _loc3_.bagType = param1;
         _loc3_.place = param2;
         _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert",true);
         _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = _loc3_;
      }
      
      private function getAlertInfo(param1:String, param2:Boolean = false) : AlertInfo
      {
         var _loc3_:AlertInfo = new AlertInfo();
         _loc3_.autoDispose = true;
         _loc3_.showSubmit = true;
         _loc3_.showCancel = param2;
         _loc3_.enterEnable = true;
         _loc3_.escEnable = true;
         _loc3_.moveEnable = false;
         _loc3_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc3_.data = LanguageMgr.GetTranslation(param1);
         return _loc3_;
      }
      
      private function __onAlertSizeChanged(param1:ComponentEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(_loc2_.info.frameCenter)
         {
            _loc2_.x = (StageReferance.stageWidth - _loc2_.width) / 2;
            _loc2_.y = (StageReferance.stageHeight - _loc2_.height) / 2;
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ChangeSexAlertFrame = ChangeSexAlertFrame(param1.currentTarget);
         _loc2_.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendChangeSex(_loc2_.bagType,_loc2_.place);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function __changeSexHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:SimpleAlert = null;
         SocketManager.Instance.socket.close();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _loc3_ = ComponentFactory.Instance.creat("sellGoodsAlert");
            _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert.success",false);
            _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onSuccessAlertResponse);
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = _loc3_;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.changeSexAlert.failed"));
         }
      }
      
      private function __onSuccessAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         ExternalInterface.call("WindowReturn");
      }
      
      public function set isScreenFood(param1:Boolean) : void
      {
         this._isScreenFood = param1;
      }
      
      public function get beadFeedBtn() : BeadFeedButton
      {
         return this._beadFeedBtn;
      }
      
      public function deleteButtonForPet() : void
      {
         if(Boolean(this._bagLockBtn))
         {
            this._bagLockBtn.dispose();
            this._bagLockBtn = null;
         }
         if(Boolean(this._dressSelectedBtn))
         {
            this._dressSelectedBtn.dispose();
            this._dressSelectedBtn = null;
         }
      }
   }
}

