package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BrowseLeftMenuView extends Sprite implements Disposeable
   {
      
      private static const ALL:int = -1;
      
      private static const WEAPON:int = 25;
      
      private static const SUB_WEAPON:int = 7;
      
      private static const OFFHAND:int = 17;
      
      private static const CLOTH:int = 21;
      
      private static const HAT:int = 1;
      
      private static const GLASS:int = 2;
      
      private static const SUB_CLOTH:int = 5;
      
      private static const JEWELRY:int = 24;
      
      private static const BEAUTY:int = 22;
      
      private static const HAIR:int = 3;
      
      private static const ORNAMENT:int = 4;
      
      private static const EYES:int = 6;
      
      private static const SUITS:int = 13;
      
      private static const WINGS:int = 15;
      
      private static const STRENTH:int = 1100;
      
      private static const STRENTH_1:int = 11025;
      
      private static const STRENTH_2:int = 1102;
      
      private static const STRENTH_3:int = 1103;
      
      private static const STRENTH_4:int = 1104;
      
      private static const STRENTH_5:int = 1110;
      
      private static const COMPOSE:int = 1105;
      
      private static const ZHUQUE:int = 1106;
      
      private static const XUANWU:int = 1107;
      
      private static const QINGLONG:int = 1108;
      
      private static const BAIHU:int = 1109;
      
      private static const SPHERE:int = 26;
      
      private static const TRIANGLE:int = 27;
      
      private static const ROUND:int = 28;
      
      private static const SQUERE:int = 29;
      
      private static const WISHBEAD:int = 35;
      
      private static const Drill:int = 1115;
      
      private static const DrillLv1:int = 1116;
      
      private static const DrillLv2:int = 1117;
      
      private static const DrillLv3:int = 1118;
      
      private static const DrillLv4:int = 1119;
      
      private static const DrillLv5:int = 1120;
      
      private static const PATCH:int = 30;
      
      private static const WUQISP:int = 1111;
      
      private static const FUWUQISP:int = 1112;
      
      private static const CARDS:int = 31;
      
      private static const FREAKCARD:int = 1113;
      
      private static const EQUIPCARD:int = 1114;
      
      private static const PROP:int = 23;
      
      private static const UNFIGHT_PROP:int = 11;
      
      private static const PAOPAO:int = 16;
      
      private static const PET:int = 36;
      
      private static const UNBINDPET:int = 37;
      
      private static const PETEQUIP:int = 38;
      
      private static const PETSTONE:int = 39;
      
      private var menu:VerticalMenu;
      
      private var list:ScrollPanel;
      
      private var _name:SimpleDropListTarget;
      
      private var searchStatus:Boolean;
      
      private var _searchBtn:TextButton;
      
      private var _WuqiFont:ScaleFrameImage;
      
      private var _searchValue:String;
      
      private var _glowState:Boolean;
      
      private var _isForAll:Boolean = true;
      
      private var _isFindAll:Boolean = false;
      
      public function BrowseLeftMenuView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.LeftBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.baiduBG");
         addChild(_loc2_);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.baidu_btn");
         this._searchBtn.text = LanguageMgr.GetTranslation("shop.ShopRankingView.SearchBtnText");
         addChild(this._searchBtn);
         this._name = ComponentFactory.Instance.creat("auctionHouse.baiduText");
         this._searchValue = "";
         this._name.maxChars = 20;
         addChild(this._name);
         this.list = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftScrollpanel");
         addChild(this.list);
         this.list.hScrollProxy = ScrollPanel.OFF;
         this.list.vScrollProxy = ScrollPanel.ON;
         this.menu = new VerticalMenu(11,45,33);
         this.list.setView(this.menu);
      }
      
      private function menuRefrash(param1:Event) : void
      {
         this._isFindAll = ((param1.currentTarget as VerticalMenu).currentItem as BrowseLeftMenuItem).isOpen;
         this.list.invalidateViewport();
      }
      
      private function addEvent() : void
      {
         this._name.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.addEventListener(Event.CHANGE,this._nameChange);
         this._name.addEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.addEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.addEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.addEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function removeEvent() : void
      {
         this._name.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.removeEventListener(Event.CHANGE,this._nameChange);
         this._name.removeEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.removeEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.removeEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function _clickName(param1:MouseEvent) : void
      {
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
      }
      
      private function setFocus(param1:Event) : void
      {
         this._name.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere");
         this._searchValue = "";
         this._name.setFocus();
         this._name.setCursor(this._name.text.length);
      }
      
      public function setFocusName() : void
      {
         this._name.setFocus();
      }
      
      internal function getInfo() : CateCoryInfo
      {
         if(this._isForAll)
         {
            return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
         }
         if(Boolean(this.menu.currentItem))
         {
            return this.menu.currentItem.info as CateCoryInfo;
         }
         return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
      }
      
      internal function setSelectType(param1:CateCoryInfo) : void
      {
      }
      
      internal function getType() : int
      {
         if(this._isForAll)
         {
            return -1;
         }
         if(Boolean(this.menu.currentItem))
         {
            return this.menu.currentItem.info.ID;
         }
         return -1;
      }
      
      internal function setCategory(param1:Vector.<CateCoryInfo>) : void
      {
         var _loc24_:CateCoryInfo = null;
         var _loc25_:CateCoryInfo = null;
         var _loc26_:BrowseLeftMenuItem = null;
         var _loc27_:CateCoryInfo = null;
         var _loc28_:BrowseLeftMenuItem = null;
         var _loc29_:CateCoryInfo = null;
         var _loc30_:BrowseLeftMenuItem = null;
         var _loc31_:BrowseLeftMenuItem = null;
         var _loc32_:BrowseLeftMenuItem = null;
         var _loc33_:BrowseLeftMenuItem = null;
         var _loc34_:BrowseLeftMenuItem = null;
         var _loc35_:BrowseLeftMenuItem = null;
         var _loc36_:BrowseLeftMenuItem = null;
         var _loc37_:BrowseLeftMenuItem = null;
         var _loc38_:BrowseLeftMenuItem = null;
         var _loc39_:BrowseLeftMenuItem = null;
         var _loc40_:BrowseLeftMenuItem = null;
         var _loc41_:BrowseLeftMenuItem = null;
         var _loc42_:BrowseLeftMenuItem = null;
         var _loc43_:BrowseLeftMenuItem = null;
         var _loc44_:BrowseLeftMenuItem = null;
         var _loc45_:BrowseLeftMenuItem = null;
         var _loc46_:BrowseLeftMenuItem = null;
         var _loc47_:BrowseLeftMenuItem = null;
         var _loc48_:CateCoryInfo = null;
         var _loc49_:BrowseLeftMenuItem = null;
         var _loc50_:CateCoryInfo = null;
         var _loc51_:BrowseLeftMenuItem = null;
         var _loc52_:CateCoryInfo = null;
         var _loc53_:BrowseLeftMenuItem = null;
         var _loc54_:CateCoryInfo = null;
         var _loc55_:BrowseLeftMenuItem = null;
         var _loc56_:BrowseLeftMenuItem = null;
         var _loc2_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.fuzhuang")),this.getMainCateInfo(CLOTH,LanguageMgr.GetTranslation("")));
         var _loc3_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.meirong")),this.getMainCateInfo(BEAUTY,LanguageMgr.GetTranslation("")));
         var _loc4_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.prop")),this.getMainCateInfo(PROP,LanguageMgr.GetTranslation("")));
         var _loc5_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.weapon")),this.getMainCateInfo(WEAPON,LanguageMgr.GetTranslation("")));
         var _loc6_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.qianghuashi")),this.getMainCateInfo(STRENTH,LanguageMgr.GetTranslation("")));
         var _loc7_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.hechengshi")),this.getMainCateInfo(COMPOSE,LanguageMgr.GetTranslation("")));
         var _loc8_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.baozhu")),this.getMainCateInfo(SPHERE,LanguageMgr.GetTranslation("")));
         var _loc9_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.zhuangtou")),this.getMainCateInfo(Drill,LanguageMgr.GetTranslation("")));
         var _loc10_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.xycp")),this.getMainCateInfo(PATCH,LanguageMgr.GetTranslation("")));
         var _loc11_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.cards")),this.getMainCateInfo(CARDS,LanguageMgr.GetTranslation("")));
         var _loc12_:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.pets")),this.getMainCateInfo(PET,LanguageMgr.GetTranslation("")));
         var _loc13_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.Weapon");
         var _loc14_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cloth");
         var _loc15_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.beauty");
         var _loc16_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.qianghuashi");
         var _loc17_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.hechengshi");
         var _loc18_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.sphere");
         var _loc19_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.drill");
         var _loc20_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.rarechip");
         var _loc21_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cards");
         var _loc22_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.prop");
         var _loc23_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.petIcon");
         this.menu.addItemAt(_loc5_,-1);
         this.menu.addItemAt(_loc2_,-1);
         this.menu.addItemAt(_loc3_,-1);
         this.menu.addItemAt(_loc6_,-1);
         this.menu.addItemAt(_loc7_,-1);
         this.menu.addItemAt(_loc8_,-1);
         this.menu.addItemAt(_loc9_,-1);
         this.menu.addItemAt(_loc10_,-1);
         this.menu.addItemAt(_loc11_,-1);
         this.menu.addItemAt(_loc4_,-1);
         this.menu.addItemAt(_loc12_,-1);
         _loc5_.addChild(_loc13_);
         _loc2_.addChild(_loc14_);
         _loc3_.addChild(_loc15_);
         _loc6_.addChild(_loc16_);
         _loc7_.addChild(_loc17_);
         _loc8_.addChild(_loc18_);
         _loc9_.addChild(_loc19_);
         _loc10_.addChild(_loc20_);
         _loc11_.addChild(_loc21_);
         _loc4_.addChild(_loc22_);
         _loc12_.addChild(_loc23_);
         for each(_loc24_ in param1)
         {
            if(_loc24_.ID == HAT || _loc24_.ID == GLASS || _loc24_.ID == SUB_CLOTH)
            {
               _loc56_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc24_);
               this.menu.addItemAt(_loc56_,1);
            }
            else if(_loc24_.ID == SUITS || _loc24_.ID == WINGS || _loc24_.ID == EYES || _loc24_.ID == ORNAMENT || _loc24_.ID == HAIR)
            {
               _loc56_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc24_);
               this.menu.addItemAt(_loc56_,2);
            }
            else if(_loc24_.ID == UNFIGHT_PROP || _loc24_.ID == PAOPAO)
            {
               _loc56_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc24_);
               this.menu.addItemAt(_loc56_,9);
            }
            else
            {
               _loc56_ = null;
            }
         }
         _loc25_ = new CateCoryInfo();
         _loc25_.ID = JEWELRY;
         _loc25_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.jewelry");
         _loc26_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc25_);
         this.menu.addItemAt(_loc26_,1);
         _loc27_ = new CateCoryInfo();
         _loc27_.ID = SUB_WEAPON;
         _loc27_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
         _loc28_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc27_);
         this.menu.addItemAt(_loc28_,0);
         _loc29_ = new CateCoryInfo();
         _loc29_.ID = OFFHAND;
         _loc29_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.offhand");
         _loc30_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc29_);
         this.menu.addItemAt(_loc30_,0);
         _loc31_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_1,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua")));
         this.menu.addItemAt(_loc31_,3);
         _loc32_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(ZHUQUE,LanguageMgr.GetTranslation("BrowseLeftMenuView.zhuque")));
         _loc33_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(XUANWU,LanguageMgr.GetTranslation("BrowseLeftMenuView.xuanwu")));
         _loc34_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(QINGLONG,LanguageMgr.GetTranslation("BrowseLeftMenuView.qinglong")));
         _loc35_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(BAIHU,LanguageMgr.GetTranslation("BrowseLeftMenuView.baihu")));
         this.menu.addItemAt(_loc32_,4);
         this.menu.addItemAt(_loc33_,4);
         this.menu.addItemAt(_loc34_,4);
         this.menu.addItemAt(_loc35_,4);
         _loc36_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(WUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.wuqisp")));
         _loc37_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FUWUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.fuwuqisp")));
         this.menu.addItemAt(_loc36_,7);
         this.menu.addItemAt(_loc37_,7);
         _loc38_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FREAKCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")));
         _loc39_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(EQUIPCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard")));
         this.menu.addItemAt(_loc38_,8);
         this.menu.addItemAt(_loc39_,8);
         _loc40_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv1,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv1 - Drill)));
         _loc41_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv2,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv2 - Drill)));
         _loc42_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv3,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv3 - Drill)));
         _loc43_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv4,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv4 - Drill)));
         _loc44_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv5,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv5 - Drill)));
         this.menu.addItemAt(_loc40_,6);
         this.menu.addItemAt(_loc41_,6);
         this.menu.addItemAt(_loc42_,6);
         this.menu.addItemAt(_loc43_,6);
         this.menu.addItemAt(_loc44_,6);
         _loc45_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(UNBINDPET,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt1")));
         _loc46_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(PETEQUIP,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt2")));
         _loc47_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(PETSTONE,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt3")));
         this.menu.addItemAt(_loc45_,10);
         this.menu.addItemAt(_loc46_,10);
         this.menu.addItemAt(_loc47_,10);
         _loc48_ = new CateCoryInfo();
         _loc48_.ID = TRIANGLE;
         _loc48_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.triangle");
         _loc49_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc48_);
         this.menu.addItemAt(_loc49_,5);
         _loc50_ = new CateCoryInfo();
         _loc50_.ID = ROUND;
         _loc50_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.round");
         _loc51_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc50_);
         this.menu.addItemAt(_loc51_,5);
         _loc52_ = new CateCoryInfo();
         _loc52_.ID = SQUERE;
         _loc52_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.square");
         _loc53_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc52_);
         this.menu.addItemAt(_loc53_,5);
         _loc54_ = new CateCoryInfo();
         _loc54_.ID = WISHBEAD;
         _loc54_.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.wishBead");
         _loc55_ = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),_loc54_);
         this.menu.addItemAt(_loc55_,5);
         this.list.invalidateViewport();
      }
      
      private function getMainCateInfo(param1:int, param2:String) : CateCoryInfo
      {
         var _loc3_:CateCoryInfo = new CateCoryInfo();
         _loc3_.ID = param1;
         _loc3_.Name = param2;
         return _loc3_;
      }
      
      private function _nameKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            AuctionHouseModel._dimBooble = false;
            if(!this._isFindAll)
            {
               this.__searchGoods(true);
               return;
            }
            this.__searchGoods(false);
         }
      }
      
      private function _nameChange(param1:Event) : void
      {
         if(this._name.text.indexOf(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere")) > -1)
         {
            this._name.text = this._name.text.replace(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"),"");
         }
      }
      
      public function get searchText() : String
      {
         return this._searchValue;
      }
      
      public function set setSearchStatus(param1:Boolean) : void
      {
         this.searchStatus = param1;
      }
      
      public function set searchText(param1:String) : void
      {
         this._name.text = param1;
         this._searchValue = param1;
      }
      
      private function __searchCondition(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AuctionHouseModel._dimBooble = false;
         if(!this._isFindAll)
         {
            this.__searchGoods(true);
            return;
         }
         this.__searchGoods(false);
      }
      
      private function __searchGoods(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
         this._searchValue = "";
         this._name.text = this._trim(this._name.text);
         this._searchValue = this._name.text;
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function __searchGoodsII(param1:Boolean = false) : void
      {
         this._isForAll = param1;
         AuctionHouseModel._dimBooble = false;
         this._searchValue = "";
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function _trim(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         return param1.replace(/(^\s*)|(\s*$)/g,"");
      }
      
      private function menuItemClick(param1:Event) : void
      {
         this.list.invalidateViewport();
         if(this.menu.isseach)
         {
            AuctionHouseModel._dimBooble = false;
            this.__searchGoodsII();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._searchBtn))
         {
            this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         }
         if(Boolean(this.menu))
         {
            this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
            this.menu.dispose();
            this.menu = null;
         }
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._searchBtn))
         {
            ObjectUtils.disposeObject(this._searchBtn);
         }
         this._searchBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

