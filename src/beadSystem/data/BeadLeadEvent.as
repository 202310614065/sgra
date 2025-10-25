package beadSystem.data
{
   import ddt.data.quest.QuestInfo;
   import flash.events.Event;
   
   public class BeadLeadEvent extends Event
   {
      
      public static const GETTASKISCOMPLETE:String = "getTaskIsComplete";
      
      public static const SPALINGUPLEVELCELL:String = "spalinguplevelcell";
      
      private var _taskinfo:QuestInfo;
      
      public function BeadLeadEvent(param1:String, param2:QuestInfo = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._taskinfo = param2;
      }
      
      public function get taskinfo() : QuestInfo
      {
         return this._taskinfo;
      }
   }
}

