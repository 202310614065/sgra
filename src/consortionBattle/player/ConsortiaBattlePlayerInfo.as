package consortionBattle.player
{
   import flash.geom.Point;
   
   public class ConsortiaBattlePlayerInfo
   {
      
      public var id:int;
      
      public var pos:Point = new Point(600,580);
      
      public var clothIndex:int = 1;
      
      public var sex:Boolean;
      
      public var selfOrEnemy:int;
      
      public var consortiaName:String;
      
      public var tombstoneEndTime:Date;
      
      public var status:int;
      
      public var winningStreak:int;
      
      public var failBuffCount:int;
      
      public function ConsortiaBattlePlayerInfo()
      {
         super();
      }
   }
}

