package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.analyze.LoadEdictumAnalyze;
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import times.TimesManager;
   
   public class EdictumManager extends EventDispatcher
   {
      
      private static var _instance:EdictumManager;
      
      private var unShowArr:Array = new Array();
      
      private var edictumDataList:Array;
      
      public function EdictumManager(param1:IEventDispatcher = null)
      {
         super();
      }
      
      public static function get Instance() : EdictumManager
      {
         if(_instance == null)
         {
            _instance = new EdictumManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EDICTUM_GET_VERSION,this.__getEdictumVersion);
      }
      
      private function __getEdictumVersion(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.push(_loc2_.readInt());
            _loc5_++;
         }
         this.__checkVersion(_loc4_);
      }
      
      private function __checkVersion(param1:Array) : void
      {
         this.unShowArr = param1;
         if(this.unShowArr.length > 0)
         {
            this.__loadEdictumData();
         }
      }
      
      private function __loadEdictumData() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(this.__getURL(),BaseLoader.REQUEST_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc1_.analyzer = new LoadEdictumAnalyze(this.__returnWebSiteInfoHandler);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      private function __returnWebSiteInfoHandler(param1:LoadEdictumAnalyze) : void
      {
         this.edictumDataList = param1.edictumDataList;
         TimesManager.Instance.checkLoadUpdateRes(this.edictumDataList,this.unShowArr);
      }
      
      private function __getURL() : String
      {
         return PathManager.solveRequestPath("GMTipAllByIDs.ashx?ids=" + this.unShowArr.join(","));
      }
   }
}

