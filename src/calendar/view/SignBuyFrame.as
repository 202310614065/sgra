package calendar.view
{
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   
   public class SignBuyFrame extends BaseAlerFrame
   {
      
      private var _txt:FilterFrameText;
      
      private var _date:Date;
      
      private var _dayCell:DayCell;
      
      public function SignBuyFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.dayCell.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = _loc1_;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("dayCell.alert.txt");
         this._txt.text = LanguageMgr.GetTranslation("dayCell.alert.text",CalendarManager.getInstance().price,5 - CalendarManager.getInstance().times);
         addToContent(this._txt);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function responseHander(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < CalendarManager.getInstance().price)
            {
               LeavePageManager.showFillFrame();
               this.dispose();
               return;
            }
            SocketManager.Instance.out.sendDaySign(this._date);
            if(CalendarManager.getInstance().signNew(this._date))
            {
               this._dayCell.signMovie();
            }
            this.dispose();
         }
         else if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.dispose();
         }
      }
      
      public function set date(param1:Date) : void
      {
         this._date = param1;
      }
      
      public function set dayCellClass(param1:DayCell) : void
      {
         this._dayCell = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

