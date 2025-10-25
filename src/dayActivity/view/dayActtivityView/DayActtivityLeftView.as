package dayActivity.view.dayActtivityView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.ActivityData;
   import dayActivity.items.DayActivityLeftList;
   import flash.display.Sprite;
   
   public class DayActtivityLeftView extends Sprite implements Disposeable
   {
      
      private var _rightBack:MutipleImage;
      
      private var _resArray:Array = ["day.activity.noover","day.activity.over"];
      
      private var _wordArray:Array = ["ddt.dayActivity.activityNoOver","ddt.dayActivity.activityOver"];
      
      private var _boolArray:Array = [false,false];
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _itemList:Vector.<DayActivityLeftList>;
      
      public function DayActtivityLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemList = new Vector.<DayActivityLeftList>();
         this._rightBack = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.ActivityStateBg");
         addChild(this._rightBack);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.luckpaihangBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.scrollpanel");
         this._panel.y = 21;
         this._panel.setView(this._list);
         addChild(this._panel);
         this._panel.invalidateViewport();
      }
      
      public function initList(param1:Vector.<ActivityData>, param2:Vector.<ActivityData>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:DayActivityLeftList = null;
         this.clearList();
         var _loc3_:Array = [];
         _loc3_.push(param2);
         _loc3_.push(param1);
         _loc4_ = 0;
         while(_loc4_ < 2)
         {
            _loc5_ = new DayActivityLeftList(this._resArray[_loc4_],_loc3_[_loc4_],this._boolArray[_loc4_]);
            _loc5_.y = (_loc5_.height + 4) * _loc4_ + 36;
            _loc5_.setTxt(this._wordArray[_loc4_]);
            _loc5_.x = 18;
            this._list.addChild(_loc5_);
            this._itemList.push(_loc5_);
            _loc4_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function clearList() : void
      {
         if(!this._itemList)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            if(this._itemList.length > 0)
            {
               while(Boolean(this._itemList[_loc1_].numChildren))
               {
                  ObjectUtils.disposeObject(this._itemList[_loc1_].getChildAt(0));
               }
               ObjectUtils.disposeObject(this._itemList[_loc1_]);
            }
            _loc1_++;
         }
         this._itemList.splice(0,this._itemList.length);
      }
      
      public function dispose() : void
      {
         this.clearList();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._itemList = null;
         this._list = null;
         this._panel = null;
      }
   }
}

