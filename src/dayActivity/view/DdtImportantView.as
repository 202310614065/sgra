package dayActivity.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DdtImportantView extends Sprite implements Disposeable
   {
      
      private var _prePageBtn:SimpleBitmapButton;
      
      private var _nextPageBtn:SimpleBitmapButton;
      
      private var _contentView:Bitmap;
      
      private var _currentIndex:int = 0;
      
      private var _sumIndex:int = 18;
      
      private var _maskSprite:Sprite;
      
      private var _hBox:HBox;
      
      private var _contentViewVector:Vector.<Bitmap> = new Vector.<Bitmap>();
      
      public function DdtImportantView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:Bitmap = null;
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("day.ddtImportantAdv.hBox");
         addChild(this._hBox);
         this._maskSprite = new Sprite();
         this._maskSprite.graphics.beginFill(0);
         this._maskSprite.graphics.drawRect(0,0,737,466);
         this._maskSprite.graphics.endFill();
         addChild(this._maskSprite);
         this._maskSprite.x = this._hBox.x;
         this._maskSprite.y = this._hBox.y;
         this._hBox.mask = this._maskSprite;
         var _loc1_:int = 0;
         while(_loc1_ < this._sumIndex)
         {
            _loc2_ = ComponentFactory.Instance.creat("day.actiity.groundBack" + (_loc1_ + 1));
            this._contentViewVector.push(_loc2_);
            this._hBox.addChild(_loc2_);
            _loc1_++;
         }
         this._hBox.arrange();
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("day.ddtImportantAdv.prePageBtn");
         this._prePageBtn.alpha = 0.3;
         addChild(this._prePageBtn);
         this._prePageBtn.tipData = LanguageMgr.GetTranslation("prePage");
         this._prePageBtn.visible = false;
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("day.ddtImportantAdv.nextPageBtn");
         this._nextPageBtn.alpha = 0.3;
         addChild(this._nextPageBtn);
         this._nextPageBtn.tipData = LanguageMgr.GetTranslation("nextPage");
         this.currentIndex = 0;
      }
      
      private function addEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._prePageBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._nextPageBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._nextPageBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__leftPageHandler);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__rightPageHandler);
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         (param1.target as SimpleBitmapButton).alpha = 1;
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         (param1.target as SimpleBitmapButton).alpha = 0.3;
      }
      
      protected function __leftPageHandler(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.currentIndex <= 0)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         var _loc2_:int = 0;
         while(_loc2_ < this._contentViewVector.length)
         {
            if(_loc2_ == this._currentIndex || _loc2_ == this._currentIndex - 1)
            {
               this._contentViewVector[_loc2_].visible = true;
            }
            else
            {
               this._contentViewVector[_loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc3_ = this._hBox.x;
         this._prePageBtn.visible = this._nextPageBtn.visible = false;
         TweenLite.to(this._hBox,1,{
            "x":_loc3_ + this._contentViewVector[this._currentIndex].width,
            "onComplete":this.prePage
         });
      }
      
      private function prePage() : void
      {
         if(!this._prePageBtn || !this._nextPageBtn)
         {
            return;
         }
         this._prePageBtn.visible = this._nextPageBtn.visible = true;
         this.currentIndex = this._currentIndex - 1;
      }
      
      private function nextPage() : void
      {
         if(!this._prePageBtn || !this._nextPageBtn)
         {
            return;
         }
         this._prePageBtn.visible = this._nextPageBtn.visible = true;
         this.currentIndex = this._currentIndex + 1;
      }
      
      protected function __rightPageHandler(param1:MouseEvent) : void
      {
         if(this.currentIndex >= this._sumIndex - 1)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         var _loc2_:int = 0;
         while(_loc2_ < this._contentViewVector.length)
         {
            if(_loc2_ == this._currentIndex || _loc2_ == this._currentIndex + 1)
            {
               this._contentViewVector[_loc2_].visible = true;
            }
            else
            {
               this._contentViewVector[_loc2_].visible = false;
            }
            _loc2_++;
         }
         var _loc3_:int = this._hBox.x;
         this._prePageBtn.visible = this._nextPageBtn.visible = false;
         TweenLite.to(this._hBox,1,{
            "x":_loc3_ - this._contentViewVector[this._currentIndex].width,
            "onComplete":this.nextPage
         });
      }
      
      public function get currentIndex() : int
      {
         return this._currentIndex;
      }
      
      public function set currentIndex(param1:int) : void
      {
         this._currentIndex = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._contentViewVector.length)
         {
            if(_loc2_ == this._currentIndex)
            {
               this._contentViewVector[_loc2_].visible = true;
            }
            else
            {
               this._contentViewVector[_loc2_].visible = false;
            }
            _loc2_++;
         }
         switch(this._currentIndex)
         {
            case 0:
               this._prePageBtn.visible = false;
               this._nextPageBtn.visible = true;
               break;
            case this._sumIndex - 1:
               this._prePageBtn.visible = true;
               this._nextPageBtn.visible = false;
               break;
            default:
               this._prePageBtn.visible = this._nextPageBtn.visible = true;
         }
      }
      
      private function disposeContentView() : void
      {
         ObjectUtils.disposeObject(this._contentView);
         this._contentView = null;
         this._contentView = ComponentFactory.Instance.creat("day.actiity.groundBack" + this._currentIndex);
         this._contentView.alpha = 0;
         this._contentView.x = 22;
         this._contentView.y = 86;
         addChildAt(this._contentView,0);
         TweenLite.to(this._contentView,1,{"alpha":1});
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._prePageBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._nextPageBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._nextPageBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__leftPageHandler);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__rightPageHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:Bitmap = null;
         for each(_loc1_ in this._contentViewVector)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._contentViewVector = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._contentView);
         this._contentView = null;
         ObjectUtils.disposeObject(this._maskSprite);
         this._maskSprite = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

