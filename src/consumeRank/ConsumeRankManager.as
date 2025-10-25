package consumeRank
{
   import consumeRank.data.ConsumeRankEvent;
   import consumeRank.data.ConsumeRankVo;
   import consumeRank.views.ConsumeRankView;
   import ddt.manager.SocketManager;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   
   public class ConsumeRankManager
   {
      
      private static var _instance:ConsumeRankManager;
      
      public var actId:String;
      
      public var status:int;
      
      public var xmlData:GmActivityInfo;
      
      public var view:ConsumeRankView;
      
      public var myConsume:int;
      
      public var rankList:Array;
      
      private var requestCount:int = 0;
      
      public function ConsumeRankManager()
      {
         super();
      }
      
      public static function get instance() : ConsumeRankManager
      {
         if(!_instance)
         {
            _instance = new ConsumeRankManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(ConsumeRankEvent.UPDATE,this.__updateInfo);
      }
      
      protected function __updateInfo(param1:ConsumeRankEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ConsumeRankVo = null;
         var _loc2_:PackageIn = param1.pkg;
         this.actId = _loc2_.readUTF();
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:Dictionary = WonderfulActivityManager.Instance.activityData;
         var _loc5_:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         if(_loc3_)
         {
            this.status = _loc2_.readInt();
            this.xmlData = _loc4_[this.actId];
            if(!this.xmlData)
            {
               ++this.requestCount;
               if(this.requestCount <= 5)
               {
                  SocketManager.Instance.out.requestWonderfulActInit(0);
               }
               return;
            }
            if(WonderfulActivityManager.Instance.actList.indexOf(this.actId) == -1)
            {
               _loc5_[this.actId] = new LeftViewInfoVo(ActivityType.CONSUME_RANK,"· " + this.xmlData.activityName,this.xmlData.icon);
               WonderfulActivityManager.Instance.addElement(this.actId);
            }
            this.rankList = [];
            _loc6_ = _loc2_.readInt();
            _loc7_ = 0;
            while(_loc7_ <= _loc6_ - 1)
            {
               _loc8_ = new ConsumeRankVo();
               _loc8_.userId = _loc2_.readInt();
               _loc8_.name = _loc2_.readUTF();
               _loc8_.vipLvl = _loc2_.readByte();
               _loc8_.consume = _loc2_.readInt();
               this.rankList.push(_loc8_);
               _loc7_++;
            }
            this.myConsume = _loc2_.readInt();
            if(Boolean(this.view))
            {
               this.view.updateView();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.removeElement(this.actId);
         }
      }
   }
}

