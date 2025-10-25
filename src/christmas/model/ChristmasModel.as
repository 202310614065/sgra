package christmas.model
{
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.manager.ChristmasManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   
   public class ChristmasModel extends EventDispatcher
   {
      
      public var isOpen:Boolean;
      
      public var isEnter:Boolean;
      
      public var beginTime:Date;
      
      public var endTime:Date;
      
      public var gameBeginTime:Date;
      
      public var gameEndTime:Date;
      
      public var count:int;
      
      public var exp:int = 0;
      
      public var totalExp:int = 10;
      
      public var awardState:int;
      
      public var packsNumber:int;
      
      public var packsLen:int;
      
      public var myGiftData:Vector.<ChristmasSystemItemsInfo>;
      
      public var isSelect:Boolean;
      
      public var snowPackNum:Array;
      
      public var lastPacks:int;
      
      public var money:int;
      
      public var snowPackNumber:int;
      
      public var maxSnowMenNumber:int = 2000;
      
      public var todayCount:int;
      
      public function ChristmasModel()
      {
         super();
      }
      
      public function get activityTime() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         this.beginTime = ChristmasManager.instance.model.beginTime;
         this.endTime = ChristmasManager.instance.model.endTime;
         if(Boolean(this.beginTime) && Boolean(this.endTime))
         {
            _loc2_ = this.beginTime.minutes > 9 ? this.beginTime.minutes + "" : "0" + this.beginTime.minutes;
            _loc3_ = this.endTime.minutes > 9 ? this.endTime.minutes + "" : "0" + this.endTime.minutes;
            _loc1_ = this.beginTime.fullYear + "." + (this.beginTime.month + 1) + "." + this.beginTime.date + " - " + this.endTime.fullYear + "." + (this.endTime.month + 1) + "." + this.endTime.date;
         }
         return _loc1_;
      }
      
      public function serverTime() : Number
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         return _loc1_.hours;
      }
   }
}

