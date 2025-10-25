package dayActivity.items
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import dayActivity.DayActivityManager;
   import dayActivity.data.ActivityData;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import labyrinth.LabyrinthManager;
   import league.manager.LeagueManager;
   import ringStation.RingStationManager;
   import room.RoomManager;
   import room.view.roomView.SingleRoomView;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import worldboss.WorldBossManager;
   
   public class DayActivityLeftListItem extends Component implements Disposeable
   {
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _line:Bitmap;
      
      private var _str:String;
      
      private var _overCount:int;
      
      private var _total:int;
      
      private var _money:int;
      
      private var _data:ActivityData;
      
      private var _lastCreatTime:int = 0;
      
      private var _backGround:Component;
      
      private var _startTime:int;
      
      private var _endTime:int;
      
      private var alertFrame:BaseAlerFrame;
      
      public function DayActivityLeftListItem(param1:Boolean, param2:ActivityData)
      {
         super();
         this._data = param2;
         this.initView(param1,param2);
      }
      
      private function initView(param1:Boolean, param2:ActivityData) : void
      {
         if(param1)
         {
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt1");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt1");
            this._btn = ComponentFactory.Instance.creatComponentByStylename("dayActivity.quikeBtn");
            this._btn.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.quitkOver",param2.ActivePoint);
            this._money = param2.MoneyPoint;
            addChild(this._btn);
            buttonMode = true;
            useHandCursor = true;
         }
         else
         {
            this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt2");
            this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.Itemtxt2");
         }
         _id = param2.ID;
         this._txt1.x = 0;
         this._txt1.y = 4;
         this._txt1.text = param2.Description;
         addChild(this._txt1);
         this._txt2.y = 4;
         this._txt2.text = param2.OverCount + "/" + param2.Count;
         addChild(this._txt2);
         this._total = param2.Count;
         this._line = ComponentFactory.Instance.creatBitmap("day.line");
         addChild(this._line);
         addEventListener(MouseEvent.CLICK,this.jumpHander);
         this._backGround = new Component();
         this._backGround.graphics.beginFill(0);
         this._backGround.graphics.drawRect(0,0,200,20);
         this._backGround.graphics.endFill();
         this._backGround.alpha = 0;
         this._backGround.tipStyle = "ddt.view.tips.OneLineTip";
         this._backGround.tipDirctions = "5,1,2";
         if(param2.JumpType > 0)
         {
            this._backGround.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.itemTips",param2.ActivePoint,param2.Description);
         }
         else
         {
            this._backGround.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.btnTip",param2.ActivePoint);
         }
         addChild(this._backGround);
      }
      
      protected function jumpHander(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         if(param1.target is SimpleBitmapButton)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._str = LanguageMgr.GetTranslation("ddt.Dayactivity.addSpeed",this._money);
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),this._str,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.GAME_TOP_LAYER,null,"SimpleAlert",50,true,AlertManager.SELECTBTN);
            _loc2_.enterEnable = false;
            if(Boolean(_loc2_.parent))
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
            return;
         }
         if(this._data.JumpType > 0)
         {
            switch(this._data.JumpType)
            {
               case 1:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,30))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                     return;
                  }
                  LabyrinthManager.Instance.show();
                  break;
               case 2:
                  if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,2))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",2));
                     return;
                  }
                  if(!LeagueManager.instance.isOpen)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  StateManager.setState(StateType.ROOM_LIST);
                  ComponentSetting.SEND_USELOG_ID(3);
                  if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
                  }
                  break;
               case 3:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,16))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",16));
                     return;
                  }
                  if(!BattleGroudManager.Instance.isShow)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  GameInSocketOut.sendSingleRoomBegin(RoomManager.BATTLE_ROOM);
                  break;
               case 4:
                  if(!WorldBossManager.Instance.isOpen)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     return;
                  }
                  SocketManager.Instance.out.enterWorldBossRoom();
                  break;
               case 5:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,20))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                     return;
                  }
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.TOTEMVIEW - 1);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 6:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,25))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 7:
                  if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,7))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",7));
                     return;
                  }
                  StateManager.setState(StateType.CONSORTIA);
                  ComponentSetting.SEND_USELOG_ID(5);
                  if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
                  }
                  break;
               case 8:
                  StateManager.setState(StateType.SHOP);
                  ComponentSetting.SEND_USELOG_ID(1);
                  break;
               case 9:
                  if(PlayerManager.Instance.Self.Grade < 8)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
                     return;
                  }
                  if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                     return;
                  }
                  if(getTimer() - this._lastCreatTime > 1000)
                  {
                     this._lastCreatTime = getTimer();
                     GameInSocketOut.sendSingleRoomBegin(SingleRoomView.ENCOUNTER);
                  }
                  break;
               case 10:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,10))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                     return;
                  }
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 11:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,7))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",7));
                     return;
                  }
                  _loc3_ = ConsortionModelControl.Instance.bossCallCondition;
                  if(PlayerManager.Instance.Self.consortiaInfo.Level < _loc3_)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.conditionTxt2",_loc3_));
                     return;
                  }
                  StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
                  break;
               case 12:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,25))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                  break;
               case 13:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,9))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",9));
                     return;
                  }
                  this.toDungeon();
                  break;
               case 14:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                  return;
               case 15:
                  if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,25))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                     return;
                  }
                  SocketManager.Instance.out.enterBuried();
                  break;
               case 16:
                  BagAndInfoManager.Instance.showBagAndInfo(4);
                  if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLICK_BAG))
                  {
                     SocketManager.Instance.out.syncWeakStep(Step.CLICK_BAG);
                     SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN_SHOW);
                  }
                  break;
               case 53:
                  RingStationManager.instance.show();
            }
            DayActivityManager.Instance.dispose();
         }
      }
      
      public function setTxt2(param1:int) : void
      {
         if(param1 >= this._total)
         {
            param1 = this._total;
         }
         this._txt2.text = param1 + "/" + this._total;
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(!_loc2_.isBand)
            {
               if(!this.checkMoney(false))
               {
                  _loc2_.dispose();
                  this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this.alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               LeavePageManager.showFillFrame();
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               return;
            }
            if(!this.checkMoney(true))
            {
               _loc2_.dispose();
               this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
               return;
            }
            DayActivityManager.Instance.send(1,_id);
         }
         ObjectUtils.disposeObject(_loc2_);
         _loc2_ = null;
      }
      
      private function checkMoney(param1:Boolean) : Boolean
      {
         if(param1)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._money)
         {
            return false;
         }
         return true;
      }
      
      private function onResponseHander(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            DayActivityManager.Instance.send(2,_id);
         }
         param1.currentTarget.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function toDungeon() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,8))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
            return;
         }
         if(!PlayerManager.Instance.checkEnterDungeon)
         {
            return;
         }
         StateManager.setState(StateType.DUNGEON_LIST);
         ComponentSetting.SEND_USELOG_ID(4);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.jumpHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

