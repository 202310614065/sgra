package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionSkillInfo;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaMyTaskView extends Sprite implements Disposeable
   {
      
      private var _taskInfo:ConsortiaTaskInfo;
      
      private var _vbox:VBox;
      
      private var _finishItemList:Vector.<ConsortiaMyTaskFinishItem>;
      
      private var _myFinishTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _offerTxt:FilterFrameText;
      
      private var _richesTxt:FilterFrameText;
      
      private var _skillNameTxt:FilterFrameText;
      
      private var _contentTxt1:FilterFrameText;
      
      private var _contentTxt2:FilterFrameText;
      
      private var _contentTxt3:FilterFrameText;
      
      private var _expText:FilterFrameText;
      
      private var _moneyText:FilterFrameText;
      
      private var _caiText:FilterFrameText;
      
      private var _skillText:FilterFrameText;
      
      private var _contributionLbl:FilterFrameText;
      
      private var _contributionTxt:FilterFrameText;
      
      private var _myReseBtn:TextButton;
      
      private var _delayTimeBtn:TextButton;
      
      public function ConsortiaMyTaskView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc5_:int = 0;
         var _loc6_:ConsortiaMyTaskFinishItem = null;
         this._finishItemList = new Vector.<ConsortiaMyTaskFinishItem>();
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgI");
         var _loc2_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgII");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.task.vboxI");
         this._myFinishTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MyfinishTxt");
         this._expText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.expTxt");
         this._expText.text = LanguageMgr.GetTranslation("consortion.task.exp");
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontIMoneyTxt");
         this._moneyText.text = LanguageMgr.GetTranslation("consortion.task.offer");
         this._caiText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontCaiTxt");
         this._caiText.text = LanguageMgr.GetTranslation("consortion.task.Money");
         this._skillText = ComponentFactory.Instance.creatComponentByStylename("consortion.task.FontSkillTxt");
         this._skillText.text = LanguageMgr.GetTranslation("consortion.task.skillName");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.EXPTxt");
         this._offerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MoneyTxt");
         this._richesTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.caiTxt");
         this._skillNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.SkillTxt");
         this._contributionLbl = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contributionLbl");
         this._contributionLbl.text = LanguageMgr.GetTranslation("consortion.task.contribution");
         this._contributionTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contributionTxt");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.conortionTask.FontContent");
         this._contentTxt1 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt1");
         this._contentTxt2 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt2");
         this._contentTxt3 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt3");
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc6_ = ComponentFactory.Instance.creatCustomObject("ConsortiaMyTaskFinishItem");
            this._finishItemList.push(_loc6_);
            this._vbox.addChild(_loc6_);
            _loc4_++;
         }
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(this._vbox);
         addChild(this._myFinishTxt);
         addChild(this._expText);
         addChild(this._moneyText);
         addChild(this._caiText);
         addChild(this._skillText);
         addChild(this._contributionLbl);
         addChild(this._expTxt);
         addChild(this._offerTxt);
         addChild(this._richesTxt);
         addChild(this._skillNameTxt);
         addChild(this._contributionTxt);
         this._myReseBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.reset1");
         this._myReseBtn.text = LanguageMgr.GetTranslation("consortia.task.resetTable");
         addChild(this._myReseBtn);
         this._delayTimeBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.task.delayTimeBtn");
         this._delayTimeBtn.text = LanguageMgr.GetTranslation("consortia.task.delayTime");
         addChild(this._delayTimeBtn);
         _loc5_ = PlayerManager.Instance.Self.Right;
         this._myReseBtn.visible = ConsortiaDutyManager.GetRight(_loc5_,ConsortiaDutyType._10_ChangeMan);
         this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(_loc5_,ConsortiaDutyType._10_ChangeMan);
      }
      
      private function initEvents() : void
      {
         this._myReseBtn.addEventListener(MouseEvent.CLICK,this.__resetClick);
         this._delayTimeBtn.addEventListener(MouseEvent.CLICK,this.__delayTimeClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __delayTimeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = ConsortionModelControl.Instance.TaskModel.taskInfo.level - 1;
         var _loc3_:int = int(ServerConfigManager.instance.consortiaTaskDelayInfo[_loc2_][0]);
         var _loc4_:int = int(ServerConfigManager.instance.consortiaTaskDelayInfo[_loc2_][1]);
         var _loc5_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.delayTime"),LanguageMgr.GetTranslation("consortia.task.delayTimeContent",_loc4_,_loc3_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc5_.moveEnable = false;
         _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.DELAY_TIME);
         }
      }
      
      private function __resetClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"),LanguageMgr.GetTranslation("consortia.task.resetContent",ConsortiaTaskView.RESET_MONEY),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortia.task.stopTable"));
            }
            else
            {
               if(BuriedManager.Instance.checkMoney(param1.currentTarget.isBand,ConsortiaTaskView.RESET_MONEY))
               {
                  ObjectUtils.disposeObject(param1.currentTarget as BaseAlerFrame);
                  return;
               }
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK,(param1.currentTarget as BaseAlerFrame).isBand);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
            }
         }
         ObjectUtils.disposeObject(param1.currentTarget as BaseAlerFrame);
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         _loc2_.disposeChildren = true;
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._myReseBtn))
         {
            this._myReseBtn.removeEventListener(MouseEvent.CLICK,this.__resetClick);
         }
         if(Boolean(this._delayTimeBtn))
         {
            this._delayTimeBtn.removeEventListener(MouseEvent.CLICK,this.__delayTimeClick);
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __propChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1.changedProperties["Right"]))
         {
            _loc2_ = PlayerManager.Instance.Self.Right;
            this._myReseBtn.visible = ConsortiaDutyManager.GetRight(_loc2_,ConsortiaDutyType._10_ChangeMan);
            this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(_loc2_,ConsortiaDutyType._10_ChangeMan);
         }
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         _loc1_ = PlayerManager.Instance.Self.Right;
         this._myReseBtn.visible = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._10_ChangeMan);
         this._delayTimeBtn.visible = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._10_ChangeMan);
         var _loc2_:int = 0;
         while(_loc2_ < this._finishItemList.length)
         {
            this._finishItemList[_loc2_].update(this._taskInfo.itemList[_loc2_]["taskType"],this._taskInfo.itemList[_loc2_]["content"],this._taskInfo.itemList[_loc2_]["currenValue"],this._taskInfo.itemList[_loc2_]["targetValue"]);
            _loc2_++;
         }
         this._expTxt.text = this._taskInfo.exp.toString();
         this._offerTxt.text = this._taskInfo.offer.toString();
         this._richesTxt.text = this._taskInfo.riches.toString();
         this._contributionTxt.text = this._taskInfo.contribution.toString();
         var _loc3_:ConsortionSkillInfo = ConsortionModelControl.Instance.model.getSkillInfoByID(this._taskInfo.buffID);
         if(_loc3_ != null)
         {
            this._skillNameTxt.text = _loc3_.name + "*1gün";
         }
         this._contentTxt1.text = "1. " + this._taskInfo.itemList[0]["content"];
         this._contentTxt2.text = "2. " + this._taskInfo.itemList[1]["content"];
         this._contentTxt3.text = "3. " + this._taskInfo.itemList[2]["content"];
         var _loc4_:int = int((this._taskInfo.itemList[0]["finishValue"] / this._taskInfo.itemList[0]["targetValue"] + this._taskInfo.itemList[1]["finishValue"] / this._taskInfo.itemList[1]["targetValue"] + this._taskInfo.itemList[2]["finishValue"] / this._taskInfo.itemList[2]["targetValue"]) / 3 * 100);
         this._myFinishTxt.text = _loc4_ + "%";
      }
      
      public function set taskInfo(param1:ConsortiaTaskInfo) : void
      {
         this._taskInfo = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._taskInfo = null;
         if(Boolean(this._myReseBtn))
         {
            ObjectUtils.disposeObject(this._myReseBtn);
         }
         this._myReseBtn = null;
         if(Boolean(this._delayTimeBtn))
         {
            ObjectUtils.disposeObject(this._delayTimeBtn);
         }
         this._delayTimeBtn = null;
         var _loc1_:int = 0;
         while(this._finishItemList != null && _loc1_ < this._finishItemList.length)
         {
            ObjectUtils.disposeObject(this._finishItemList[_loc1_]);
            _loc1_++;
         }
         this._finishItemList = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._myFinishTxt))
         {
            ObjectUtils.disposeObject(this._myFinishTxt);
         }
         this._myFinishTxt = null;
         if(Boolean(this._expText))
         {
            ObjectUtils.disposeObject(this._expText);
         }
         this._expText = null;
         if(Boolean(this._moneyText))
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(Boolean(this._caiText))
         {
            ObjectUtils.disposeObject(this._caiText);
         }
         this._caiText = null;
         if(Boolean(this._skillText))
         {
            ObjectUtils.disposeObject(this._skillText);
         }
         this._skillText = null;
         if(Boolean(this._expTxt))
         {
            ObjectUtils.disposeObject(this._expTxt);
         }
         this._expTxt = null;
         if(Boolean(this._offerTxt))
         {
            ObjectUtils.disposeObject(this._offerTxt);
         }
         this._offerTxt = null;
         if(Boolean(this._richesTxt))
         {
            ObjectUtils.disposeObject(this._richesTxt);
         }
         this._richesTxt = null;
         if(Boolean(this._skillNameTxt))
         {
            ObjectUtils.disposeObject(this._skillNameTxt);
         }
         this._skillNameTxt = null;
         if(Boolean(this._contentTxt1))
         {
            ObjectUtils.disposeObject(this._contentTxt1);
         }
         this._contentTxt1 = null;
         if(Boolean(this._contentTxt2))
         {
            ObjectUtils.disposeObject(this._contentTxt2);
         }
         this._contentTxt2 = null;
         if(Boolean(this._contentTxt3))
         {
            ObjectUtils.disposeObject(this._contentTxt3);
         }
         this._contentTxt3 = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

