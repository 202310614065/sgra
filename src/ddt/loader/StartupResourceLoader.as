package ddt.loader
{
   import GodSyah.SyahManager;
   import SendRecord.SendRecordManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.StartupEvent;
   import ddt.manager.DesktopManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import deng.fzip.FZip;
   import deng.fzip.FZipFile;
   import email.manager.MailManager;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import road7th.comm.PackageIn;
   
   public class StartupResourceLoader extends EventDispatcher
   {
      
      private static var _instance:StartupResourceLoader;
      
      public static const NEWBIE:int = 1;
      
      public static const NORMAL:int = 2;
      
      public static const USER_GUILD_RESOURCE_COMPLETE:String = "userGuildResourceComplete";
      
      public static var firstEnterHall:Boolean = false;
      
      private var _currentMode:int = 0;
      
      private var _languageLoader:BaseLoader;
      
      private var _languagePath:String;
      
      private var _isSecondLoad:Boolean = false;
      
      private var _uimoduleProgress:Number;
      
      private var _progressArr:Array;
      
      private var _trainerComplete:Boolean;
      
      private var _trainerUIComplete:Boolean;
      
      private var _trainerFristComplete:Boolean;
      
      public var _queueIsComplete:Boolean;
      
      private var _loaderQueue:QueueLoader;
      
      private var _requestCompleted:int;
      
      public function StartupResourceLoader()
      {
         super();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RELOAD_XML,this.__reloadXML);
      }
      
      public static function get Instance() : StartupResourceLoader
      {
         if(_instance == null)
         {
            _instance = new StartupResourceLoader();
         }
         return _instance;
      }
      
      private function __reloadXML(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:BaseLoader = null;
         var _loc3_:PackageIn = param1.pkg;
         _loc2_ = _loc3_.readInt();
         switch(_loc2_)
         {
            case 1:
               _loc4_ = LoaderCreate.Instance.creatItemTempleteReload();
               break;
            case 2:
               _loc4_ = LoaderCreate.Instance.creatQuestTempleteReload();
               break;
            default:
               return;
         }
         if(Boolean(_loc4_))
         {
            LoadResourceManager.Instance.startLoad(_loc4_);
         }
      }
      
      public function reloadGodSyah(param1:PackageIn) : void
      {
         var _loc2_:BaseLoader = null;
         var _loc3_:int = param1.readInt();
         SyahManager.Instance.isOpen = param1.readBoolean();
         if(SyahManager.Instance.isOpen)
         {
            _loc2_ = LoaderCreate.Instance.creatGodSyahLoader(_loc3_);
            if(Boolean(_loc2_))
            {
               LoaderManager.Instance.startLoad(_loc2_);
            }
         }
         else
         {
            SyahManager.Instance.stopSyah();
         }
      }
      
      private function __onUIModuleLoadError(param1:UIModuleEvent) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ddt.StartupResourceLoader.Error.LoadModuleError",param1.module),LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get progress() : int
      {
         if(this._loaderQueue == null)
         {
            return int(this._uimoduleProgress * 35) + 40;
         }
         if(this._queueIsComplete)
         {
            return 99;
         }
         var _loc1_:int = this._uimoduleProgress * 35 + this._requestCompleted / this._loaderQueue.length * 25 + 40;
         return _loc1_ > 99 ? 99 : _loc1_;
      }
      
      public function start(param1:int) : void
      {
         this._currentMode = param1;
         this.loadLanguage();
      }
      
      private function loadLanguage() : void
      {
         this._languagePath = PathManager.getLanguagePath();
         this._languageLoader = LoadResourceManager.Instance.createLoader(this._languagePath,BaseLoader.BYTE_LOADER);
         this._languageLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         LoadResourceManager.Instance.startLoad(this._languageLoader);
      }
      
      private function __onLoadLanZipComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadLanZipComplete);
         var _loc2_:ByteArray = param1.loader.content;
         this.analyMd5(_loc2_);
      }
      
      private function zipLoad(param1:ByteArray) : void
      {
         var _loc2_:FZip = new FZip();
         _loc2_.addEventListener(Event.COMPLETE,this.__onZipParaComplete);
         _loc2_.loadBytes(param1);
      }
      
      private function analyMd5(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = null;
         if(ComponentSetting.USEMD5 && (ComponentSetting.md5Dic["language.png"] || this.hasHead(param1)))
         {
            if(this.compareMD5(param1))
            {
               _loc2_ = new ByteArray();
               param1.position = 37;
               param1.readBytes(_loc2_);
               this.zipLoad(_loc2_);
            }
            else
            {
               if(this._isSecondLoad)
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("alert",this._languagePath + ":is old");
                  }
               }
               else
               {
                  this._languagePath = this._languagePath.replace(ComponentSetting.FLASHSITE,ComponentSetting.BACKUP_FLASHSITE);
                  this._languageLoader.url = this._languagePath + "?rnd=" + Math.random();
                  this._languageLoader.isLoading = false;
                  this._languageLoader.loadFromWeb();
               }
               this._isSecondLoad = true;
            }
         }
         else
         {
            this.zipLoad(param1);
         }
      }
      
      private function hasHead(param1:ByteArray) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(ComponentSetting.swf_head);
         _loc2_.position = 0;
         param1.position = 0;
         while(_loc2_.bytesAvailable > 0)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = param1.readByte();
            if(_loc3_ != _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      private function compareMD5(param1:ByteArray) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(ComponentSetting.md5Dic["language.png"]);
         _loc2_.position = 0;
         param1.position = 5;
         while(_loc2_.bytesAvailable > 0)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = param1.readByte();
            if(_loc3_ != _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      private function __onZipParaComplete(param1:Event) : void
      {
         var _loc2_:FZip = param1.currentTarget as FZip;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onZipParaComplete);
         var _loc3_:FZipFile = _loc2_.getFileAt(0);
         var _loc4_:String = _loc3_.content.toString();
         LanguageMgr.setup(_loc4_);
         var _loc5_:QueueLoader = new QueueLoader();
         _loc5_.addLoader(LoaderCreate.Instance.creatZhanLoader());
         _loc5_.addEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         _loc5_.start();
      }
      
      private function __onLoadLanguageComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         if(this._currentMode == NEWBIE)
         {
            this.newBieXML();
         }
         else
         {
            this.loadUIModule();
         }
         this._setStageRightMouse();
      }
      
      private function __onUIModuleProgress(param1:UIModuleEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc7_:String = null;
         var _loc2_:BaseLoader = param1.loader;
         var _loc3_:int = 35;
         if(param1.module == UIModuleTypes.ROAD_COMPONENT)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CORE_ICON_AND_TIP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.DDTCORESCALEBITMAP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CHAT)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CHATII)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.PLAYER_TIP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.LEVEL_ICON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.ENTHRALL)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TRAINER)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TRAINER_UI)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.DDT_HALL)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.DDT_HALLICON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TOOLBAR)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.DDT_TIMEBOX)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.ACADEMY_COMMON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(!this._progressArr)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc6_:uint = this._progressArr.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this._progressArr[_loc5_];
            _loc4_ += this._progressArr[_loc7_];
            _loc5_++;
         }
         this._uimoduleProgress = _loc4_ / _loc6_;
      }
      
      private function setLoaderProgressArr(param1:String, param2:Number = 0) : void
      {
         if(!this._progressArr)
         {
            this._progressArr = [];
         }
         if(this._progressArr.indexOf(param1) < 0)
         {
            this._progressArr.push(param1);
            this._progressArr[param1] = param2;
         }
         else
         {
            this._progressArr[param1] = param2;
         }
      }
      
      public function addUserGuildResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINERFIRSTGAME);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER_UI);
      }
      
      public function finishLoadingProgress() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function startLoadRelatedInfo() : void
      {
         var _loc1_:QueueLoader = new QueueLoader();
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            _loc1_.addLoader(LoaderCreate.Instance.creatVoteSubmit());
         }
         this.SendVersion();
         _loc1_.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
         _loc1_.addLoader(LoaderCreate.Instance.creatFriendListLoader());
         _loc1_.addLoader(LoaderCreate.Instance.creatMyacademyPlayerListLoader());
         _loc1_.addLoader(LoaderCreate.Instance.getMyConsortiaData());
         _loc1_.addLoader(LoaderCreate.Instance.createCalendarRequest());
         _loc1_.addLoader(MailManager.Instance.getAllEmailLoader());
         _loc1_.addLoader(MailManager.Instance.getSendedEmailLoader());
         _loc1_.addLoader(ConsortionModelControl.Instance.getLevelUpInfo());
         _loc1_.addLoader(LoaderCreate.Instance.creatFeedbackInfoLoader());
         _loc1_.addLoader(LoaderCreate.Instance.createConsortiaLoader());
         _loc1_.addLoader(LoaderCreate.Instance.creatItemTempleteReload());
         _loc1_.addLoader(LoaderCreate.Instance.createGodsRoadsLoader());
         _loc1_.start();
      }
      
      private function __onSetupSourceLoadComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         _loc2_.removeEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         _loc2_.dispose();
         _loc2_ = null;
         this._queueIsComplete = true;
         dispatchEvent(new StartupEvent(StartupEvent.CORE_SETUP_COMPLETE));
      }
      
      private function __onUIMoudleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TRAINER || param1.module == UIModuleTypes.TRAINER_UI || param1.module == UIModuleTypes.TRAINERFIRSTGAME)
         {
            if(param1.module == UIModuleTypes.TRAINER)
            {
               this._trainerComplete = true;
            }
            if(param1.module == UIModuleTypes.TRAINER_UI)
            {
               this._trainerUIComplete = true;
            }
            if(param1.module == UIModuleTypes.TRAINERFIRSTGAME)
            {
               this._trainerFristComplete = true;
            }
            if(this._trainerComplete && this._trainerUIComplete && this._trainerFristComplete)
            {
               dispatchEvent(new Event(USER_GUILD_RESOURCE_COMPLETE));
            }
         }
         if(param1.module == UIModuleTypes.DDT_TIMEBOX)
         {
            dispatchEvent(new StartupEvent(StartupEvent.CORE_LOAD_COMPLETE));
            this._loaderQueue = new QueueLoader();
            this._queueIsComplete = false;
            this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
            this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
            this.addLoader(LoaderCreate.Instance.creatActiveInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatActionExchangeInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatItemTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatGoodCategoryLoader());
            this.addLoader(LoaderCreate.Instance.creatShopTempleteLoader());
            this.addLoader(LoaderCreate.Instance.createCardSetsSortRule());
            this.addLoader(LoaderCreate.Instance.createCardSetsProperties());
            this.addLoader(ConsortionModelControl.Instance.loadSkillInfoList());
            this.addLoader(LoaderCreate.Instance.creatServerListLoader());
            this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
            this.addLoader(LoaderCreate.Instance.creatQuestTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatEffortTempleteLoader());
            this.addLoader(LoaderCreate.Instance.creatAllQuestionInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatUserBoxInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatBoxTempInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
            this.addLoader(LoaderCreate.Instance.creatShopSortLoader());
            this.addLoader(LoaderCreate.Instance.creatMapInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDungeonInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatOpenMapInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatExpericenceAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatPetExpericenceAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatWeaponBallAnalyzeLoader());
            this.addLoader(LoaderCreate.Instance.creatTexpExpLoader());
            this.addLoader(LoaderCreate.Instance.creatBadgeInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyLeagueAwardLoader());
            this.addLoader(LoaderCreate.Instance.creatDailyLeagueLevelLoader());
            this.addLoader(LoaderCreate.Instance.createWishInfoLader());
            this.addLoader(LoaderCreate.Instance.creatServerConfigLoader());
            this.addLoader(LoaderCreate.Instance.creatPetInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatPetSkillLoader());
            this.addLoader(LoaderCreate.Instance.creatPetSkillTemplateInfoLoader());
            this.addLoader(LoaderCreate.Instance.creatFoodComposeLoader());
            this.addLoader(LoaderCreate.Instance.creatPetConfigLoader());
            this.addLoader(LoaderCreate.Instance.createStoreEquipConfigLoader());
            this.addLoader(LoaderCreate.Instance.creatCardGrooveLoader());
            this.addLoader(LoaderCreate.Instance.creatCardTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatItemStrengthenGoodsInfoLoader());
            this.addLoader(LoaderCreate.Instance.createBeadTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatShopDisCountRealTimesLoader());
            this.addLoader(LoaderCreate.Instance.creatHallIcon());
            this.addLoader(LoaderCreate.Instance.createTotemTemplateLoader());
            this.addLoader(LoaderCreate.Instance.createHonorUpTemplateLoader());
            this.addLoader(LoaderCreate.Instance.createConsortiaBossTemplateLoader());
            this.addLoader(LoaderCreate.Instance.creatActiveLoader());
            this.addLoader(LoaderCreate.Instance.creatActivePointLoader());
            this.addLoader(LoaderCreate.Instance.creatRewardLoader());
            this.addLoader(LoaderCreate.Instance.loaderSearchGoodsPayMoney());
            this.addLoader(LoaderCreate.Instance.loaderSearchGoodsTemp());
            this.addLoader(LoaderCreate.Instance.creatWondActiveLoader());
            this.addLoader(LoaderCreate.Instance.firstRechargeLoader());
            this.addLoader(LoaderCreate.Instance.accumulativeLoginLoader());
            this.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
            this.addLoader(LoaderCreate.Instance.createDragonBoatActiveLoader());
            this.addLoader(LoaderCreate.Instance.createCaddyAwardsLoader());
            this.addLoader(LoaderCreate.Instance.createNewFusionDataLoader());
            this.addLoader(LoaderCreate.Instance.createEnergyDataLoader());
            this.addLoader(LoaderCreate.Instance.createEnergyDataLoader());
            this.addLoader(LoaderCreate.Instance.createActivitySystemItemsLoader());
            this.addLoader(LoaderCreate.Instance.loadWonderfulActivityXml());
            this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
            this.addLoader(LoaderCreate.Instance.createAvatarCollectionUnitDataLoader());
            this.addLoader(LoaderCreate.Instance.createAvatarCollectionItemDataLoader());
            this.addLoader(LoaderCreate.Instance.createPetsRisingStarDataLoader());
            this.addLoader(LoaderCreate.Instance.createPetsEvolutionDataLoader());
            this.addLoader(LoaderCreate.Instance.loadMagicStoneTemplate());
            if(PathManager.suitEnable)
            {
               this.addLoader(LoaderCreate.Instance.creatSuitTempleteLoader());
               this.addLoader(LoaderCreate.Instance.creatEquipSuitTempleteLoader());
            }
            if(PathManager.GodSyahEnable)
            {
               this.addLoader(LoaderCreate.Instance.creatGodSyahLoader());
            }
            this.addLoader(LoaderCreate.Instance.creatSuperWinnerLoader());
            this.addLoader(LoaderCreate.Instance.loadLanternRiddlesXml());
            this.addLoader(LoaderCreate.Instance.createLightRoadLoader());
            this.addLoader(LoaderCreate.Instance.createHalloweenLoader());
            this._loaderQueue.start();
         }
         if(param1.module == UIModuleTypes.TOOLBAR)
         {
            dispatchEvent(new Event("RegisterUIModuleComplete"));
         }
      }
      
      private function newBieXML() : void
      {
         this._loaderQueue = new QueueLoader();
         this._queueIsComplete = false;
         this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         this.addLoader(LoaderCreate.Instance.creatActiveInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatItemTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatShopTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatServerListLoader());
         this.addLoader(LoaderCreate.Instance.creatSelectListLoader());
         this.addLoader(LoaderCreate.Instance.creatQuestTempleteLoader());
         this.addLoader(LoaderCreate.Instance.creatMovingNotificationLoader());
         this.addLoader(LoaderCreate.Instance.creatMapInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatDungeonInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatOpenMapInfoLoader());
         this.addLoader(LoaderCreate.Instance.creatExpericenceAnalyzeLoader());
         this.addLoader(LoaderCreate.Instance.creatWeaponBallAnalyzeLoader());
         this.addLoader(LoaderCreate.Instance.creatServerConfigLoader());
         this.addLoader(LoaderCreate.Instance.creatHallIcon());
         this.addLoader(LoaderCreate.Instance.creatBallInfoLoader());
         this.addLoader(LoaderCreate.Instance.createStoreEquipConfigLoader());
         this.addLoader(LoaderCreate.Instance.createHalloweenLoader());
         this.addLoader(LoaderCreate.Instance.loadWonderfulActivityXml());
         this.addLoader(LoaderCreate.Instance.createDragonBoatActiveLoader());
         this._loaderQueue.start();
      }
      
      private function addLoader(param1:BaseLoader) : void
      {
         this._loaderQueue.addLoader(param1);
      }
      
      private function __onSetupSourceLoadChange(param1:Event) : void
      {
         this._requestCompleted = (param1.currentTarget as QueueLoader).completeCount;
      }
      
      public function addRegisterUIModule() : void
      {
         firstEnterHall = true;
         this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
         this.addUIModlue(UIModuleTypes.FIRST_CORE);
         this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
         this.addUIModlue(UIModuleTypes.CHAT);
         this.addUIModlue(UIModuleTypes.ENTHRALL);
         this.addUIModlue(UIModuleTypes.TRAINERFIRSTGAME);
         this.addUIModlue(UIModuleTypes.TRAINER_UI);
         this.addUIModlue(UIModuleTypes.TOOLBAR);
         this.addUIModlue(UIModuleTypes.DDT_COREII);
         this.addUIModlue(UIModuleTypes.DDT_HALL);
         this.addUIModlue(UIModuleTypes.DDT_HALLICON);
         this.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
         this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
         this.setLoaderProgressArr(UIModuleTypes.FIRST_CORE);
         this.setLoaderProgressArr(UIModuleTypes.DDTCORESCALEBITMAP);
         this.setLoaderProgressArr(UIModuleTypes.CHAT);
         this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
         this.setLoaderProgressArr(UIModuleTypes.TRAINERFIRSTGAME);
         this.setLoaderProgressArr(UIModuleTypes.TRAINER_UI);
         this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
         this.setLoaderProgressArr(UIModuleTypes.DDT_COREII);
         this.setLoaderProgressArr(UIModuleTypes.DDT_HALL);
         this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
         this.setLoaderProgressArr(UIModuleTypes.WONDERFULACTIVI);
      }
      
      public function addThirdGameUI() : void
      {
         firstEnterHall = false;
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALL);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_HALLICON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREI);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_COREII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CHATII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.PLAYER_TIP);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.LEVEL_ICON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
      }
      
      private function loadUIModule() : void
      {
         if(this._currentMode == NORMAL)
         {
            this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
            this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.TRAINER);
            this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
            this.addUIModlue(UIModuleTypes.FIRST_CORE);
            this.addUIModlue(UIModuleTypes.DDT_COREI);
            this.addUIModlue(UIModuleTypes.DDT_COREII);
            this.addUIModlue(UIModuleTypes.CHAT);
            this.addUIModlue(UIModuleTypes.CHATII);
            this.addUIModlue(UIModuleTypes.GAME);
            this.addUIModlue(UIModuleTypes.PLAYER_TIP);
            this.addUIModlue(UIModuleTypes.LEVEL_ICON);
            this.addUIModlue(UIModuleTypes.ENTHRALL);
            this.addUIModlue(UIModuleTypes.DDT_HALL);
            this.addUIModlue(UIModuleTypes.DDT_HALLICON);
            this.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
            this.addUIModlue(UIModuleTypes.TOOLBAR);
            this.addUIModlue(UIModuleTypes.DDT_TIMEBOX);
            this.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
            this.addUIModlue(UIModuleTypes.DDTBEAD);
            this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
            this.setLoaderProgressArr(UIModuleTypes.CORE_ICON_AND_TIP);
            this.setLoaderProgressArr(UIModuleTypes.DDTCORESCALEBITMAP);
            this.setLoaderProgressArr(UIModuleTypes.FIRST_CORE);
            this.setLoaderProgressArr(UIModuleTypes.DDT_COREI);
            this.setLoaderProgressArr(UIModuleTypes.DDT_COREII);
            this.setLoaderProgressArr(UIModuleTypes.CHAT);
            this.setLoaderProgressArr(UIModuleTypes.CHATII);
            this.setLoaderProgressArr(UIModuleTypes.GAME);
            this.setLoaderProgressArr(UIModuleTypes.PLAYER_TIP);
            this.setLoaderProgressArr(UIModuleTypes.LEVEL_ICON);
            this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
            this.setLoaderProgressArr(UIModuleTypes.DDT_HALL);
            this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
            this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
            this.setLoaderProgressArr(UIModuleTypes.DDT_TIMEBOX);
            this.setLoaderProgressArr(UIModuleTypes.ACADEMY_COMMON);
         }
      }
      
      public function addFirstGameNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTROOMLOADING);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEIII);
      }
      
      public function addNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAGANDINFO);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTSTORE);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
      }
      
      private function addUIModlue(param1:String) : void
      {
         UIModuleLoader.Instance.addUIModlue(param1);
      }
      
      private function _setStageRightMouse() : void
      {
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_BOTTOM_LAYER).contextMenu = this.creatRightMenu();
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.addCallback("sendSwfNowUrl",this.receivedFromJavaScript);
         }
      }
      
      private function creatRightMenu() : ContextMenu
      {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         var _loc2_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.share"));
         _loc2_.separatorBefore = true;
         _loc1_.customItems.push(_loc2_);
         _loc2_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onQQMSNClick);
         var _loc3_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.collection"));
         _loc3_.separatorBefore = true;
         _loc1_.customItems.push(_loc3_);
         _loc3_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.addFavClick);
         var _loc4_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.supply"));
         _loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.goPayClick);
         _loc1_.customItems.push(_loc4_);
         _loc1_.builtInItems.zoom = true;
         return _loc1_;
      }
      
      private function onQQMSNClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("getLocationUrl","");
         }
      }
      
      public function receivedFromJavaScript(param1:String) : void
      {
         this._receivedFromJavaScriptII(param1);
      }
      
      private function _receivedFromJavaScriptII(param1:String) : void
      {
         System.setClipboard(param1);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazytank.copyOK"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function SendVersion() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         var _loc2_:URLLoader = new URLLoader();
         _loc1_.version = Capabilities.version.split(" ")[1];
         var _loc3_:URLRequest = new URLRequest(PathManager.solveRequestPath("UpdateVersion.ashx"));
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = _loc1_;
         _loc2_.load(_loc3_);
         if(PathManager.isSendRecordUserVersion)
         {
            this.sendRecordUserVersion();
         }
         if(PathManager.isSendFlashInfo && !SharedManager.Instance.flashInfoExist)
         {
            this.sendUserVersion();
         }
      }
      
      private function sendRecordUserVersion() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         var _loc2_:URLLoader = new URLLoader();
         _loc1_.Version = Capabilities.version.split(" ")[1];
         _loc1_.Sys = Capabilities.os;
         _loc1_.UserName = PlayerManager.Instance.Account.Account;
         var _loc3_:URLRequest = new URLRequest(PathManager.solveRequestPath("RecordUserVersion.ashx"));
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = _loc1_;
         _loc2_.load(_loc3_);
      }
      
      private function sendUserVersion() : void
      {
         SendRecordManager.Instance.setUp();
      }
      
      private function addFavClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("addToFavorite","");
         }
      }
      
      private function goPayClick(param1:ContextMenuEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
      }
   }
}

