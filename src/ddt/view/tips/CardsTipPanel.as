package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import road7th.data.DictionaryData;
   
   public class CardsTipPanel extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 300;
      
      public static const CARDTYPE:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const CARDTYPE_VICE_MAIN:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
      
      private var _bg:ScaleBitmapImage;
      
      private var _cardName:FilterFrameText;
      
      private var _cardType:Bitmap;
      
      private var _cardTypeDetail:FilterFrameText;
      
      private var _cardLevel:Bitmap;
      
      private var _cardLevelDetail:FilterFrameText;
      
      private var _EpDetail:FilterFrameText;
      
      private var _Explain:FilterFrameText;
      
      private var _Quality:FilterFrameText;
      
      private var _QualityDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _band:ScaleFrameImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _place:int;
      
      private var _isGroove:Boolean;
      
      private var _cardGrooveInfo:GrooveInfo;
      
      private var _thisHeight:int;
      
      public function CardsTipPanel()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._cardName = null;
         this._cardType = null;
         this._cardTypeDetail = null;
         this._cardLevel = null;
         this._rule1 = null;
         this._band = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._propVec.length)
         {
            this._propVec[_loc1_] = null;
            _loc1_++;
         }
         this._propVec = null;
         this._rule2 = null;
         this._setsName = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._setsPropVec.length)
         {
            this._setsPropVec[_loc2_] = null;
            _loc2_++;
         }
         this._setsPropVec = null;
         this._validity = null;
         this._cardInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._band = ComponentFactory.Instance.creatComponentByStylename("tipPanel.band");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._cardType = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsType");
         PositionUtils.setPos(this._cardType,"CardsTipPanel.typePos");
         this._cardTypeDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.typeDetail");
         this._cardLevel = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsLevel");
         this._cardLevelDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         this._propVec = new Vector.<FilterFrameText>(4);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._propVec[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
            _loc1_++;
         }
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._setsPropVec = new Vector.<FilterFrameText>(4);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._setsPropVec[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
            _loc2_++;
         }
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._EpDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExpPropTitle");
         PositionUtils.setPos(this._EpDetail,"core.cardTipEp.pos");
         this._Explain = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExplainTitle");
         this._Quality = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.QualityTitle");
         this._QualityDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.Quality");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._cardName);
         addChild(this._cardType);
         addChild(this._cardTypeDetail);
         addChild(this._cardLevel);
         addChild(this._cardLevelDetail);
         addChild(this._rule1);
         addChild(this._band);
         addChild(this._Quality);
         addChild(this._QualityDetail);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            addChild(this._propVec[_loc1_]);
            _loc1_++;
         }
         addChild(this._rule2);
         addChild(this._setsName);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            addChild(this._setsPropVec[_loc2_]);
            _loc2_++;
         }
         addChild(this._validity);
         addChild(this._EpDetail);
         addChild(this._Explain);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 is CardInfo)
         {
            this._cardInfo = param1 as CardInfo;
            this.visible = true;
            _tipData = this._cardInfo;
            this._place = this._cardInfo.Place;
            if(this._place < 5)
            {
               if(CardControl.Instance.model.GrooveInfoVector == null)
               {
                  this.visible = false;
               }
               else
               {
                  this._cardGrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
                  this._isGroove = true;
               }
            }
            else
            {
               this._isGroove = false;
            }
            this.upview();
         }
         else if(param1 == null)
         {
            this.visible = false;
         }
         else
         {
            this._place = param1 as int;
            if(CardControl.Instance.model.GrooveInfoVector == null)
            {
               this._cardGrooveInfo == null;
            }
            else
            {
               this._cardGrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
            }
            if(this._cardGrooveInfo == null)
            {
               this.visible = false;
               if(Boolean(CardControl.Instance.model.tempCardGroove))
               {
                  this.visible = true;
                  _tipData = CardControl.Instance.model.tempCardGroove;
                  this._cardGrooveInfo = CardControl.Instance.model.tempCardGroove;
                  this.upview();
                  CardControl.Instance.model.tempCardGroove = null;
                  this._cardGrooveInfo = null;
               }
            }
            else
            {
               this.visible = true;
               _tipData = this._cardGrooveInfo;
               this.upview();
            }
         }
      }
      
      private function upview() : void
      {
         this._thisHeight = 0;
         this.showHeadPart();
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      private function showHeadPart() : void
      {
         var _loc1_:CardGrooveInfo = null;
         var _loc2_:CardGrooveInfo = null;
         var _loc3_:CardGrooveInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_tipData == this._cardGrooveInfo)
         {
            _loc1_ = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
            PositionUtils.setPos(this._cardLevelDetail,"core.grooveLevel.pos");
            PositionUtils.setPos(this._cardLevel,"core.cardLevelBmpOne.pos");
            this._cardLevel.visible = true;
            this._cardLevelDetail.visible = true;
            this._cardLevelDetail.text = this._cardGrooveInfo.Level < 10 ? "0" + String(this._cardGrooveInfo.Level) : String(this._cardGrooveInfo.Level);
            this._cardName.visible = false;
            this._cardTypeDetail.visible = false;
            this._cardType.visible = false;
            this._band.visible = false;
            this._EpDetail.visible = true;
            this._Quality.visible = false;
            this._QualityDetail.visible = false;
            if(this._cardGrooveInfo.Level >= 40)
            {
               this._EpDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.EP",0 + "/" + 0);
            }
            else
            {
               _loc2_ = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
               _loc3_ = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level + 1),String(this._cardGrooveInfo.Type));
               _loc4_ = this._cardGrooveInfo.GP - int(_loc2_.Exp);
               _loc5_ = int(_loc3_.Exp) - int(_loc2_.Exp);
               this._EpDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.EP",_loc4_ + "/" + _loc5_);
            }
            this._rule1.x = this._EpDetail.x;
            this._rule1.y = this._EpDetail.y + this._EpDetail.textHeight + 10;
            this._thisHeight = this._rule1.y + this._rule1.height;
         }
         else
         {
            this._cardName.visible = true;
            this._cardTypeDetail.visible = true;
            this._cardType.visible = true;
            this._band.visible = true;
            this._EpDetail.visible = false;
            this._Quality.visible = true;
            this._QualityDetail.visible = true;
            this._cardLevel.visible = false;
            this._cardLevelDetail.visible = false;
            this._cardName.text = this._cardInfo.templateInfo.Name;
            this._cardTypeDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.typeDetail",CARDTYPE[int(this._cardInfo.templateInfo.Property6)],CARDTYPE_VICE_MAIN[this._cardInfo.templateInfo.Property8]);
            this._Quality.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Quality");
            PositionUtils.setPos(this._Quality,"core.cardLevel.pos");
            this._QualityDetail.x = this._Quality.x + this._Quality.textWidth;
            this._QualityDetail.y = this._Quality.y;
            this._band.setFrame(this._cardInfo.templateInfo.BindType == 0 ? 2 : 1);
            _loc6_ = this._cardInfo.Level == 30 ? 3 : (this._cardInfo.Level >= 20 ? 2 : (this._cardInfo.Level >= 10 ? 1 : 0));
            if(this._cardInfo.Level == 0)
            {
               this._cardName.textColor = 16777215;
            }
            else
            {
               this._cardName.textColor = QualityType.QUALITY_COLOR[_loc6_ + 1];
            }
            if(this._cardInfo.CardType == 1)
            {
               this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.jin");
            }
            else if(this._cardInfo.CardType == 2)
            {
               this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.yin");
            }
            else if(this._cardInfo.CardType == 4)
            {
               this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.baijin");
            }
            else
            {
               this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.tong");
            }
            this._rule1.x = this._cardName.x;
            this._rule1.y = this._Quality.y + this._Quality.textHeight + 10;
            this._thisHeight = this._rule1.y + this._rule1.height;
         }
      }
      
      private function showMiddlePart() : void
      {
         var _loc2_:CardGrooveInfo = null;
         var _loc3_:int = 0;
         var _loc4_:CardTemplateInfo = null;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         if(_tipData == this._cardGrooveInfo)
         {
            _loc2_ = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
            if(int(_loc2_.Attack) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",this._cardGrooveInfo.realAttack));
            }
            if(int(_loc2_.Defend) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",this._cardGrooveInfo.realDefence));
            }
            if(int(_loc2_.Agility) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",this._cardGrooveInfo.realAgility));
            }
            if(int(_loc2_.Lucky) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",this._cardGrooveInfo.realLucky));
            }
            if(int(_loc2_.Damage) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Gamage",this._cardGrooveInfo.realDamage));
            }
            if(int(_loc2_.Guard) >= 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",this._cardGrooveInfo.realGuard));
            }
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(_loc3_ < _loc1_.length)
               {
                  this._propVec[_loc3_].visible = true;
                  this._propVec[_loc3_].text = _loc1_[_loc3_];
                  this._propVec[_loc3_].textColor = QualityType.QUALITY_COLOR[5];
                  this._propVec[_loc3_].y = this._rule1.y + this._rule1.height + 8 + 24 * _loc3_;
                  if(_loc3_ == _loc1_.length - 1)
                  {
                     this._rule2.x = this._propVec[_loc3_].x;
                     this._rule2.y = this._propVec[_loc3_].y + this._propVec[_loc3_].textHeight + 12;
                  }
               }
               else
               {
                  this._propVec[_loc3_].visible = false;
               }
               this._rule2.x = this._propVec[_loc3_].x;
               this._rule2.y = this._propVec[_loc3_].y + this._propVec[_loc3_].textHeight + 12;
               this._thisHeight = this._rule2.y + this._rule2.height;
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = CardTemplateInfoManager.instance.getInfoByCardId(String(this._cardInfo.TemplateID),String(this._cardInfo.CardType));
            if(!this._isGroove)
            {
               if(this._cardInfo.templateInfo.Attack != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",Number(_loc4_.AttackRate)) + (int(_loc4_.AddAttack) != 0 ? (int(_loc4_.AddAttack) > 0 ? "+" + int(_loc4_.AddAttack) : int(_loc4_.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Defence != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",Number(_loc4_.DefendRate)) + (int(_loc4_.AddDefend) != 0 ? (int(_loc4_.AddDefend) > 0 ? "+" + int(_loc4_.AddDefend) : int(_loc4_.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Agility != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",Number(_loc4_.AgilityRate)) + (int(_loc4_.AddAgility) != 0 ? (int(_loc4_.AddAgility) > 0 ? "+" + int(_loc4_.AddAgility) : int(_loc4_.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Luck != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",Number(_loc4_.LuckyRate)) + (int(_loc4_.AddLucky) != 0 ? (int(_loc4_.AddLucky) > 0 ? "+" + int(_loc4_.AddLucky) : int(_loc4_.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
               }
               if(parseInt(this._cardInfo.templateInfo.Property4) != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Gamage",Number(_loc4_.DamageRate)) + (int(_loc4_.AddDamage) != 0 ? (int(_loc4_.AddDamage) > 0 ? "+" + int(_loc4_.AddDamage) : int(_loc4_.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
               }
               if(parseInt(this._cardInfo.templateInfo.Property5) != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",Number(_loc4_.GuardRate)) + (int(_loc4_.AddGuard) != 0 ? (int(_loc4_.AddGuard) > 0 ? "+" + int(_loc4_.AddGuard) : int(_loc4_.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
               }
            }
            else
            {
               if(this._cardInfo.templateInfo.Attack != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",Math.floor(this._cardGrooveInfo.realAttack * Number(_loc4_.AttackRate) * 10) / 10) + (int(_loc4_.AddAttack) != 0 ? (int(_loc4_.AddAttack) > 0 ? "+" + int(_loc4_.AddAttack) : int(_loc4_.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Defence != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",Math.floor(this._cardGrooveInfo.realDefence * Number(_loc4_.DefendRate) * 10) / 10) + (int(_loc4_.AddDefend) != 0 ? (int(_loc4_.AddDefend) > 0 ? "+" + int(_loc4_.AddDefend) : int(_loc4_.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Agility != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",Math.floor(this._cardGrooveInfo.realAgility * Number(_loc4_.AgilityRate) * 10) / 10) + (int(_loc4_.AddAgility) != 0 ? (int(_loc4_.AddAgility) > 0 ? "+" + int(_loc4_.AddAgility) : int(_loc4_.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
               }
               if(this._cardInfo.templateInfo.Luck != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",Math.floor(this._cardGrooveInfo.realLucky * Number(_loc4_.LuckyRate) * 10) / 10) + (int(_loc4_.AddLucky) != 0 ? (int(_loc4_.AddLucky) > 0 ? "+" + int(_loc4_.AddLucky) : int(_loc4_.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
               }
               if(parseInt(this._cardInfo.templateInfo.Property4) != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Gamage",Math.floor(this._cardGrooveInfo.realDamage * Number(_loc4_.DamageRate) * 10) / 10) + (int(_loc4_.AddDamage) != 0 ? (int(_loc4_.AddDamage) > 0 ? "+" + int(_loc4_.AddDamage) : int(_loc4_.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
               }
               if(parseInt(this._cardInfo.templateInfo.Property5) != 0)
               {
                  _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",Math.floor(this._cardGrooveInfo.realGuard * Number(_loc4_.GuardRate) * 10) / 10) + (int(_loc4_.AddGuard) != 0 ? (int(_loc4_.AddGuard) > 0 ? "+" + int(_loc4_.AddGuard) : int(_loc4_.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
               }
            }
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               if(_loc5_ < _loc1_.length)
               {
                  this._propVec[_loc5_].visible = true;
                  this._propVec[_loc5_].text = _loc1_[_loc5_];
                  this._propVec[_loc5_].textColor = QualityType.QUALITY_COLOR[5];
                  this._propVec[_loc5_].y = this._rule1.y + this._rule1.height + 8 + 24 * _loc5_;
                  if(_loc5_ == _loc1_.length - 1)
                  {
                     this._rule2.x = this._propVec[_loc5_].x;
                     this._rule2.y = this._propVec[_loc5_].y + this._propVec[_loc5_].textHeight + 12;
                  }
               }
               else
               {
                  this._propVec[_loc5_].visible = false;
               }
               _loc5_++;
            }
            this._thisHeight = this._rule2.y + this._rule2.height;
         }
      }
      
      private function showButtomPart() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<int> = null;
         var _loc3_:PlayerInfo = null;
         var _loc4_:DictionaryData = null;
         var _loc5_:CardInfo = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:DictionaryData = null;
         var _loc8_:CardInfo = null;
         var _loc9_:int = 0;
         var _loc10_:Vector.<SetsInfo> = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:Vector.<SetsPropertyInfo> = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:GrooveInfo = null;
         var _loc18_:Array = null;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         if(_tipData == this._cardGrooveInfo)
         {
            this._setsName.visible = false;
            _loc1_ = 0;
            while(_loc1_ < this._setsPropVec.length)
            {
               this._setsPropVec[_loc1_].visible = false;
               _loc1_++;
            }
            this._validity.visible = false;
            this._Explain.visible = true;
            this._Explain.text = LanguageMgr.GetTranslation("ddt.cardsTipPanel.Groove.epdetai");
            this._Explain.y = this._thisHeight + 10;
            this._thisHeight = this._Explain.y + this._Explain.textHeight;
         }
         else
         {
            _loc2_ = new Vector.<int>();
            _loc3_ = PlayerManager.Instance.findPlayer(this._cardInfo.UserID);
            _loc4_ = _loc3_.cardEquipDic;
            this._setsName.visible = true;
            this._validity.visible = true;
            this._Explain.visible = false;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7 && _loc5_.Count > -1)
               {
                  if(!this._isGroove)
                  {
                     _loc2_.push(_loc5_.Level);
                  }
                  else
                  {
                     _loc17_ = CardControl.Instance.model.GrooveInfoVector[_loc5_.Place];
                     _loc2_.push(_loc17_.Level);
                  }
               }
            }
            _loc2_.sort(this.compareFun);
            _loc6_ = new Vector.<int>();
            _loc7_ = _loc3_.cardBagDic;
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7)
               {
                  if(!this._isGroove)
                  {
                     _loc6_.push(_loc8_.Level);
                  }
                  else
                  {
                     _loc6_.push(this._cardGrooveInfo.Level);
                  }
               }
            }
            _loc6_.sort(this.compareFun);
            _loc9_ = 0;
            _loc10_ = CardControl.Instance.model.setsSortRuleVector;
            _loc11_ = int(_loc10_.length);
            _loc12_ = "";
            _loc13_ = 0;
            while(_loc13_ < _loc11_)
            {
               if(_loc10_[_loc13_].ID == this._cardInfo.templateInfo.Property7)
               {
                  _loc9_ = int(_loc10_[_loc13_].cardIdVec.length);
                  _loc12_ = _loc10_[_loc13_].name;
                  break;
               }
               _loc13_++;
            }
            this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.setsName",_loc12_,_loc2_.length,_loc9_);
            if(_loc2_.length > 0)
            {
               this._setsName.textColor = 16777215;
            }
            else
            {
               this._setsName.textColor = 10066329;
            }
            this._setsName.y = this._thisHeight + 5;
            this._thisHeight = this._setsName.y + this._setsName.textHeight;
            _loc14_ = CardControl.Instance.model.setsList[this._cardInfo.templateInfo.Property7];
            _loc15_ = int(_loc14_.length);
            _loc16_ = 0;
            while(_loc16_ < 4)
            {
               if(_loc16_ < _loc15_)
               {
                  this._setsPropVec[_loc16_].visible = true;
                  _loc18_ = _loc14_[_loc16_].value.split("|");
                  _loc19_ = "";
                  _loc20_ = _loc14_[_loc16_].condition;
                  if(_loc2_.length >= _loc20_)
                  {
                     if(_loc18_.length == 4)
                     {
                        _loc19_ = _loc2_[_loc20_ - 1] == 40 ? _loc18_[3] : (_loc2_[_loc20_ - 1] >= 30 ? _loc18_[3] : (_loc2_[_loc20_ - 1] >= 20 ? _loc18_[2] : (_loc2_[_loc20_ - 1] >= 10 ? _loc18_[1] : _loc18_[0])));
                     }
                     else
                     {
                        _loc19_ = _loc18_[0];
                     }
                     this._setsPropVec[_loc16_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc20_) + "\n    " + _loc14_[_loc16_].Description.replace("{0}",_loc19_);
                     this._setsPropVec[_loc16_].textColor = QualityType.QUALITY_COLOR[2];
                  }
                  else
                  {
                     if(_loc18_.length == 4)
                     {
                        if(_loc6_.length >= _loc20_)
                        {
                           _loc19_ = _loc6_[_loc20_ - 1] == 40 ? _loc18_[3] : (_loc6_[_loc20_ - 1] >= 30 ? _loc18_[3] : (_loc6_[_loc20_ - 1] >= 20 ? _loc18_[2] : (_loc6_[_loc20_ - 1] >= 10 ? _loc18_[1] : _loc18_[0])));
                        }
                        else
                        {
                           _loc19_ = _loc18_[0];
                        }
                     }
                     else
                     {
                        _loc19_ = _loc18_[0];
                     }
                     this._setsPropVec[_loc16_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc20_) + "\n    " + _loc14_[_loc16_].Description.replace("{0}",_loc19_);
                     this._setsPropVec[_loc16_].textColor = 10066329;
                  }
                  this._setsPropVec[_loc16_].y = this._thisHeight + 4;
                  this._thisHeight = this._setsPropVec[_loc16_].y + this._setsPropVec[_loc16_].textHeight;
               }
               else
               {
                  this._setsPropVec[_loc16_].visible = false;
               }
               _loc16_++;
            }
            this._validity.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
            this._validity.textColor = 16776960;
            this._validity.y = this._thisHeight + 10;
            this._thisHeight = this._validity.y + this._validity.textHeight;
         }
      }
      
      private function compareFun(param1:int, param2:int) : Number
      {
         if(param1 < param2)
         {
            return 1;
         }
         if(param1 > param2)
         {
            return -1;
         }
         return 0;
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = THISWIDTH;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
   }
}

