package ddt.data.analyze
{
   import cardSystem.data.CardGrooveInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class CardGrooveEventAnalyzer extends DataAnalyzer
   {
      
      private var _list:Dictionary;
      
      public function CardGrooveEventAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:CardGrooveInfo = null;
         this._list = new Dictionary();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = describeType(new CardGrooveInfo());
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc6_ = new CardGrooveInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               this._list[_loc6_.Level + "," + _loc6_.Type] = _loc6_;
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get list() : Dictionary
      {
         return this._list;
      }
   }
}

