package ddt.manager
{
   import beadSystem.model.BeadInfo;
   import ddt.data.analyze.BeadAnalyzer;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class BeadTemplateManager extends EventDispatcher
   {
      
      private static var _instance:BeadTemplateManager;
      
      public var _beadList:DictionaryData;
      
      public function BeadTemplateManager()
      {
         super();
         this._beadList = new DictionaryData();
      }
      
      public static function get Instance() : BeadTemplateManager
      {
         if(_instance == null)
         {
            _instance = new BeadTemplateManager();
         }
         return _instance;
      }
      
      public function setup(param1:BeadAnalyzer) : void
      {
         this._beadList = param1.list;
      }
      
      public function GetBeadInfobyID(param1:int) : BeadInfo
      {
         return this._beadList[param1];
      }
      
      public function GetBeadTemplateIDByLv(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc5_:BeadInfo = null;
         var _loc4_:BeadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(param2);
         for each(_loc5_ in this._beadList)
         {
            if(_loc4_.Name == _loc5_.Name)
            {
               if(param1 >= _loc5_.BaseLevel && param1 < _loc5_.BaseLevel + _loc5_.MaxLevel)
               {
                  _loc3_ = _loc5_.TemplateID;
                  break;
               }
            }
         }
         return _loc3_;
      }
   }
}

