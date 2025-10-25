package dayActivity.items
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.ActivityData;
   import dayActivity.data.DayActiveData;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   
   public class DayActivityLeftList extends Sprite implements Disposeable
   {
      
      private var _tilte:DayActivityLeftTitleItem;
      
      private var _num:int;
      
      private var _expriedNum:int;
      
      public function DayActivityLeftList(param1:String, param2:Vector.<ActivityData>, param3:Boolean)
      {
         super();
         this._num = param2.length;
         this._expriedNum = 0;
         this.initView(param1,param2,param3);
      }
      
      private function initView(param1:String, param2:Vector.<ActivityData>, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc7_:DayActivityLeftListItem = null;
         this._expriedNum = 0;
         this._tilte = new DayActivityLeftTitleItem(param1,this._num);
         addChild(this._tilte);
         var _loc4_:Vector.<DayActiveData> = DayActivityManager.Instance.acitiveDataList;
         var _loc5_:int = TimeManager.Instance.serverDate.day;
         _loc6_ = 0;
         for(; _loc6_ < this._num; _loc6_++)
         {
            if(param2[_loc6_].ActivityType == 6)
            {
               if(!this.compareDay(_loc5_,DayActivityManager.Instance.YUANGUJULONG_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            if(param2[_loc6_].ActivityType == 18)
            {
               if(Boolean(DayActivityManager.Instance.ANYEBOJUE_DAYOFWEEK) && !this.compareDay(_loc5_,DayActivityManager.Instance.ANYEBOJUE_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            if(param2[_loc6_].ActivityType == 19)
            {
               if(!this.compareDay(_loc5_,DayActivityManager.Instance.ZUQIUBOSS_DAYOFWEEK))
               {
                  ++this._expriedNum;
                  continue;
               }
            }
            _loc7_ = new DayActivityLeftListItem(param3,param2[_loc6_]);
            _loc7_.setTxt2(param2[_loc6_].OverCount);
            if(param2[_loc6_].JumpType > 0)
            {
               _loc7_.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.itemTips",param2[_loc6_].ActivePoint,param2[_loc6_].Description);
            }
            else
            {
               _loc7_.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.btnTip",param2[_loc6_].ActivePoint);
            }
            _loc7_.x = 2;
            _loc7_.y = 30 + 25 * (_loc6_ - this._expriedNum);
            addChild(_loc7_);
         }
      }
      
      private function compareDay(param1:int, param2:String) : Boolean
      {
         var _loc3_:Array = param2.split(",");
         if(_loc3_.indexOf("" + param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function setTxt(param1:String) : void
      {
         this._tilte.setTxt(LanguageMgr.GetTranslation(param1,this._num - this._expriedNum));
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

