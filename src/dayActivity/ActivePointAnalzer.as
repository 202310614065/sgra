package dayActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.DayActiveData;
   
   public class ActivePointAnalzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<DayActiveData>;
      
      public function ActivePointAnalzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:DayActiveData = null;
         this.itemList = new Vector.<DayActiveData>();
         XML.ignoreWhitespace = true;
         var _loc2_:XML = new XML(param1);
         var _loc3_:int = int(_loc2_.item.length());
         var _loc4_:XMLList = _loc2_..item;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc6_ = new DayActiveData();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
            _loc6_.setLong();
            this.itemList.push(_loc6_);
            _loc5_++;
         }
         onAnalyzeComplete();
      }
   }
}

