package cardSystem.analyze
{
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class CardTemplateAnalyzer extends DataAnalyzer
   {
      
      private var _list:Dictionary;
      
      public function CardTemplateAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:CardTemplateInfo = null;
         this._list = new Dictionary();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = describeType(new CardTemplateInfo());
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc6_ = new CardTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               this._list[_loc6_.CardID + "," + _loc6_.CardType] = _loc6_;
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

