package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.data.DaylyGiveInfo;
   import flash.utils.Dictionary;
   
   public class DaylyGiveAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public var signAwardList:Array;
      
      public var signAwardCounts:Array;
      
      public var userAwardLog:int;
      
      public var awardLen:int;
      
      private var _xml:XML;
      
      private var _awardDic:Dictionary;
      
      public function DaylyGiveAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DaylyGiveInfo = null;
         this._xml = new XML(param1);
         this.list = new Array();
         this.signAwardList = new Array();
         this._awardDic = new Dictionary(true);
         this.signAwardCounts = new Array();
         if(this._xml.@value == "true")
         {
            _loc2_ = this._xml..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@GetWay == DailyAwardType.Normal)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.list.push(_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.Sign)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.signAwardList.push(_loc4_);
                  if(!this._awardDic[String(_loc2_[_loc3_].@AwardDays)])
                  {
                     this._awardDic[String(_loc2_[_loc3_].@AwardDays)] = true;
                     this.signAwardCounts.push(_loc2_[_loc3_].@AwardDays);
                  }
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

