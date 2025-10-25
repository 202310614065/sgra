package consortion.view.boss
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaBossLevelCell extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _light:Bitmap;
      
      private var _level:int;
      
      public function ConsortiaBossLevelCell(param1:int, param2:String)
      {
         super();
         this._level = param1;
         this.buttonMode = true;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.levelShowTxt");
         PositionUtils.setPos(this._txt,"consortiaBoss.levelView.cellTxtPos");
         this._txt.text = LanguageMgr.GetTranslation(param2,this._level);
         addChild(this._txt);
         this._light = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.levelCellLight");
         this._light.visible = false;
         addChild(this._light);
         addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      public function judgeMaxLevel(param1:int) : void
      {
         if(this._level > param1)
         {
            this.mouseEnabled = false;
            this._txt.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function changeLightSizePos(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._light.width = param1;
         this._light.height = param2;
         this._light.x = param3;
         this._light.y = param4;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         this._light.visible = false;
      }
      
      public function dispose() : void
      {
      }
   }
}

