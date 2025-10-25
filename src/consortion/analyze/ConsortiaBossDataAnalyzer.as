package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import consortion.data.ConsortiaBossConfigVo;
   
   public class ConsortiaBossDataAnalyzer extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function ConsortiaBossDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ConsortiaBossConfigVo = null;
         var _loc2_:XML = new XML(param1);
         this._dataList = [];
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new ConsortiaBossConfigVo();
               _loc5_.level = _loc3_[_loc4_].@Level;
               _loc5_.callBossRich = _loc3_[_loc4_].@CostRich;
               _loc5_.extendTimeRich = _loc3_[_loc4_].@ProlongRich;
               this._dataList.push(_loc5_);
               _loc4_++;
            }
            this._dataList.sortOn("level",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
   }
}

