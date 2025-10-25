package cardSystem.elements
{
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PreviewCard extends Sprite implements Disposeable
   {
      
      private var _cardId:int;
      
      private var _cell:CardCell;
      
      private var _bg:Bitmap;
      
      private var _Goldbg:Bitmap;
      
      private var _WhiteGoldbg:Bitmap;
      
      private var _Silverbg:Bitmap;
      
      private var _Coppebg:Bitmap;
      
      private var _prop:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _cardName:FilterFrameText;
      
      public function PreviewCard()
      {
         super();
         this.initView();
      }
      
      public function get cardId() : int
      {
         return this._cardId;
      }
      
      public function set cardId(param1:int) : void
      {
         this._cardId = param1;
         this._cardName.text = ItemManager.Instance.getTemplateById(this.cardId).Name;
         this._cardName.y = 41 - this._cardName.textHeight / 2;
      }
      
      private function initView() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,57,70);
         _loc1_.graphics.endFill();
         this._cell = new CardCell(_loc1_);
         this._cell.setContentSize(52,70);
         this._cell.starVisible = false;
         this._cell.Visibles = false;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.storyCard.BG");
         this._WhiteGoldbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.WhiteGrodCard.BG");
         this._Goldbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.GrodCard.BG");
         this._Silverbg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.SilverCard.BG");
         this._Coppebg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.CopperCard.BG");
         this._prop = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.Propset");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.name");
         PositionUtils.setPos(this._cell,"PreviewCard.cellPos");
         addChild(this._bg);
         addChild(this._WhiteGoldbg);
         addChild(this._Goldbg);
         addChild(this._Silverbg);
         addChild(this._Coppebg);
         addChild(this._cardName);
         addChild(this._cell);
         addChild(this._prop);
         this._bg.visible = this._Goldbg.visible = this._Silverbg.visible = this._Coppebg.visible = false;
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         var _loc3_:CardTemplateInfo = null;
         var _loc2_:String = "";
         if(Boolean(param1))
         {
            this._cardInfo = param1;
            this._cell.cardInfo = param1;
            this._cell.visible = true;
            this._cell.Visibles = false;
            _loc3_ = CardTemplateInfoManager.instance.getInfoByCardId(String(param1.TemplateID),String(param1.CardType));
            if(param1.templateInfo.Attack != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",Number(_loc3_.AttackRate)) + "<br/>");
            }
            if(param1.templateInfo.Defence != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",Number(_loc3_.DefendRate)) + "<br/>");
            }
            if(param1.templateInfo.Agility != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",Number(_loc3_.AgilityRate)) + "<br/>");
            }
            if(param1.templateInfo.Luck != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",Number(_loc3_.LuckyRate)) + "<br/>");
            }
            if(parseInt(param1.templateInfo.Property4) != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage",Number(_loc3_.DamageRate)) + "<br/>");
            }
            if(parseInt(param1.templateInfo.Property5) != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",Number(_loc3_.GuardRate)) + "<br/>");
            }
            if(param1.CardType == 1)
            {
               this._Goldbg.visible = true;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(param1.CardType == 2)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = true;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(param1.CardType == 3)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = true;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = false;
            }
            else if(param1.CardType == 4)
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = true;
               this._bg.visible = false;
            }
            else
            {
               this._Goldbg.visible = false;
               this._Silverbg.visible = false;
               this._Coppebg.visible = false;
               this._WhiteGoldbg.visible = false;
               this._bg.visible = true;
            }
         }
         else
         {
            this._cell.cardInfo = null;
            this._cell.visible = false;
            this._Goldbg.visible = false;
            this._Silverbg.visible = false;
            this._WhiteGoldbg.visible = false;
            this._Coppebg.visible = false;
            this._bg.visible = true;
            _loc2_ = LanguageMgr.GetTranslation("ddt.cardSystem.cardProp.unknown");
         }
         this._prop.htmlText = _loc2_;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      public function dispose() : void
      {
         this._cardInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._cell = null;
         this._bg = null;
         this._prop = null;
         this._cardName = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

