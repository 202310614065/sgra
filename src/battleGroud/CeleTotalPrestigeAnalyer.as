package battleGroud
{
   import battleGroud.data.BattlPrestigeData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CeleTotalPrestigeAnalyer extends DataAnalyzer
   {
      
      public var battleDataList:Vector.<BattlPrestigeData>;
      
      public function CeleTotalPrestigeAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:BattlPrestigeData = null;
         this.battleDataList = new Vector.<BattlPrestigeData>();
         var _loc2_:XML = new XML(param1);
         var _loc3_:int = int(_loc2_.item.length());
         var _loc4_:XMLList = _loc2_..Item;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc6_ = new BattlPrestigeData();
            _loc6_.Numbers = _loc5_ + 1;
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
            this.battleDataList.push(_loc6_);
            _loc5_++;
         }
         onAnalyzeComplete();
      }
   }
}

