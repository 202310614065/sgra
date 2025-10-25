package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.rank.RankData;
   
   public class PersonalRankAnalyze extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function PersonalRankAnalyze(param1:Function)
      {
         super(param1);
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:RankData = null;
         this._dataList = [];
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_.Item;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new RankData();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
            this._dataList.push(_loc5_);
            _loc4_++;
         }
         this._dataList.sortOn("Rank",Array.NUMERIC);
         onAnalyzeComplete();
      }
   }
}

