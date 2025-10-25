package ddt.manager
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class LogManager extends EventDispatcher
   {
      
      private static var instance:LogManager;
      
      public function LogManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function getInstance() : LogManager
      {
         if(instance == null)
         {
            instance = new LogManager();
         }
         return instance;
      }
      
      public function sendLog(param1:String = "") : void
      {
         var _loc2_:URLRequest = new URLRequest(PathManager.solveRequestPath("LogClickTip.ashx"));
         var _loc3_:URLVariables = new URLVariables();
         _loc3_["title"] = param1;
         _loc2_.data = _loc3_;
         var _loc4_:URLLoader = new URLLoader(_loc2_);
         _loc4_.load(_loc2_);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
      }
   }
}

