package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import hall.HallStateView;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   
   public class LandersAwardManager
   {
      
      public static var LANDERS_AWARD_4399:Boolean;
      
      private static var _instance:LandersAwardManager;
      
      private var _landersBtn:SimpleBitmapButton;
      
      private var _getFlag:Boolean = true;
      
      private var _hallView:HallStateView;
      
      public function LandersAwardManager()
      {
         super();
      }
      
      public static function get instance() : LandersAwardManager
      {
         if(!_instance)
         {
            _instance = new LandersAwardManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(RingStationEvent.LANDERSAWARD_RECEIVE,this.__onIsReceiveAward);
      }
      
      protected function __onIsReceiveAward(param1:RingStationEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._getFlag = _loc2_.readBoolean();
         if(!this._getFlag)
         {
            this.showIcon();
         }
         else
         {
            this.disposeEntryBtn();
         }
      }
      
      private function showIcon() : void
      {
         if(Boolean(this._hallView))
         {
            this.createEntryBtn(this._hallView);
         }
      }
      
      public function createEntryBtn(param1:HallStateView) : void
      {
         this._hallView = param1;
         if(LANDERS_AWARD_4399 && !this._getFlag)
         {
            this._landersBtn = ComponentFactory.Instance.creatComponentByStylename("hall.landersAwardBtn");
            this._landersBtn.addEventListener(MouseEvent.CLICK,this.__onGetAward);
            this._hallView.addChild(this._landersBtn);
         }
      }
      
      protected function __onGetAward(param1:MouseEvent) : void
      {
         if(DesktopManager.Instance.landersAwardFlag)
         {
            SocketManager.Instance.out.receiveLandersAward();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("hall.getLandersAward.tipsText"));
            navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
         }
      }
      
      public function disposeEntryBtn() : void
      {
         if(Boolean(this._landersBtn))
         {
            this._landersBtn.removeEventListener(MouseEvent.CLICK,this.__onGetAward);
            this._landersBtn.dispose();
            this._landersBtn = null;
         }
      }
   }
}

