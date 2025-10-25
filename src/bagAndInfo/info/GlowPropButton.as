package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class GlowPropButton extends PropButton
   {
      
      private var _overGraphics:DisplayObject;
      
      private var _showOverGraphics:Boolean = true;
      
      public function GlowPropButton()
      {
         super();
         this.addEvent();
         _tipStyle = "core.ChatacterPropTxtTips";
      }
      
      public function get showOverGraphics() : Boolean
      {
         return this._showOverGraphics;
      }
      
      public function set showOverGraphics(param1:Boolean) : void
      {
         this._showOverGraphics = param1;
      }
      
      override protected function addChildren() : void
      {
         if(!_back)
         {
            _back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.prop_up");
            addChild(_back);
         }
         if(!this._overGraphics)
         {
            this._overGraphics = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.light");
            this._overGraphics.visible = false;
            addChild(this._overGraphics);
         }
      }
      
      public function setOverGraphicsPosition(param1:Point) : void
      {
         if(!param1)
         {
            return;
         }
         this._overGraphics.x = param1.x;
         this._overGraphics.y = param1.y;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         this._overGraphics.visible = this._showOverGraphics;
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         this._overGraphics.visible = false && this._showOverGraphics;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._overGraphics))
         {
            ObjectUtils.disposeObject(this._overGraphics);
            this._overGraphics = null;
         }
         super.dispose();
      }
   }
}

