package cardSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class CardPropress extends Component
   {
      
      private var _thuck:Component;
      
      private var _graphics_thuck:BitmapData;
      
      private var _propgressLabel:FilterFrameText;
      
      private var _value:Number = 0;
      
      private var _max:Number = 100;
      
      public function CardPropress()
      {
         super();
         _width = _height = 10;
         this.initView();
         this.drawProgress();
      }
      
      private function initView() : void
      {
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("cardSystem.info.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("card.info.Bitmap_thuck1");
         this._propgressLabel = ComponentFactory.Instance.creatComponentByStylename("CardSystem.info.LevelProgressText");
         addChild(this._propgressLabel);
      }
      
      public function setProgress(param1:Number, param2:Number) : void
      {
         if(this._value != param1 || this._max != param2)
         {
            this._value = param1;
            this._max = param2;
            this.drawProgress();
         }
      }
      
      private function drawProgress() : void
      {
         var _loc1_:Number = this._value / this._max > 1 ? 1 : this._value / this._max;
         var _loc2_:Graphics = this._thuck.graphics;
         _loc2_.clear();
         if(_loc1_ >= 0)
         {
            this._propgressLabel.text = Math.floor(_loc1_ * 10000) / 100 + "%";
            _loc2_.beginBitmapFill(this._graphics_thuck,new Matrix(128 / 123));
            _loc2_.drawRect(0,0,(_width + 20) * _loc1_,_height - 4);
            _loc2_.endFill();
         }
      }
      
      public function set labelText(param1:String) : void
      {
         this._propgressLabel.text = param1;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._propgressLabel);
         this._propgressLabel = null;
         super.dispose();
      }
   }
}

