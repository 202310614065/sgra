package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.rank.RankData;
   
   public class ConsortiaAnalyze extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function ConsortiaAnalyze(param1:Function)
      {
         super(param1);
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:RankData = null;
         this._dataList = [];
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_.Item;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc6_ = new RankData();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc4_]);
            this._dataList.push(_loc6_);
            _loc4_++;
         }
         this._dataList.sortOn("Rank",Array.NUMERIC);
         for each(_loc5_ in this._dataList)
         {
         }
         onAnalyzeComplete();
      }
   }
}

