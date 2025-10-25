package beadSystem.controls
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import store.view.embed.EmbedStoneCell;
   
   public class BeadLockButton extends TextButton implements IDragable
   {
      
      public function BeadLockButton()
      {
         super();
         this.addEvt();
      }
      
      private function addEvt() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function removeEvt() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function clickthis(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dragStart(stage.mouseX,stage.mouseY);
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(param1.target is BeadCell)
         {
            if((param1.target as BeadCell).LockBead())
            {
               setTimeout(this.continueDrag,75);
            }
         }
         if(param1.target is EmbedStoneCell)
         {
            if((param1.target as EmbedStoneCell).LockBead())
            {
               setTimeout(this.continueDrag,75);
            }
         }
      }
      
      private function continueDrag() : void
      {
         if(Boolean(stage))
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
      }
      
      public function dragStart(param1:Number, param2:Number) : void
      {
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon");
         DragManager.startDrag(this,this,_loc3_,param1,param2,DragEffect.MOVE,false);
      }
      
      override public function get width() : Number
      {
         return 81;
      }
      
      override public function get height() : Number
      {
         return 31;
      }
   }
}

