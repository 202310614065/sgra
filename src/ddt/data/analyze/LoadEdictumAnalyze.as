package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class LoadEdictumAnalyze extends DataAnalyzer
   {
      
      public var edictumDataList:Array;
      
      public function LoadEdictumAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this.edictumDataList = [];
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = int(_loc3_.length());
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = new Object();
               _loc6_["id"] = _loc3_[_loc5_].@ID.toString();
               _loc6_["Title"] = _loc3_[_loc5_].@Title.toString();
               _loc6_["Text"] = _loc3_[_loc5_].@Text.toString();
               _loc6_["IsExist"] = _loc3_[_loc5_].@IsExist.toString();
               _loc6_["BeginTime"] = _loc3_[_loc5_].@BeginTime.toString();
               this.edictumDataList.push(_loc6_);
               _loc5_++;
            }
            this.edictumDataList.sortOn("id",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

