package ddt.view.caddyII
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.caddyII.reader.AwardsInfo;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CaddyModel extends EventDispatcher
   {
      
      public static var _instance:CaddyModel;
      
      public static const Gold_Caddy:int = 4;
      
      public static const Silver_Caddy:int = 5;
      
      public static const CADDY_TYPE:int = 1;
      
      public static const BEAD_TYPE:int = 2;
      
      public static const OFFER_PACKET:int = 3;
      
      public static const CARD_TYPE:int = 6;
      
      public static const MYSTICAL_CARDBOX:int = 8;
      
      public static const MY_CARDBOX:int = 9;
      
      public static const CARDSOUL_BOX:int = 11;
      
      public static const BOMB_KING_BLESS:int = 10;
      
      public static const VIP_TYPE:int = 13;
      
      public static const CELEBRATION_BOX:int = 12;
      
      public static const AWARDS_NUMBER:int = 1000;
      
      public static const BEADTYPE_CHANGE:String = "beadType_change";
      
      public static const AWARDS_CHANGE:String = "awards_change";
      
      public static const BLESS_CHAGE:String = "bless_change";
      
      public static const CARDS_NAME:String = "cards_name";
      
      public static const Bead_Attack:int = 0;
      
      public static const Bead_Defense:int = 1;
      
      public static const Bead_Attribute:int = 2;
      
      public static const PACK_I:int = 0;
      
      public static const PACK_II:int = 1;
      
      public static const PACK_III:int = 2;
      
      public static const PACK_IV:int = 3;
      
      public static const PACK_V:int = 4;
      
      private var _type:int;
      
      private var _bagInfo:BagInfo;
      
      private var _beadType:int;
      
      private var _offerType:int;
      
      private var _boxName:Array = [LanguageMgr.GetTranslation("tank.view.caddy.boxNameCaddy"),LanguageMgr.GetTranslation("tank.view.caddy.boxNameBead"),LanguageMgr.GetTranslation("tank.view.caddy.boxNameGift")];
      
      private var _caddyTempId:Array;
      
      private var _CaddyType:int;
      
      public var _caddyBoxList:Vector.<InventoryItemInfo>;
      
      public var _attackList:Vector.<InventoryItemInfo>;
      
      public var _defenseList:Vector.<InventoryItemInfo>;
      
      public var _attributeList:Vector.<InventoryItemInfo>;
      
      public var awardsList:Vector.<AwardsInfo>;
      
      public var beadAwardsList:Vector.<AwardsInfo>;
      
      public var exploitList:Array;
      
      public function CaddyModel()
      {
         super();
         this.init();
      }
      
      public static function get instance() : CaddyModel
      {
         if(_instance == null)
         {
            _instance = new CaddyModel();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.awardsList = new Vector.<AwardsInfo>();
         this.beadAwardsList = new Vector.<AwardsInfo>();
         this._caddyBoxList = new Vector.<InventoryItemInfo>();
         this._attackList = new Vector.<InventoryItemInfo>();
         this._defenseList = new Vector.<InventoryItemInfo>();
         this._attributeList = new Vector.<InventoryItemInfo>();
         this.initExploitList();
         this.createData();
      }
      
      private function initExploitList() : void
      {
         this.exploitList = new Array();
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
      }
      
      public function setup(param1:int) : void
      {
         this._type = param1;
      }
      
      private function createData() : void
      {
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_ATTACK],this._attackList);
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_DEFENSE],this._defenseList);
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_ATTRIBUTE],this._attributeList);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_I],this.exploitList[0]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_II],this.exploitList[1]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_III],this.exploitList[2]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_IV],this.exploitList[3]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_V],this.exploitList[4]);
         this.sortBeadData();
      }
      
      private function createBeadData(param1:Vector.<BoxGoodsTempInfo>, param2:Vector.<InventoryItemInfo>) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            param2.push(this.createInfo(param1[_loc3_]));
            _loc3_++;
         }
      }
      
      private function createInfo(param1:BoxGoodsTempInfo) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = null;
         if(Boolean(param1))
         {
            _loc2_ = this.getTemplateInfo(param1.TemplateId) as InventoryItemInfo;
            _loc2_.StrengthenLevel = param1.StrengthenLevel;
            _loc2_.AttackCompose = param1.AttackCompose;
            _loc2_.DefendCompose = param1.DefendCompose;
            _loc2_.LuckCompose = param1.LuckCompose;
            _loc2_.AgilityCompose = param1.AgilityCompose;
            _loc2_.isShowBind = false;
            if(param1.TemplateId == 11025)
            {
               _loc2_.Count == 10;
            }
            else
            {
               _loc2_.Count = param1.ItemCount;
            }
            _loc2_.IsJudge = true;
         }
         return _loc2_;
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function sortBeadData() : void
      {
         this._attackList.sort(this.compareBeadDataFun);
         this._defenseList.sort(this.compareBeadDataFun);
         this._attributeList.sort(this.compareBeadDataFun);
      }
      
      private function compareFun(param1:BoxGoodsTempInfo, param2:BoxGoodsTempInfo) : int
      {
         if(param1.IsTips >= param2.IsTips)
         {
            return -1;
         }
         return 1;
      }
      
      private function compareBeadDataFun(param1:InventoryItemInfo, param2:InventoryItemInfo) : int
      {
         if(param1.TemplateID >= param2.TemplateID)
         {
            return -1;
         }
         return 1;
      }
      
      private function _addAwardsInfo(param1:String, param2:int, param3:Boolean = false, param4:String = "", param5:int = 0, param6:int = 0, param7:int = 1) : void
      {
         var _loc8_:AwardsInfo = new AwardsInfo();
         _loc8_.name = param1;
         _loc8_.TemplateId = param2;
         _loc8_.isLong = param3;
         _loc8_.zone = param4;
         _loc8_.zoneID = param5;
         _loc8_.channel = param6;
         _loc8_.count = param7;
         this.awardsList.unshift(_loc8_);
         if(this.awardsList.length > AWARDS_NUMBER)
         {
            this.awardsList.pop();
         }
      }
      
      private function _addBeadAwardsInfo(param1:String, param2:int, param3:Boolean = false, param4:String = "", param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:AwardsInfo = new AwardsInfo();
         _loc7_.name = param1;
         _loc7_.TemplateId = param2;
         _loc7_.isLong = param3;
         _loc7_.zone = param4;
         _loc7_.zoneID = param5;
         _loc7_.channel = param6;
         this.beadAwardsList.unshift(_loc7_);
         if(this.beadAwardsList.length > AWARDS_NUMBER)
         {
            this.beadAwardsList.pop();
         }
      }
      
      public function get tempid() : Array
      {
         return this._caddyTempId;
      }
      
      public function set tempid(param1:Array) : void
      {
         this._caddyTempId = param1;
      }
      
      private function fillListFromAward(param1:Vector.<CaddyAwardInfo>) : Vector.<InventoryItemInfo>
      {
         var _loc2_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc3_:DictionaryData = BossBoxManager.instance.boxTempIDList;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_[param1[_loc5_].TemplateID].ItemCount = param1[_loc5_].Count;
            _loc2_.push(this.createInfo(_loc3_[param1[_loc5_].TemplateID]));
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getCaddyTrophy(param1:int) : Vector.<InventoryItemInfo>
      {
         if(param1 == EquipType.Gold_Caddy || param1 == EquipType.GOLD_BLESS)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getGoldAwards());
         }
         if(param1 == EquipType.Silver_Caddy || param1 == EquipType.SILVER_BLESS)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getSilverAwards());
         }
         if(param1 == EquipType.BOMB_KING_BLESS)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getAwards());
         }
         if(param1 == EquipType.TREASURE_CADDY)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getTreasureAwards());
         }
         return this.fillListFromAward(CaddyAwardModel.getInstance().getAwards());
      }
      
      public function getOfferPacketThrophy(param1:int) : Vector.<InventoryItemInfo>
      {
         switch(param1)
         {
            case EquipType.OFFER_PACK_I:
               return this.exploitList[PACK_I];
            case EquipType.OFFER_PACK_II:
               return this.exploitList[PACK_II];
            case EquipType.OFFER_PACK_III:
               return this.exploitList[PACK_III];
            case EquipType.OFFER_PACK_IV:
               return this.exploitList[PACK_IV];
            case EquipType.OFFER_PACK_V:
               return this.exploitList[PACK_V];
            default:
               return null;
         }
      }
      
      public function getTrophyData() : Vector.<InventoryItemInfo>
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return this._caddyBoxList;
            case BEAD_TYPE:
               if(this.beadType == 0)
               {
                  return this._attackList;
               }
               if(this.beadType == 1)
               {
                  return this._defenseList;
               }
               return this._attributeList;
               break;
            case OFFER_PACKET:
               return this.exploitList[this._offerType];
            default:
               return this._caddyBoxList;
         }
      }
      
      public function appendAwardsInfo(param1:String, param2:int, param3:Boolean = false, param4:String = "", param5:int = 0, param6:int = 0) : void
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               if(param6 == 3)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
               break;
            case CELEBRATION_BOX:
               if(param6 == 14)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
               break;
            case BEAD_TYPE:
               if(param6 == 4)
               {
                  this._addBeadAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(BEADTYPE_CHANGE));
               }
               break;
            case OFFER_PACKET:
               if(param6 == 5)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
               break;
            case BOMB_KING_BLESS:
               if(param6 == 11)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(BLESS_CHAGE));
               }
         }
      }
      
      public function addAwardsInfoByArr(param1:Vector.<AwardsInfo>) : void
      {
         var _loc2_:int = param1.length > AWARDS_NUMBER ? AWARDS_NUMBER : int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._addAwardsInfo(param1[_loc3_].name,param1[_loc3_].TemplateId,param1[_loc3_].isLong,param1[_loc3_].zone,param1[_loc3_].zoneID,param1[_loc3_].channel,param1[_loc3_].count);
            _loc3_++;
         }
         dispatchEvent(new Event(AWARDS_CHANGE));
      }
      
      public function addBlessInfoByArr(param1:Vector.<AwardsInfo>) : void
      {
         var _loc2_:int = param1.length > AWARDS_NUMBER ? AWARDS_NUMBER : int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._addAwardsInfo(param1[_loc3_].name,param1[_loc3_].TemplateId,param1[_loc3_].isLong,param1[_loc3_].zone,param1[_loc3_].zoneID,param1[_loc3_].channel,param1[_loc3_].count);
            _loc3_++;
         }
         dispatchEvent(new Event(BLESS_CHAGE));
      }
      
      public function clearAwardsList() : void
      {
         this.awardsList.splice(0,this.awardsList.length);
         this.awardsList = new Vector.<AwardsInfo>();
      }
      
      public function get bagInfo() : BagInfo
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return PlayerManager.Instance.Self.CaddyBag;
            case BEAD_TYPE:
               return PlayerManager.Instance.Self.CaddyBag;
            default:
               return PlayerManager.Instance.Self.CaddyBag;
         }
      }
      
      public function get rightView() : RightView
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.CaddyViewII");
            case CELEBRATION_BOX:
               return ComponentFactory.Instance.creatCustomObject("celebration.CelebrationBoxView");
            case BEAD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("bead.BeadViewII");
            case MYSTICAL_CARDBOX:
               return ComponentFactory.Instance.creatCustomObject("caddy.CaddyViewII");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("offer.OfferPackViewII");
            case MY_CARDBOX:
               return ComponentFactory.Instance.creatCustomObject("caddy.CaddyViewII");
            case BOMB_KING_BLESS:
               return ComponentFactory.Instance.creatCustomObject("caddy.BLESSViewI");
            default:
               return ComponentFactory.Instance.creatCustomObject("offer.OfferPackViewII");
         }
      }
      
      public function get readView() : CaddyUpdate
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.BadLuckView",[CADDY_TYPE]);
            case BEAD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
            case CELEBRATION_BOX:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
            case MY_CARDBOX:
            case MYSTICAL_CARDBOX:
            case CARDSOUL_BOX:
            case CARD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsViewI");
            case BOMB_KING_BLESS:
               return ComponentFactory.Instance.creatCustomObject("caddy.BlessLuckView");
            default:
               return ComponentFactory.Instance.creatCustomObject("caddy.BlessLuckView");
         }
      }
      
      public function get moveSprite() : Sprite
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.moveSprite");
            case BEAD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("bead.moveSprite");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("bead.moveSprite");
            case VIP_TYPE:
               return ComponentFactory.Instance.creatCustomObject("bead.moveSprite");
            default:
               return ComponentFactory.Instance.creatCustomObject("caddy.moveSprite");
         }
      }
      
      public function get caddyType() : int
      {
         return this._CaddyType;
      }
      
      public function set caddyType(param1:int) : void
      {
         this._CaddyType = param1;
      }
      
      public function get beadType() : int
      {
         return this._beadType;
      }
      
      public function set beadType(param1:int) : void
      {
         switch(param1)
         {
            case EquipType.BEAD_ATTACK:
               this._beadType = Bead_Attack;
               break;
            case EquipType.BEAD_DEFENSE:
               this._beadType = Bead_Defense;
               break;
            case EquipType.BEAD_ATTRIBUTE:
               this._beadType = Bead_Attribute;
               break;
            default:
               this._beadType = param1;
         }
         dispatchEvent(new Event(BEADTYPE_CHANGE));
      }
      
      public function set offerType(param1:int) : void
      {
         switch(param1)
         {
            case EquipType.OFFER_PACK_I:
               this._offerType = PACK_I;
               break;
            case EquipType.OFFER_PACK_II:
               this._offerType = PACK_II;
               break;
            case EquipType.OFFER_PACK_III:
               this._offerType = PACK_III;
               break;
            case EquipType.OFFER_PACK_IV:
               this._offerType = PACK_IV;
               break;
            case EquipType.OFFER_PACK_V:
               this._offerType = PACK_V;
               break;
            default:
               this._offerType = 0;
         }
      }
      
      public function get offerType() : int
      {
         return this._offerType;
      }
      
      public function get CaddyFrameTitle() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.title");
            case CELEBRATION_BOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.celebrationTitle");
            case BEAD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.bead.title");
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.game.GameView.cardBoxBattle");
            case CARD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.card.title");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.game.GameView.cardBoxBattle1");
            case BOMB_KING_BLESS:
               return LanguageMgr.GetTranslation("tank.view.BOMO.title");
            default:
               return null;
         }
      }
      
      public function get dontClose() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.dontClose");
            case CELEBRATION_BOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.celebrationClose");
            case BEAD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.bead.dontClose");
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.view.offer.dontClose");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.cardBoxDontClose");
            case CARD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.card.dontClose");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.cardBoxDontClose");
            case BOMB_KING_BLESS:
               return LanguageMgr.GetTranslation("tank.view.caddy.BlessClose");
            default:
               return null;
         }
      }
      
      public function get AwardsBuff() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCaddy");
            case CELEBRATION_BOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCelebration");
            case BEAD_TYPE:
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.view.offer.opendGetAwards");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCardBox");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCardBox");
            case BOMB_KING_BLESS:
               return LanguageMgr.GetTranslation("tank.view.caddy.openBless");
            case VIP_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.openVip");
            default:
               return LanguageMgr.GetTranslation("tank.view.caddy.openBless");
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
   }
}

