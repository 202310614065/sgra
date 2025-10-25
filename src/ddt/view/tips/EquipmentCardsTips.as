package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import cardSystem.view.LaterEquipmentGrooveView;
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
   
   public class EquipmentCardsTips extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 350;
      
      public static const CARDTYPE:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const CARDTYPE_VICE_MAIN:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
      
      private var _bg:ScaleBitmapImage;
      
      private var _cardName:FilterFrameText;
      
      private var _cardType:Bitmap;
      
      private var _cardTypeDetail:FilterFrameText;
      
      private var _cardLevel:Bitmap;
      
      private var _cardLevelDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _band:ScaleFrameImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _thisHeight:int;
      
      private var _cardGrooveInfo:GrooveInfo;
      
      private var _place:int;
      
      private var _Quality:FilterFrameText;
      
      private var _QualityDetail:FilterFrameText;
      
      private var _laterEquipmentView:LaterEquipmentGrooveView;
      
      private var _isGroove:Boolean;
      
      public function EquipmentCardsTips()
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
         while(_loc1_ < 6)
         {
            this._propVec[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
            _loc1_++;
         }
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._setsPropVec = new Vector.<FilterFrameText>(4);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._setsPropVec[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText1");
            _loc2_++;
         }
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._Quality = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.QualityTitle");
         this._QualityDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.Quality");
         this._laterEquipmentView = new LaterEquipmentGrooveView();
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._cardName);
         addChild(this._cardType);
         addChild(this._cardTypeDetail);
         addChild(this._rule1);
         addChild(this._band);
         addChild(this._Quality);
         addChild(this._QualityDetail);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
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
         addChild(this._laterEquipmentView);
         this._laterEquipmentView.x = 350;
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
            if(this._place == 2 || this._place == 4)
            {
               this._laterEquipmentView.x = -200;
            }
            else
            {
               this._laterEquipmentView.x = 350;
            }
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
                  this._laterEquipmentView.visible = true;
                  this.laterEquipment(this._cardInfo);
               }
            }
            else
            {
               this._isGroove = false;
               this._laterEquipmentView.visible = false;
            }
            this.upview();
         }
         else
         {
            this.visible = false;
            _tipData = null;
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
      
      private function laterEquipment(param1:CardInfo) : void
      {
         if(!this._laterEquipmentView)
         {
            this._laterEquipmentView = new LaterEquipmentGrooveView();
         }
         this._laterEquipmentView.tipData = param1;
      }
      
      private function showHeadPart() : void
      {
         this._cardName.text = this._cardInfo.templateInfo.Name;
         this._cardTypeDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.typeDetail",CARDTYPE[int(this._cardInfo.templateInfo.Property6)],CARDTYPE_VICE_MAIN[this._cardInfo.templateInfo.Property8]);
         this._Quality.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Quality");
         PositionUtils.setPos(this._Quality,"core.cardLevel.pos");
         this._QualityDetail.x = this._Quality.x + this._Quality.textWidth + 10;
         this._QualityDetail.y = this._Quality.y;
         this._band.setFrame(this._cardInfo.templateInfo.BindType == 0 ? 2 : 1);
         var _loc1_:int = this._cardInfo.Level == 30 ? 3 : (this._cardInfo.Level >= 20 ? 2 : (this._cardInfo.Level >= 10 ? 1 : 0));
         if(this._cardInfo.Level == 0)
         {
            this._cardName.textColor = 16777215;
         }
         else
         {
            this._cardName.textColor = QualityType.QUALITY_COLOR[_loc1_ + 1];
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
         this._band.x = 200;
         this._band.y = 98;
         this._rule1.x = this._cardName.x;
         this._rule1.y = this._Quality.y + this._Quality.textHeight + 10;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         var _loc1_:Array = null;
         var _loc3_:int = 0;
         _loc1_ = new Array();
         var _loc2_:CardTemplateInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(this._cardInfo.TemplateID),String(this._cardInfo.CardType));
         if(!this._isGroove)
         {
            if(Number(_loc2_.AttackRate) < 1 || int(_loc2_.AddAttack) + this._cardInfo.Attack != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack1") + (Number(_loc2_.AttackRate) < 1 ? Number(_loc2_.AttackRate) * 100 + "%" : "") + (int(_loc2_.AddAttack) != 0 ? (int(_loc2_.AddAttack) > 0 ? "+" + int(_loc2_.AddAttack) : int(_loc2_.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
            }
            if(Number(_loc2_.DefendRate) < 1 || int(_loc2_.AddDefend) + this._cardInfo.Defence != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence1") + (Number(_loc2_.DefendRate) < 1 ? Number(_loc2_.DefendRate) * 100 + "%" : "") + (int(_loc2_.AddDefend) != 0 ? (int(_loc2_.AddDefend) > 0 ? "+" + int(_loc2_.AddDefend) : int(_loc2_.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
            }
            if(Number(_loc2_.AgilityRate) < 1 || int(_loc2_.AddAgility) + this._cardInfo.Agility != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility1") + (Number(_loc2_.AgilityRate) < 1 ? Number(_loc2_.AgilityRate) * 100 + "%" : "") + (int(_loc2_.AddAgility) != 0 ? (int(_loc2_.AddAgility) > 0 ? "+" + int(_loc2_.AddAgility) : int(_loc2_.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
            }
            if(Number(_loc2_.LuckyRate) < 1 || int(_loc2_.AddLucky) + this._cardInfo.Luck != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck1") + (Number(_loc2_.LuckyRate) < 1 ? Number(_loc2_.LuckyRate) * 100 + "%" : "") + (int(_loc2_.AddLucky) != 0 ? (int(_loc2_.AddLucky) > 0 ? "+" + int(_loc2_.AddLucky) : int(_loc2_.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
            }
            if(Number(_loc2_.DamageRate) < 1 || int(_loc2_.AddDamage) + this._cardInfo.Damage != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage1") + (Number(_loc2_.DamageRate) < 1 ? Number(_loc2_.DamageRate) * 100 + "%" : "") + (int(_loc2_.AddDamage) != 0 ? (int(_loc2_.AddDamage) > 0 ? "+" + int(_loc2_.AddDamage) : int(_loc2_.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
            }
            if(Number(_loc2_.GuardRate) < 1 || int(_loc2_.AddGuard) + this._cardInfo.Guard != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard1") + (Number(_loc2_.GuardRate) < 1 ? Number(_loc2_.GuardRate) * 100 + "%" : "") + (int(_loc2_.AddGuard) != 0 ? (int(_loc2_.AddGuard) > 0 ? "+" + int(_loc2_.AddGuard) : int(_loc2_.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
            }
         }
         else
         {
            if(int(_loc2_.AddAttack) + this._cardInfo.Attack != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack1") + (int(_loc2_.AddAttack) != 0 ? (int(_loc2_.AddAttack) > 0 ? "+" + int(_loc2_.AddAttack) : int(_loc2_.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
            }
            if(int(_loc2_.AddDefend) + this._cardInfo.Defence != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence1") + (int(_loc2_.AddDefend) != 0 ? (int(_loc2_.AddDefend) > 0 ? "+" + int(_loc2_.AddDefend) : int(_loc2_.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
            }
            if(int(_loc2_.AddAgility) + this._cardInfo.Agility != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility1") + (int(_loc2_.AddAgility) != 0 ? (int(_loc2_.AddAgility) > 0 ? "+" + int(_loc2_.AddAgility) : int(_loc2_.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
            }
            if(int(_loc2_.AddLucky) + this._cardInfo.Luck != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck1") + (int(_loc2_.AddLucky) != 0 ? (int(_loc2_.AddLucky) > 0 ? "+" + int(_loc2_.AddLucky) : int(_loc2_.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
            }
            if(int(_loc2_.AddDamage) + this._cardInfo.Damage != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage1") + (int(_loc2_.AddDamage) != 0 ? (int(_loc2_.AddDamage) > 0 ? "+" + int(_loc2_.AddDamage) : int(_loc2_.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
            }
            if(int(_loc2_.AddGuard) + this._cardInfo.Guard != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard1") + (int(_loc2_.AddGuard) != 0 ? (int(_loc2_.AddGuard) > 0 ? "+" + int(_loc2_.AddGuard) : int(_loc2_.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
            }
         }
         _loc3_ = 0;
         while(_loc3_ < 6)
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
            _loc3_++;
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var _loc4_:CardInfo = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:DictionaryData = null;
         var _loc7_:CardInfo = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<SetsInfo> = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:GrooveInfo = null;
         var _loc17_:Array = null;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:PlayerInfo = PlayerManager.Instance.findPlayer(this._cardInfo.UserID);
         var _loc3_:DictionaryData = _loc2_.cardEquipDic;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7 && _loc4_.Count > -1)
            {
               if(!this._isGroove)
               {
                  _loc1_.push(_loc4_.Level);
               }
               else
               {
                  _loc16_ = CardControl.Instance.model.GrooveInfoVector[_loc4_.Place];
                  _loc1_.push(_loc16_.Level);
               }
            }
         }
         _loc1_.sort(this.compareFun);
         _loc5_ = new Vector.<int>();
         _loc6_ = _loc2_.cardBagDic;
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7)
            {
               if(!this._isGroove)
               {
                  _loc5_.push(_loc7_.Level);
               }
               else
               {
                  _loc5_.push(this._cardGrooveInfo.Level);
               }
            }
         }
         _loc5_.sort(this.compareFun);
         _loc8_ = 0;
         _loc9_ = CardControl.Instance.model.setsSortRuleVector;
         _loc10_ = int(_loc9_.length);
         _loc11_ = "";
         _loc12_ = 0;
         while(_loc12_ < _loc10_)
         {
            if(_loc9_[_loc12_].ID == this._cardInfo.templateInfo.Property7)
            {
               _loc8_ = int(_loc9_[_loc12_].cardIdVec.length);
               _loc11_ = _loc9_[_loc12_].name;
               break;
            }
            _loc12_++;
         }
         this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.setsName",_loc11_,_loc1_.length,_loc8_);
         if(_loc1_.length > 0)
         {
            this._setsName.textColor = 16777215;
         }
         else
         {
            this._setsName.textColor = 10066329;
         }
         this._setsName.y = this._thisHeight + 5;
         this._thisHeight = this._setsName.y + this._setsName.textHeight;
         var _loc13_:Vector.<SetsPropertyInfo> = CardControl.Instance.model.setsList[this._cardInfo.templateInfo.Property7];
         var _loc14_:int = int(_loc13_.length);
         _loc15_ = 0;
         while(_loc15_ < 4)
         {
            if(_loc15_ < _loc14_)
            {
               this._setsPropVec[_loc15_].visible = true;
               _loc17_ = _loc13_[_loc15_].value.split("|");
               _loc18_ = "";
               _loc19_ = _loc13_[_loc15_].condition;
               if(_loc1_.length >= _loc19_)
               {
                  if(_loc17_.length == 4)
                  {
                     _loc18_ = _loc1_[_loc19_ - 1] == 40 ? _loc17_[3] : (_loc1_[_loc19_ - 1] >= 30 ? _loc17_[3] : (_loc1_[_loc19_ - 1] >= 20 ? _loc17_[2] : (_loc1_[_loc19_ - 1] >= 10 ? _loc17_[1] : _loc17_[0])));
                  }
                  else
                  {
                     _loc18_ = _loc17_[0];
                  }
                  this._setsPropVec[_loc15_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc19_) + "\n    " + _loc13_[_loc15_].Description.replace("{0}",_loc18_);
                  this._setsPropVec[_loc15_].textColor = QualityType.QUALITY_COLOR[2];
               }
               else
               {
                  if(_loc17_.length == 4)
                  {
                     if(_loc5_.length >= _loc19_)
                     {
                        _loc18_ = _loc5_[_loc19_ - 1] == 40 ? _loc17_[3] : (_loc5_[_loc19_ - 1] >= 30 ? _loc17_[3] : (_loc5_[_loc19_ - 1] >= 20 ? _loc17_[2] : (_loc5_[_loc19_ - 1] >= 10 ? _loc17_[1] : _loc17_[0])));
                     }
                     else
                     {
                        _loc18_ = _loc17_[0];
                     }
                  }
                  else
                  {
                     _loc18_ = _loc17_[0];
                  }
                  this._setsPropVec[_loc15_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc19_) + "\n    " + _loc13_[_loc15_].Description.replace("{0}",_loc18_);
                  this._setsPropVec[_loc15_].textColor = 10066329;
               }
               this._setsPropVec[_loc15_].y = this._thisHeight + 4;
               this._thisHeight = this._setsPropVec[_loc15_].y + this._setsPropVec[_loc15_].textHeight;
            }
            else
            {
               this._setsPropVec[_loc15_].visible = false;
            }
            _loc15_++;
         }
         this._validity.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
         this._validity.textColor = 16776960;
         this._validity.y = this._thisHeight + 10;
         this._thisHeight = this._validity.y + this._validity.textHeight;
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

