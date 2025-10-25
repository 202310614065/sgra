package ddt.manager
{
   import beadSystem.controls.BeadLeadManager;
   import com.pickgliss.action.ShowTipAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.data.quest.*;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.states.StateType;
   import ddt.utils.BitArray;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatEvent;
   import exitPrompt.ExitPromptManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import oldPlayerRegress.event.RegressEvent;
   import petsBag.controller.PetBagController;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import quest.TaskMainFrame;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import tryonSystem.TryonSystemController;
   
   [Event(name="remove",type="tank.events.TaskEvent")]
   [Event(name="add",type="tank.events.TaskEvent")]
   [Event(name="changed",type="tank.events.TaskEvent")]
   public class TaskManager extends EventDispatcher
   {
      
      public static var itemAwardSelected:int;
      
      private static var _selectedQuest:QuestInfo;
      
      private static var _questListLoader:TextLoader;
      
      private static var _mainFrame:TaskMainFrame;
      
      private static var _questDataInited:Boolean;
      
      private static var _instance:TaskManager;
      
      private static var _allQuests:Dictionary;
      
      private static var _questLog:BitArray;
      
      public static var currentQuest:QuestInfo;
      
      private static var _currentNewQuest:QuestInfo;
      
      private static var _isShowing:Boolean;
      
      private static var mc:MovieClipWrapper;
      
      private static var _itemListenerArr:Array;
      
      private static var _consortChatConditions:Array;
      
      public static const GUIDE_QUEST_ID:int = 339;
      
      public static const COLLECT_INFO_EMAIL:int = 544;
      
      public static const COLLECT_INFO_CELLPHONE:int = 545;
      
      public static const COLLECT_INFO_CELLPHONEII:int = 550;
      
      public static const achievementQuestNo:int = 1000;
      
      public static const BEADLEAD_TASKTYPE1:int = 1578;
      
      public static const BEADLEAD_TASKTYPE2:int = 1579;
      
      public static const HALLICON_TASKTYPE:int = 2042;
      
      private static var firstshowTask:Boolean = true;
      
      private static const _questListPath:String = "QuestList.xml";
      
      public static var _newQuests:Array = new Array();
      
      public static var _currentCategory:int = 0;
      
      public var guideId:int;
      
      private var _improve:QuestImproveInfo;
      
      private var _returnFun:Function;
      
      private var _isShown:Boolean = false;
      
      private var _annexListenerArr:Array;
      
      private var _desktopCond:QuestCondition;
      
      private var _friendListenerArr:Array;
      
      private var tmpQuestId:int;
      
      public function TaskManager()
      {
         super();
      }
      
      public static function get instance() : TaskManager
      {
         if(_instance == null)
         {
            _instance = new TaskManager();
         }
         return _instance;
      }
      
      public function get improve() : QuestImproveInfo
      {
         return this._improve;
      }
      
      public function set selectedQuest(param1:QuestInfo) : void
      {
         _selectedQuest = param1;
      }
      
      public function get selectedQuest() : QuestInfo
      {
         return _selectedQuest;
      }
      
      public function get MainFrame() : TaskMainFrame
      {
         if(!_mainFrame)
         {
            _mainFrame = ComponentFactory.Instance.creat("QuestFrame");
         }
         return _mainFrame;
      }
      
      public function switchVisible() : void
      {
         if(firstshowTask)
         {
            this._returnFun = this.switchVisible;
            this.moduleLoad();
            return;
         }
         if(!this._isShown)
         {
            this.MainFrame.open();
            this._isShown = true;
         }
         else
         {
            if(TryonSystemController.Instance.view != null)
            {
               return;
            }
            _mainFrame.dispose();
            _mainFrame = null;
            this._isShown = false;
            dispatchEvent(new Event(TaskMainFrame.TASK_FRAME_HIDE));
         }
      }
      
      private function moduleLoad() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
      }
      
      private function __onTaskLoadComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.QUEST)
         {
            firstshowTask = false;
            this._returnFun();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private function __onTaskLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.QUEST)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      public function get isShow() : Boolean
      {
         return this._isShown;
      }
      
      public function set isShow(param1:Boolean) : void
      {
         this._isShown = param1;
         if(!this._isShown)
         {
            _mainFrame = null;
         }
      }
      
      public function setup(param1:QuestListAnalyzer) : void
      {
         this.allQuests = param1.list;
         _questDataInited = false;
         this._improve = this.getImproveArray(param1.improveXml);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,this.__updateAcceptedTask);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH,this.__questFinish);
      }
      
      public function reloadNewQuest(param1:QuestListAnalyzer) : void
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Dictionary = param1.list;
         for each(_loc3_ in _loc2_)
         {
            if(this.getQuestByID(_loc3_.id) == null)
            {
               this.addQuest(_loc3_);
            }
         }
      }
      
      private function getImproveArray(param1:XML) : QuestImproveInfo
      {
         var _loc2_:QuestImproveInfo = new QuestImproveInfo();
         _loc2_.bindMoneyRate = String(param1.@BindMoneyRate).split("|");
         _loc2_.expRate = String(param1.@ExpRate).split("|");
         _loc2_.goldRate = String(param1.@GoldRate).split("|");
         _loc2_.exploitRate = String(param1.@ExploitRate).split("|");
         _loc2_.canOneKeyFinishTime = Number(param1.@CanOneKeyFinishTime);
         return _loc2_;
      }
      
      public function addQuest(param1:QuestInfo) : void
      {
         TaskManager.instance.allQuests[param1.Id] = param1;
      }
      
      public function loadQuestLog(param1:ByteArray) : void
      {
         param1.position = 0;
         _questLog = new BitArray();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _questLog.writeByte(param1.readByte());
            _loc2_++;
         }
      }
      
      private function IsQuestFinish(param1:int) : Boolean
      {
         if(!_questLog)
         {
            return false;
         }
         if(param1 > _questLog.length * 8 || param1 < 1)
         {
            return false;
         }
         param1--;
         var _loc2_:int = param1 / 8;
         var _loc3_:int = param1 % 8;
         var _loc4_:int = _questLog[_loc2_] & 1 << _loc3_;
         return _loc4_ != 0;
      }
      
      public function get allQuests() : Dictionary
      {
         if(!_allQuests)
         {
            _allQuests = new Dictionary();
         }
         return _allQuests;
      }
      
      public function set allQuests(param1:Dictionary) : void
      {
         _allQuests = param1;
      }
      
      public function getQuestByID(param1:int) : QuestInfo
      {
         if(!this.allQuests)
         {
            return null;
         }
         return this.allQuests[param1];
      }
      
      public function getQuestDataByID(param1:int) : QuestDataInfo
      {
         if(!this.getQuestByID(param1))
         {
            return null;
         }
         return this.getQuestByID(param1).data;
      }
      
      public function getAvailableQuests(param1:int = -1, param2:Boolean = true) : QuestCategory
      {
         var _loc4_:QuestInfo = null;
         var _loc3_:QuestCategory = new QuestCategory();
         for each(_loc4_ in this.allQuests)
         {
            if(_loc4_.QuestID == 3000)
            {
            }
            if(_loc4_.QuestID == 545 || _loc4_.QuestID == 550)
            {
               if(!PathManager.phoneBandEnable())
               {
                  continue;
               }
            }
            if(param1 > -1)
            {
               if(param1 == 0)
               {
                  if(_loc4_.Type != 0)
                  {
                     continue;
                  }
               }
               else if(param1 == 1)
               {
                  if(_loc4_.Type != 4 && _loc4_.Type != 1 && _loc4_.Type != 6)
                  {
                     continue;
                  }
               }
               else if(param1 == 2)
               {
                  if(_loc4_.Type != 2 && _loc4_.Type < 100)
                  {
                     continue;
                  }
               }
               else if(param1 == 3)
               {
                  if(_loc4_.Type != 3)
                  {
                     continue;
                  }
               }
               else if(param1 == 4)
               {
                  if(_loc4_.Type != 7)
                  {
                     continue;
                  }
               }
               else if(param1 == 5)
               {
                  if(_loc4_.Type != 10)
                  {
                     continue;
                  }
               }
            }
            if(param2 && _loc4_.data && !_loc4_.data.isExist)
            {
               this.requestQuest(_loc4_);
            }
            else if(this.isAvailableQuest(_loc4_,true))
            {
               if(_loc4_.Id != achievementQuestNo)
               {
                  if(_loc4_.isCompleted)
                  {
                     _loc3_.addCompleted(_loc4_);
                  }
                  else if(Boolean(_loc4_.data) && _loc4_.data.isNew)
                  {
                     _loc3_.addNew(_loc4_);
                  }
                  else
                  {
                     _loc3_.addQuest(_loc4_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function getQuestCategory() : void
      {
      }
      
      public function get allAvailableQuests() : Array
      {
         return this.getAvailableQuests(-1,false).list;
      }
      
      public function get allCurrentQuest() : Array
      {
         return this.getAvailableQuests(-1,true).list;
      }
      
      public function get mainQuests() : Array
      {
         return this.getAvailableQuests(0,true).list;
      }
      
      public function get sideQuests() : Array
      {
         return this.getAvailableQuests(1,true).list;
      }
      
      public function get dailyQuests() : Array
      {
         return this.getAvailableQuests(2,true).list;
      }
      
      public function get texpQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:QuestCategory = new QuestCategory();
         for each(_loc2_ in this.allQuests)
         {
            if(_loc2_.Type >= 100)
            {
               if(Boolean(_loc2_.data) && !_loc2_.data.isExist)
               {
                  this.requestQuest(_loc2_);
               }
               else if(this.isAvailableQuest(_loc2_,true))
               {
                  if(_loc2_.Id != achievementQuestNo)
                  {
                     if(_loc2_.isCompleted)
                     {
                        _loc1_.addCompleted(_loc2_);
                     }
                     else if(Boolean(_loc2_.data) && _loc2_.data.isNew)
                     {
                        _loc1_.addNew(_loc2_);
                     }
                     else
                     {
                        _loc1_.addQuest(_loc2_);
                     }
                  }
               }
            }
         }
         return _loc1_.list;
      }
      
      public function get newQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.allAvailableQuests)
         {
            if(_loc2_.data && _loc2_.data.needInformed && _loc2_.Type != 2)
            {
               _loc1_.push(_loc2_);
            }
         }
         _newQuests = _loc1_;
         return _loc1_;
      }
      
      public function set currentCategory(param1:int) : void
      {
         _currentCategory = param1;
      }
      
      public function get currentCategory() : int
      {
         if(Boolean(this.selectedQuest))
         {
            return this.selectedQuest.Type;
         }
         return _currentCategory;
      }
      
      public function get welcomeQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.dailyQuests)
         {
            if(_loc2_.otherCondition != 1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.reverse();
      }
      
      public function get welcomeGuildQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.dailyQuests)
         {
            if(_loc2_.otherCondition == 1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.reverse();
      }
      
      public function getTaskData(param1:int) : QuestDataInfo
      {
         if(Boolean(this.getQuestByID(param1)))
         {
            return this.getQuestByID(param1).data;
         }
         return null;
      }
      
      public function isAvailableQuest(param1:QuestInfo, param2:Boolean = false) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:QuestInfo = null;
         var _loc3_:Array = PathManager.DISABLE_TASK_ID;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1.id == parseInt(_loc3_[_loc4_]))
            {
               return false;
            }
            _loc4_++;
         }
         if(param1.disabled)
         {
            return false;
         }
         if(param1.texpTaskIsTimeOut())
         {
            return false;
         }
         if(param1.Type <= 100)
         {
            _loc5_ = PlayerManager.Instance.Self.Grade;
            if(param1.NeedMinLevel > _loc5_ || param1.NeedMaxLevel < _loc5_)
            {
               return false;
            }
         }
         if(param1.PreQuestID != "0,")
         {
            _loc6_ = [];
            _loc6_ = param1.PreQuestID.split(",");
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_ != 0)
               {
                  if(Boolean(this.getQuestByID(_loc7_)))
                  {
                     _loc8_ = this.getQuestByID(_loc7_);
                     if(!_loc8_)
                     {
                        return false;
                     }
                     if(!this.isAchieved(_loc8_))
                     {
                        return false;
                     }
                  }
               }
            }
         }
         if(!(this.isValidateByDate(param1) && this.isAvailableByGuild(param1) && this.isAvailableByMarry(param1)))
         {
            return false;
         }
         if(param1.Type <= 100 && this.haveLog(param1))
         {
            return false;
         }
         if(!param1.isAvailable)
         {
            return false;
         }
         if(param1.data == null || !param1.data.isExist && param1.CanRepeat)
         {
            this.requestQuest(param1);
            if(param2 && param1.Type != 4)
            {
               return false;
            }
         }
         return true;
      }
      
      public function isAchieved(param1:QuestInfo) : Boolean
      {
         if(param1.isAchieved)
         {
            return true;
         }
         if(!param1.CanRepeat)
         {
            if(this.IsQuestFinish(param1.Id))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isCompleted(param1:QuestInfo) : Boolean
      {
         if(param1.isCompleted)
         {
            return true;
         }
         return false;
      }
      
      public function isAvailable(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return this.isAvailableQuest(param1) && !param1.isCompleted;
      }
      
      private function haveLog(param1:QuestInfo) : Boolean
      {
         if(param1.CanRepeat)
         {
            if(Boolean(param1.data) && param1.data.repeatLeft == 0)
            {
               return true;
            }
            return false;
         }
         if(this.IsQuestFinish(param1.Id))
         {
            return true;
         }
         return false;
      }
      
      public function isValidateByDate(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return !param1.isTimeOut();
      }
      
      public function isAvailableByGuild(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 1 || PlayerManager.Instance.Self.ConsortiaID != 0;
      }
      
      public function isAvailableByMarry(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 2 || PlayerManager.Instance.Self.IsMarried;
      }
      
      public function __updateAcceptedTask(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:QuestInfo = null;
         var _loc7_:QuestDataInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = new QuestInfo();
            if(Boolean(this.getQuestByID(_loc5_)))
            {
               _loc6_ = this.getQuestByID(_loc5_);
               if(Boolean(_loc6_.data))
               {
                  _loc7_ = _loc6_.data;
               }
               else
               {
                  _loc7_ = new QuestDataInfo(_loc5_);
                  if(_loc6_.required)
                  {
                     _loc7_.isNew = true;
                  }
               }
               _loc7_.isAchieved = _loc2_.readBoolean();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc7_.setProgress(_loc8_,_loc9_,_loc10_,_loc11_);
               _loc7_.CompleteDate = _loc2_.readDate();
               _loc7_.repeatLeft = _loc2_.readInt();
               _loc7_.quality = _loc2_.readInt();
               _loc7_.isExist = _loc2_.readBoolean();
               _loc6_.QuestLevel = _loc2_.readInt();
               _loc12_ = [0,0,0,0];
               _loc13_ = _loc2_.readInt();
               _loc14_ = 0;
               while(_loc14_ < _loc13_)
               {
                  _loc15_ = _loc2_.readInt() - 4;
                  _loc12_[_loc15_] = _loc2_.readInt();
                  _loc14_++;
               }
               _loc7_.setProgressConcoat(_loc12_);
               _loc6_.data = _loc7_;
               if(_loc7_.isNew)
               {
                  this.addNewQuest(_loc6_);
               }
               if(PetBagController.instance().isPetFarmGuildeTask(_loc6_.QuestID))
               {
                  PetBagController.instance().dispatchEvent(new UpdatePetFarmGuildeEvent(UpdatePetFarmGuildeEvent.FINISH,_loc6_));
               }
               if(_loc5_ == TaskManager.BEADLEAD_TASKTYPE1)
               {
                  BeadLeadManager.Instance.perTaskComplete = _loc6_.data.isCompleted;
               }
               else if(_loc5_ == TaskManager.BEADLEAD_TASKTYPE2)
               {
                  BeadLeadManager.Instance.taskComplete = _loc6_.data.isCompleted;
               }
               else if(_loc5_ == TaskManager.HALLICON_TASKTYPE)
               {
                  HallIconManager.instance.checkHallIconExperienceTask(_loc6_.data.isCompleted);
               }
               dispatchEvent(new TaskEvent(TaskEvent.CHANGED,_loc6_,_loc7_));
            }
            _loc4_++;
         }
         this.loadQuestLog(_loc2_.readByteArray());
         _questDataInited = true;
         this.checkHighLight();
         if(this.hasEventListener(RegressEvent.REGRESS_UPDATE_TASKMENUITEM))
         {
            dispatchEvent(new RegressEvent(RegressEvent.REGRESS_UPDATE_TASKMENUITEM));
         }
      }
      
      private function addNewQuest(param1:QuestInfo) : void
      {
         if(!_newQuests)
         {
            _newQuests = new Array();
         }
         if(_newQuests.indexOf(param1) == -1 && !_isShowing)
         {
            this.showGetNewQuest();
         }
         _newQuests.push(param1);
      }
      
      private function availableForMainToolBar() : Boolean
      {
         if(StateManager.currentStateType == null || StateManager.currentStateType == StateType.LOGIN)
         {
            return false;
         }
         return true;
      }
      
      public function clearNewQuest() : void
      {
         var _loc1_:QuestInfo = null;
         for each(_loc1_ in this.allAvailableQuests)
         {
         }
      }
      
      public function showGetNewQuest() : void
      {
         if(NewHandGuideManager.Instance.progress < Step.PICK_ONE)
         {
            return;
         }
         if(mc == null)
         {
            if(firstshowTask)
            {
               this._returnFun = this.showGetNewQuest;
               this.moduleLoad();
               return;
            }
            mc = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("core.quest.GetNewQuestMovie"),false,true);
            mc.movie.buttonMode = true;
            mc.movie.addEventListener(MouseEvent.CLICK,this.__onclicked);
            mc.addEventListener(Event.COMPLETE,this.__onComplete);
            if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new ShowTipAction(mc.movie));
            }
            else if(!LevelRewardManager.Instance.isShow)
            {
               LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
               mc.play();
               _isShowing = true;
            }
            else
            {
               WeakGuildManager.Instance.newTask = true;
               mc = null;
            }
         }
      }
      
      private function __onComplete(param1:Event) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,this.__onclicked);
         mc.removeEventListener(Event.COMPLETE,this.__onComplete);
         ObjectUtils.disposeObject(mc);
         mc = null;
         _isShowing = false;
      }
      
      private function __onclicked(param1:MouseEvent) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,this.__onclicked);
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            return;
         }
         mc.movie.visible = false;
         if(!this._isShown)
         {
            this.switchVisible();
         }
      }
      
      public function get currentNewQuest() : QuestInfo
      {
         return _currentNewQuest;
      }
      
      private function __questFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == TaskManager.achievementQuestNo)
         {
            return;
         }
         this.onFinishQuest(_loc3_);
      }
      
      private function onFinishQuest(param1:int) : void
      {
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         if(_loc2_.isAvailable || Boolean(_loc2_.NextQuestID))
         {
            this.requestCanAcceptTask();
         }
         dispatchEvent(new TaskEvent(TaskEvent.FINISH,_loc2_,_loc2_.data));
      }
      
      public function jumpToQuest(param1:QuestInfo) : void
      {
         this.selectedQuest = param1;
         this.MainFrame.jumpToQuest(param1);
      }
      
      public function onBagChanged() : void
      {
         this.checkHighLight();
      }
      
      public function onGuildUpdate() : void
      {
         this.checkHighLight();
      }
      
      public function onPlayerLevelUp() : void
      {
         this.checkHighLight();
      }
      
      public function finshMarriage() : void
      {
         var _loc1_:QuestInfo = null;
         var _loc2_:QuestDataInfo = null;
         for each(var _loc5_ in this.allQuests)
         {
            _loc1_ = _loc5_;
            _loc5_;
            _loc2_ = _loc1_.data;
            if(_loc2_)
            {
               if(!_loc2_.isAchieved)
               {
                  if(_loc1_.Condition == 21)
                  {
                     this.showTaskHightLight();
                  }
               }
            }
         }
         this.requestCanAcceptTask();
      }
      
      public function get achievementQuest() : QuestInfo
      {
         return TaskManager.instance.getQuestByID(achievementQuestNo);
      }
      
      public function requestAchievementReward() : void
      {
         SocketManager.Instance.out.sendQuestFinish(achievementQuestNo,0);
      }
      
      public function requestCanAcceptTask() : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestInfo = null;
         var _loc1_:Array = this.allAvailableQuests;
         if(_loc1_.length != 0)
         {
            _loc2_ = new Array();
            for each(var _loc6_ in _loc1_)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.Type <= 100)
               {
                  if(!(Boolean(_loc3_.data) && _loc3_.data.isExist))
                  {
                     _loc2_.push(_loc3_.QuestID);
                     if(_questDataInited)
                     {
                        _loc3_.required = true;
                     }
                  }
               }
            }
            this.socketSendQuestAdd(_loc2_);
         }
      }
      
      public function requestQuest(param1:QuestInfo) : void
      {
         if(StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         if(param1.Type > 100)
         {
            return;
         }
         var _loc2_:Array = new Array();
         _loc2_.push(param1.QuestID);
         if(_questDataInited)
         {
            param1.required = true;
         }
         this.socketSendQuestAdd(_loc2_);
      }
      
      public function requestClubTask() : void
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(var _loc5_ in this.allAvailableQuests)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.otherCondition == 1)
            {
               if(this.isAvailableQuest(_loc2_))
               {
                  _loc1_.push(_loc2_.QuestID);
               }
            }
         }
         if(_loc1_.length > 0)
         {
            this.socketSendQuestAdd(_loc1_);
         }
      }
      
      public function isHaveBuriedQuest() : Boolean
      {
         var _loc1_:QuestInfo = null;
         for each(var _loc4_ in this.allAvailableQuests)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(_loc1_.Type == 10 && _loc1_.data.isExist)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addItemListener(param1:int) : void
      {
         if(!_itemListenerArr)
         {
            _itemListenerArr = new Array();
         }
         _itemListenerArr.push(param1);
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         _loc2_.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         _loc2_.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
      }
      
      private function __onBagUpdate(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         for each(var _loc6_ in param1.changedSlots)
         {
            _loc2_ = _loc6_;
            _loc6_;
            for each(var _loc8_ in _itemListenerArr)
            {
               _loc3_ = _loc8_;
               _loc8_;
               if(_loc3_ == _loc2_.TemplateID)
               {
                  this.checkHighLight();
               }
            }
         }
      }
      
      public function addGradeListener() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function __onPlayerPropertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["Grade"]))
         {
            this.checkHighLight();
         }
      }
      
      public function onMarriaged() : void
      {
         this.checkHighLight();
      }
      
      public function addGuildMemberListener() : void
      {
      }
      
      public function addAnnexListener(param1:QuestCondition) : void
      {
         if(!this._annexListenerArr)
         {
            this._annexListenerArr = new Array();
         }
         this._annexListenerArr.push(param1);
      }
      
      public function addDesktopListener(param1:QuestCondition) : void
      {
         this._desktopCond = param1;
         if(DesktopManager.Instance.isDesktop)
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onDesktopApp() : void
      {
         if(Boolean(this._desktopCond))
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onSendAnnex(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:QuestCondition = null;
         for each(var _loc6_ in param1)
         {
            _loc2_ = _loc6_;
            _loc6_;
            for each(var _loc8_ in this._annexListenerArr)
            {
               _loc3_ = _loc8_;
               _loc8_;
               if(_loc3_.param2 == _loc2_.TemplateID)
               {
                  if(this.isAvailableQuest(this.getQuestByID(_loc3_.questID),true))
                  {
                     this.checkQuest(_loc3_.questID,_loc3_.ConID,0);
                  }
               }
            }
         }
      }
      
      public function addFriendListener(param1:QuestCondition) : void
      {
         if(!this._friendListenerArr)
         {
            this._friendListenerArr = new Array();
         }
         this._friendListenerArr.push(param1);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__onFriendListComplete);
         addEventListener(TaskEvent.CHANGED,this.__onQuestChange);
      }
      
      private function __onQuestChange(param1:TaskEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(var _loc5_ in this._friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(param1.info.Id == _loc2_.questID)
            {
               this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
            }
         }
      }
      
      private function __onFriendListComplete(param1:Event) : void
      {
         var _loc2_:QuestCondition = null;
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,this.__onFriendListUpdated);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__onFriendListUpdated);
         for each(var _loc5_ in this._friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      private function __onFriendListUpdated(param1:DictionaryEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(var _loc5_ in this._friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            this.checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      public function hasConsortiaSayTask() : Boolean
      {
         var _loc2_:QuestInfo = null;
         var _loc3_:QuestCondition = null;
         var _loc1_:Array = this.getAvailableQuests(-1,true).list;
         for each(var _loc6_ in _loc1_)
         {
            _loc2_ = _loc6_;
            _loc6_;
            if(!_loc2_.isAchieved)
            {
               for each(var _loc8_ in _loc2_._conditions)
               {
                  _loc3_ = _loc8_;
                  _loc8_;
                  if(_loc3_.type == 20 && _loc3_.param == 4)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function addConsortaChatCondition(param1:QuestCondition) : void
      {
         if(_consortChatConditions == null)
         {
            _consortChatConditions = [];
         }
         _consortChatConditions.push(param1);
         ChatManager.Instance.addEventListener(ChatEvent.SEND_CONSORTIA,this.__onConsortiaChat);
      }
      
      private function __onConsortiaChat(param1:ChatEvent) : void
      {
         var _loc2_:QuestCondition = null;
         if(!this.hasConsortiaSayTask())
         {
            return;
         }
         for each(var _loc5_ in _consortChatConditions)
         {
            _loc2_ = _loc5_;
            _loc5_;
            this.checkQuest(_loc2_.questID,_loc2_.ConID,0);
         }
      }
      
      public function sendQuestFinish(param1:uint) : void
      {
         SocketManager.Instance.out.sendQuestFinish(param1,itemAwardSelected);
         this.questFinishHook(param1);
      }
      
      private function questFinishHook(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:URLVariables = null;
         var _loc4_:BaseLoader = null;
         switch(param1)
         {
            case COLLECT_INFO_EMAIL:
               _loc2_ = PlayerManager.Instance.Self.ID;
               _loc3_ = RequestVairableCreater.creatWidthKey(true);
               _loc3_["selfid"] = _loc2_;
               _loc3_["url"] = PathManager.solveLogin();
               _loc3_["nickname"] = PlayerManager.Instance.Self.NickName;
               _loc3_["rnd"] = Math.random();
               _loc4_ = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SendMailGameUrl.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
               LoadResourceManager.Instance.startLoad(_loc4_);
         }
      }
      
      public function sendQuestData(param1:int, param2:int) : void
      {
         if(!this.getQuestByID(param1).data)
         {
            return;
         }
         var _loc3_:int = int(this.getQuestByID(param1).data.progress[param2]);
         _loc3_--;
         this.checkQuest(param1,param2,_loc3_);
      }
      
      public function HighLightChecked(param1:QuestInfo) : void
      {
         if(param1.isCompleted)
         {
            param1.hadChecked = true;
         }
      }
      
      public function checkQuest(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.sendQuestCheck(param1,param2,param3);
      }
      
      private function socketSendQuestAdd(param1:Array) : void
      {
         SocketManager.Instance.out.sendQuestAdd(param1);
      }
      
      public function checkHighLight() : void
      {
         var _loc3_:QuestInfo = null;
         ExitPromptManager.Instance.changeJSQuestVar();
         var _loc1_:int = 0;
         var _loc2_:QuestCategory = this.getAvailableQuests(4);
         for each(var _loc6_ in this.allCurrentQuest)
         {
            _loc3_ = _loc6_;
            _loc6_;
            if(_loc2_.list.indexOf(_loc3_) == -1)
            {
               if(!_loc3_.isAchieved || _loc3_.CanRepeat)
               {
                  if(_loc3_.isCompleted)
                  {
                     if(!_loc3_.hadChecked)
                     {
                        _loc1_++;
                     }
                  }
               }
            }
         }
         if(_loc1_ > 0)
         {
            this.showTaskHightLight();
         }
         else
         {
            MainToolBar.Instance.hideTaskHightLight();
         }
      }
      
      private function showTaskHightLight() : void
      {
         if(this.availableForMainToolBar())
         {
            if(!this._isShown)
            {
               MainToolBar.Instance.showTaskHightLight();
            }
         }
      }
      
      public function jumpToQuestByID(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            param1 = this.tmpQuestId;
         }
         if(firstshowTask)
         {
            this.tmpQuestId = param1;
            this._returnFun = this.jumpToQuestByID;
            this.moduleLoad();
            return;
         }
         var _loc2_:QuestInfo = this.getQuestByID(param1);
         this._isShown = true;
         this.MainFrame.open();
         this.MainFrame.gotoQuest(_loc2_);
      }
   }
}

