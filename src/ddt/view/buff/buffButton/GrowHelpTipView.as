package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GrowHelpTipView extends Sprite
   {
      
      private static const BTNNUM:int = 4;
      
      private var _viewBg:ScaleBitmapImage;
      
      private var _buffArray:Vector.<BuffButton>;
      
      private var _openBtn:Vector.<TextButton>;
      
      public function GrowHelpTipView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._buffArray = new Vector.<BuffButton>();
         this._openBtn = new Vector.<TextButton>();
      }
      
      private function initView() : void
      {
         this._viewBg = ComponentFactory.Instance.creatComponentByStylename("bagBuffer.tipView.bg");
         addChild(this._viewBg);
      }
      
      private function addOpenButton() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < BTNNUM)
         {
            this._openBtn.push(ComponentFactory.Instance.creatComponentByStylename("bagBuffer.growHelp.openBtn"));
            this._openBtn[_loc1_].text = LanguageMgr.GetTranslation("ddt.bagandinfo.buffBuf");
            this._openBtn[_loc1_].addEventListener(MouseEvent.CLICK,this.__onClick);
            PositionUtils.setPos(this._openBtn[_loc1_],"growhelp.buffPos" + String(_loc1_ + 1));
            this._openBtn[_loc1_].x += 35;
            this._openBtn[_loc1_].y -= 4;
            addChild(this._openBtn[_loc1_]);
            PositionUtils.setPos(this._buffArray[_loc1_],"growhelp.buffPos" + String(_loc1_ + 1));
            _loc1_++;
         }
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this._openBtn.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._openBtn[_loc3_] == param1.currentTarget)
            {
               this._buffArray[_loc3_].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            }
            _loc3_++;
         }
      }
      
      public function addBuff(param1:Array) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ != 3)
            {
               this._buffArray.push(param1[_loc3_]);
               addChild(param1[_loc3_]);
            }
            _loc3_++;
         }
         this.addOpenButton();
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._viewBg))
         {
            this._viewBg.dispose();
            this._viewBg = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._buffArray.length)
         {
            this._buffArray[_loc1_].dispose();
            this._buffArray[_loc1_] = null;
            _loc1_++;
         }
         this._buffArray = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._openBtn.length)
         {
            this._openBtn[_loc2_].dispose();
            this._openBtn[_loc2_] = null;
            _loc2_++;
         }
         this._openBtn = null;
      }
      
      public function get viewBg() : ScaleBitmapImage
      {
         return this._viewBg;
      }
   }
}

