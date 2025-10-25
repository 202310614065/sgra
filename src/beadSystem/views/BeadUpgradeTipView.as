package beadSystem.views
{
   import beadSystem.model.BeadInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import ddt.view.SimpleItem;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import road7th.utils.StringHelper;
   
   public class BeadUpgradeTipView extends Component
   {
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _expItem:SimpleItem;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      private var _remainTimeTxt:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 240;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _tipbackgound:MutipleImage;
      
      private var _rightArrows:Bitmap;
      
      private var _exp:int;
      
      private var _UpExp:int;
      
      public function BeadUpgradeTipView()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         this._rightArrows = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
         this._tipbackgound = ComponentFactory.Instance.creat("ddtstore.strengthTips.strengthenImageBG");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._expItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.EXPItem");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(Boolean(param1))
         {
            if(param1 is GoodTipInfo)
            {
               _tipData = param1 as GoodTipInfo;
               this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
         }
      }
      
      public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         this._displayIdx = 0;
         this._displayList = new Vector.<DisplayObject>();
         this._lineIdx = 0;
         this._isReAdd = false;
         this._maxWidth = 0;
         this._info = param1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.clear();
         this.createItemName();
         this.createCategoryItem();
         this.careteEXP();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.addChildren();
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      override protected function addChildren() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:int = int(this._displayList.length);
         var _loc2_:Point = new Point(4,4);
         var _loc3_:int = 6;
         var _loc5_:int = this._maxWidth;
         var _loc6_:int = 0;
         while(_loc6_ < _loc1_)
         {
            _loc4_ = this._displayList[_loc6_] as DisplayObject;
            if(this._lines.indexOf(_loc4_) < 0 && _loc4_ != this._descriptionTxt)
            {
               _loc5_ = Math.max(_loc4_.width,_loc5_);
            }
            PositionUtils.setPos(_loc4_,_loc2_);
            addChild(_loc4_);
            _loc2_.y = _loc4_.y + _loc4_.height + _loc3_;
            _loc6_++;
         }
         this._maxWidth = Math.max(this._minWidth,_loc5_);
         this._maxWidth -= 20;
         if(this._descriptionTxt.width != this._maxWidth)
         {
            this._descriptionTxt.width = this._maxWidth;
            this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
            this.addChildren();
            return;
         }
         if(!this._isReAdd)
         {
            _loc6_ = 0;
            while(_loc6_ < this._lines.length)
            {
               this._lines[_loc6_].width = this._maxWidth;
               if(_loc6_ + 1 < this._lines.length && this._lines[_loc6_ + 1].parent != null && Math.abs(this._lines[_loc6_ + 1].y - this._lines[_loc6_].y) <= 10)
               {
                  this._displayList.splice(this._displayList.indexOf(this._lines[_loc6_ + 1]),1);
                  this._lines[_loc6_ + 1].parent.removeChild(this._lines[_loc6_ + 1]);
                  this._isReAdd = true;
               }
               _loc6_++;
            }
            if(this._isReAdd)
            {
               this.addChildren();
               return;
            }
         }
         if(Boolean(this._rightArrows))
         {
            addChildAt(this._rightArrows,0);
         }
         if(_loc1_ > 0)
         {
            this._tipbackgound.y = -5;
            _width = this._tipbackgound.width = this._maxWidth + 15;
            _height = this._tipbackgound.height = _loc4_.y + _loc4_.height + 18;
         }
         if(Boolean(this._tipbackgound))
         {
            addChildAt(this._tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         this._rightArrows.x = 5 - this._rightArrows.width;
         this._rightArrows.y = (this.height - this._rightArrows.height) / 2;
      }
      
      private function createItemName() : void
      {
         this._nameTxt.text = _tipData.beadName;
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         this._displayList[this._displayIdx++] = this._nameTxt;
      }
      
      private function careteEXP() : void
      {
         var _loc1_:FilterFrameText = this._expItem.foreItems[0] as FilterFrameText;
         if(EquipType.isBead(int(this._info.Property1)))
         {
            this._exp = ServerConfigManager.instance.getBeadUpgradeExp()[(this._info as InventoryItemInfo).Hole1];
            this._UpExp = ServerConfigManager.instance.getBeadUpgradeExp()[(this._info as InventoryItemInfo).Hole1 + 1];
            _loc1_.text = this._exp + "/" + this._UpExp;
            this._displayList[this._displayIdx++] = this._expItem;
         }
      }
      
      private function createCategoryItem() : void
      {
         var _loc1_:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         switch(this._info.Property2)
         {
            case "1":
               _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.atacckt");
               break;
            case "2":
               _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.defent");
               break;
            case "3":
               _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.attribute");
         }
         _loc1_.textColor = 65406;
         this._displayList[this._displayIdx++] = this._typeItem;
      }
      
      private function setPurpleHtmlTxt(param1:String, param2:int, param3:String) : String
      {
         return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.setPurpleHtmlTxt",param1,param2,param3);
      }
      
      private function createDescript() : void
      {
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.TemplateID);
         if(this._info.Description == "")
         {
            return;
         }
         this._info.Description = _loc1_.Description;
         var _loc2_:InventoryItemInfo = this._info as InventoryItemInfo;
         var _loc3_:BeadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(this._info.TemplateID);
         if(_loc3_.Attribute1 == "0" && _loc3_.Attribute2 == "0")
         {
            this._descriptionTxt.text = StringHelper.format(this._info.Description);
         }
         else if(_loc3_.Attribute1 == "0" && _loc3_.Attribute2 != "0")
         {
            if(_loc3_.Att2.length > 1)
            {
               if(Boolean(_loc2_) && _loc2_.Hole1 > _loc3_.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att2[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att2[0]);
               }
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Attribute2);
            }
         }
         else if(_loc3_.Attribute1 != "0" && _loc3_.Attribute2 == "0")
         {
            if(_loc3_.Att1.length > 1)
            {
               if(Boolean(_loc2_) && _loc2_.Hole1 > _loc3_.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[0]);
               }
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Attribute1);
            }
         }
         else if(_loc3_.Attribute1 != "0" && _loc3_.Attribute2 != "0")
         {
            if(_loc3_.Att1.length > 1 && _loc3_.Att2.length == 1)
            {
               if(Boolean(_loc2_) && _loc2_.Hole1 > _loc3_.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[1],_loc3_.Attribute2);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[0],_loc3_.Attribute2);
               }
            }
            else if(_loc3_.Att1.length == 1 && _loc3_.Att2.length > 1)
            {
               if(Boolean(_loc2_) && _loc2_.Hole1 > _loc3_.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Attribute1,_loc3_.Att2[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Attribute1,_loc3_.Att2[0]);
               }
            }
            else if(Boolean(_loc2_) && _loc2_.Hole1 > _loc3_.BaseLevel)
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[1],_loc3_.Att2[1]);
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,_loc3_.Att1[0],_loc3_.Att2[0]);
            }
         }
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         this._displayList[this._displayIdx++] = this._descriptionTxt;
      }
      
      private function ShowBound(param1:InventoryItemInfo) : Boolean
      {
         return param1.CategoryID != EquipType.SEED && param1.CategoryID != EquipType.MANURE && param1.CategoryID != EquipType.VEGETABLE;
      }
      
      private function createBindType() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && this.ShowBound(_loc1_))
         {
            this._boundImage.setFrame(_loc1_.IsBinds ? int(GoodTip.BOUND) : int(GoodTip.UNBOUND));
            PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
            addChild(this._boundImage);
            if(!_loc1_.IsBinds)
            {
               if(_loc1_.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 4)
               {
                  if(Boolean(this._boundImage.parent))
                  {
                     this._boundImage.parent.removeChild(this._boundImage);
                  }
               }
            }
         }
         else if(Boolean(this._boundImage.parent))
         {
            this._boundImage.parent.removeChild(this._boundImage);
         }
      }
      
      private function createRemainTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getRemainDate();
            _loc4_ = _loc2_.getColorValidDate();
            _loc5_ = _loc2_.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
            if(_loc4_ > 0 && _loc4_ != int.MAX_VALUE)
            {
               if(_loc4_ >= 1)
               {
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_loc4_) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._remainTimeTxt;
               }
               else
               {
                  _loc6_ = Math.floor(_loc4_ * 24);
                  if(_loc6_ < 1)
                  {
                     _loc6_ = 1;
                  }
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc6_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._remainTimeTxt;
               }
            }
            if(_loc3_ == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = GoodTip.ITEM_ETERNAL_COLOR;
               this._displayList[this._displayIdx++] = this._remainTimeTxt;
            }
            else if(_loc3_ > 0)
            {
               if(_loc3_ >= 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc1_ + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._remainTimeTxt;
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? 1 : _loc1_;
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc1_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  this._displayList[this._displayIdx++] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(_loc3_))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
               this._displayList[this._displayIdx++] = this._remainTimeTxt;
            }
         }
      }
      
      private function seperateLine() : void
      {
         var _loc1_:Image = null;
         ++this._lineIdx;
         if(this._lines.length < this._lineIdx)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._lines.push(_loc1_);
         }
         this._displayList[this._displayIdx++] = this._lines[this._lineIdx - 1];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._rightArrows))
         {
            ObjectUtils.disposeObject(this._rightArrows);
         }
         this._rightArrows = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(this._strengthenLevelImage))
         {
            ObjectUtils.disposeObject(this._strengthenLevelImage);
         }
         this._strengthenLevelImage = null;
         if(Boolean(this._fusionLevelImage))
         {
            ObjectUtils.disposeObject(this._fusionLevelImage);
         }
         this._fusionLevelImage = null;
         if(Boolean(this._boundImage))
         {
            ObjectUtils.disposeObject(this._boundImage);
         }
         this._boundImage = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._qualityItem))
         {
            ObjectUtils.disposeObject(this._qualityItem);
         }
         this._qualityItem = null;
         if(Boolean(this._typeItem))
         {
            ObjectUtils.disposeObject(this._typeItem);
         }
         this._typeItem = null;
         if(Boolean(this._descriptionTxt))
         {
            ObjectUtils.disposeObject(this._descriptionTxt);
         }
         this._descriptionTxt = null;
         if(Boolean(this._bindTypeTxt))
         {
            ObjectUtils.disposeObject(this._bindTypeTxt);
         }
         this._bindTypeTxt = null;
         if(Boolean(this._remainTimeTxt))
         {
            ObjectUtils.disposeObject(this._remainTimeTxt);
         }
         this._remainTimeTxt = null;
         if(Boolean(this._remainTimeBg))
         {
            ObjectUtils.disposeObject(this._remainTimeBg);
         }
         this._remainTimeBg = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

