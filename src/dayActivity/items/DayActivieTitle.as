package dayActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DayActivieTitle extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      public function DayActivieTitle()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:Bitmap = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Bitmap = null;
         this._bg = ComponentFactory.Instance.creat("asset.consortion.menberList.bg2");
         this._bg.width = 720;
         this._bg.height = 375;
         this._bg.x = 27;
         this._bg.y = 92;
         addChild(this._bg);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityName");
         this._txt1.x = 50;
         this._txt1.y = 102;
         addChild(this._txt1);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt2.text = LanguageMgr.GetTranslation("ddt.dayActivity.activitytime");
         this._txt2.x = 189;
         this._txt2.y = 100;
         addChild(this._txt2);
         this._txt3 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt3.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityNum");
         this._txt3.x = 330;
         this._txt3.y = 100;
         addChild(this._txt3);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt4.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityOpen");
         this._txt4.x = 494;
         this._txt4.y = 100;
         addChild(this._txt4);
         _loc1_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc1_.x = 140;
         _loc1_.y = 93;
         addChild(_loc1_);
         _loc2_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc2_.x = 300;
         _loc2_.y = 93;
         addChild(_loc2_);
         _loc3_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc3_.x = 430;
         _loc3_.y = 93;
         addChild(_loc3_);
         _loc4_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc4_.x = 620;
         _loc4_.y = 93;
         addChild(_loc4_);
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

