package ddt.loader
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import GodSyah.SyahAnalyzer;
   import GodSyah.SyahManager;
   import accumulativeLogin.AccumulativeLoginAnalyer;
   import accumulativeLogin.AccumulativeManager;
   import bagAndInfo.callPropData.CallPropDataAnalyer;
   import bagAndInfo.energyData.EnergyDataAnalyzer;
   import baglocked.BaglockedManager;
   import baglocked.phone4399.MsnConfirmAnalyzer;
   import calendar.CalendarManager;
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.GrooveInfoManager;
   import cardSystem.analyze.CardTemplateAnalyzer;
   import cardSystem.analyze.SetsPropertiesAnalyzer;
   import cardSystem.analyze.SetsSortRuleAnalyzer;
   import chickActivation.ChickActivationManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortiaBossDataAnalyzer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import dayActivity.ActivePointAnalzer;
   import dayActivity.ActivityAnalyzer;
   import dayActivity.ActivityRewardAnalyzer;
   import dayActivity.DayActivityManager;
   import ddt.data.Experience;
   import ddt.data.GoodsAdditioner;
   import ddt.data.PetExperience;
   import ddt.data.analyze.ActivitySystemItemsDataAnalyzer;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import ddt.data.analyze.BallInfoAnalyzer;
   import ddt.data.analyze.BeadAnalyzer;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.CardGrooveEventAnalyzer;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.EffortItemTemplateInfoAnalyzer;
   import ddt.data.analyze.EquipSuitTempleteAnalyzer;
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.data.analyze.FilterWordAnalyzer;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.GoodsAdditionAnalyer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.LoginSelectListAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.PetAllSkillAnalyzer;
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.data.analyze.PetInfoAnalyzer;
   import ddt.data.analyze.PetSkillAnalyzer;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.analyze.QuestionInfoAnalyze;
   import ddt.data.analyze.RegisterAnalyzer;
   import ddt.data.analyze.ServerConfigAnalyz;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.analyze.SuitTempleteAnalyzer;
   import ddt.data.analyze.TexpExpAnalyze;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitAnalyzer;
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.BallManager;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetAllSkillManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QuestionInfoMannager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ServerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VoteManager;
   import ddt.manager.WeaponBallManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.caddyII.CaddyAwardDataAnalyzer;
   import ddt.view.caddyII.CaddyAwardModel;
   import ddtBuried.BuriedManager;
   import ddtBuried.SearchGoodsPayAnalyer;
   import ddtBuried.UpdateStarAnalyer;
   import dragonBoat.DragonBoatManager;
   import dragonBoat.dataAnalyzer.DragonBoatActiveDataAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.control.FarmComposeHouseController;
   import feedback.FeedbackManager;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import firstRecharge.FirstRechargeManger;
   import firstRecharge.RechargeAnalyer;
   import flash.net.URLVariables;
   import flash.utils.getDefinitionByName;
   import godsRoads.analyze.GodsRoadsDataAnalyzer;
   import godsRoads.manager.GodsRoadsManager;
   import groupPurchase.GroupPurchaseManager;
   import groupPurchase.data.GroupPurchaseAwardAnalyzer;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import halloween.HalloweenManager;
   import halloween.analyze.HalloweenDataAnalyzer;
   import kingDivision.KingDivisionManager;
   import lanternriddles.LanternRiddlesManager;
   import lanternriddles.data.LanternDataAnalyzer;
   import lightRoad.dataAnalyzer.LightRoadDataAnalyzer;
   import lightRoad.manager.LightRoadManager;
   import magicStone.MagicStoneManager;
   import magicStone.data.MagicStoneTempAnalyer;
   import mainbutton.data.HallIconDataAnalyz;
   import mainbutton.data.MainButtonManager;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.petsAdvanced.PetsEvolutionDataAnalyzer;
   import petsBag.petsAdvanced.PetsRisingStarDataAnalyzer;
   import pyramid.PyramidManager;
   import roomList.movingNotification.MovingNotificationManager;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDayTarget.dataAnalyzer.SevenDayTargetDataAnalyzer;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import store.data.StoreEquipExperience;
   import store.forge.wishBead.WishBeadManager;
   import store.newFusion.FusionNewManager;
   import store.newFusion.data.FusionNewDataAnalyzer;
   import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import superWinner.analyze.SuperWinnerAnalyze;
   import superWinner.manager.SuperWinnerManager;
   import texpSystem.controller.TexpManager;
   import totem.HonorUpManager;
   import totem.TotemManager;
   import totem.data.HonorUpDataAnalyz;
   import totem.data.TotemDataAnalyz;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActAnalyer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.WonderfulGMActAnalyer;
   
   public class LoaderCreate
   {
      
      private static var _instance:LoaderCreate;
      
      private var _reloadCount:int = 0;
      
      private var _reloadQuestCount:int = 0;
      
      private var _rechargeCount:int = 0;
      
      private var _actReloadeCount:int = 0;
      
      public function LoaderCreate()
      {
         super();
      }
      
      public static function get Instance() : LoaderCreate
      {
         if(_instance == null)
         {
            _instance = new LoaderCreate();
         }
         return _instance;
      }
      
      public function createAudioILoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveSoundSwf(),BaseLoader.MODULE_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIFail");
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createAudioIILoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveSoundSwf2(),BaseLoader.MODULE_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAudioIIFail");
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function loadExppression(param1:Function) : void
      {
         var _loc2_:ModuleLoader = LoadResourceManager.Instance.createLoader(PathManager.getExpressionPath(),BaseLoader.MODULE_LOADER);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingExpressionResourcesFailure");
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,param1);
         LoadResourceManager.Instance.startLoad(_loc2_);
      }
      
      public function creatBallInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("BallList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBombMetadataFailure");
         _loc1_.analyzer = new BallInfoAnalyzer(BallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatBoxTempInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadBoxTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsListFailure");
         _loc1_.analyzer = new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDungeonInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPVEItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingCopyMapsInformationFailure");
         _loc1_.analyzer = new DungeonAnalyzer(MapManager.setupDungeonInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEffortTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AchievementList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         _loc1_.analyzer = new EffortItemTemplateInfoAnalyzer(EffortManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatFriendListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["uname"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("IMListLoad.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc2_.analyzer = new FriendListAnalyzer(PlayerManager.Instance.setupFriendList);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatMyacademyPlayerListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["RelationshipID"] = PlayerManager.Instance.Self.masterID;
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("UserApprenticeshipInfoList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new MyAcademyPlayersAnalyze(PlayerManager.Instance.setupMyacademyPlayers);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatGoodCategoryLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadItemsCategory.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingItemTypeFailure");
         _loc1_.analyzer = new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TemplateAllList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemTempleteReload() : BaseLoader
      {
         this._reloadCount += 1;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["lv"] = LoaderSavingManager.Version + this._reloadCount;
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._reloadCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopBox.xml"),BaseLoader.TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingNewGoodsTemplateFailure");
         _loc2_.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.addGoodsTemplates);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatBadgeInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaBadgeConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBadgeInfoFailure");
         _loc1_.analyzer = new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatMovingNotificationLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getMovingNotificationPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAnnouncementFailure");
         _loc1_.analyzer = new MovingNotificationAnalyzer(MovingNotificationManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyAwardList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLoginFailedRewardInformation");
         _loc1_.analyzer = new DaylyGiveAnalyzer(CalendarManager.getInstance().setDailyInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadMapsItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadMapInformationFailure");
         _loc1_.analyzer = new MapAnalyzer(MapManager.setupMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatOpenMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MapServerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingOpenMapListFailure");
         _loc1_.analyzer = new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatQuestTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         _loc1_.analyzer = new QuestListAnalyzer(TaskManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatQuestTempleteReload() : BaseLoader
      {
         this._reloadQuestCount += 1;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["lv"] = LoaderSavingManager.Version + this._reloadQuestCount;
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._reloadQuestCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         _loc2_.analyzer = new QuestListAnalyzer(TaskManager.instance.reloadNewQuest);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatRegisterLoader() : BaseLoader
      {
         var _loc1_:* = getDefinitionByName("register.RegisterState");
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["Sex"] = _loc1_.SelectedSex;
         _loc2_["NickName"] = _loc1_.Nickname;
         _loc2_["Name"] = PlayerManager.Instance.Account.Account;
         _loc2_["Pass"] = PlayerManager.Instance.Account.Password;
         _loc2_["site"] = "";
         var _loc3_:RequestLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VisualizeRegister.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.FailedToRegister");
         _loc3_.analyzer = new RegisterAnalyzer(null);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc3_;
      }
      
      public function creatSelectListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         _loc1_["username"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoginSelectList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingRoleListFailure");
         _loc2_.analyzer = new LoginSelectListAnalyzer(SelectListManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatServerListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ServerList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingServerListFailure");
         _loc2_.analyzer = new ServerListAnalyzer(ServerManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createCardSetsSortRule() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsSortRule");
         _loc1_.analyzer = new SetsSortRuleAnalyzer(CardControl.Instance.initSetsSortRule);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCardSetsProperties() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardBuffList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsProperties");
         _loc1_.analyzer = new SetsPropertiesAnalyzer(CardControl.Instance.initSetsProperties);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatShopTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingStoreItemsFail");
         _loc1_.analyzer = new ShopItemAnalyzer(ShopManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatGoodsAdditionLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ItemStrengthenPlusData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsAdditionFail");
         _loc1_.analyzer = new GoodsAdditionAnalyer(GoodsAdditioner.Instance.addGoodsAddition);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatShopSortLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopGoodsShowList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.TheClassificationOfGoodsLoadingShopFailure");
         _loc1_.analyzer = new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatAllQuestionInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadAllQuestions.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTestFailure");
         _loc1_.analyzer = new QuestionInfoAnalyze(QuestionInfoMannager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatUserBoxInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadUserBox.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsInformationFailure");
         _loc1_.analyzer = new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatZhanLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getZhanPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "LoadingDirtyCharacterSheetsFailure";
         _loc1_.analyzer = new FilterWordAnalyzer(FilterWordManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createConsortiaLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["page"] = 1;
         _loc1_["size"] = 10000;
         _loc1_["order"] = -1;
         _loc1_["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["userID"] = -1;
         _loc1_["state"] = -1;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGuildMembersListFailure");
         _loc2_.analyzer = new ConsortionMemberAnalyer(ConsortionModelControl.Instance.memberListComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createCalendarRequest() : BaseLoader
      {
         return CalendarManager.getInstance().request();
      }
      
      public function getMyConsortiaData() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["page"] = 1;
         _loc1_["size"] = 1;
         _loc1_["name"] = "";
         _loc1_["level"] = -1;
         _loc1_["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["order"] = -1;
         _loc1_["openApply"] = -1;
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaInfoError");
         _loc2_.analyzer = new ConsortionListAnalyzer(ConsortionModelControl.Instance.selfConsortionComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatFeedbackInfoLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["userid"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionRead.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingComplainInformationFailure");
         _loc2_.analyzer = new LoadFeedbackReplyAnalyzer(FeedbackManager.instance.setupFeedbackData);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LevelList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         _loc1_.analyzer = new ExpericenceAnalyze(Experience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetLevelInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPetExpirenceTemplateFormFailure");
         _loc1_.analyzer = new PetExpericenceAnalyze(PetExperience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatTexpExpLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ExerciseInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTexpExpFailure");
         _loc1_.analyzer = new TexpExpAnalyze(TexpManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatWeaponBallAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("BombConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWeaponBallListFormFailure");
         _loc1_.analyzer = new WeaponBallInfoAnalyze(WeaponBallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyLeagueAwardLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyLeagueAward.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueAwardFailure");
         _loc1_.analyzer = new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatDailyLeagueLevelLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DailyLeagueLevel.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createWishInfoLader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GoldEquipTemplateLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new WishInfoAnalyzer(WishBeadManager.instance.getwishInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatServerConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ServerConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetTemplateInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetInfoFail");
         _loc1_.analyzer = new PetInfoAnalyzer(PetInfoManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetSkillLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("Petskillinfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetSkillFail");
         _loc1_.analyzer = new PetSkillAnalyzer(PetSkillManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatFoodComposeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FoodComposeList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadFoodComposeListFail");
         _loc1_.analyzer = new FoodComposeListAnalyzer(FarmComposeHouseController.instance().setupFoodComposeList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetConfigInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetConfigFail");
         _loc1_.analyzer = new PetconfigAnalyzer(null);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetSkillTemplateInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetSkillTemplateInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetAllSkillFail");
         _loc1_.analyzer = new PetAllSkillAnalyzer(PetAllSkillManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActiveInfoLoader() : BaseLoader
      {
         return CalendarManager.getInstance().requestActiveEvent();
      }
      
      public function creatActionExchangeInfoLoader() : BaseLoader
      {
         return CalendarManager.getInstance().requestActionExchange();
      }
      
      public function creatShopDisCountRealTimesLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         _loc2_.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount);
         return _loc2_;
      }
      
      public function creatVoteSubmit() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["userId"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VoteSubmit.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.vip.loadVip.error");
         _loc2_.analyzer = new VoteSubmitAnalyzer(this.loadVoteXml);
         return _loc2_;
      }
      
      public function createStoreEquipConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadStrengthExp.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadStoreEquipExperienceAllFail");
         _loc1_.analyzer = new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatCardGrooveLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardGrooveUpdateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadCardGrooveFail");
         _loc1_.analyzer = new CardGrooveEventAnalyzer(GrooveInfoManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatCardTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CardTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadCardTemplateInfoFail");
         _loc1_.analyzer = new CardTemplateAnalyzer(CardTemplateInfoManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemStrengthenGoodsInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ItemStrengthenGoodsInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadItemStrengthenGoodsInfoListFail");
         _loc1_.analyzer = new ItemStrengthenGoodsInfoAnalyzer(ItemStrengthenGoodsInfoManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createBeadTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("RuneTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadBeadInfoFail");
         _loc1_.analyzer = new BeadAnalyzer(BeadTemplateManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatHallIcon() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ButtonConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHallIconFail");
         _loc1_.analyzer = new HallIconDataAnalyz(MainButtonManager.instance.gethallIconInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createTotemTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TotemInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadTotemInfoFail");
         _loc1_.analyzer = new TotemDataAnalyz(TotemManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createHonorUpTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TotemHonorTemplate.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHonorUpInfoFail");
         _loc1_.analyzer = new HonorUpDataAnalyz(HonorUpManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createConsortiaBossTemplateLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaBossConfigLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadConsortiaBossInfoFail");
         _loc1_.analyzer = new ConsortiaBossDataAnalyzer(ConsortionModelControl.Instance.bossConfigDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatActiveLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActivePointTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadEveryDayActFail");
         _loc1_.analyzer = new ActivityAnalyzer(DayActivityManager.Instance.everyDayActive);
         return _loc1_;
      }
      
      public function creatActivePointLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActiveProgressInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.actInfoFail");
         _loc1_.analyzer = new ActivePointAnalzer(DayActivityManager.Instance.everyDayActivePoint);
         return _loc1_;
      }
      
      public function creatRewardLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EveryDayActiveRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.everyDayRewardFail");
         _loc1_.analyzer = new ActivityRewardAnalyzer(DayActivityManager.Instance.activityRewardComp);
         return _loc1_;
      }
      
      public function loaderSearchGoodsTemp() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SearchGoodsTemp.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.starUpdataInfoFail");
         _loc1_.analyzer = new UpdateStarAnalyer(BuriedManager.Instance.SearchGoodsTempHander);
         return _loc1_;
      }
      
      public function loaderSearchGoodsPayMoney() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SearchGoodsPayMoney.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.starUpDataCountInfoFail");
         _loc1_.analyzer = new SearchGoodsPayAnalyer(BuriedManager.Instance.searchGoodsPayHander);
         return _loc1_;
      }
      
      public function creatWondActiveLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadChargeActiveTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wondActInfoFail");
         _loc2_.analyzer = new WonderfulActAnalyer(WonderfulActivityManager.Instance.wonderfulActiveType);
         return _loc2_;
      }
      
      public function firstRechargeLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ChargeSpendRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.firstRechargeInfoFail");
         _loc2_.analyzer = new RechargeAnalyer(FirstRechargeManger.Instance.completeHander);
         return _loc2_;
      }
      
      public function accumulativeLoginLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoginAwardItemTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.accumulativeLoginInfoFail");
         _loc2_.analyzer = new AccumulativeLoginAnalyer(AccumulativeManager.instance.loadTempleteDataComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createDragonBoatActiveLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CommunalActive.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.dragonBoatActiveInfoFail");
         _loc1_.analyzer = new DragonBoatActiveDataAnalyzer(DragonBoatManager.instance.templateDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCaddyAwardsLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LotteryShowTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.analyzer = new CaddyAwardDataAnalyzer(CaddyAwardModel.getInstance().setUp);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createActivitySystemItemsLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivitySystemItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.activitySystemItemsInfoFail");
         _loc1_.analyzer = new ActivitySystemItemsDataAnalyzer(this.activitySystemItemsDataHandler);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function activitySystemItemsDataHandler(param1:DataAnalyzer) : void
      {
         var _loc2_:ActivitySystemItemsDataAnalyzer = null;
         if(param1 is ActivitySystemItemsDataAnalyzer)
         {
            _loc2_ = param1 as ActivitySystemItemsDataAnalyzer;
            PyramidManager.instance.templateDataSetup(_loc2_.pyramidSystemDataList);
            GuildMemberWeekManager.instance.templateDataSetup(_loc2_.guildMemberWeekDataList);
            GrowthPackageManager.instance.templateDataSetup(_loc2_.growthPackageDataList);
            KingDivisionManager.Instance.templateDataSetup(_loc2_.kingDivisionDataList);
            ChickActivationManager.instance.templateDataSetup(_loc2_.chickActivationDataList);
            WitchBlessingManager.Instance.templateDataSetup(_loc2_.witchBlessingDataList);
         }
      }
      
      public function createNewFusionDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FusionInfoLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.newFusionDataInfoFail");
         _loc1_.analyzer = new FusionNewDataAnalyzer(FusionNewManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createEnergyDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MissionEnergyPrice.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.energyInfoFail");
         _loc1_.analyzer = new EnergyDataAnalyzer(PlayerManager.Instance.setupEnergyData);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCallPropDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("RankTemplateAll.xml?type=" + Math.random()),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.callPropInfoFail");
         _loc1_.analyzer = new CallPropDataAnalyer(PlayerManager.Instance.setupCallPropData);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createGroupPurchaseAwardInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("TeamBuyActiveAwardInfo.ashx"),BaseLoader.REQUEST_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.groupPurchaseDataInfoFail");
         _loc1_.analyzer = new GroupPurchaseAwardAnalyzer(GroupPurchaseManager.instance.awardAnalyComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function loadVoteXml(param1:VoteSubmitAnalyzer) : void
      {
         var _loc2_:BaseLoader = null;
         if(param1.result == VoteSubmitAnalyzer.FILENAME)
         {
            _loc2_ = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(VoteSubmitAnalyzer.FILENAME),BaseLoader.TEXT_LOADER);
            _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.view.vote.loadXMLError");
            _loc2_.analyzer = new VoteInfoAnalyzer(VoteManager.Instance.loadCompleted);
            LoadResourceManager.Instance.startLoad(_loc2_);
         }
      }
      
      public function loadWonderfulActivityXml() : BaseLoader
      {
         ++this._actReloadeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._actReloadeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GmActivityInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wonderfulActiveInfoFail");
         _loc2_.analyzer = new WonderfulGMActAnalyer(WonderfulActivityManager.Instance.wonderfulGMActiveInfo);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function requestMsnConfirm(param1:int, param2:String = "") : BaseLoader
      {
         var _loc3_:URLVariables = new URLVariables();
         _loc3_["uid"] = PlayerManager.Instance.Self.ID;
         _loc3_["type"] = param1;
         _loc3_["code"] = param2;
         _loc3_["rnd"] = Math.random();
         var _loc4_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ResetPassword4399.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
         _loc4_.analyzer = new MsnConfirmAnalyzer(BaglockedManager.Instance.msnConfirmAnalyeComplete);
         _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc4_;
      }
      
      public function createAvatarCollectionUnitDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothPropertyTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionUnitDataFail");
         _loc1_.analyzer = new AvatarCollectionUnitDataAnalyzer(AvatarCollectionManager.instance.unitListDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createAvatarCollectionItemDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothGroupTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionItemDataFail");
         _loc1_.analyzer = new AvatarCollectionItemDataAnalyzer(AvatarCollectionManager.instance.itemListDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createPetsRisingStarDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetStarExp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         _loc1_.analyzer = new PetsRisingStarDataAnalyzer(PetsAdvancedManager.Instance.risingStarDataComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createPetsEvolutionDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadPetFightProperty.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         _loc1_.analyzer = new PetsEvolutionDataAnalyzer(PetsAdvancedManager.Instance.evolutionDataComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function loadMagicStoneTemplate() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("MagicStoneTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.magicStoneTempFail");
         _loc1_.analyzer = new MagicStoneTempAnalyer(MagicStoneManager.instance.loadMgStoneTempComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function creatSuitTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new SuitTempleteAnalyzer(ItemManager.Instance.setupSuitTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipSuitTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitPartEquipInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new EquipSuitTempleteAnalyzer(ItemManager.Instance.setupEquipSuitTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatGodSyahLoader(param1:int = 7) : BaseLoader
      {
         if(param1 != 7)
         {
            return null;
         }
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["rnd"] = TextLoader.TextLoaderKey + Math.random().toString();
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SubActiveList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGodSyahFailure");
         _loc3_.analyzer = new SyahAnalyzer(SyahManager.Instance.godSyahLoaderCompleted);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc3_;
      }
      
      public function creatSuperWinnerLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("DiceGameAwardItem.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.superWinner.loadAwardsError");
         _loc1_.analyzer = new SuperWinnerAnalyze(SuperWinnerManager.instance.awardsLoadCompleted);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function loadLanternRiddlesXml() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LightRiddleQuest.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.lanternRiddlesInfoFail");
         _loc1_.analyzer = new LanternDataAnalyzer(LanternRiddlesManager.instance.questionInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createLightRoadLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("GoodsCollect.xml?type=LightRoadPath"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LightRoadInfoFail");
         _loc1_.analyzer = new LightRoadDataAnalyzer(LightRoadManager.instance.templateDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createGodsRoadsLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityQuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.godsRoads.cuowu");
         _loc1_.analyzer = new GodsRoadsDataAnalyzer(GodsRoadsManager.instance.templateDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createSevenDayTargetLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityQuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.sevenDayTargetInfoFail");
         _loc1_.analyzer = new SevenDayTargetDataAnalyzer(SevenDayTargetManager.Instance.templateDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createHalloweenLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivityHalloweenItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.halloweenPrizeInfoFail");
         _loc1_.analyzer = new HalloweenDataAnalyzer(HalloweenManager.instance.templateDataSetup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
   }
}

