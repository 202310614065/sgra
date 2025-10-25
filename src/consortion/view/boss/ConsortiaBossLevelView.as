package consortion.view.boss
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaBossLevelView extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _levelShowBtn:SimpleBitmapButton;
      
      private var _showSprite:Sprite;
      
      private var _selectedBg:Bitmap;
      
      private var _selectedCellList:Vector.<ConsortiaBossLevelCell>;
      
      private var _selectedSprite:Sprite;
      
      private var _selectedLevel:int;
      
      public function ConsortiaBossLevelView()
      {
         super();
         this._selectedLevel = ConsortionModelControl.Instance.getCanCallBossMaxLevel();
         this.initView();
         this.initEvent();
      }
      
      public function set selectedLevel(param1:int) : void
      {
         this._selectedLevel = param1;
         this._txt.text = LanguageMgr.GetTranslation("consortiaBossFrame.levelSelected.levelTxt",this._selectedLevel);
      }
      
      public function get selectedLevel() : int
      {
         return this._selectedLevel;
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ConsortiaBossLevelCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.levelBg");
         this._levelShowBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.levelShowBtn");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.levelShowTxt");
         this._txt.text = LanguageMgr.GetTranslation("consortiaBossFrame.levelSelected.levelTxt",this._selectedLevel);
         this._showSprite = new Sprite();
         this._showSprite.addChild(this._bg);
         this._showSprite.addChild(this._txt);
         this._showSprite.addChild(this._levelShowBtn);
         this._showSprite.buttonMode = true;
         this._showSprite.mouseChildren = false;
         addChild(this._showSprite);
         this._selectedBg = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.levelSelectedBg");
         this._selectedSprite = new Sprite();
         PositionUtils.setPos(this._selectedSprite,"consortiaBoss.levelView.selectedSpritePos");
         this._selectedSprite.addChild(this._selectedBg);
         this._selectedCellList = new Vector.<ConsortiaBossLevelCell>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new ConsortiaBossLevelCell(_loc1_ + 1,"consortiaBossFrame.levelSelected.levelTxt");
            _loc2_.x = 3 + _loc1_ % 2 * 136;
            _loc2_.y = 3 + int(_loc1_ / 2) * 34.5;
            _loc2_.judgeMaxLevel(this._selectedLevel);
            _loc2_.addEventListener(MouseEvent.CLICK,this.selecteLevelHandler,false,0,true);
            this._selectedSprite.addChild(_loc2_);
            _loc1_++;
         }
         addChild(this._selectedSprite);
         this._selectedSprite.visible = false;
      }
      
      private function initEvent() : void
      {
         this._showSprite.addEventListener(MouseEvent.CLICK,this.showOrHideSelectedSprite,false,0,true);
      }
      
      private function selecteLevelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedLevel = (param1.target as ConsortiaBossLevelCell).level;
         this._txt.text = LanguageMgr.GetTranslation("consortiaBossFrame.levelSelected.levelTxt",this._selectedLevel);
         this._selectedSprite.visible = false;
      }
      
      private function showOrHideSelectedSprite(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedSprite.visible = !this._selectedSprite.visible;
      }
      
      public function dispose() : void
      {
         var _loc1_:ConsortiaBossLevelCell = null;
         this._showSprite.removeEventListener(MouseEvent.CLICK,this.showOrHideSelectedSprite);
         for each(_loc1_ in this._selectedCellList)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.selecteLevelHandler);
         }
         ObjectUtils.disposeAllChildren(this._showSprite);
         ObjectUtils.disposeAllChildren(this._selectedSprite);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._txt = null;
         this._bg = null;
         this._levelShowBtn = null;
         this._showSprite = null;
         this._selectedBg = null;
         this._selectedCellList = null;
         this._selectedSprite = null;
      }
   }
}

