package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class LaterEquipmentGrooveView extends Component
   {
      
      public static const THISWIDTH:int = 200;
      
      private var _bg:ScaleBitmapImage;
      
      private var _topName:FilterFrameText;
      
      private var _GrooveLevel:FilterFrameText;
      
      private var _GrooveLevelDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _cardGrooveInfo:GrooveInfo;
      
      private var _place:int;
      
      private var _thisHeight:int;
      
      private var _EpDetail:FilterFrameText;
      
      private var _Explain:FilterFrameText;
      
      public function LaterEquipmentGrooveView()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2.visible = false;
         this._topName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._topName.text = LanguageMgr.GetTranslation("tank.view.card.GrooveText");
         this._topName.textColor = 16777215;
         this._GrooveLevel = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.LevelTitle");
         this._GrooveLevel.text = LanguageMgr.GetTranslation("tank.view.card.GrooveText1");
         PositionUtils.setPos(this._GrooveLevel,"core.cardLevelBmpOne.pos1");
         this._GrooveLevelDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         PositionUtils.setPos(this._GrooveLevelDetail,"core.grooveLevel.pos1");
         this._EpDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExpPropTitle");
         PositionUtils.setPos(this._EpDetail,"core.cardTipEp.pos1");
         this._Explain = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExplainTitle");
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
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set place(param1:int) : void
      {
         this._place = param1;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(Boolean(param1))
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
               }
               this.showTip();
            }
            else
            {
               _tipData = null;
               visible = false;
            }
         }
      }
      
      public function showTip() : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._cardGrooveInfo == null)
         {
            return;
         }
         this.addChildren();
         this.showHeadPart();
         this.showMiddlePart();
         this.upBackground();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._bg);
         addChild(this._topName);
         addChild(this._GrooveLevel);
         addChild(this._GrooveLevelDetail);
         addChild(this._rule1);
         addChild(this._EpDetail);
         addChild(this._Explain);
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
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      private function showHeadPart() : void
      {
         var _loc2_:CardGrooveInfo = null;
         var _loc3_:CardGrooveInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
         this._GrooveLevelDetail.text = this._cardGrooveInfo.Level < 10 ? "0" + String(this._cardGrooveInfo.Level) : String(this._cardGrooveInfo.Level);
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
      
      private function showMiddlePart() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
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
            this._rule2.visible = false;
            this._rule2.x = this._propVec[_loc3_].x;
            this._rule2.y = this._propVec[_loc3_].y + this._propVec[_loc3_].textHeight + 12;
            this._thisHeight = this._rule2.y + this._rule2.height;
            _loc3_++;
         }
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
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._GrooveLevel = null;
         this._rule1 = null;
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
         this._validity = null;
         this._cardInfo = null;
         this._cardGrooveInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

