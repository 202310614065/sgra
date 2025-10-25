package ddt.data.goods
{
   import ddt.data.EquipType;
   import ddt.events.GoodsEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import gemstone.info.GemstListInfo;
   import magicStone.data.MagicStoneInfo;
   import road7th.utils.DateUtils;
   import store.forge.wishBead.WishBeadManager;
   import store.forge.wishBead.WishChangeInfo;
   
   public class InventoryItemInfo extends ItemTemplateInfo
   {
      
      private static var _isTimerStarted:Boolean = false;
      
      private static var _temp_Instances:Array = new Array();
      
      private var _checkTimeOutTimer:Timer;
      
      private var _checkColorValidTimer:Timer;
      
      private var _checkTimePackTimer:Timer;
      
      public var ItemID:Number;
      
      public var UserID:Number;
      
      public var IsBinds:Boolean;
      
      public var isDeleted:Boolean;
      
      public var BagType:int;
      
      public var type:int;
      
      public var isInvalid:Boolean;
      
      public var lock:Boolean = false;
      
      public var goodsLock:Boolean = false;
      
      public var Color:String;
      
      public var Skin:String;
      
      public var isMoveSpace:Boolean = true;
      
      private var _isUsed:Boolean;
      
      public var BeginDate:String;
      
      protected var _ValidDate:Number;
      
      public var isConversion:Boolean = false;
      
      private var _isGetTimePack:Boolean;
      
      private var _DiscolorValidDate:String;
      
      private var atLeastOnHour:Boolean;
      
      private var _count:int = 1;
      
      private var _exaltLevel:int;
      
      public var _StrengthenLevel:int;
      
      public var _StrengthenExp:int;
      
      private var _isGold:Boolean;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var Boold:int;
      
      public var Bless:int;
      
      private var _goldValidDate:int;
      
      private var _goldBeginTime:String;
      
      public var IsJudge:Boolean;
      
      public var Place:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var lockType:int;
      
      public var Hole1:int = -1;
      
      public var Hole2:int = -1;
      
      public var Hole3:int = -1;
      
      public var Hole4:int = -1;
      
      public var Hole5:int = -1;
      
      public var Hole6:int = -1;
      
      public var Hole5Level:int;
      
      public var Hole5Exp:int = 0;
      
      public var Hole6Level:int;
      
      public var Hole6Exp:int = 0;
      
      public var beadExp:int;
      
      public var beadLevel:int = 1;
      
      public var beadIsLock:int;
      
      public var isShowBind:Boolean = true;
      
      public var gemstoneList:Vector.<GemstListInfo>;
      
      public var latentEnergyCurStr:String = "0,0,0,0";
      
      public var latentEnergyNewStr:String = "0,0,0,0";
      
      public var latentEnergyEndTime:Date;
      
      public var magicStoneAttr:MagicStoneInfo;
      
      public function InventoryItemInfo()
      {
         super();
         if(!_isTimerStarted)
         {
            _temp_Instances.push(this);
         }
      }
      
      public static function startTimer() : void
      {
         var _loc1_:InventoryItemInfo = null;
         if(!_isTimerStarted)
         {
            _isTimerStarted = true;
            for each(_loc1_ in _temp_Instances)
            {
               _loc1_.updateRemainDate();
            }
            _temp_Instances = null;
         }
      }
      
      public function get IsUsed() : Boolean
      {
         return this._isUsed;
      }
      
      public function setIsUsed(param1:Boolean) : void
      {
         this._isUsed = param1;
      }
      
      public function set IsUsed(param1:Boolean) : void
      {
         isBeadLocked = param1;
         if(this._isUsed == param1)
         {
            return;
         }
         this._isUsed = param1;
         if(this._isUsed && _isTimerStarted)
         {
            this.updateRemainDate();
         }
      }
      
      override public function set Property5(param1:String) : void
      {
         _property5 = param1;
         this.transformValidDate();
      }
      
      public function set ValidDate(param1:Number) : void
      {
         this.isConversion = false;
         this._ValidDate = param1;
         this.transformValidDate();
      }
      
      private function transformValidDate() : void
      {
         if(!EquipType.isPropertyWater(this))
         {
            return;
         }
         if(!this.isConversion)
         {
            switch(int(Property5))
            {
               case 1:
                  break;
               case 2:
                  this._ValidDate /= 24;
                  this.isConversion = true;
                  break;
               case 3:
                  this._ValidDate /= 24 * 60;
                  this.isConversion = true;
            }
         }
      }
      
      public function get ValidDate() : Number
      {
         return this._ValidDate;
      }
      
      public function get isGetTimePack() : Boolean
      {
         return this._isGetTimePack;
      }
      
      public function getRemainDate() : Number
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(this.ValidDate == 0)
         {
            return int.MAX_VALUE;
         }
         if(!this._isUsed)
         {
            return this.ValidDate;
         }
         _loc1_ = DateUtils.getDateByStr(this.BeginDate);
         _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         return this.ValidDate - _loc2_;
      }
      
      public function getColorValidDate() : Number
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(!this._isUsed)
         {
            return int.MAX_VALUE;
         }
         _loc1_ = DateUtils.getDateByStr(this.DiscolorValidDate);
         return TimeManager.Instance.TotalDaysToNow(_loc1_) * -1;
      }
      
      public function set DiscolorValidDate(param1:String) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         this._DiscolorValidDate = param1;
         if(RefineryLevel >= 3 && this._isUsed)
         {
            _loc2_ = DateUtils.getDateByStr(this.DiscolorValidDate);
            _loc3_ = _loc2_.time - TimeManager.Instance.Now().time;
            if(_loc3_ <= 0)
            {
               SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
            }
            else
            {
               this.updateDiscolorValidDate();
            }
         }
      }
      
      public function get DiscolorValidDate() : String
      {
         return this._DiscolorValidDate;
      }
      
      private function updateDiscolorValidDate() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this.DiscolorValidDate);
         var _loc2_:Number = _loc1_.time - TimeManager.Instance.Now().time;
         if(this._checkColorValidTimer != null)
         {
            this._checkColorValidTimer.stop();
            this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
            this._checkColorValidTimer = null;
         }
         this._checkColorValidTimer = new Timer(_loc2_,1);
         this._checkColorValidTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.start();
      }
      
      private function updateRemainDate() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         if(this.ValidDate != 0 && this._isUsed)
         {
            _loc1_ = DateUtils.getDateByStr(this.BeginDate);
            _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_);
            _loc3_ = this.ValidDate - _loc2_;
            if(_loc3_ > 0)
            {
               if(this._checkTimeOutTimer != null)
               {
                  this._checkTimeOutTimer.stop();
                  this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
                  this._checkTimeOutTimer = null;
               }
               this.checkTimePcak(_loc3_);
               this.atLeastOnHour = _loc3_ * 24 > 1;
               _loc4_ = this.atLeastOnHour ? uint(_loc3_ * TimeManager.DAY_TICKS - 1 * 60 * 60 * 1000) : uint(_loc3_ * TimeManager.DAY_TICKS);
               this._checkTimeOutTimer = new Timer(_loc4_,1);
               this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
               this._checkTimeOutTimer.start();
            }
            else
            {
               if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
               {
                  if(PlayerManager.Instance.Self.pets.length > 0)
                  {
                     for(_loc5_ in PlayerManager.Instance.Self.pets)
                     {
                        SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[_loc5_].Place,this.Place);
                     }
                  }
                  return;
               }
               SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            }
         }
      }
      
      private function checkTimePcak(param1:Number) : void
      {
         var _loc2_:uint = 0;
         if(this._checkTimePackTimer != null)
         {
            this._checkTimePackTimer.stop();
            this._checkTimePackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._checkTimePackTimer = null;
         }
         if(TemplateID >= 1120098 && TemplateID <= 1120101)
         {
            if(param1 * TimeManager.DAY_TICKS <= 30 * 60 * 1000)
            {
               ChatManager.Instance.addTimePackTip(Name);
               return;
            }
            _loc2_ = param1 * TimeManager.DAY_TICKS - 30 * 60 * 1000;
            this._checkTimePackTimer = new Timer(_loc2_,1);
            this._checkTimePackTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerPackComplete);
            this._checkTimePackTimer.start();
         }
      }
      
      protected function __timerPackComplete(param1:TimerEvent) : void
      {
         this._checkTimePackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerPackComplete);
         this._checkTimePackTimer.stop();
         ChatManager.Instance.addTimePackTip(Name);
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._checkTimeOutTimer.stop();
         if(!this.IsBinds)
         {
            return;
         }
         if(TemplateID >= 1120098 && TemplateID <= 1120101)
         {
            ChatManager.Instance.addTimePackTip(Name);
         }
         if(this.atLeastOnHour)
         {
            this._checkTimeOutTimer.delay = 10000 + 1 * 60 * 60 * 1000;
         }
         else
         {
            this._checkTimeOutTimer.delay = 10000;
         }
         this._checkTimeOutTimer.reset();
         this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
         this._checkTimeOutTimer.start();
      }
      
      private function _timerColorComplete(param1:TimerEvent) : void
      {
         this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.stop();
         SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
      }
      
      private function __sendGoodsTimeOut(param1:TimerEvent) : void
      {
         var _loc2_:* = undefined;
         if(StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
            {
               if(PlayerManager.Instance.Self.pets.length > 0)
               {
                  for(_loc2_ in PlayerManager.Instance.Self.pets)
                  {
                     SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[_loc2_].Place,this.Place);
                  }
               }
               return;
            }
            SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
            this._checkTimeOutTimer.stop();
         }
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(param1:int) : void
      {
         if(this._count == param1)
         {
            return;
         }
         this._count = param1;
         dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE,"Count",this._count));
      }
      
      public function clone() : InventoryItemInfo
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         return _loc1_.readObject();
      }
      
      public function set exaltLevel(param1:int) : void
      {
         this._exaltLevel = param1;
      }
      
      public function get exaltLevel() : int
      {
         return this._exaltLevel;
      }
      
      public function set StrengthenLevel(param1:int) : void
      {
         this._StrengthenLevel = param1;
      }
      
      public function get StrengthenLevel() : int
      {
         return this._StrengthenLevel;
      }
      
      public function set StrengthenExp(param1:int) : void
      {
         this._StrengthenExp = param1;
      }
      
      public function get StrengthenExp() : int
      {
         return this._StrengthenExp;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(param1:Boolean) : void
      {
         var _loc2_:WishChangeInfo = null;
         this._isGold = param1;
         if(this._isGold)
         {
            _loc2_ = WishBeadManager.instance.getWishInfoByTemplateID(TemplateID,CategoryID);
            if(!_loc2_)
            {
               return;
            }
            Attack = _loc2_.Attack > 0 ? _loc2_.Attack : Attack;
            Defence = _loc2_.Defence > 0 ? _loc2_.Defence : Defence;
            Agility = _loc2_.Agility > 0 ? _loc2_.Agility : Agility;
            Luck = _loc2_.Luck > 0 ? _loc2_.Luck : Luck;
            this.Damage = _loc2_.Damage >= 0 ? _loc2_.Damage : this.Damage;
            this.Guard = _loc2_.Guard >= 0 ? _loc2_.Guard : this.Guard;
            this.Boold = _loc2_.Boold >= 0 ? _loc2_.Boold : this.Boold;
            this.Bless = _loc2_.BlessID;
            Pic = _loc2_.Pic != "" ? _loc2_.Pic : Pic;
         }
      }
      
      public function get goldValidDate() : int
      {
         return this._goldValidDate;
      }
      
      public function set goldValidDate(param1:int) : void
      {
         this._goldValidDate = param1;
      }
      
      public function get goldBeginTime() : String
      {
         return this._goldBeginTime;
      }
      
      public function set goldBeginTime(param1:String) : void
      {
         this._goldBeginTime = param1;
      }
      
      public function getGoldRemainDate() : Number
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._goldBeginTime);
         var _loc2_:Number = TimeManager.Instance.TotalDaysToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         return this.goldValidDate - _loc2_;
      }
      
      public function get isHasLatentEnergy() : Boolean
      {
         if(!this.latentEnergyEndTime || this.latentEnergyEndTime.getTime() <= TimeManager.Instance.Now().getTime())
         {
            return false;
         }
         var _loc1_:Array = this.latentEnergyCurList;
         if(_loc1_[0] == "0" || _loc1_[1] == "0" || _loc1_[2] == "0" || _loc1_[3] == "0")
         {
            return false;
         }
         return true;
      }
      
      public function get latentEnergyCurList() : Array
      {
         if(!this.isCanLatentEnergy)
         {
            this.latentEnergyCurStr = "0,0,0,0";
         }
         if(this.latentEnergyCurStr == "")
         {
            this.latentEnergyCurStr = "0,0,0,0";
         }
         return this.latentEnergyCurStr.split(",");
      }
      
      public function get latentEnergyNewList() : Array
      {
         if(this.latentEnergyNewStr == "")
         {
            this.latentEnergyNewStr = "0,0,0,0";
         }
         if(!this.isHasLatentEnergy)
         {
            this.latentEnergyNewStr = "0,0,0,0";
         }
         return this.latentEnergyNewStr.split(",");
      }
      
      public function get isHasLatenetEnergyNew() : Boolean
      {
         var _loc1_:Array = this.latentEnergyNewList;
         if(_loc1_[0] == "0" || _loc1_[1] == "0" || _loc1_[2] == "0" || _loc1_[3] == "0")
         {
            return false;
         }
         return true;
      }
      
      public function get isCanLatentEnergy() : Boolean
      {
         if(CategoryID == EquipType.HAIR || CategoryID == EquipType.SUITS || CategoryID == EquipType.GLASS || CategoryID == EquipType.EFF || CategoryID == EquipType.FACE || CategoryID == EquipType.WING)
         {
            return true;
         }
         return false;
      }
      
      public function get hasComposeAttribte() : Boolean
      {
         return this.AttackCompose > 0 || this.DefendCompose > 0 || this.LuckCompose > 0 || this.AgilityCompose > 0;
      }
   }
}

