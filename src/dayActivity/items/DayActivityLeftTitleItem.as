package dayActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class DayActivityLeftTitleItem extends Sprite implements Disposeable
   {
      
      private var _back:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function DayActivityLeftTitleItem(param1:String, param2:int)
      {
         super();
         this.initView(param1,param2);
      }
      
      private function initView(param1:String, param2:int) : void
      {
         this._back = ComponentFactory.Instance.creat(param1);
         addChild(this._back);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("day.activityView.left.txt1");
         this._txt.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityNoOver",param2);
         addChild(this._txt);
      }
      
      public function setTxt(param1:String) : void
      {
         this._txt.text = param1;
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

