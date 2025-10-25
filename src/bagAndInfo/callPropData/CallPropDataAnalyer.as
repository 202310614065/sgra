package bagAndInfo.callPropData
{
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CallPropDataAnalyer extends DataAnalyzer
   {
      
      private var _data:Object;
      
      public function CallPropDataAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:CallPropTxtTipInfo = null;
         var _loc6_:String = null;
         var _loc2_:XML = new XML(param1);
         this._data = {};
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new CallPropTxtTipInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc6_ = _loc3_[_loc4_].@Rank;
               if(!this._data[_loc6_])
               {
                  this._data[_loc6_] = _loc5_;
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

