package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class CampBattleMonsterRole extends CampBattlePlayer
   {
      
      private var walkList:Vector.<Point>;
      
      private var _timer:Timer;
      
      public function CampBattleMonsterRole(param1:RoleData, param2:Function = null)
      {
         super(param1,param2);
         this.walkList = new Vector.<Point>();
         this.walkList.push(new Point(993,901));
         this.walkList.push(new Point(1208,866));
         this.walkList.push(new Point(1124,644));
         this.walkList.push(new Point(1107,803));
         this.walkList.push(new Point(879,896));
         this._timer = new Timer(4000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
      }
      
      override protected function mouseClickHander(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(clickFun != null)
         {
            clickFun(this);
         }
      }
      
      private function timerHander(param1:TimerEvent) : void
      {
         if(!scene)
         {
            return;
         }
         var _loc2_:int = Math.random() * this.walkList.length;
         var _loc3_:Point = this.walkList[_loc2_];
         walk(_loc3_);
      }
      
      override protected function enterFrameHander(param1:Event) : void
      {
         update();
         playerWalkPath();
         characterMirror();
      }
   }
}

