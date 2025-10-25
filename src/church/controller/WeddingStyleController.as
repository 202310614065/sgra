package church.controller
{
   import baglocked.BaglockedManager;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.frame.WeddingRoomCreateView;
   import church.view.weddingRoomList.frame.WeddingRoomStyleChooseView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.socket.ePackageType;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageOut;
   
   public class WeddingStyleController extends EventDispatcher
   {
      
      private var _listController:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _createRoomFrame:WeddingRoomCreateView;
      
      private var _chooseStyleFrame:WeddingRoomStyleChooseView;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      public function WeddingStyleController(param1:ChurchRoomListController, param2:ChurchRoomListModel)
      {
         super();
         this._listController = param1;
         this._model = param2;
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._baseAlerFrame.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this._baseAlerFrame.dispose();
               this.confirmMarry();
         }
      }
      
      private function confirmMarry() : void
      {
         if(PlayerManager.Instance.Self.Money < 2000)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_SIMPLE);
         SocketManager.Instance.out.sendPackage(_loc1_);
      }
      
      public function showChooseFrame() : void
      {
         if(!PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
            return;
         }
         if(Boolean(ChurchManager.instance.selfRoom))
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._chooseStyleFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingStyleChooseFrame");
         this._chooseStyleFrame.setController(this);
         this._chooseStyleFrame.show();
      }
      
      public function chooseWeddingStyle(param1:int) : void
      {
         if(param1 == 0)
         {
            this._createRoomFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingRoomCreateView");
            this._createRoomFrame.setController(this._listController,this._model);
            this._createRoomFrame.show();
         }
         else if(PlayerManager.Instance.Self.IsGotRing)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.weddingRepeat.tip"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("church.weddingRoom.weddingRepeat.tip"));
         }
         else
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("church.SimpleWedding.title"),"2000PV akan ditolak untuk mengadakan Majlis Perkahwinan, ingin meneruskan?",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._createRoomFrame))
         {
            if(Boolean(this._createRoomFrame.parent))
            {
               this._createRoomFrame.parent.removeChild(this._createRoomFrame);
            }
            this._createRoomFrame.dispose();
         }
         this._createRoomFrame = null;
         if(Boolean(this._chooseStyleFrame))
         {
            if(Boolean(this._chooseStyleFrame.parent))
            {
               this._chooseStyleFrame.parent.removeChild(this._chooseStyleFrame);
            }
            this._chooseStyleFrame.dispose();
         }
         this._chooseStyleFrame = null;
      }
   }
}

