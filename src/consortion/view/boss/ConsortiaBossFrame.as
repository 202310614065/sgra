package consortion.view.boss
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaBossDataVo;
   import consortion.data.ConsortiaBossModel;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class ConsortiaBossFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _cellList:Vector.<BossMemberItem>;
      
      private var _endTimeTxt:FilterFrameText;
      
      private var _extendBtn:SimpleBitmapButton;
      
      private var _bossStateBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      private var _timerChairman:Timer;
      
      private var _bossState:int = -1;
      
      private var _callBossLevel:int = 0;
      
      private var _isClickEnter:Boolean = false;
      
      private var _levelView:ConsortiaBossLevelView;
      
      public function ConsortiaBossFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BossMemberItem = null;
         titleText = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.bg");
         addToContent(this._bg);
         this._cellList = new Vector.<BossMemberItem>(11);
         _loc1_ = 0;
         while(_loc1_ < 11)
         {
            _loc2_ = new BossMemberItem();
            _loc2_.x = 26;
            _loc2_.y = 88 + _loc1_ * 35;
            _loc2_.visible = false;
            addToContent(_loc2_);
            this._cellList[_loc1_] = _loc2_;
            _loc1_++;
         }
         this._endTimeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.endTimeTxt");
         this._endTimeTxt.visible = false;
         addToContent(this._endTimeTxt);
         this._extendBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.extendBtn");
         addToContent(this._extendBtn);
         this._extendBtn.enable = false;
         (this._extendBtn.backgound["mc"] as MovieClip).gotoAndStop(4);
         this._bossStateBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.bossStateBtn");
         addToContent(this._bossStateBtn);
         this._bossStateBtn.enable = false;
         (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(1);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.helpBtn");
         addToContent(this._helpBtn);
         this._levelView = new ConsortiaBossLevelView();
         PositionUtils.setPos(this._levelView,"consortiaBoss.levelViewPos");
         addToContent(this._levelView);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._extendBtn.addEventListener(MouseEvent.CLICK,this.extendBossTime,false,0,true);
         this._bossStateBtn.addEventListener(MouseEvent.CLICK,this.callOrEnterBoss,false,0,true);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.showHelpFrame,false,0,true);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      private function extendBossTime(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = ConsortionModelControl.Instance.getCallExtendBossCostRich(2,this._callBossLevel);
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.bossFrame.extendConfirmTxt",_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__confirmExtendBossTime,false,0,true);
      }
      
      private function __confirmExtendBossTime(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmExtendBossTime);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc3_ = ConsortionModelControl.Instance.getCallExtendBossCostRich(2,this._callBossLevel);
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < _loc3_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.unenoughRiches"));
               return;
            }
            SocketManager.Instance.out.sendConsortiaBossInfo(2);
            this._timerChairman.reset();
            this._timerChairman.start();
            this._timer.reset();
            this._timer.start();
            this._extendBtn.enable = false;
         }
      }
      
      private function callOrEnterBoss(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._bossState == 0)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = ConsortionModelControl.Instance.getCallBossCostRich(this._levelView.selectedLevel);
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.bossFrame.callConfirmTxt",_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc3_.moveEnable = false;
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__confirmCallBoss,false,0,true);
         }
         else if(this._bossState == 1)
         {
            if(!this._isClickEnter)
            {
               this._isClickEnter = true;
               GameInSocketOut.sendSingleRoomBegin(2);
            }
         }
      }
      
      private function __confirmCallBoss(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmCallBoss);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc3_ = ConsortionModelControl.Instance.getCallBossCostRich(this._levelView.selectedLevel);
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < _loc3_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.unenoughRiches"));
               return;
            }
            SocketManager.Instance.out.sendConsortiaBossInfo(0,ConsortionModelControl.Instance.getRequestCallBossLevel(this._levelView.selectedLevel));
            this._timerChairman.reset();
            this._timerChairman.start();
            this._timer.reset();
            this._timer.start();
            this._bossStateBtn.enable = false;
         }
      }
      
      private function initData() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.refreshData);
         this._timerChairman = new Timer(1000);
         this._timerChairman.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer = new Timer(10000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         this.timerHandler(null);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         SocketManager.Instance.out.sendConsortiaBossInfo(1);
      }
      
      private function refreshData(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ConsortiaBossDataVo = null;
         var _loc8_:ConsortiaBossDataVo = null;
         var _loc2_:ConsortiaBossModel = new ConsortiaBossModel();
         _loc2_.endTime = TimeManager.Instance.Now();
         _loc2_.extendAvailableNum = 3;
         _loc2_.playerList = new Vector.<ConsortiaBossDataVo>(11);
         this._callBossLevel = 0;
         var _loc3_:PackageIn = param1.pkg;
         _loc2_.bossState = _loc3_.readByte();
         if(_loc2_.bossState == 1 || _loc2_.bossState == 2)
         {
            _loc4_ = _loc3_.readBoolean();
            if(_loc4_)
            {
               _loc7_ = new ConsortiaBossDataVo();
               _loc7_.name = PlayerManager.Instance.Self.NickName;
               _loc7_.rank = _loc3_.readInt();
               _loc7_.damage = _loc3_.readInt();
               _loc7_.honor = _loc3_.readInt();
               _loc7_.contribution = _loc3_.readInt();
               _loc2_.playerList[0] = _loc7_;
            }
            _loc5_ = _loc3_.readByte();
            _loc6_ = 1;
            while(_loc6_ <= _loc5_)
            {
               _loc8_ = new ConsortiaBossDataVo();
               _loc8_.name = _loc3_.readUTF();
               _loc8_.rank = _loc3_.readInt();
               _loc8_.damage = _loc3_.readInt();
               _loc8_.honor = _loc3_.readInt();
               _loc8_.contribution = _loc3_.readInt();
               _loc2_.playerList[_loc6_] = _loc8_;
               _loc6_++;
            }
            _loc2_.extendAvailableNum = _loc3_.readByte();
            _loc2_.endTime = _loc3_.readDate();
            _loc2_.callBossLevel = _loc3_.readInt();
            this._callBossLevel = _loc2_.callBossLevel;
         }
         this._bossState = _loc2_.bossState;
         this.refreshView(_loc2_);
      }
      
      private function refreshView(param1:ConsortiaBossModel) : void
      {
         var _loc5_:ConsortiaBossDataVo = null;
         var _loc2_:Vector.<ConsortiaBossDataVo> = param1.playerList;
         var _loc3_:int = 0;
         while(_loc3_ < 11)
         {
            _loc5_ = _loc2_[_loc3_];
            if(Boolean(_loc5_))
            {
               this._cellList[_loc3_].info = _loc5_;
               this._cellList[_loc3_].visible = true;
            }
            else
            {
               this._cellList[_loc3_].visible = false;
            }
            _loc3_++;
         }
         this.refreshEndTimeTxt(param1);
         (this._extendBtn.backgound["mc"] as MovieClip).gotoAndStop(param1.extendAvailableNum + 1);
         var _loc4_:Boolean = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._10_ChangeMan);
         if(param1.bossState == 1)
         {
            (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(2);
            if(param1.extendAvailableNum <= 0)
            {
               this._extendBtn.enable = false;
            }
            else
            {
               this._extendBtn.enable = _loc4_;
            }
            this._bossStateBtn.enable = true;
            this._endTimeTxt.visible = true;
            this._timerChairman.stop();
         }
         else
         {
            this._endTimeTxt.visible = false;
            this._extendBtn.enable = false;
            if(param1.bossState == 0)
            {
               if(_loc4_)
               {
                  (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(4);
               }
               else
               {
                  (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(1);
               }
               this._bossStateBtn.enable = _loc4_;
            }
            else if(param1.bossState == 2)
            {
               (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(3);
               this._bossStateBtn.enable = false;
            }
         }
         if(Boolean(this._levelView))
         {
            if(param1.bossState == 0)
            {
               this._levelView.mouseChildren = true;
               this._levelView.mouseEnabled = true;
            }
            else
            {
               this._levelView.mouseChildren = false;
               this._levelView.mouseEnabled = false;
               if(param1.bossState == 1)
               {
                  this._levelView.selectedLevel = ConsortionModelControl.Instance.getCanCallBossMaxLevel(this._callBossLevel);
               }
            }
         }
      }
      
      private function refreshEndTimeTxt(param1:ConsortiaBossModel) : void
      {
         var _loc6_:String = null;
         var _loc2_:Number = param1.endTime.getTime();
         var _loc3_:Number = TimeManager.Instance.Now().getTime();
         var _loc4_:int = _loc2_ - _loc3_;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         var _loc5_:int = 0;
         if(_loc4_ / TimeManager.HOUR_TICKS > 1)
         {
            _loc5_ = _loc4_ / TimeManager.HOUR_TICKS;
            _loc6_ = _loc5_ + LanguageMgr.GetTranslation("hour");
         }
         else if(_loc4_ / TimeManager.Minute_TICKS > 1)
         {
            _loc5_ = _loc4_ / TimeManager.Minute_TICKS;
            _loc6_ = _loc5_ + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            _loc5_ = _loc4_ / TimeManager.Second_TICKS;
            _loc6_ = _loc5_ + LanguageMgr.GetTranslation("second");
         }
         this._endTimeTxt.text = _loc6_;
      }
      
      private function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function showHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("consortiaBoss.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("consortiaBoss.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._extendBtn))
         {
            this._extendBtn.removeEventListener(MouseEvent.CLICK,this.extendBossTime);
         }
         if(Boolean(this._bossStateBtn))
         {
            this._bossStateBtn.removeEventListener(MouseEvent.CLICK,this.callOrEnterBoss);
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.showHelpFrame);
         }
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.refreshData);
         if(Boolean(this._timerChairman))
         {
            this._timerChairman.stop();
            this._timerChairman.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timerChairman = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer = null;
         if(Boolean(this._extendBtn))
         {
            (this._extendBtn.backgound as MovieClip).gotoAndStop(5);
         }
         if(Boolean(this._bossStateBtn))
         {
            (this._bossStateBtn.backgound as MovieClip).gotoAndStop(5);
         }
         super.dispose();
         this._bg = null;
         this._cellList = null;
         this._endTimeTxt = null;
         this._extendBtn = null;
         this._bossStateBtn = null;
         this._helpBtn = null;
         this._levelView = null;
      }
   }
}

