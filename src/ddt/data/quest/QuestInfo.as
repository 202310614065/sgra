package ddt.data.quest
{
   import com.pickgliss.utils.StringUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import quest.TrusteeshipManager;
   import road7th.utils.DateUtils;
   
   public class QuestInfo
   {
      
      public static const PET:int = 0;
      
      public var QuestID:int;
      
      public var data:QuestDataInfo;
      
      public var Detail:String;
      
      public var Objective:String;
      
      public var otherCondition:int;
      
      public var Level:int;
      
      public var NeedMinLevel:int;
      
      public var NeedMaxLevel:int;
      
      public var required:Boolean = false;
      
      public var Type:int;
      
      public var PreQuestID:String;
      
      public var NextQuestID:String;
      
      public var CanRepeat:Boolean;
      
      public var RepeatInterval:int;
      
      public var RepeatMax:int;
      
      public var Title:String;
      
      public var disabled:Boolean = false;
      
      public var optionalConditionNeed:uint = 0;
      
      public var _conditions:Array;
      
      private var _itemRewards:Array;
      
      public var StrengthenLevel:int;
      
      public var FinishCount:int;
      
      public var ReqItemID:int;
      
      public var ReqKillLevel:int;
      
      public var ReqBeCaption:Boolean;
      
      public var ReqMap:int;
      
      public var ReqFightMode:int;
      
      public var ReqTimeMode:int;
      
      public var RewardGold:int;
      
      public var RewardMoney:int;
      
      public var RewardGP:int;
      
      public var OneKeyFinishNeedMoney:int;
      
      public var TrusteeshipCost:int;
      
      public var TrusteeshipNeedTime:int;
      
      public var RewardOffer:int;
      
      public var RewardRiches:int;
      
      public var RewardBindMoney:int;
      
      public var RewardBuffID:int;
      
      public var RewardBuffDate:int;
      
      public var Rank:String;
      
      public var Level2NeedMoney:int;
      
      public var Level3NeedMoney:int;
      
      public var Level4NeedMoney:int;
      
      public var Level5NeedMoney:int;
      
      public var MapID:int;
      
      public var AutoEquip:Boolean;
      
      public var StarLev:int;
      
      private var _questLevel:int;
      
      public var TimeLimit:Boolean;
      
      public var StartDate:Date;
      
      public var EndDate:Date;
      
      public var BuffID:int;
      
      public var BuffValidDate:int;
      
      public function QuestInfo()
      {
         super();
      }
      
      public static function createFromXML(param1:XML) : QuestInfo
      {
         var _loc7_:XML = null;
         var _loc8_:QuestCondition = null;
         var _loc9_:XML = null;
         var _loc10_:Array = null;
         var _loc11_:QuestItemReward = null;
         var _loc2_:QuestInfo = new QuestInfo();
         _loc2_.QuestID = param1.@ID;
         _loc2_.Type = param1.@QuestID;
         _loc2_.Detail = param1.@Detail;
         _loc2_.Title = param1.@Title;
         _loc2_.Objective = param1.@Objective;
         _loc2_.StarLev = param1.@StarLev;
         _loc2_.QuestLevel = param1.@QuestLevel;
         _loc2_.NeedMinLevel = param1.@NeedMinLevel;
         _loc2_.NeedMaxLevel = param1.@NeedMaxLevel;
         _loc2_.PreQuestID = param1.@PreQuestID;
         _loc2_.NextQuestID = param1.@NextQuestID;
         _loc2_.CanRepeat = param1.@CanRepeat == "true" ? true : false;
         _loc2_.RepeatInterval = param1.@RepeatInterval;
         _loc2_.RepeatMax = param1.@RepeatMax;
         _loc2_.RewardGold = param1.@RewardGold;
         _loc2_.RewardGP = param1.@RewardGP;
         _loc2_.RewardMoney = param1.@RewardMoney;
         _loc2_.OneKeyFinishNeedMoney = param1.@OneKeyFinishNeedMoney;
         _loc2_.TrusteeshipCost = param1.@CollocationCost;
         _loc2_.TrusteeshipNeedTime = param1.@CollocationColdTime;
         _loc2_.Rank = param1.@Rank;
         _loc2_.RewardOffer = param1.@RewardOffer;
         _loc2_.RewardRiches = param1.@RewardRiches;
         _loc2_.RewardBindMoney = param1.@RewardBindMoney;
         _loc2_.TimeLimit = param1.@TimeMode;
         _loc2_.RewardBuffID = param1.@RewardBuffID;
         _loc2_.RewardBuffDate = param1.@RewardBuffDate;
         _loc2_.Level2NeedMoney = param1.@Level2NeedMoney;
         _loc2_.Level3NeedMoney = param1.@Level3NeedMoney;
         _loc2_.Level4NeedMoney = param1.@Level4NeedMoney;
         _loc2_.Level5NeedMoney = param1.@Level5NeedMoney;
         _loc2_.otherCondition = param1.@IsOther;
         _loc2_.StartDate = DateUtils.decodeDated(String(param1.@StartDate));
         _loc2_.EndDate = DateUtils.decodeDated(String(param1.@EndDate));
         _loc2_.MapID = param1.@MapID;
         _loc2_.AutoEquip = StringUtils.converBoolean(param1.@AutoEquip);
         _loc2_.optionalConditionNeed = param1.@NotMustCount;
         var _loc3_:XMLList = param1..Item_Condiction;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc7_ = _loc3_[_loc4_];
            _loc8_ = new QuestCondition(_loc2_.QuestID,_loc7_.@CondictionID,_loc7_.@CondictionType,_loc7_.@CondictionTitle,_loc7_.@Para1,_loc7_.@Para2);
            if(_loc7_.@isOpitional == "true")
            {
               _loc8_.isOpitional = true;
            }
            else
            {
               _loc8_.isOpitional = false;
            }
            loop3:
            switch(_loc8_.type)
            {
               case 1:
                  TaskManager.instance.addGradeListener();
                  break;
               case 2:
               case 14:
               case 15:
               case 99:
                  TaskManager.instance.addItemListener(_loc8_.param);
                  break;
               case 18:
                  break;
               case 20:
                  switch(_loc8_.param)
                  {
                     case 1:
                        if(!_loc2_.isTimeOut())
                        {
                           TaskManager.instance.addDesktopListener(_loc8_);
                        }
                        break loop3;
                     case 2:
                        TaskManager.instance.addAnnexListener(_loc8_);
                        break loop3;
                     case 3:
                        TaskManager.instance.addFriendListener(_loc8_);
                        break loop3;
                     case 4:
                        break loop3;
                     default:
                        break loop3;
                  }
            }
            _loc2_.addCondition(_loc8_);
            _loc4_++;
         }
         var _loc5_:XMLList = param1..Item_Good;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length())
         {
            _loc9_ = _loc5_[_loc6_];
            _loc10_ = new Array(int(_loc9_.@RewardItemCount1),int(_loc9_.@RewardItemCount2),int(_loc9_.@RewardItemCount3),int(_loc9_.@RewardItemCount4),int(_loc9_.@RewardItemCount5));
            _loc11_ = new QuestItemReward(_loc9_.@RewardItemID,_loc10_,_loc9_.@IsSelect,_loc9_.@IsBind);
            _loc11_.time = _loc9_.@RewardItemValid;
            _loc11_.AttackCompose = _loc9_.@AttackCompose;
            _loc11_.DefendCompose = _loc9_.@DefendCompose;
            _loc11_.AgilityCompose = _loc9_.@AgilityCompose;
            _loc11_.LuckCompose = _loc9_.@LuckCompose;
            _loc11_.StrengthenLevel = _loc9_.@StrengthenLevel;
            _loc11_.IsCount = _loc9_.@IsCount;
            _loc2_.addReward(_loc11_);
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function get QuestLevel() : int
      {
         return this._questLevel;
      }
      
      public function set QuestLevel(param1:int) : void
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > 5)
         {
            param1 = 5;
         }
         this._questLevel = param1;
      }
      
      public function get RewardItemCount() : int
      {
         return this._itemRewards[0].count;
      }
      
      public function get RewardItemValidate() : int
      {
         return this._itemRewards[0].count;
      }
      
      public function get itemRewards() : Array
      {
         return this._itemRewards;
      }
      
      public function get Id() : int
      {
         return this.QuestID;
      }
      
      public function get hadChecked() : Boolean
      {
         if(Boolean(this.data) && this.data.hadChecked)
         {
            return true;
         }
         return false;
      }
      
      public function set hadChecked(param1:Boolean) : void
      {
         if(Boolean(this.data))
         {
            this.data.hadChecked = param1;
         }
      }
      
      public function BuffName() : String
      {
         return ItemManager.Instance.getTemplateById(this.BuffID).Name;
      }
      
      public function addCondition(param1:QuestCondition) : void
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         this._conditions.push(param1);
      }
      
      public function addReward(param1:QuestItemReward) : void
      {
         if(!this._itemRewards)
         {
            this._itemRewards = new Array();
         }
         this._itemRewards.push(param1);
      }
      
      public function texpTaskIsTimeOut() : Boolean
      {
         if(this.Type > 100 && Boolean(PlayerManager.Instance.Self.texpTaskDate))
         {
            return TimeManager.Instance.Now().getDate() != PlayerManager.Instance.Self.texpTaskDate.getDate();
         }
         return false;
      }
      
      public function isTimeOut() : Boolean
      {
         if(this.Id == 538 && PathManager.solveClientDownloadPath() == "")
         {
            return true;
         }
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Date = new Date(1990,1,1,_loc1_.getHours(),_loc1_.getMinutes(),_loc1_.getSeconds());
         var _loc3_:Date = new Date(1990,1,1,this.StartDate.getHours(),this.StartDate.getMinutes(),this.StartDate.getSeconds());
         var _loc4_:Date = new Date(1990,1,1,this.EndDate.getHours(),this.EndDate.getMinutes(),this.EndDate.getSeconds());
         if(_loc1_.time > this.EndDate.time || _loc1_.time < this.StartDate.time)
         {
            return true;
         }
         return false;
      }
      
      public function get id() : int
      {
         return this.QuestID;
      }
      
      public function get Condition() : int
      {
         return this._conditions[0].type;
      }
      
      public function get RewardItemID() : int
      {
         return this._itemRewards[0].itemID;
      }
      
      public function get RewardItemValidateTime() : int
      {
         return this._itemRewards[0].time;
      }
      
      public function isAvailableFor(param1:SelfInfo) : Boolean
      {
         return false;
      }
      
      public function get isAvailable() : Boolean
      {
         if(!this.isAchieved)
         {
            return true;
         }
         if(!this.CanRepeat)
         {
            return false;
         }
         if(TimeManager.Instance.TotalDaysToNow2(this.data.CompleteDate) < this.RepeatInterval)
         {
            if(this.data.repeatLeft < 1 && !this.data.isExist)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isAchieved() : Boolean
      {
         if(!this.data || !this.data.isAchieved)
         {
            return false;
         }
         return true;
      }
      
      private function getProgressById(param1:uint) : uint
      {
         var _loc2_:SelfInfo = null;
         var _loc3_:QuestCondition = null;
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:InventoryItemInfo = null;
         var _loc14_:InventoryItemInfo = null;
         _loc2_ = PlayerManager.Instance.Self;
         _loc3_ = this.getConditionById(param1);
         var _loc4_:int = 0;
         if(this.data == null || this.data.progress[param1] == null)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = int(this.data.progress[param1]);
         }
         var _loc5_:int = _loc3_.type;
         switch(_loc5_)
         {
            case 1:
               _loc4_ = _loc2_.Grade;
               break;
            case 2:
               _loc4_ = 0;
               _loc6_ = _loc2_.getBag(BagInfo.EQUIPBAG).findEquipedItemByTemplateId(_loc3_.param,false);
               if(Boolean(_loc6_) && _loc6_.Place <= 30)
               {
                  _loc4_ = 1;
               }
               break;
            case 9:
               _loc4_ = 0;
               _loc7_ = _loc2_.getBag(BagInfo.EQUIPBAG).findItemsForEach(_loc3_.param);
               _loc8_ = _loc2_.getBag(BagInfo.STOREBAG).findItemsForEach(_loc3_.param);
               for each(_loc13_ in _loc7_)
               {
                  if(_loc13_.StrengthenLevel >= _loc3_.target)
                  {
                     _loc4_ = _loc3_.target;
                     break;
                  }
               }
               for each(_loc14_ in _loc8_)
               {
                  if(_loc14_.StrengthenLevel >= _loc3_.target)
                  {
                     _loc4_ = _loc3_.target;
                     break;
                  }
               }
               break;
            case 14:
            case 15:
               _loc9_ = _loc2_.getBag(BagInfo.EQUIPBAG).getItemCountByTemplateId(_loc3_.param,false);
               _loc10_ = _loc2_.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(_loc3_.param,false);
               _loc4_ = _loc9_ + _loc10_;
               break;
            case 16:
               _loc4_ = 1;
               break;
            case 17:
               _loc4_ = _loc2_.IsMarried ? 1 : 0;
               break;
            case 18:
               switch(_loc3_.param)
               {
                  case 0:
                     if(ConsortionModelControl.Instance.model.memberList.length > 0)
                     {
                        _loc4_ = ConsortionModelControl.Instance.model.memberList.length;
                     }
                     break;
                  case 1:
                     if(Boolean(PlayerManager.Instance.Self.UseOffer))
                     {
                        _loc4_ = PlayerManager.Instance.Self.UseOffer;
                     }
                     break;
                  case 2:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.SmithLevel))
                     {
                        _loc4_ = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
                     }
                     break;
                  case 3:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.ShopLevel))
                     {
                        _loc4_ = PlayerManager.Instance.Self.consortiaInfo.ShopLevel;
                     }
                     break;
                  case 4:
                     if(Boolean(PlayerManager.Instance.Self.consortiaInfo.StoreLevel))
                     {
                        _loc4_ = PlayerManager.Instance.Self.consortiaInfo.StoreLevel;
                     }
               }
               break;
            case 20:
               _loc4_ = _loc3_.target - this.data.progress[param1];
               if(_loc3_.param == 3)
               {
                  _loc4_ = PlayerManager.Instance.friendList.length;
               }
               break;
            case 21:
               _loc4_ = _loc3_.target - 1;
               if(this.data && this.data.progress[param1] < _loc3_.target && this.data.progress[param1] >= 0)
               {
                  _loc4_ = _loc3_.target;
               }
               break;
            case 99:
               _loc11_ = _loc2_.getBag(BagInfo.EQUIPBAG).getBagItemCountByTemplateId(_loc3_.param,false);
               _loc12_ = _loc2_.getBag(BagInfo.PROPBAG).getBagItemCountByTemplateId(_loc3_.param,false);
               _loc4_ = _loc11_ + _loc12_;
               break;
            default:
               if(this.data == null || this.data.progress[param1] == null)
               {
                  _loc4_ = 0;
                  break;
               }
               _loc4_ = int(this.data.progress[param1]);
         }
         if(_loc4_ > _loc3_.target)
         {
            return 0;
         }
         return _loc3_.target - _loc4_;
      }
      
      public function get progress() : Array
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(Boolean(this._conditions[_loc2_]))
         {
            _loc1_[_loc2_] = this.getProgressById(_loc2_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get conditionStatus() : Array
      {
         var _loc3_:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(Boolean(this._conditions[_loc2_]))
         {
            _loc3_ = int(this.progress[_loc2_]);
            if(_loc3_ <= 0 || this.isCompleted)
            {
               _loc1_[_loc2_] = LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
            }
            else if(this._conditions[_loc2_].type == 9 || this._conditions[_loc2_].type == 12 || this._conditions[_loc2_].type == 17 || this._conditions[_loc2_].type == 21 || this._conditions[_loc2_].type == 50)
            {
               _loc1_[_loc2_] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else if(this._conditions[_loc2_].type == 20 && this._conditions[_loc2_].param == 2)
            {
               _loc1_[_loc2_] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else
            {
               _loc1_[_loc2_] = "(" + String(this._conditions[_loc2_].target - _loc3_) + "/" + String(this._conditions[_loc2_].target) + ")";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get conditionDescription() : Array
      {
         var _loc3_:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(Boolean(this._conditions[_loc2_]))
         {
            _loc3_ = int(this.progress[_loc2_]);
            if(_loc3_ <= 0 || this.isCompleted)
            {
               _loc1_[_loc2_] = this._conditions[_loc2_].description + LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
            }
            else if(this._conditions[_loc2_].type == 9 || this._conditions[_loc2_].type == 12 || this._conditions[_loc2_].type == 21)
            {
               _loc1_[_loc2_] = this._conditions[_loc2_].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else if(this._conditions[_loc2_].type == 20 && this._conditions[_loc2_].param == 2)
            {
               _loc1_[_loc2_] = this._conditions[_loc2_].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
            }
            else
            {
               _loc1_[_loc2_] = this._conditions[_loc2_].description + "(" + String(this._conditions[_loc2_].target - _loc3_) + "/" + String(this._conditions[_loc2_].target) + ")";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get isCompleted() : Boolean
      {
         var _loc1_:QuestCondition = null;
         if(TrusteeshipManager.instance.isTrusteeshipQuestEnd(this.id))
         {
            return true;
         }
         if(this.Type == 4)
         {
            if(!PlayerManager.Instance.Self.IsVIP)
            {
               return false;
            }
            if(this.id == 306 && PlayerManager.Instance.Self.typeVIP < 2)
            {
               return false;
            }
         }
         if(!this.CanRepeat && this.isAchieved)
         {
            return false;
         }
         var _loc2_:int = int(this.optionalConditionNeed);
         var _loc3_:int = 0;
         while(Boolean(_loc1_ = this.getConditionById(_loc3_)))
         {
            if(!_loc1_)
            {
               break;
            }
            if(this.progress[_loc3_] > 0)
            {
               if(!_loc1_.isOpitional)
               {
                  return false;
               }
            }
            else
            {
               _loc2_--;
            }
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            return false;
         }
         return true;
      }
      
      private function getConditionById(param1:uint) : QuestCondition
      {
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         return this._conditions[param1] as QuestCondition;
      }
      
      public function get questProgressNum() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(Boolean(this._conditions[_loc3_]))
         {
            _loc1_ += this.progress[_loc3_];
            _loc2_ += this._conditions[_loc3_].target;
            _loc3_++;
         }
         return _loc1_ / _loc2_;
      }
      
      public function get canViewWithProgress() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this._conditions)
         {
            this._conditions = new Array();
         }
         var _loc1_:Boolean = true;
         if(this.isCompleted)
         {
            return _loc1_;
         }
         var _loc4_:int = 0;
         while(Boolean(this._conditions[_loc4_]))
         {
            _loc2_ += this.progress[_loc4_];
            _loc3_ += this._conditions[_loc4_].target;
            _loc4_++;
         }
         if(_loc2_ == _loc3_)
         {
            _loc1_ = false;
         }
         _loc4_ = 0;
         while(Boolean(this._conditions[_loc4_]))
         {
            if(this._conditions[_loc4_].type == 9 || this._conditions[_loc4_].type == 12 || this._conditions[_loc4_].type == 17 || this._conditions[_loc4_].type == 21)
            {
               _loc1_ = false;
            }
            if(this._conditions[_loc4_].type == 20 && this._conditions[_loc4_].param == 2)
            {
               _loc1_ = false;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function hasOtherAward() : Boolean
      {
         if(this.RewardGP > 0)
         {
            return true;
         }
         if(this.RewardGold > 0)
         {
            return true;
         }
         if(this.RewardMoney > 0)
         {
            return true;
         }
         if(this.RewardOffer > 0)
         {
            return true;
         }
         if(this.RewardRiches > 0)
         {
            return true;
         }
         if(this.RewardBindMoney > 0)
         {
            return true;
         }
         if(this.Rank != "")
         {
            return true;
         }
         if(this.RewardBuffID != 0)
         {
            return true;
         }
         return false;
      }
   }
}

