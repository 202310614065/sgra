package baglocked.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class BagLockedEvent extends Event
   {
      
      public static const GET_BACK_LOCK_PWD:String = "getBackLockPwd";
      
      public static const DEL_QUESTION:String = "delQuestion";
      
      private var _pkg:PackageIn;
      
      public function BagLockedEvent(param1:String, param2:PackageIn = null)
      {
         super(param1,bubbles,cancelable);
         this._pkg = param2;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}

