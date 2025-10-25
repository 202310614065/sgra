package ddt.dailyRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class DailyRecordItem extends Sprite implements Disposeable
   {
      
      private static var item_height:int = 35;
      
      private var _content:FilterFrameText;
      
      private var str0:String;
      
      private var str1:String;
      
      public function DailyRecordItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._content = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.contentStyle");
         addChild(this._content);
      }
      
      public function setData(param1:int, param2:DailiyRecordInfo) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.valueList.length)
         {
            this["str" + _loc3_] = param2.valueList[_loc3_];
            _loc3_++;
         }
         if(param1 < 9)
         {
            this._content.htmlText = " " + LanguageMgr.GetTranslation("ddt.dailyRecord.content" + param2.type,param1 + 1,this.str0,this.str1);
         }
         else
         {
            this._content.htmlText = LanguageMgr.GetTranslation("ddt.dailyRecord.content" + param2.type,param1 + 1,this.str0,this.str1);
         }
      }
      
      override public function get height() : Number
      {
         return item_height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._content = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

