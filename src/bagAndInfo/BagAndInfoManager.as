package bagAndInfo
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BagAndInfoManager extends EventDispatcher
   {
      
      private static var _instance:BagAndInfoManager;
      
      public static var _firstShowBag:Boolean = true;
      
      private var _bagAndGiftFrame:BagAndGiftFrame;
      
      private var _giftFrame:GiftFrame;
      
      private var _progress:int = 0;
      
      private var _type:int = 0;
      
      private var _name:String = "";
      
      public function BagAndInfoManager(param1:SingletonForce)
      {
         super();
      }
      
      public static function get Instance() : BagAndInfoManager
      {
         if(_instance == null)
         {
            _instance = new BagAndInfoManager(new SingletonForce());
         }
         return _instance;
      }
      
      public function get isShown() : Boolean
      {
         if(!this._bagAndGiftFrame)
         {
            return false;
         }
         return true;
      }
      
      public function getBagAndGiftFrame() : BagAndGiftFrame
      {
         return this._bagAndGiftFrame;
      }
      
      public function showGiftFrame() : void
      {
         this._giftFrame = new GiftFrame();
         this._giftFrame.backStyle = "SimpleFrameBackgound";
         this._giftFrame.titleStyle = "FrameTitleTextStyle";
         this._giftFrame.titleOuterRectPosString = "15,10,5";
         this._giftFrame.closeInnerRectString = "44,19,6,30,14";
         this._giftFrame.closestyle = "core.closebt";
         this._giftFrame.width = 894;
         this._giftFrame.height = 524;
         LayerManager.Instance.addToLayer(this._giftFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __createBag(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAGANDINFO || param1.module == UIModuleTypes.DDTBEAD)
         {
            ++this._progress;
         }
         if(this._progress == 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            _firstShowBag = false;
            this.showBagAndInfo(this._type);
         }
      }
      
      public function showBagAndInfo(param1:int = 0, param2:String = "") : void
      {
         this._type = param1;
         if(param2 != "")
         {
            this._name = param2;
         }
         if(this._bagAndGiftFrame == null)
         {
            if(_firstShowBag)
            {
               this._progress = 0;
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAGANDINFO);
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTBEAD);
            }
            else
            {
               this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
               this._bagAndGiftFrame.show(param1,this._name);
               dispatchEvent(new Event(Event.OPEN));
               this._name = "";
            }
         }
         else
         {
            this._bagAndGiftFrame.show(param1);
            dispatchEvent(new Event(Event.OPEN));
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAGANDINFO)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      public function hideBagAndInfo() : void
      {
         if(Boolean(this._bagAndGiftFrame))
         {
            this._bagAndGiftFrame.dispose();
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function hideGiftFrame() : void
      {
         if(Boolean(this._giftFrame))
         {
            this._giftFrame.dispose();
            this._giftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function clearReference() : void
      {
         this._bagAndGiftFrame = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

class SingletonForce
{
   
   public function SingletonForce()
   {
      super();
   }
}
