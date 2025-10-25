package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ChairmanChannelPanel extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _declaration:TextButton;
      
      private var _jobManage:TextButton;
      
      private var _transfer:TextButton;
      
      private var _upGrade:TextButton;
      
      private var _mail:TextButton;
      
      private var _task:TextButton;
      
      public function ChairmanChannelPanel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.bg");
         this._declaration = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.declaration");
         this._declaration.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText1");
         this._jobManage = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.jobManage");
         this._jobManage.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText2");
         this._transfer = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.transfer");
         this._transfer.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText3");
         this._upGrade = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.upGrade");
         this._upGrade.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText4");
         this._mail = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.mail");
         this._mail.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText5");
         this._task = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.task");
         this._task.text = LanguageMgr.GetTranslation("consortia.chairmanChannel.BtnText6");
         addChild(this._bg);
         addChild(this._declaration);
         addChild(this._jobManage);
         addChild(this._upGrade);
         addChild(this._transfer);
         addChild(this._mail);
         addChild(this._task);
      }
      
      private function initEvent() : void
      {
         this._upGrade.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._transfer.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._jobManage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._declaration.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._mail.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._task.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._upGrade))
         {
            this._upGrade.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         if(Boolean(this._transfer))
         {
            this._transfer.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         if(Boolean(this._jobManage))
         {
            this._jobManage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         if(Boolean(this._declaration))
         {
            this._declaration.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         if(Boolean(this._mail))
         {
            this._mail.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         if(Boolean(this._task))
         {
            this._task.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ConsortionUpGradeFrame = null;
         var _loc3_:ConsortionTrasferFrame = null;
         var _loc4_:ConsortionJobManageFrame = null;
         var _loc5_:ConsortionDeclareFrame = null;
         var _loc6_:ConsortionMailFrame = null;
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._upGrade:
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortionUpGradeFrame");
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._transfer:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("consortionTrasferFrame");
               LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._jobManage:
               _loc4_ = ComponentFactory.Instance.creatComponentByStylename("consortionJobManageFrame");
               LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               ConsortionModelControl.Instance.loadDutyList(ConsortionModelControl.Instance.dutyListComplete,PlayerManager.Instance.Self.ConsortiaID);
               break;
            case this._declaration:
               _loc5_ = ComponentFactory.Instance.creatComponentByStylename("consortionDeclareFrame");
               LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._mail:
               _loc6_ = ComponentFactory.Instance.creatComponentByStylename("consortionMailFrame");
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._task:
               ConsortionModelControl.Instance.TaskModel.showReleaseFrame();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(Boolean(this._declaration))
         {
            ObjectUtils.disposeObject(this._declaration);
         }
         this._declaration = null;
         if(Boolean(this._jobManage))
         {
            ObjectUtils.disposeObject(this._jobManage);
         }
         this._jobManage = null;
         if(Boolean(this._transfer))
         {
            ObjectUtils.disposeObject(this._transfer);
         }
         this._transfer = null;
         if(Boolean(this._upGrade))
         {
            ObjectUtils.disposeObject(this._upGrade);
         }
         this._upGrade = null;
         if(Boolean(this._mail))
         {
            ObjectUtils.disposeObject(this._mail);
         }
         this._mail = null;
         if(Boolean(this._task))
         {
            ObjectUtils.disposeObject(this._task);
         }
         this._task = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

