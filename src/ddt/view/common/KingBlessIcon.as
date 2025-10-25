package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import kingBless.KingBlessManager;
   
   public class KingBlessIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _isOpen:Boolean;
      
      private var _isSelf:Boolean;
      
      public function KingBlessIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.core.kingBlessBtn");
         addChild(this._icon);
         this.buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function __openKingBlessFrameHandlder(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         KingBlessManager.instance.loadKingBlessModule(KingBlessManager.instance.doOpenKingBlessFrame);
      }
      
      private function updateIcon() : void
      {
         if(!this._isOpen)
         {
            this._icon.filters = [new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0])];
         }
         else
         {
            this._icon.filters = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this);
         removeChild(this._icon);
         this._icon.bitmapData.dispose();
         this._icon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__openKingBlessFrameHandlder);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__openKingBlessFrameHandlder);
      }
      
      public function setInfo(param1:Boolean, param2:Boolean) : void
      {
         this._isOpen = param1;
         this._isSelf = param2;
         this.updateIcon();
         if(this._isSelf)
         {
            this.addEvent();
         }
         else
         {
            this.removeEvent();
         }
      }
      
      public function get tipData() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(!this._isOpen)
         {
            _loc1_ = new Object();
            _loc1_.isOpen = false;
            _loc1_.content = LanguageMgr.GetTranslation("ddt.kingBlessFrame.noOpenTipTxt");
            return _loc1_;
         }
         if(this._isSelf)
         {
            return KingBlessManager.instance.getRemainTimeTxt();
         }
         _loc2_ = new Object();
         _loc2_.isOpen = true;
         _loc2_.isSelf = false;
         _loc2_.content = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openTipTxt");
         return _loc2_;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

