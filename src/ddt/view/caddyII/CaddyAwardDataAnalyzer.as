package ddt.view.caddyII
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CaddyAwardDataAnalyzer extends DataAnalyzer
   {
      
      public var _awards:Vector.<CaddyAwardInfo>;
      
      public var _silverAwards:Vector.<CaddyAwardInfo>;
      
      public var _goldAwards:Vector.<CaddyAwardInfo>;
      
      public var _treasureAwards:Vector.<CaddyAwardInfo>;
      
      public function CaddyAwardDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:CaddyAwardInfo = null;
         this._awards = new Vector.<CaddyAwardInfo>();
         this._silverAwards = new Vector.<CaddyAwardInfo>();
         this._goldAwards = new Vector.<CaddyAwardInfo>();
         this._treasureAwards = new Vector.<CaddyAwardInfo>();
         var _loc2_:XML = new XML(param1);
         var _loc3_:int = int(_loc2_.item.length());
         var _loc4_:XMLList = _loc2_.item;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = new CaddyAwardInfo();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc4_[_loc5_]);
            if(_loc4_[_loc5_].@BoxType == 1)
            {
               this._awards.push(_loc6_);
            }
            else if(_loc4_[_loc5_].@BoxType == 2)
            {
               this._silverAwards.push(_loc6_);
            }
            else if(_loc4_[_loc5_].@BoxType == 3)
            {
               this._goldAwards.push(_loc6_);
            }
            else if(_loc4_[_loc5_].@BoxType == 4)
            {
               this._treasureAwards.push(_loc6_);
            }
            _loc5_++;
         }
         onAnalyzeComplete();
      }
   }
}

