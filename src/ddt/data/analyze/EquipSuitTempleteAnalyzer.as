package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class EquipSuitTempleteAnalyzer extends DataAnalyzer
   {
      
      private var _dic:Dictionary;
      
      private var _data:Dictionary;
      
      public function EquipSuitTempleteAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:EquipSuitTemplateInfo = null;
         var _loc7_:Array = null;
         this._dic = new Dictionary();
         this._data = new Dictionary();
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..item;
            _loc4_ = describeType(new SuitTemplateInfo());
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc6_ = new EquipSuitTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc3_[_loc5_]);
               if(Boolean(this._dic[_loc6_.ID]))
               {
                  _loc7_ = this._dic[_loc6_.ID];
               }
               else
               {
                  _loc7_ = [];
                  this._dic[_loc6_.ID] = _loc7_;
               }
               _loc7_.push(_loc6_);
               this._data[_loc6_.PartName] = _loc6_;
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
      
      public function get dic() : Dictionary
      {
         return this._dic;
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
   }
}

