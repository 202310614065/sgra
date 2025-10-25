package dayActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.DayRewaidData;
   
   public class ActivityRewardAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<DayRewaidData>;
      
      public function ActivityRewardAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:DayRewaidData = null;
         XML.ignoreWhitespace = true;
         this.itemList = new Vector.<DayRewaidData>();
         var _loc2_:XML = new XML(param1);
         var _loc3_:int = int(_loc2_.item.length());
         var _loc4_:XMLList = _loc2_..item;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc6_ = new DayRewaidData();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
            this.itemList.push(_loc6_);
            _loc5_++;
         }
         onAnalyzeComplete();
      }
   }
}

