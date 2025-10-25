package dayActivity.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.ActivityData;
   import dayActivity.view.dayActtivityView.DayActtivityLeftView;
   import dayActivity.view.dayActtivityView.DayActtivityRightView;
   import flash.display.Sprite;
   
   public class DayActivityView extends Sprite implements Disposeable
   {
      
      private var _rightView:DayActtivityRightView;
      
      private var _leftView:DayActtivityLeftView;
      
      public function DayActivityView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._rightView = new DayActtivityRightView();
         this._rightView.x = 360;
         this._rightView.y = 87;
         addChild(this._rightView);
         this._leftView = new DayActtivityLeftView();
         this._leftView.x = 23;
         this._leftView.y = 87;
         addChild(this._leftView);
      }
      
      public function updataBtn(param1:int) : void
      {
         this._rightView.updataBtn(param1);
      }
      
      public function setBar(param1:int) : void
      {
         this._rightView.setBarValue(param1);
      }
      
      public function setLeftView(param1:Vector.<ActivityData>, param2:Vector.<ActivityData>) : void
      {
         this._leftView.initList(param1,param2);
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

