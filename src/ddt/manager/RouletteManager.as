package ddt.manager
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.command.QuickBuyFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.caddyII.CaddyAwardListFrame;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.card.CardFrame;
   import ddt.view.caddyII.card.CardSoulBoxFrame;
   import ddt.view.caddyII.vip.VipBoxFrame;
   import ddt.view.roulette.RouletteBoxPanel;
   import ddt.view.roulette.RouletteEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import surpriseRoulette.view.SurpriseRouletteView;
   
   public class RouletteManager extends EventDispatcher
   {
      
      private static var _instance:RouletteManager = null;
      
      public static const SLEEP:int = 0;
      
      public static const OPEN_ROULETTEBOX:int = 1;
      
      public static const OPEN_CADDY:int = 2;
      
      public static const NO_BOX:int = 0;
      
      public static const ROULETTEBOX:int = 1;
      
      public static const CADDY:int = 2;
      
      private var _rouletteBoxkeyCount:int = -1;
      
      private var _sRouletteKeyCount:int = 10;
      
      private var id:int;
      
      private var _caddyKeyCount:int = -1;
      
      private var _templateIDList:Array;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _stateAfterBuyKey:int = 0;
      
      private var _boxType:int = 0;
      
      private var _numList:Array = [0,0,0,4,4,4,3,3,3,2];
      
      public var dataList:Vector.<Object>;
      
      public var goodList:Vector.<InventoryItemInfo>;
      
      private var _goodsInfo:ItemTemplateInfo;
      
      private var limdataList:Vector.<Object>;
      
      public function RouletteManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : RouletteManager
      {
         if(_instance == null)
         {
            _instance = new RouletteManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._templateIDList = new Array();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_BADLUCK,this.__getBadLuckHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,this._showBox);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKSTONE_RANK_LIMIT,this.luckStoneRankLimit);
      }
      
      protected function luckStoneRankLimit(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:CaddyEvent = null;
         var _loc6_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.limdataList = new Vector.<Object>();
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:Boolean = _loc4_.readBoolean();
         if(_loc5_)
         {
            _loc10_ = _loc4_.readInt();
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc2_ = new Object();
               _loc2_.TemplateID = _loc4_.readInt();
               _loc2_.count = this._numList[_loc11_];
               this.limdataList.push(_loc2_);
               _loc11_++;
            }
            _loc3_ = new CaddyEvent(CaddyEvent.LUCKSTONE_RANK_LIMIT);
            _loc3_.lastTime = _loc6_;
            _loc3_.dataList = this.limdataList;
            dispatchEvent(_loc3_);
            return;
         }
         _loc6_ = _loc4_.readUTF();
         var _loc7_:Boolean = _loc4_.readBoolean();
         var _loc8_:int = _loc4_.readInt();
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc2_ = new Object();
            _loc2_["Rank"] = _loc4_.readInt();
            _loc2_["UserID"] = _loc4_.readInt();
            _loc2_["LuckStone"] = _loc4_.readInt();
            _loc2_["TemplateID"] = _loc4_.readInt();
            _loc2_["Nickname"] = _loc4_.readUTF();
            _loc2_["count"] = this._numList[_loc9_];
            this.limdataList.push(_loc2_);
            _loc9_++;
         }
         _loc3_ = new CaddyEvent(CaddyEvent.LUCKSTONE_RANK_LIMIT);
         _loc3_.lastTime = _loc6_;
         _loc3_.dataList = this.limdataList;
         dispatchEvent(_loc3_);
      }
      
      private function _showBox(param1:CrazyTankSocketEvent) : void
      {
         switch(this._boxType)
         {
            case ROULETTEBOX:
               this._showRoultteView(param1);
               break;
            case CADDY:
         }
      }
      
      private function _showRoultteView(param1:CrazyTankSocketEvent) : void
      {
         var i:int;
         var info:BoxGoodsTempInfo = null;
         var evt:CrazyTankSocketEvent = param1;
         var pkg:PackageIn = evt.pkg;
         try
         {
            this.id = pkg.readInt();
         }
         catch(e:Error)
         {
         }
         i = 0;
         while(i < 18)
         {
            try
            {
               info = new BoxGoodsTempInfo();
               info.TemplateId = pkg.readInt();
               info.IsBind = pkg.readBoolean();
               info.ItemCount = pkg.readByte();
               info.ItemValid = pkg.readByte();
               this._templateIDList.push(info);
            }
            catch(e:Error)
            {
            }
            i++;
         }
         this._randomTemplateID();
         if(this.id == EquipType.SURPRISE_ROULETTE_BOX)
         {
            this.showSurpriseRouletteView();
         }
         else if(this.id == EquipType.ROULETTE_BOX)
         {
            this.showRouletteView();
         }
         this._boxType = NO_BOX;
      }
      
      public function showSurpriseRouletteView() : void
      {
         var _loc1_:SurpriseRouletteView = new SurpriseRouletteView(this._templateIDList);
         _loc1_.keyCount = this._sRouletteKeyCount;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function useRouletteBox(param1:BagCell) : void
      {
         this._rouletteBoxkeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         this._bagType = param1.itemInfo.BagType;
         this._place = param1.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._rouletteBoxkeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.ROULETTE_KEY);
         }
      }
      
      public function useVipBox(param1:BagCell) : void
      {
         this._goodsInfo = param1.info;
         var _loc2_:VipBoxFrame = ComponentFactory.Instance.creatCustomObject("caddyII.VipFrame",[CaddyModel.VIP_TYPE,this._goodsInfo]);
         _loc2_.setCardType(param1.info.TemplateID,param1.place);
         _loc2_.show();
         this._boxType = NO_BOX;
      }
      
      public function useSurpriseRoulette(param1:BagCell) : void
      {
         this._sRouletteKeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         this._bagType = param1.itemInfo.BagType;
         this._place = param1.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._sRouletteKeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.SURPRISE_ROULETTE_KEY);
         }
      }
      
      private function updateState() : void
      {
         switch(this._stateAfterBuyKey)
         {
            case SLEEP:
               break;
            case OPEN_ROULETTEBOX:
               if(this._rouletteBoxkeyCount >= 1)
               {
                  SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
               }
               this._stateAfterBuyKey = SLEEP;
               break;
            case OPEN_CADDY:
         }
      }
      
      public function showRouletteView() : void
      {
         var _loc1_:RouletteBoxPanel = ComponentFactory.Instance.creat("roulette.RoulettePanelAsset");
         _loc1_.templateIDList = this._templateIDList;
         _loc1_.keyCount = this._rouletteBoxkeyCount;
         _loc1_.show();
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showBuyRouletteKey(param1:int, param2:int) : void
      {
         var _loc3_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc3_.itemID = param2;
         _loc3_.stoneNumber = param1;
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as QuickBuyFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this._closeFun();
         }
      }
      
      private function _closeFun() : void
      {
         this._stateAfterBuyKey = SLEEP;
      }
      
      private function _randomTemplateID() : void
      {
         var _loc3_:int = 0;
         var _loc1_:BoxGoodsTempInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._templateIDList.length)
         {
            _loc3_ = Math.floor(Math.random() * this._templateIDList.length);
            _loc1_ = this._templateIDList[_loc2_] as BoxGoodsTempInfo;
            this._templateIDList[_loc2_] = this._templateIDList[_loc3_];
            this._templateIDList[_loc3_] = _loc1_;
            _loc2_++;
         }
      }
      
      private function _bagUpdate(param1:BagEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RouletteEvent = null;
         _loc2_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         if(this._sRouletteKeyCount != _loc2_)
         {
            _loc3_ = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            _loc3_.keyCount = this._sRouletteKeyCount = _loc2_;
            dispatchEvent(_loc3_);
            this.updateState();
            return;
         }
         _loc2_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         if(this._rouletteBoxkeyCount != _loc2_)
         {
            _loc3_ = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            _loc3_.keyCount = this._rouletteBoxkeyCount = _loc2_;
            dispatchEvent(_loc3_);
            this.updateState();
         }
      }
      
      private function __getBadLuckHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:Object = null;
         var _loc8_:CaddyEvent = null;
         this.dataList = new Vector.<Object>();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new Object();
            _loc7_["Rank"] = _loc2_.readInt();
            _loc7_["UserID"] = _loc2_.readInt();
            _loc7_["Count"] = _loc2_.readInt();
            _loc7_["TemplateID"] = _loc2_.readInt();
            _loc7_["Nickname"] = _loc2_.readUTF();
            this.dataList.push(_loc7_);
            _loc6_++;
         }
         if(_loc5_ == 0 || this.dataList[0].TemplateID == 0)
         {
            _loc8_ = new CaddyEvent(CaddyEvent.UPDATE_BADLUCK);
            _loc8_.lastTime = _loc3_;
            _loc8_.dataList = this.dataList;
            dispatchEvent(_loc8_);
         }
         else if(this.getStateAble(StateManager.currentStateType) && _loc4_)
         {
            this.__showBadLuckEndFrame();
         }
         else
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(this.__showBadLuckEndFrame));
         }
      }
      
      private function __showBadLuckEndFrame() : void
      {
         var _loc1_:CaddyAwardListFrame = ComponentFactory.Instance.creatComponentByStylename("caddyAwardListFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function getStateAble(param1:String) : Boolean
      {
         if(param1 == StateType.MAIN || param1 == StateType.AUCTION || param1 == StateType.DDTCHURCH_ROOM_LIST || param1 == StateType.ROOM_LIST || param1 == StateType.CONSORTIA || param1 == StateType.DUNGEON_LIST || param1 == StateType.HOT_SPRING_ROOM_LIST || param1 == StateType.FIGHT_LIB || param1 == StateType.ACADEMY_REGISTRATION || param1 == StateType.CIVIL || param1 == StateType.TOFFLIST)
         {
            return true;
         }
         return false;
      }
      
      public function useCaddy(param1:BagCell) : void
      {
         this._goodsInfo = param1.info;
         this._loadSWF();
      }
      
      private function _creatCaddy() : void
      {
         var _loc1_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CADDY_TYPE,this._goodsInfo]);
         _loc1_.show();
         this._boxType = NO_BOX;
      }
      
      public function useBless(param1:BagCell = null) : void
      {
         var cell:BagCell = param1;
         if(!cell)
         {
            this._goodsInfo = ItemManager.Instance.getTemplateById(112047);
         }
         else
         {
            this._goodsInfo = cell.info;
         }
         try
         {
            this._creatCaddy();
         }
         catch(event:Error)
         {
            _loadSWF();
         }
      }
      
      private function _creatBless() : void
      {
         var _loc1_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.BOMB_KING_BLESS,this._goodsInfo]);
         _loc1_.show();
      }
      
      public function useCelebrationBox() : void
      {
         var _loc1_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CELEBRATION_BOX]);
         _loc1_.show();
      }
      
      public function useBead(param1:int) : void
      {
         var _loc2_:CaddyFrame = null;
         if(param1 == EquipType.MYSTICAL_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.MYSTICAL_CARDBOX]);
         }
         else if(param1 == EquipType.MY_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyIII.CardBoxFrame",[CaddyModel.MY_CARDBOX]);
         }
         else
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.BEAD_TYPE]);
         }
         _loc2_.setBeadType(param1);
         _loc2_.show();
      }
      
      public function useOfferPack(param1:BagCell) : void
      {
         CaddyModel.instance.offerType = param1.info.TemplateID;
         var _loc2_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.OFFER_PACKET]);
         _loc2_.setOfferType(param1.info.TemplateID);
         _loc2_.show();
      }
      
      public function useCard(param1:BagCell) : void
      {
         var _loc2_:CardFrame = null;
         var _loc3_:CardSoulBoxFrame = null;
         if(param1.info.TemplateID == EquipType.MY_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.MY_CARDBOX]);
         }
         else if(param1.info.TemplateID == EquipType.MYSTICAL_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.MYSTICAL_CARDBOX]);
         }
         else
         {
            if(param1.info.TemplateID == EquipType.CARDSOUL_BOX)
            {
               _loc3_ = ComponentFactory.Instance.creatCustomObject("caddy.CardSoulBoxFrame",[CaddyModel.CARD_TYPE]);
               _loc3_.setCardType(param1.info.TemplateID,param1.place);
               _loc3_.show();
               return;
            }
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.CARD_TYPE]);
         }
         _loc2_.setCardType(param1.info.TemplateID,param1.place);
         _loc2_.show();
      }
      
      private function _loadSWF() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CADDY);
      }
      
      private function _loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUICompleteOne);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CADDY);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._creatCaddy();
         }
      }
      
      private function __onUICompleteOne(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._creatBless();
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
         if(param1.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
   }
}

