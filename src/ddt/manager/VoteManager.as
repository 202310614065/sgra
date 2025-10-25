package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitResultAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.view.vote.VoteView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class VoteManager extends EventDispatcher
   {
      
      private static var vote:VoteManager;
      
      public static var LOAD_COMPLETED:String = "loadCompleted";
      
      public var loadOver:Boolean = false;
      
      public var showVote:Boolean = true;
      
      public var count:int = 0;
      
      public var questionLength:int = 0;
      
      public var awardDic:Dictionary;
      
      private var voteView:VoteView;
      
      private var list:Dictionary;
      
      private var firstQuestionID:String;
      
      private var completeMessage:String;
      
      private var voteId:String;
      
      private var allAnswer:String = "";
      
      private var answerArr:Array = new Array();
      
      private var isVoteComplete:Boolean;
      
      private var nowVoteQuestionInfo:VoteQuestionInfo;
      
      public function VoteManager()
      {
         super();
      }
      
      public static function get Instance() : VoteManager
      {
         if(vote == null)
         {
            vote = new VoteManager();
         }
         return vote;
      }
      
      public function loadCompleted(param1:VoteInfoAnalyzer) : void
      {
         this.loadOver = true;
         this.list = param1.list;
         this.voteId = param1.voteId;
         this.firstQuestionID = param1.firstQuestionID;
         this.completeMessage = param1.completeMessage;
         this.questionLength = param1.questionLength;
         this.awardDic = param1.awardDic;
         dispatchEvent(new Event(LOAD_COMPLETED));
      }
      
      public function openVote() : void
      {
         var _loc1_:String = null;
         this.voteView = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView");
         this.voteView.addEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.addEventListener(VoteView.VOTEVIEW_CLOSE,this.__voteViewCLose);
         if(SharedManager.Instance.voteData["userId"] == PlayerManager.Instance.Self.ID)
         {
            _loc1_ = SharedManager.Instance.voteData["voteId"];
            if(this.voteId == _loc1_)
            {
               this.count = SharedManager.Instance.voteData["voteProgress"] - 1;
               this.nextQuetion(SharedManager.Instance.voteData["voteQuestionID"]);
               this.answerArr = SharedManager.Instance.voteData["voteAnswer"];
            }
            else
            {
               this.nextQuetion(this.firstQuestionID);
            }
         }
         else
         {
            this.nextQuetion(this.firstQuestionID);
         }
      }
      
      private function __chosed(param1:Event) : void
      {
         this.answerArr.push(this.voteView.selectAnswer);
         this.nextQuetion(this.nowVoteQuestionInfo.nextQuestionID);
      }
      
      private function nextQuetion(param1:String) : void
      {
         ++this.count;
         if(param1 != "0")
         {
            this.voteView.visible = false;
            this.nowVoteQuestionInfo = this.list[param1];
            this.voteView.info = this.nowVoteQuestionInfo;
            this.voteView.visible = true;
            LayerManager.Instance.addToLayer(this.voteView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.closeVote();
         }
      }
      
      public function closeVote() : void
      {
         this.loadOver = false;
         this.showVote = false;
         this.voteView.removeEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.dispose();
         this.sendToServer();
      }
      
      private function sendToServer() : void
      {
         var _loc2_:URLVariables = null;
         var _loc3_:BaseLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.answerArr.length)
         {
            _loc2_ = new URLVariables();
            _loc2_["userId"] = PlayerManager.Instance.Self.ID;
            _loc2_["voteId"] = this.voteId;
            _loc2_["answerContent"] = this.answerArr[_loc1_];
            _loc2_["rnd"] = Math.random();
            _loc3_ = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VoteSubmitResult.ashx"),BaseLoader.REQUEST_LOADER,_loc2_,URLRequestMethod.POST);
            _loc3_.analyzer = new VoteSubmitResultAnalyzer(this.getResult);
            LoadResourceManager.Instance.startLoad(_loc3_);
            _loc1_++;
         }
      }
      
      private function getResult(param1:VoteSubmitResultAnalyzer) : void
      {
         if(this.isVoteComplete)
         {
            return;
         }
         if(param1.result == 1)
         {
            MessageTipManager.getInstance().show(this.completeMessage);
         }
         else
         {
            MessageTipManager.getInstance().show("投票失败!");
         }
         this.isVoteComplete = true;
      }
      
      private function __voteViewCLose(param1:Event) : void
      {
         this.loadOver = false;
         this.showVote = false;
         SharedManager.Instance.voteData["voteId"] = this.voteId;
         SharedManager.Instance.voteData["voteAnswer"] = this.answerArr;
         SharedManager.Instance.voteData["voteProgress"] = this.count;
         SharedManager.Instance.voteData["voteQuestionID"] = this.nowVoteQuestionInfo.questionID;
         SharedManager.Instance.voteData["userId"] = PlayerManager.Instance.Self.ID;
         SharedManager.Instance.save();
      }
   }
}

