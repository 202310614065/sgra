package ddt.manager
{
   import ddt.data.ServerConfigInfo;
   import ddt.data.analyze.ServerConfigAnalyz;
   import dragonBoat.DragonBoatManager;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class ServerConfigManager
   {
      
      private static var _instance:ServerConfigManager;
      
      private static var privileges:Dictionary;
      
      public static const MARRT_ROOM_CREATE_MONET:String = "MarryRoomCreateMoney";
      
      public static const MISSION_RICHES:String = "MissionRiches";
      
      public static const VIP_RATE_FOR_GP:String = "VIPRateForGP";
      
      public static const VIP_QUEST_STAR:String = "VIPQuestStar";
      
      public static const VIP_LOTTERY_COUNT_MAX_PER_DAY:String = "VIPLotteryCountMaxPerDay";
      
      public static const VIP_TAKE_CARD_DISCOUNT:String = "VIPTakeCardDisCount";
      
      public static const VIP_EXP_NEEDEDFOREACHLV:String = "VIPExpForEachLv";
      
      public static const HOT_SPRING_EXP:String = "HotSpringExp";
      
      public static const VIP_STRENGTHEN_EX:String = "VIPStrengthenEx";
      
      public static const CONSORTIA_STRENGTHEN_EX:String = "ConsortiaStrengthenEx";
      
      public static const VIPEXTTRA_BIND_MOMEYUPPER:String = "VIPExtraBindMoneyUpper";
      
      public static const AWARD_MAX_MONEY:String = "AwardMaxMoney";
      
      public static const VIP_RENEWAL_PRIZE:String = "VIPRenewalPrize";
      
      public static const VIP_DAILY_PACK:String = "VIPDailyPackID";
      
      public static const VIP_PRIVILEGE:String = "VIPPrivilege";
      
      public static const VIP_PAYAIMENERGY:String = "VIPPayAimEnergy";
      
      public static const PAYAIMENERGY:String = "PayAimEnergy";
      
      public static const VIP_QUEST_FINISH_DIRECT:String = "VIPQuestFinishDirect";
      
      public static const CARD_RESETSOUL_VALUE_CARD:String = "CardResetSoulValue";
      
      public static const CARD_GROOVE_REVERT:String = "CardGrooveRevert";
      
      public static const PLAYER_MIN_LEVEL:String = "PlayerMinLevel";
      
      public static const BEAD_UPGRADE_EXP:String = "RuneLevelUpExp";
      
      public static const REQUEST_BEAD_PRICE:String = "OpenRunePackageMoney";
      
      public static const BEAD_HOLE_UP_EXP:String = "HoleLevelUpExpList";
      
      public static const CREATE_GUILD:String = "CreateGuild";
      
      public static const TRANSFER_STRENGTHENEX:String = "MustTransferGold";
      
      public static const AUCTION_RATE:String = "Cess";
      
      public static const STORE_MUSTINLAYGOLD:String = "MustInlayGold";
      
      public static const PET_SCORE_ENABLE:String = "IsOpenPetScore";
      
      public static const TAKECARDMONEY:String = "TakeCardMoney";
      
      public static const WARRIORFAMRAIDPRICEPERMIN:String = "WarriorFamRaidPricePerMin";
      
      public static const BUYCARDSOULVALUEMONEY:String = "BuyCardSoulValueMoney";
      
      public static const PYRAMIDTOPPOINT:String = "PyramidTopPoint";
      
      public static const TOTEMPROPMONEYOFFSET:String = "TotemPropMoneyOffset";
      
      public static const ISPROMOTEPACKAGEOPEN:String = "IsPromotePackageOpen";
      
      public static const ENTERTAINMENT_SCORE:String = "EntertainmentScore";
      
      public static const RECREATIONPVPREFRESHPROP_BINDMONEY:String = "RecreationPvpRefreshPropBindMoney";
      
      public static const RECREATIONPVP_MINLEVEL:String = "RecreationPvpMinLevel";
      
      public static const RECREATIONPK_REMOVE_MONEY:String = "RecreationPkRemoveMoney";
      
      public static const RECREATIONPK_ADD_MONEY:String = "RecreationPkAddMoney";
      
      public static const PRIVILEGE_CANBUYFERT:String = "8";
      
      public static const PRIVILEGE_LOTTERYNOTIME:String = "13";
      
      public static const LIGHTROAD_MINLEVEL:String = "GoodsCollectMinLevel";
      
      public static const PROMOTEPACKAGEPRICE:String = "PromotePackagePrice";
      
      public static const CONSORTIA_MATCH_START_TIME:String = "ConsortiaMatchStartTime";
      
      public static const CONSORTIA_MATCH_END_TIME:String = "ConsortiaMatchEndTime";
      
      public static const LOCAL_CONSORTIA_MATCH_DAYS:String = "LocalConsortiaMatchDays";
      
      public static const AREA_CONSORTIA_MATCH_DAYS:String = "AreaConsortiaMatchDays";
      
      public static const HALLOWEEN_MINNUM:String = "HalloweenMinNum";
      
      public static const HALLOWEEN_BEGINDATE:String = "HalloweenBeginDate";
      
      public static const HALLOWEEN_ENDDATE:String = "HalloweenEndDate";
      
      public static const WITCH_BLESS_GP:String = "WitchBlessGP";
      
      public static const WITCH_BLESS_DOUBLEGP_TIME:String = "WitchBlessDoubleGpTime";
      
      public static const WITCH_BLESS_MONEY:String = "WithcBlessMoney";
      
      public static const CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE:String = "ChickenActiveKeyLvAwardNeedPrestige";
      
      public static const DRAGONBOAT_PROP:String = "DragonBoatProp";
      
      public static const ISCHICKENACTIVEKEYOPEN:String = "IsChickenActiveKeyOpen";
      
      private var _serverConfigInfoList:DictionaryData;
      
      private var _BindMoneyMax:Array;
      
      private var _VIPExtraBindMoneyUpper:Array;
      
      private var _activityEnterNum:int;
      
      private var _consortiaTaskDelayInfo:Array;
      
      private var _dailyRewardIDForMonth:Array;
      
      public function ServerConfigManager()
      {
         super();
      }
      
      public static function get instance() : ServerConfigManager
      {
         if(_instance == null)
         {
            _instance = new ServerConfigManager();
         }
         return _instance;
      }
      
      public function getserverConfigInfo(param1:ServerConfigAnalyz) : void
      {
         this._serverConfigInfoList = param1.serverConfigInfoList;
         this._BindMoneyMax = this._serverConfigInfoList["BindMoneyMax"].Value.split("|");
         this._VIPExtraBindMoneyUpper = this._serverConfigInfoList["VIPExtraBindMoneyUpper"].Value.split("|");
         this._activityEnterNum = this._serverConfigInfoList["QXGameLimitCount"].Value;
         this._dailyRewardIDForMonth = this._serverConfigInfoList["DailyRewardIDForMonth"].Value.split("|");
         var _loc2_:Array = this._serverConfigInfoList["ConsortiaMissionAddTime"].Value.split("|");
         var _loc3_:int = int(_loc2_.length);
         this._consortiaTaskDelayInfo = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._consortiaTaskDelayInfo.push(_loc2_[_loc4_].split(","));
            _loc4_++;
         }
      }
      
      public function get serverConfigInfo() : DictionaryData
      {
         return this._serverConfigInfoList;
      }
      
      public function get consortiaTaskDelayInfo() : Array
      {
         return this._consortiaTaskDelayInfo;
      }
      
      public function getBindBidLimit(param1:int, param2:int = 0) : int
      {
         var _loc3_:int = param1 % 10 == 0 ? int(this._BindMoneyMax[int(param1 / 10) - 1]) : int(this._BindMoneyMax[int(param1 / 10)]);
         var _loc4_:int = 0;
         if(PlayerManager.Instance.Self.IsVIP && param2 > 0)
         {
            _loc4_ = int(this._VIPExtraBindMoneyUpper[param2 - 1]);
         }
         return _loc3_ + _loc4_;
      }
      
      public function get PayAimEnergy() : int
      {
         return int(this.findInfoByName(ServerConfigManager.PAYAIMENERGY).Value);
      }
      
      public function get VIPPayAimEnergy() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_PAYAIMENERGY).Value.split("|");
      }
      
      public function get weddingMoney() : Array
      {
         return this.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
      }
      
      public function get MissionRiches() : Array
      {
         return this.findInfoByName(ServerConfigManager.MISSION_RICHES).Value.split("|");
      }
      
      public function get VIPExpNeededForEachLv() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_EXP_NEEDEDFOREACHLV).Value.split("|");
      }
      
      public function get CardRestSoulValue() : String
      {
         return this.findInfoByName(ServerConfigManager.CARD_RESETSOUL_VALUE_CARD).Value;
      }
      
      public function get cardResetCardSoulMoney() : String
      {
         return this.findInfoByName(ServerConfigManager.CARD_GROOVE_REVERT).Value;
      }
      
      public function get VIPExtraBindMoneyUpper() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIPEXTTRA_BIND_MOMEYUPPER).Value.split("|");
      }
      
      public function get HotSpringExp() : Array
      {
         return this.findInfoByName(ServerConfigManager.HOT_SPRING_EXP).Value.split(",");
      }
      
      public function findInfoByName(param1:String) : ServerConfigInfo
      {
         return this._serverConfigInfoList[param1];
      }
      
      public function get CreateGuild() : int
      {
         return 100000;
      }
      
      public function get TransferStrengthenEx() : String
      {
         return this.findInfoByName(TRANSFER_STRENGTHENEX).Value;
      }
      
      public function get AuctionRate() : String
      {
         return String(Number(this.findInfoByName(AUCTION_RATE).Value) * 100);
      }
      
      public function get VIPStrengthenEx() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_STRENGTHEN_EX);
         if(Boolean(_loc1_))
         {
            return this.findInfoByName(VIP_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function ConsortiaStrengthenEx() : Array
      {
         var _loc1_:Object = this.findInfoByName(CONSORTIA_STRENGTHEN_EX);
         if(Boolean(_loc1_))
         {
            return this.findInfoByName(CONSORTIA_STRENGTHEN_EX).Value.split("|");
         }
         return null;
      }
      
      public function get RouletteMaxTicket() : String
      {
         return this.findInfoByName(ServerConfigManager.AWARD_MAX_MONEY).Value;
      }
      
      public function get VIPRenewalPrice() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_RENEWAL_PRIZE);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPRateForGP() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_RATE_FOR_GP);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestStar() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_QUEST_STAR);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPLotteryCountMaxPerDay() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_LOTTERY_COUNT_MAX_PER_DAY);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPTakeCardDisCount() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_TAKE_CARD_DISCOUNT);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPQuestFinishDirect() : Array
      {
         return this.analyzeData(VIP_QUEST_FINISH_DIRECT);
      }
      
      public function analyzeData(param1:String) : Array
      {
         var _loc2_:Object = this.findInfoByName(param1);
         if(Boolean(_loc2_))
         {
            return String(_loc2_.Value).split("|");
         }
         return null;
      }
      
      public function getPrivilegeString(param1:int) : String
      {
         var _loc2_:Object = this.findInfoByName(VIP_PRIVILEGE);
         if(Boolean(_loc2_))
         {
            return String(_loc2_.Value);
         }
         return null;
      }
      
      public function get VIPDailyPack() : Array
      {
         return this.findInfoByName(ServerConfigManager.VIP_DAILY_PACK).Value.split("|");
      }
      
      public function getPrivilegeMinLevel(param1:String) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(privileges == null)
         {
            _loc2_ = this.findInfoByName(VIP_PRIVILEGE);
            _loc3_ = 1;
            _loc4_ = String(_loc2_.Value).split("|");
            privileges = new Dictionary();
            for each(_loc5_ in _loc4_)
            {
               for each(_loc6_ in _loc5_.split(","))
               {
                  privileges[_loc6_] = _loc3_;
               }
               _loc3_++;
            }
         }
         return int(privileges[param1]);
      }
      
      public function getBeadUpgradeExp() : DictionaryData
      {
         var _loc4_:int = 0;
         var _loc1_:DictionaryData = new DictionaryData();
         var _loc2_:Array = this.findInfoByName(BEAD_UPGRADE_EXP).Value.split("|");
         var _loc3_:int = 1;
         for each(_loc4_ in _loc2_)
         {
            _loc1_.add(_loc3_,_loc4_);
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getRequestBeadPrice() : Array
      {
         return this.findInfoByName(REQUEST_BEAD_PRICE).Value.split("|");
      }
      
      public function getBeadHoleUpExp() : Array
      {
         return this.findInfoByName(BEAD_HOLE_UP_EXP).Value.split("|");
      }
      
      public function get minOpenPetSystemLevel() : int
      {
         var _loc1_:Object = this.findInfoByName(PLAYER_MIN_LEVEL);
         return int(_loc1_.Value);
      }
      
      public function get storeMustinlaygold() : int
      {
         return int(this.findInfoByName(STORE_MUSTINLAYGOLD).Value);
      }
      
      public function get petScoreEnable() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(PET_SCORE_ENABLE);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get TakeCardMoney() : Number
      {
         return Number(this.findInfoByName(TAKECARDMONEY).Value);
      }
      
      public function get WarriorFamRaidPricePerMin() : Number
      {
         return Number(this.findInfoByName(WARRIORFAMRAIDPRICEPERMIN).Value);
      }
      
      public function get buyCardSoulValueMoney() : Number
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(BUYCARDSOULVALUEMONEY);
         if(Boolean(_loc1_))
         {
            return Number(_loc1_.Value);
         }
         return 500;
      }
      
      public function get pyramidTopMinMaxPoint() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:ServerConfigInfo = this.findInfoByName(PYRAMIDTOPPOINT);
         if(Boolean(_loc1_))
         {
            _loc2_ = _loc1_.Value.split("|");
            return new Array(_loc2_[0],_loc2_[_loc2_.length - 1]);
         }
         return new Array(0,0);
      }
      
      public function get totemSignDiscount() : Number
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(TOTEMPROPMONEYOFFSET);
         if(Boolean(_loc1_))
         {
            return Number(_loc1_.Value);
         }
         return 40;
      }
      
      public function get growthPackagePrice() : Number
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(PROMOTEPACKAGEPRICE);
         if(Boolean(_loc1_))
         {
            return Number(_loc1_.Value);
         }
         return 0;
      }
      
      public function get growthPackageIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(ISPROMOTEPACKAGEOPEN);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function entertainmentScore() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(ENTERTAINMENT_SCORE);
         return _loc1_.Value.split(",");
      }
      
      public function entertainmentPrice() : int
      {
         return int(this.findInfoByName(RECREATIONPVPREFRESHPROP_BINDMONEY).Value);
      }
      
      public function entertainmentLevel() : int
      {
         return int(this.findInfoByName(RECREATIONPVP_MINLEVEL).Value);
      }
      
      public function entertainmentPkCostMoney() : int
      {
         return int(this.findInfoByName(RECREATIONPK_REMOVE_MONEY).Value);
      }
      
      public function entertainmentPkAddMoney() : int
      {
         return int(this.findInfoByName(RECREATIONPK_ADD_MONEY).Value);
      }
      
      public function entertainmentTime() : String
      {
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:ServerConfigInfo = this.findInfoByName("RecreationPvpBeginDate");
         var _loc2_:ServerConfigInfo = this.findInfoByName("RecreationPvpEndDate");
         if(Boolean(_loc1_) && Boolean(_loc2_))
         {
            _loc3_ = DateUtils.getDateByStr(_loc1_.Value);
            _loc4_ = DateUtils.getDateByStr(_loc2_.Value);
            _loc5_ = _loc1_.Value.split(" ")[0];
            return _loc5_ + " " + _loc3_.hours + ":" + (_loc3_.minutes < 10 ? "0" + String(_loc3_.minutes) : _loc3_.minutes) + "-" + _loc4_.hours + ":" + (_loc4_.minutes < 10 ? "0" + String(_loc4_.minutes) : _loc4_.minutes);
         }
         return " ";
      }
      
      public function get lightRoadLevel() : int
      {
         return int(this.findInfoByName(LIGHTROAD_MINLEVEL).Value);
      }
      
      public function get activityEnterNum() : int
      {
         return this._activityEnterNum;
      }
      
      public function get dailyRewardIDForMonth() : Array
      {
         return this._dailyRewardIDForMonth;
      }
      
      public function get isMissionEnergyEnable() : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc1_:ServerConfigInfo = this.findInfoByName("IsMissionEnergyEnable");
         if(Boolean(_loc1_))
         {
            _loc2_ = _loc1_.Value;
            _loc3_ = _loc1_.Name;
            return String(_loc2_).toLowerCase() == "false" ? false : true;
         }
         return false;
      }
      
      public function get chickActivationIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(ISCHICKENACTIVEKEYOPEN);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() == "true";
         }
         return false;
      }
      
      public function get chickenActiveKeyLvAwardNeedPrestige() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.split("|");
         }
         return null;
      }
      
      public function get isTanabataTreasure() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("IsTanabataTreasure");
         var _loc2_:String = _loc1_.Value;
         var _loc3_:String = _loc1_.Name;
         return String(_loc2_) == "0" ? false : true;
      }
      
      public function get getDragonboatProp() : int
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(DRAGONBOAT_PROP);
         if(Boolean(_loc1_))
         {
            return int(_loc1_.Value);
         }
         return DragonBoatManager.DRAGONBOAT_CHIP;
      }
      
      public function get localConsortiaMatchDays() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(LOCAL_CONSORTIA_MATCH_DAYS);
         return _loc1_.Value.split("|");
      }
      
      public function get areaConsortiaMatchDays() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(AREA_CONSORTIA_MATCH_DAYS);
         return _loc1_.Value.split("|");
      }
      
      public function get consortiaMatchStartTime() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_START_TIME);
         return _loc1_.Value.split(" ")[1].toString().split(":");
      }
      
      public function get consortiaMatchEndTime() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_END_TIME);
         return _loc1_.Value.split(" ")[1].toString().split(":");
      }
      
      public function get getHalloweenMinNum() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_MINNUM);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenBeginDate() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_BEGINDATE);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenEndDate() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenDateEnd() : Date
      {
         var _loc2_:Date = null;
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(_loc1_))
         {
            return DateUtils.getDateByStr(_loc1_.Value);
         }
         return null;
      }
      
      public function get getWitchBlessGP() : Array
      {
         return this.findInfoByName(WITCH_BLESS_GP).Value.split("|");
      }
      
      public function get getWitchBlessDoubleGpTime() : String
      {
         return String(this.findInfoByName(WITCH_BLESS_DOUBLEGP_TIME).Value);
      }
      
      public function get getWitchBlessMoney() : int
      {
         return int(this.findInfoByName(WITCH_BLESS_MONEY).Value);
      }
   }
}

