package ddt.states
{
   import Dice.View.DiceSystem;
   import academy.AcademyController;
   import auctionHouse.controller.AuctionHouseController;
   import boguAdventure.view.BoguAdventureStateView;
   import campbattle.view.CampBattleView;
   import christmas.controller.ChristmasRoomController;
   import church.controller.ChurchRoomController;
   import church.controller.ChurchRoomListController;
   import civil.CivilController;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.utils.StringUtils;
   import consortion.ConsortionControl;
   import consortionBattle.view.ConsortiaBattleMainView;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import escort.view.EscortMainView;
   import farm.viewx.FarmSwitchView;
   import fightFootballTime.FightFootballTimeLoadingState;
   import fightLib.FightLibState;
   import fightLib.view.FightLibGameView;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import game.view.GameView;
   import hall.HallStateView;
   import lightRoad.Controller.LightRoadController;
   import littleGame.LittleGame;
   import littleGame.LittleHall;
   import login.LoginStateView;
   import lottery.LotteryContorller;
   import lottery.contorller.CardLotteryContorller;
   import pyramid.view.PyramidSystem;
   import room.view.states.ChallengeRoomState;
   import room.view.states.DungeonRoomState;
   import room.view.states.FreshmanRoomState;
   import room.view.states.MatchRoomState;
   import room.view.states.MissionRoomState;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   import roomLoading.CampBattleLoadingState;
   import roomLoading.EncounterLoadingState;
   import roomLoading.RoomLoadingState;
   import roomLoading.SingleBattleMatchState;
   import sevenDouble.view.SevenDoubleMainView;
   import shop.ShopController;
   import superWinner.controller.SuperWinnerController;
   import tofflist.TofflistController;
   import trainer.view.TrainerGameView;
   import treasure.view.TreasureMain;
   import worldboss.WorldBossAwardController;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossFightRoomState;
   
   public class StateCreater implements IStateCreator
   {
      
      private var _state:Dictionary = new Dictionary();
      
      private var _currentStateType:String;
      
      public function StateCreater()
      {
         super();
      }
      
      public function create(param1:String, param2:int = 0) : BaseStateView
      {
         UIModuleSmallLoading.Instance.hide();
         switch(param1)
         {
            case StateType.LOGIN:
               return new LoginStateView();
            case StateType.MAIN:
               return new HallStateView();
            case StateType.ROOM_LOADING:
               return new RoomLoadingState();
            case StateType.ENCOUNTER_LOADING:
               return new EncounterLoadingState();
            case StateType.SINGLEBATTLE_MATCHING:
               return new SingleBattleMatchState();
            case StateType.CAMP_BATTLE_LOADING:
               return new CampBattleLoadingState();
            case StateType.ROOM_LIST:
               return new RoomListController();
            case StateType.AUCTION:
               return new AuctionHouseController();
            case StateType.TOFFLIST:
               return new TofflistController();
            case StateType.DUNGEON_LIST:
               return new DungeonListController();
            case StateType.CONSORTIA:
               return new ConsortionControl();
            case StateType.FARM:
               return new FarmSwitchView();
            case StateType.DDTCHURCH_ROOM_LIST:
               return new ChurchRoomListController();
            case StateType.CHURCH_ROOM:
               return new ChurchRoomController();
            case StateType.SHOP:
               return new ShopController();
            case StateType.MATCH_ROOM:
               return new MatchRoomState();
            case StateType.DUNGEON_ROOM:
               return new DungeonRoomState();
            case StateType.CHALLENGE_ROOM:
               return new ChallengeRoomState();
            case StateType.TRAINER1:
            case StateType.TRAINER2:
               return new TrainerGameView();
            case StateType.MISSION_ROOM:
               return new MissionRoomState();
            case StateType.FIGHTING:
               return new GameView();
            case StateType.CIVIL:
               return new CivilController();
            case StateType.FRESHMAN_ROOM1:
            case StateType.FRESHMAN_ROOM2:
               return new FreshmanRoomState();
            case StateType.ACADEMY_REGISTRATION:
               return new AcademyController();
            case StateType.FIGHT_LIB:
               return new FightLibState();
            case StateType.FIGHT_LIB_GAMEVIEW:
               return new FightLibGameView();
            case StateType.LITTLEHALL:
               return new LittleHall();
            case StateType.LITTLEGAME:
               return new LittleGame();
            case StateType.WORLDBOSS_ROOM:
               return WorldBossRoomController.Instance;
            case StateType.WORLDBOSS_AWARD:
               return new WorldBossAwardController();
            case StateType.WORLDBOSS_FIGHT_ROOM:
               return new WorldBossFightRoomState();
            case StateType.LOTTERY_HALL:
               return new LotteryContorller();
            case StateType.LOTTERY_CARD:
               return new CardLotteryContorller();
            case StateType.DICE_SYSTEM:
               return new DiceSystem();
            case StateType.CONSORTIA_BATTLE_SCENE:
               return new ConsortiaBattleMainView();
            case StateType.TREASURE:
               return new TreasureMain();
            case StateType.FIGHTFOOTBALLTIME:
               return new FightFootballTimeLoadingState();
            case StateType.PYRAMID:
               return new PyramidSystem();
            case StateType.CHRISTMAS_ROOM:
               return ChristmasRoomController.Instance;
            case StateType.CAMP_BATTLE_SCENE:
               return new CampBattleView();
            case StateType.SEVEN_DOUBLE_SCENE:
               return new SevenDoubleMainView();
            case StateType.ESCORT:
               return new EscortMainView();
            case StateType.SUPER_WINNER:
               return SuperWinnerController.instance;
            case StateType.LIGHTROAD_WINDOW:
               return LightRoadController.Instance;
            case StateType.BOGU_ADVENTURE:
               return new BoguAdventureStateView();
            default:
               return null;
         }
      }
      
      public function createAsync(param1:String, param2:Function, param3:int = 0) : void
      {
         var _loc5_:int = 0;
         var _loc4_:StateLoadingInfo = this.getStateLoadingInfo(param1,this.getNeededUIModuleByType(param1),param2);
         this._currentStateType = param1;
         if(_loc4_.isComplete)
         {
            param2(this.create(param1,param3));
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.neededUIModule.length)
            {
               UIModuleLoader.Instance.addUIModuleImp(_loc4_.neededUIModule[_loc5_],param1);
               _loc5_++;
            }
         }
      }
      
      private function __onCloseLoading(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade >= 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            if(this._currentStateType == StateType.WORLDBOSS_FIGHT_ROOM)
            {
               WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STOPFIGHT));
            }
         }
      }
      
      private function getStateLoadingInfo(param1:String, param2:String = null, param3:Function = null) : StateLoadingInfo
      {
         var _loc4_:StateLoadingInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         _loc4_ = this._state[param1];
         if(_loc4_ == null)
         {
            _loc4_ = new StateLoadingInfo();
            if(param2 != null && param2 != "")
            {
               _loc5_ = param2.split(",");
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_.neededUIModule.push(_loc5_[_loc6_]);
                  _loc6_++;
               }
            }
            else
            {
               _loc4_.isComplete = true;
            }
            _loc4_.state = param1;
            _loc4_.callBack = param3;
            this._state[param1] = _loc4_;
         }
         return _loc4_;
      }
      
      private function __onUimoduleLoadComplete(param1:UIModuleEvent) : void
      {
         var _loc5_:BaseStateView = null;
         if(StringUtils.isEmpty(param1.state))
         {
            return;
         }
         var _loc2_:StateLoadingInfo = this.getStateLoadingInfo(param1.state);
         if(_loc2_.completeedUIModule.indexOf(param1.module) == -1)
         {
            _loc2_.completeedUIModule.push(param1.module);
         }
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.neededUIModule.length)
         {
            if(_loc2_.completeedUIModule.indexOf(_loc2_.neededUIModule[_loc4_]) == -1)
            {
               _loc3_ = false;
            }
            _loc4_++;
         }
         _loc2_.isComplete = _loc3_;
         if(_loc2_.isComplete && this._currentStateType == _loc2_.state)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            UIModuleSmallLoading.Instance.hide();
            _loc5_ = this.create(param1.state);
            if(_loc2_.callBack != null)
            {
               _loc2_.callBack(_loc5_);
            }
         }
      }
      
      private function __onUimoduleLoadError(param1:UIModuleEvent) : void
      {
      }
      
      private function __onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         var _loc2_:StateLoadingInfo = null;
         var _loc3_:StateLoadingInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         for each(_loc2_ in this._state)
         {
            if(_loc2_.neededUIModule.indexOf(param1.module) != -1)
            {
               _loc2_.progress[param1.module] = param1.loader.progress;
            }
         }
         _loc3_ = this.getStateLoadingInfo(param1.state);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.neededUIModule.length)
         {
            if(_loc3_.progress[_loc3_.neededUIModule[_loc5_]] != null)
            {
               _loc6_ = Number(_loc3_.progress[_loc3_.neededUIModule[_loc5_]]);
               _loc4_ += _loc6_ * 100 / _loc3_.neededUIModule.length;
            }
            _loc5_++;
         }
         if(this._currentStateType == _loc3_.state)
         {
            UIModuleSmallLoading.Instance.progress = _loc4_;
         }
      }
      
      public function getNeededUIModuleByType(param1:String) : String
      {
         if(param1 == StateType.MAIN)
         {
            return UIModuleTypes.DDTCHURCH_ROOM_LIST;
         }
         if(param1 == StateType.TOFFLIST)
         {
            return UIModuleTypes.TOFFLIST;
         }
         if(param1 == StateType.SUPER_WINNER)
         {
            return UIModuleTypes.SUPER_WINNER;
         }
         if(param1 == StateType.AUCTION)
         {
            return UIModuleTypes.DDTAUCTION + "," + UIModuleTypes.DDTBEAD;
         }
         if(param1 == StateType.FARM)
         {
            return UIModuleTypes.FARM + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.CONSORTIA)
         {
            return UIModuleTypes.CONSORTIAII + "," + UIModuleTypes.DDTCONSORTIA + "," + UIModuleTypes.DDTBEAD;
         }
         if(param1 == StateType.SHOP)
         {
            return UIModuleTypes.DDTSHOP;
         }
         if(param1 == StateType.ROOM_LIST || param1 == StateType.DUNGEON_LIST || param1 == StateType.FRESHMAN_ROOM1 || param1 == StateType.WORLDBOSS_FIGHT_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.DDTROOMLIST + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.FRESHMAN_ROOM2)
         {
            return UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEIII;
         }
         if(param1 == StateType.MATCH_ROOM || param1 == StateType.DUNGEON_ROOM || param1 == StateType.MISSION_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.CHALLENGE_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING;
         }
         if(param1 == StateType.DDTCHURCH_ROOM_LIST)
         {
            return UIModuleTypes.DDTCHURCH_ROOM_LIST;
         }
         if(param1 == StateType.CHURCH_ROOM)
         {
            return UIModuleTypes.CHURCH_ROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.EXPRESSION;
         }
         if(param1 == StateType.CIVIL)
         {
            return UIModuleTypes.DDTCIVIL;
         }
         if(param1 == StateType.HOT_SPRING_ROOM_LIST)
         {
            return UIModuleTypes.DDT_HOT_SPRING_ROOM_LIST;
         }
         if(param1 == StateType.HOT_SPRING_ROOM)
         {
            return UIModuleTypes.HOT_SPRING_ROOM + "," + UIModuleTypes.EXPRESSION;
         }
         if(param1 == StateType.FIGHTING)
         {
            return UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.TRAINER1)
         {
            return UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.TRAINER2)
         {
            return UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.ACADEMY_REGISTRATION)
         {
            return UIModuleTypes.DDTACADEMY;
         }
         if(param1 == StateType.FIGHT_LIB)
         {
            return UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.FIGHT_LIB + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DDTROOM;
         }
         if(param1 == StateType.LITTLEHALL)
         {
            return UIModuleTypes.DDTSHOP + "," + UIModuleTypes.DDT_LITTLEGAME + "," + UIModuleTypes.EXPRESSION;
         }
         if(param1 == StateType.WORLDBOSS_AWARD)
         {
            return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.DDTSHOP + "," + UIModuleTypes.DDT_LITTLEGAME;
         }
         if(param1 == StateType.WORLDBOSS_ROOM || param1 == StateType.CHRISTMAS_ROOM)
         {
            return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.DDTROOM + "," + UIModuleTypes.DDTROOMLIST + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.ROOM_LOADING || param1 == StateType.ENCOUNTER_LOADING || param1 == StateType.CAMP_BATTLE_LOADING || param1 == StateType.SINGLEBATTLE_MATCHING || param1 == StateType.FIGHTFOOTBALLTIME)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.ROOM_LOADING)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.LOTTERY_HALL)
         {
            return UIModuleTypes.LOTTERY;
         }
         if(param1 == StateType.CONSORTIA_BATTLE_SCENE)
         {
            return UIModuleTypes.CONSORTIA_BATTLE;
         }
         if(param1 == StateType.CAMP_BATTLE_SCENE)
         {
            return UIModuleTypes.CAMP_BATTLE_SCENE + "," + UIModuleTypes.GAME + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.CONSORTIA_BATTLE + "," + UIModuleTypes.DDTCONSORTIA;
         }
         if(param1 == StateType.PYRAMID)
         {
            return UIModuleTypes.PYRAMID + "," + UIModuleTypes.DDTSHOP;
         }
         if(param1 == StateType.SEVEN_DOUBLE_SCENE)
         {
            return UIModuleTypes.SEVEN_DOUBLE_GAME;
         }
         if(param1 == StateType.ESCORT)
         {
            return UIModuleTypes.ESCORT_GAME;
         }
         if(param1 == StateType.BOGU_ADVENTURE)
         {
            return UIModuleTypes.BOGU_ADVENTURE + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DEFAULT_LIVING;
         }
         return "";
      }
   }
}

