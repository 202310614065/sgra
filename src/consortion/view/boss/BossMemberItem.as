package consortion.view.boss
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaBossDataVo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class BossMemberItem extends Sprite implements Disposeable
   {
      
      private var _rankTxt:FilterFrameText;
      
      private var _rankIconList:Vector.<Bitmap>;
      
      private var _nameTxt:FilterFrameText;
      
      private var _nameFirstTxt:GradientText;
      
      private var _damageTxt:FilterFrameText;
      
      private var _contributionTxt:FilterFrameText;
      
      private var _honorTxt:FilterFrameText;
      
      public function BossMemberItem()
      {
         var _loc3_:Bitmap = null;
         super();
         this._rankIconList = new Vector.<Bitmap>(3);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.cellRankth" + (_loc1_ + 1));
            addChild(_loc3_);
            this._rankIconList[_loc1_] = _loc3_;
            _loc1_++;
         }
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.rankTxt");
         addChild(this._rankTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.nameTxt");
         addChild(this._nameTxt);
         this._nameFirstTxt = VipController.instance.getVipNameTxt(105,1);
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.align = "center";
         _loc2_.bold = true;
         this._nameFirstTxt.textField.defaultTextFormat = _loc2_;
         this._nameFirstTxt.textSize = 14;
         this._nameFirstTxt.x = this._nameTxt.x + 2;
         this._nameFirstTxt.y = this._nameTxt.y;
         addChild(this._nameFirstTxt);
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.damageTxt");
         addChild(this._damageTxt);
         this._contributionTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.contributionTxt");
         addChild(this._contributionTxt);
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.cell.honorTxt");
         addChild(this._honorTxt);
      }
      
      public function set info(param1:ConsortiaBossDataVo) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:int = param1.rank;
         this.setRankIconVisible(_loc2_);
         if(_loc2_ >= 1 && _loc2_ <= 3)
         {
            this._rankTxt.visible = false;
         }
         else
         {
            this._rankTxt.text = _loc2_ + "th";
            this._rankTxt.visible = true;
         }
         if(_loc2_ == 1)
         {
            this._nameTxt.visible = false;
            this._nameFirstTxt.text = param1.name;
            this._nameFirstTxt.visible = true;
         }
         else
         {
            this._nameFirstTxt.visible = false;
            this._nameTxt.text = param1.name;
            this._nameTxt.visible = true;
         }
         this._damageTxt.text = param1.damage.toString();
         this._contributionTxt.text = param1.contribution.toString();
         this._honorTxt.text = param1.honor.toString();
      }
      
      private function setRankIconVisible(param1:int) : void
      {
         var _loc2_:int = int(this._rankIconList.length);
         var _loc3_:int = 1;
         while(_loc3_ <= _loc2_)
         {
            if(param1 == _loc3_)
            {
               this._rankIconList[_loc3_ - 1].visible = true;
            }
            else
            {
               this._rankIconList[_loc3_ - 1].visible = false;
            }
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._rankTxt = null;
         this._rankIconList = null;
         this._nameTxt = null;
         this._nameFirstTxt = null;
         this._damageTxt = null;
         this._contributionTxt = null;
         this._honorTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

