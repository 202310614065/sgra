package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.view.vote.VoteInfo;
   import flash.utils.Dictionary;
   
   public class VoteInfoAnalyzer extends DataAnalyzer
   {
      
      public var firstQuestionID:String;
      
      public var completeMessage:String;
      
      public var questionLength:int;
      
      public var list:Dictionary;
      
      public var voteId:String;
      
      private var _award:String;
      
      private var _awardDic:Dictionary;
      
      public function VoteInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get awardDic() : Dictionary
      {
         var _loc3_:Array = null;
         if(this._award == "")
         {
            return null;
         }
         var _loc1_:Array = this._award.split(",");
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_].split("|");
            if(Boolean(_loc3_))
            {
               this._awardDic[_loc3_[0]] = _loc3_[1];
            }
            _loc2_++;
         }
         return this._awardDic;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:VoteQuestionInfo = null;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         var _loc8_:VoteInfo = null;
         this._awardDic = new Dictionary();
         this.list = new Dictionary();
         var _loc2_:XML = new XML(param1);
         this.voteId = _loc2_.@voteId;
         this.firstQuestionID = _loc2_.@firstQuestionID;
         this.completeMessage = _loc2_.@completeMessage;
         this._award = _loc2_.@award;
         var _loc3_:XMLList = _loc2_..item;
         this.questionLength = _loc3_.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new VoteQuestionInfo();
            _loc5_.questionID = _loc3_[_loc4_].@id;
            _loc5_.multiple = _loc3_[_loc4_].@multiple == "true" ? true : false;
            _loc5_.otherSelect = _loc3_[_loc4_].@otherSelect == "true" ? true : false;
            _loc5_.question = _loc3_[_loc4_].@question;
            _loc5_.nextQuestionID = _loc3_[_loc4_].@nextQuestionID;
            _loc5_.questionType = _loc3_[_loc4_].@questionType;
            _loc6_ = _loc3_[_loc4_]..answer;
            _loc5_.answerLength = _loc6_.length();
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length())
            {
               _loc8_ = new VoteInfo();
               _loc8_.answerId = _loc6_[_loc7_].@id;
               _loc8_.answer = _loc6_[_loc7_].@value;
               _loc5_.answer.push(_loc8_);
               _loc7_++;
            }
            this.list[_loc5_.questionID] = _loc5_;
            _loc4_++;
         }
         onAnalyzeComplete();
      }
   }
}

