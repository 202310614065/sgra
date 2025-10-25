package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import gemstone.GemstoneManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import shop.ShopEvent;
   
   public class ShopManager extends EventDispatcher
   {
      
      private static var _instance:ShopManager;
      
      public var initialized:Boolean = false;
      
      private var _shopGoods:DictionaryData;
      
      private var _shopSortList:Dictionary;
      
      private var _shopRealTimesDisCountGoods:Dictionary;
      
      public function ShopManager(param1:SingletonEnfocer)
      {
         super();
      }
      
      public static function get Instance() : ShopManager
      {
         if(_instance == null)
         {
            _instance = new ShopManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      public function setup(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
         this.initialized = true;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT,this.__updateGoodsCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,this.__updateGoodsDisCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOP_BUYLIMITEDCOUNT,this.__shopBuyLimitedCountHandler);
      }
      
      public function updateShopGoods(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
      }
      
      public function sortShopItems(param1:ShopItemSortAnalyzer) : void
      {
         this._shopSortList = param1.shopSortedGoods;
      }
      
      public function getResultPages(param1:int, param2:int = 8) : int
      {
         var _loc3_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         return int(Math.ceil(_loc3_.length / param2));
      }
      
      public function buyIt(param1:Array) : Array
      {
         var _loc7_:ShopCarItemInfo = null;
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.Gold;
         var _loc5_:int = _loc2_.Money;
         var _loc6_:int = _loc2_.BandMoney;
         for each(_loc7_ in param1)
         {
            if(_loc4_ >= _loc7_.getItemPrice(_loc7_.currentBuyType).goldValue && _loc5_ >= _loc7_.getItemPrice(_loc7_.currentBuyType).moneyValue && _loc6_ >= _loc7_.getItemPrice(_loc7_.currentBuyType).bandDdtMoneyValue)
            {
               _loc4_ -= _loc7_.getItemPrice(_loc7_.currentBuyType).goldValue;
               _loc5_ -= _loc7_.getItemPrice(_loc7_.currentBuyType).moneyValue;
               _loc6_ -= _loc7_.getItemPrice(_loc7_.currentBuyType).bandDdtMoneyValue;
               _loc3_.push(_loc7_);
            }
         }
         return _loc3_;
      }
      
      public function giveGift(param1:Array, param2:SelfInfo) : Array
      {
         var _loc5_:ItemPrice = null;
         var _loc6_:ShopCarItemInfo = null;
         var _loc3_:Array = [];
         var _loc4_:int = param2.Money;
         for each(_loc6_ in param1)
         {
            _loc5_ = _loc6_.getItemPrice(_loc6_.currentBuyType);
            if(_loc4_ >= _loc5_.moneyValue && _loc5_.bandDdtMoneyValue == 0 && _loc5_.goldValue == 0)
            {
               _loc4_ -= _loc5_.moneyValue;
               _loc3_.push(_loc6_);
            }
         }
         return _loc3_;
      }
      
      private function __updateGoodsCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:ShopItemInfo = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:ShopItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = StateManager.currentStateType == StateType.CONSORTIA ? 2 : 1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = this.getShopItemByGoodsID(_loc10_);
            if(Boolean(_loc12_) && _loc3_ == 1)
            {
               _loc12_.LimitCount = _loc11_;
            }
            _loc5_++;
         }
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc13_ = _loc2_.readInt();
            _loc14_ = _loc2_.readInt();
            _loc15_ = this.getShopItemByGoodsID(_loc13_);
            if(_loc15_ && _loc3_ == 2 && _loc6_ == PlayerManager.Instance.Self.ConsortiaID)
            {
               _loc15_.LimitCount = _loc14_;
            }
            _loc8_++;
         }
         var _loc9_:int = _loc2_.readInt();
         GemstoneManager.Instance.upDataFitCount();
      }
      
      public function getShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc3_:DictionaryData = null;
         var _loc2_:ShopItemInfo = this._shopGoods[param1];
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         for each(_loc3_ in this._shopRealTimesDisCountGoods)
         {
            _loc2_ = _loc3_[param1];
            if(_loc2_ != null && _loc2_.isValid)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getValidSortedGoodsByType(param1:int, param2:int, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc5_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         var _loc6_:int = Math.ceil(_loc5_.length / param3);
         if(param2 > 0 && param2 <= _loc6_)
         {
            _loc7_ = 0 + param3 * (param2 - 1);
            _loc8_ = Math.min(_loc5_.length - _loc7_,param3);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc4_.push(_loc5_[_loc7_ + _loc9_]);
               _loc9_++;
            }
         }
         return _loc4_;
      }
      
      public function getValidSortedGoodsByList(param1:Vector.<ShopItemInfo>, param2:int, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc5_:int = Math.ceil(param1.length / param3);
         if(param2 > 0 && param2 <= _loc5_)
         {
            _loc6_ = 0 + param3 * (param2 - 1);
            _loc7_ = Math.min(param1.length - _loc6_,param3);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc4_.push(param1[_loc6_ + _loc8_]);
               _loc8_++;
            }
         }
         return _loc4_;
      }
      
      public function GetGoodsByTypeAndQuality(param1:int, param2:int) : Vector.<ShopItemInfo>
      {
         var _loc3_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc4_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         var _loc5_:int = 0;
         var _loc6_:int = int(_loc4_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc4_[_loc5_].TemplateInfo.Quality == param2)
            {
               _loc3_.push(_loc4_[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getGoodsByType(param1:int) : Vector.<ShopItemInfo>
      {
         return this._shopSortList[param1] as Vector.<ShopItemInfo>;
      }
      
      public function getValidGoodByType(param1:int) : Vector.<ShopItemInfo>
      {
         var _loc4_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc3_:Vector.<ShopItemInfo> = this._shopSortList[param1];
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isValid)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function consortiaShopLevelTemplates(param1:int) : Vector.<ShopItemInfo>
      {
         return this._shopSortList[ShopType.GUILD_SHOP_1 + param1 - 1] as Vector.<ShopItemInfo>;
      }
      
      public function canAddPrice(param1:int) : Boolean
      {
         if(!this.getGoodsByTemplateIDOnlyUseXuFei(param1) || !this.getGoodsByTemplateIDOnlyUseXuFei(param1).IsContinue)
         {
            return false;
         }
         if(this.getShopRechargeItemByTemplateId(param1).length <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function getShopRechargeItemByTemplateId(param1:int) : Array
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this._shopGoods)
         {
            if(_loc3_.TemplateID == param1 && _loc3_.getItemPrice(1).moneyValue > 0 && _loc3_.IsContinue)
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc4_ in this._shopGoods)
         {
            if(_loc4_.TemplateID == param1 && _loc4_.getItemPrice(1).bandDdtMoneyValue > 0 && _loc4_.IsContinue)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getShopItemByTemplateID(param1:int, param2:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         switch(param2)
         {
            case 1:
               for each(_loc3_ in this._shopGoods)
               {
                  if(_loc3_.TemplateID == param1 && _loc3_.getItemPrice(1).hardCurrencyValue > 0)
                  {
                     if(_loc3_.isValid)
                     {
                        return _loc3_;
                     }
                  }
               }
               break;
            case 2:
               for each(_loc4_ in this._shopGoods)
               {
                  if(_loc4_.TemplateID == param1 && _loc4_.getItemPrice(1).gesteValue > 0)
                  {
                     if(_loc4_.isValid)
                     {
                        return _loc4_;
                     }
                  }
               }
               break;
            case 3:
               return this.getMoneyShopItemByTemplateID(param1);
            case 4:
               for each(_loc5_ in this._shopGoods)
               {
                  if(_loc5_.TemplateID == param1 && _loc5_.getItemPrice(1).bandDdtMoneyValue > 0)
                  {
                     if(_loc5_.isValid)
                     {
                        return _loc5_;
                     }
                  }
               }
               break;
            case 5:
               for each(_loc6_ in this._shopGoods)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).scoreValue > 0)
                  {
                     if(_loc6_.isValid)
                     {
                        return _loc6_;
                     }
                  }
               }
               break;
            case 6:
               for each(_loc7_ in this._shopGoods)
               {
                  if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).leagueValue > 0)
                  {
                     if(_loc7_.isValid)
                     {
                        return _loc7_;
                     }
                  }
               }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:Vector.<ShopItemInfo> = null;
         var _loc8_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_MONEY_TYPE).concat(this.getType(ShopType.FEMALE_MONEY_TYPE)).concat(this.getType(ShopType.FEMALE_DDTMONEY_TYPE)).concat(this.getType(ShopType.MALE_DDTMONEY_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).moneyValue > 0)
                  {
                     return _loc6_;
                  }
               }
            }
         }
         else
         {
            _loc7_ = new Vector.<ShopItemInfo>();
            for each(_loc8_ in this._shopGoods)
            {
               if(_loc8_.TemplateID == param1 && _loc8_.getItemPrice(1).moneyValue > 0 && _loc8_.isValid)
               {
                  _loc7_.push(_loc8_);
               }
            }
            if(_loc7_.length > 0)
            {
               return this.getInfoByBuyType(_loc7_);
            }
         }
         return null;
      }
      
      private function getInfoByBuyType(param1:Vector.<ShopItemInfo>) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = _loc3_ - 1;
            _loc2_ = param1[_loc3_];
            while(_loc4_ >= 0 && _loc2_.ShopID < param1[_loc4_].ShopID)
            {
               param1[_loc4_ + 1] = param1[_loc4_];
               _loc4_--;
            }
            param1[_loc4_ + 1] = _loc2_;
            _loc3_++;
         }
         return param1[0];
      }
      
      public function getMoneySaleShopItemByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = this._shopSortList[ShopType.SALE_SHOP];
         if(Boolean(_loc2_))
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.GoodsID == param1 && _loc3_.getItemPrice(1).moneyValue > 0)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateIDForGiftSystem(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getBuriedGoodsList() : Vector.<ShopItemInfo>
      {
         var _loc2_:ShopItemInfo = null;
         var _loc1_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.ShopID == 94)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function getGoodsByTemplateIDOnlyUseXuFei(param1:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:int = 0;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc3_ in this._shopGoods)
         {
            if(_loc3_.TemplateID == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].IsContinue)
            {
               return _loc2_[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getGoodsByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc3_ in this._shopGoods)
         {
            if(_loc3_.TemplateID == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length > 0)
         {
            return this.getInfoByBuyType(_loc2_);
         }
         return null;
      }
      
      public function getGoodsByTemplateIDFromTransnational(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1 && _loc2_.BuyType == 100)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getGiftShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_MONEY_TYPE).concat(this.getType(ShopType.FEMALE_MONEY_TYPE)).concat(this.getType(ShopType.FEMALE_DDTMONEY_TYPE)).concat(this.getType(ShopType.MALE_DDTMONEY_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1)
                  {
                     if(_loc6_.getItemPrice(1).bandDdtMoneyValue > 0)
                     {
                        return _loc6_;
                     }
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).bandDdtMoneyValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return _loc7_;
                  }
               }
            }
         }
         return null;
      }
      
      private function getType(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         if(param1 is Array)
         {
            for each(_loc3_ in param1)
            {
               _loc2_ = _loc2_.concat(this.getType(_loc3_));
            }
         }
         else
         {
            _loc2_.push(param1);
         }
         return _loc2_;
      }
      
      public function getGoldShopItemByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopSortList[ShopType.ROOM_PROP])
         {
            if(_loc2_.TemplateID == param1)
            {
               if(_loc2_.isValid)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function moneyGoods(param1:Array, param2:SelfInfo) : Array
      {
         var _loc4_:ItemPrice = null;
         var _loc5_:ShopCarItemInfo = null;
         var _loc3_:Array = [];
         for each(_loc5_ in param1)
         {
            _loc4_ = _loc5_.getItemPrice(_loc5_.currentBuyType);
            if(_loc4_.moneyValue > 0)
            {
               _loc3_.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      public function buyLeastGood(param1:Array, param2:SelfInfo) : Boolean
      {
         var _loc3_:ShopCarItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(param2.Gold >= _loc3_.getItemPrice(_loc3_.currentBuyType).goldValue && param2.Money >= _loc3_.getItemPrice(_loc3_.currentBuyType).moneyValue && param2.BandMoney >= _loc3_.getItemPrice(_loc3_.currentBuyType).bandDdtMoneyValue)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getDesignatedAllShopItem() : Vector.<ShopItemInfo>
      {
         var _loc3_:int = 0;
         var _loc1_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < ShopType.CAN_SHOW_IN_SHOP.length)
         {
            _loc3_ = int(ShopType.CAN_SHOW_IN_SHOP[_loc2_]);
            if(Boolean(this._shopSortList[_loc3_]))
            {
               _loc1_ = _loc1_.concat(this._shopSortList[_loc3_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function fuzzySearch(param1:Vector.<ShopItemInfo>, param2:String) : Vector.<ShopItemInfo>
      {
         var _loc4_:ShopItemInfo = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:ShopItemInfo = null;
         var _loc3_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc4_ in param1)
         {
            if(_loc4_.isValid && Boolean(_loc4_.TemplateInfo))
            {
               _loc5_ = int(_loc4_.TemplateInfo.Name.indexOf(param2));
               if(_loc5_ > -1)
               {
                  _loc6_ = true;
                  for each(_loc7_ in _loc3_)
                  {
                     if(_loc7_.GoodsID == _loc4_.GoodsID)
                     {
                        _loc6_ = false;
                     }
                  }
                  if(_loc6_)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function getDisCountValidGoodByType(param1:int) : Vector.<ShopItemInfo>
      {
         var _loc3_:DictionaryData = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         var _loc2_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         if(param1 != 1)
         {
            _loc3_ = this._shopRealTimesDisCountGoods[param1];
            if(Boolean(_loc3_))
            {
               for each(_loc4_ in _loc3_.list)
               {
                  if(_loc4_.isValid && _loc4_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
            }
            return _loc2_;
         }
         if(param1 == 1)
         {
            _loc3_ = this._shopRealTimesDisCountGoods[param1];
            if(Boolean(_loc3_))
            {
               for each(_loc5_ in _loc3_.list)
               {
                  if(_loc5_.isValid && _loc5_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc2_.push(_loc5_);
                  }
               }
            }
            _loc3_ = this._shopRealTimesDisCountGoods[8];
            if(Boolean(_loc3_))
            {
               for each(_loc6_ in _loc3_.list)
               {
                  if(_loc6_.isValid && _loc6_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc2_.push(_loc6_);
                  }
               }
            }
            _loc3_ = this._shopRealTimesDisCountGoods[9];
            if(Boolean(_loc3_))
            {
               for each(_loc7_ in _loc3_.list)
               {
                  if(_loc7_.isValid && _loc7_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc2_.push(_loc7_);
                  }
               }
            }
            return _loc2_;
         }
         return _loc2_;
      }
      
      public function getDisCountResultPages(param1:int, param2:int = 8) : int
      {
         var _loc4_:int = 0;
         var _loc3_:Vector.<ShopItemInfo> = this.getDisCountValidGoodByType(param1);
         if(Boolean(_loc3_))
         {
            _loc4_ = Math.ceil(_loc3_.length / param2);
         }
         return _loc4_;
      }
      
      public function getDisCountShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:ShopItemInfo = null;
         for each(_loc2_ in this._shopRealTimesDisCountGoods)
         {
            _loc3_ = _loc2_[param1];
            if(_loc3_ != null && _loc3_.isValid)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getDisCountGoods(param1:int = 1, param2:int = 1, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc5_:Vector.<ShopItemInfo> = this.getDisCountValidGoodByType(param1);
         if(Boolean(_loc5_))
         {
            _loc6_ = Math.ceil(_loc5_.length / param3);
            if(param2 > 0 && param2 <= _loc6_)
            {
               _loc7_ = 0 + param3 * (param2 - 1);
               _loc8_ = Math.min(_loc5_.length - _loc7_,param3);
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc4_.push(_loc5_[_loc7_ + _loc9_]);
                  _loc9_++;
               }
            }
         }
         return _loc4_;
      }
      
      public function isHasDisCountGoods(param1:int) : Boolean
      {
         var _loc3_:DictionaryData = null;
         var _loc4_:DictionaryData = null;
         var _loc2_:DictionaryData = this._shopRealTimesDisCountGoods[param1];
         if(param1 == 1)
         {
            _loc3_ = this._shopRealTimesDisCountGoods[8];
            _loc4_ = this._shopRealTimesDisCountGoods[9];
            if(this.checkIsHasDisCount(_loc2_) || this.checkIsHasDisCount(_loc3_) || this.checkIsHasDisCount(_loc4_))
            {
               return true;
            }
         }
         else if(this.checkIsHasDisCount(_loc2_))
         {
            return true;
         }
         return false;
      }
      
      private function checkIsHasDisCount(param1:DictionaryData) : Boolean
      {
         var _loc2_:ShopItemInfo = null;
         if(Boolean(param1) && param1.length > 0)
         {
            for each(_loc2_ in param1.list)
            {
               if(Boolean(_loc2_) && _loc2_.isValid)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function __updateGoodsDisCount(param1:CrazyTankSocketEvent) : void
      {
         this.loadDisCounts();
      }
      
      private function __shopBuyLimitedCountHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = _loc2_.readInt();
               if(Boolean(this._shopGoods[_loc5_]))
               {
                  ShopItemInfo(this._shopGoods[_loc5_]).LimitAreaCount = _loc6_;
               }
               _loc4_++;
            }
            dispatchEvent(new ShopEvent(ShopEvent.UPDATA_LIMITAREACOUNT));
         }
      }
      
      private function loadDisCounts() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         _loc2_.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount);
         LoadResourceManager.Instance.startLoad(_loc2_);
      }
      
      public function updateRealTimesItemsByDisCount(param1:ShopItemDisCountAnalyzer) : void
      {
         this._shopRealTimesDisCountGoods = param1.shopDisCountGoods;
         dispatchEvent(new ShopEvent(ShopEvent.DISCOUNT_IS_CHANGE));
      }
      
      public function get shopGoods() : DictionaryData
      {
         return this._shopGoods;
      }
      
      public function set shopGoods(param1:DictionaryData) : void
      {
         this._shopGoods = param1;
      }
   }
}

class SingletonEnfocer
{
   
   public function SingletonEnfocer()
   {
      super();
   }
}
