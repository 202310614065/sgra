package bagAndInfo.energyData
{
   public class EnergyData
   {
      
      private var _energy:int;
      
      private var _money:int;
      
      private var _count:int;
      
      public function EnergyData()
      {
         super();
      }
      
      public function get Energy() : int
      {
         return this._energy;
      }
      
      public function set Energy(param1:int) : void
      {
         this._energy = param1;
      }
      
      public function get Money() : int
      {
         return this._money;
      }
      
      public function set Money(param1:int) : void
      {
         this._money = param1;
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(param1:int) : void
      {
         this._count = param1;
      }
   }
}

