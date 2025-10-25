package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class SevenDoubleEscortManager extends EventDispatcher
   {
      
      private static var _instance:SevenDoubleEscortManager;
      
      private var _tag:int;
      
      public function SevenDoubleEscortManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : SevenDoubleEscortManager
      {
         if(_instance == null)
         {
            _instance = new SevenDoubleEscortManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVEN_DOUBLE_ESCORT,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         if(_loc3_ == 1)
         {
            _loc4_ = _loc2_.readInt();
            if(_loc2_.readBoolean())
            {
               this._tag = _loc4_;
            }
            _loc2_.position -= 5;
         }
         _loc2_.position -= 1;
         if(this._tag == 1)
         {
            SocketManager.Instance.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVEN_DOUBLE,_loc2_));
         }
         else if(this._tag == 2)
         {
            SocketManager.Instance.dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ESCORT,_loc2_));
         }
      }
   }
}

