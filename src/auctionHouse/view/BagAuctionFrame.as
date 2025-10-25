package auctionHouse.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.bag.BagView;
   import com.pickgliss.events.FrameEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BagAuctionFrame extends BagFrame
   {
      
      public function BagAuctionFrame()
      {
         super();
         escEnable = true;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         _bagView.addEventListener(BagView.TABCHANGE,this.__onTabChanged);
      }
      
      protected function __onTabChanged(param1:Event) : void
      {
         if(_bagView.bagType == BagAndGiftFrame.BEADVIEW)
         {
            _bagView.switchButtomVisible(false);
            _bagView.enableBeadFunctionBtns(false);
         }
         else
         {
            _bagView.switchButtomVisible(true);
         }
      }
      
      override protected function initView() : void
      {
         _bagView = new AuctionBagView();
         _bagView.isNeedCard(false);
         _bagView.cardbtnVible = false;
         _bagView.tableEnable = true;
         _bagView.info = PlayerManager.Instance.Self;
         _bagView.initBeadButton();
         _bagView.switchButtomVisible(true);
         addToContent(_bagView);
         PositionUtils.setPos(_bagView,"AutionBagView.Pos");
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(null);
      }
      
      override protected function onResponse(param1:int) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               hide();
               dispatchEvent(new CellEvent(CellEvent.BAG_CLOSE));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _bagView.removeEventListener(BagView.TABCHANGE,this.__onTabChanged);
      }
   }
}

