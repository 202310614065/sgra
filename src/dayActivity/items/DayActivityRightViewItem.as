package dayActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayRewaidData;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class DayActivityRightViewItem extends Sprite implements Disposeable
   {
      
      public var id:int;
      
      private var _back:ScaleBitmapImage;
      
      private var _txt1:FilterFrameText;
      
      private var _list:Vector.<BagCell>;
      
      private var _btn1:SimpleBitmapButton;
      
      private var _btn2:SimpleBitmapButton;
      
      private var _lightBitMap:MovieClip;
      
      public function DayActivityRightViewItem(param1:int)
      {
         super();
         this.initView(param1);
      }
      
      private function initView(param1:int) : void
      {
         this._list = new Vector.<BagCell>();
         this._back = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.right.itemBack");
         addChild(this._back);
         this._lightBitMap = ComponentFactory.Instance.creat("day.receiveLight");
         this._lightBitMap.x = 284;
         this._lightBitMap.y = 13;
         this._lightBitMap.visible = false;
         addChild(this._lightBitMap);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.right.itemTxt");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.dayActivity.needActivity",param1);
         addChild(this._txt1);
         this._btn1 = ComponentFactory.Instance.creatComponentByStylename("dayActivity.day.receiveBtn");
         this._btn1.addEventListener(MouseEvent.CLICK,this.clickHander);
         addChild(this._btn1);
         this._btn1.visible = false;
         this._btn2 = ComponentFactory.Instance.creatComponentByStylename("dayActivity.receiveOverBtn");
         this._btn2.visible = false;
         addChild(this._btn2);
         this.initGoods(DayActivityManager.Instance.reweadDataList,param1);
      }
      
      private function clickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGetGoods(this.id);
      }
      
      public function showBtn(param1:Boolean) : void
      {
         this._txt1.visible = false;
         this._btn2.visible = false;
         this._btn1.visible = false;
         this._lightBitMap.visible = false;
         if(param1)
         {
            this._btn2.visible = true;
            this._btn2.enable = false;
            this.applyGray(this);
         }
         else
         {
            this._btn1.visible = true;
            this._btn1.enable = true;
            this._lightBitMap.visible = true;
         }
      }
      
      private function applyGray(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         this.applyFilter(param1,_loc2_);
      }
      
      private function applyFilter(param1:DisplayObject, param2:Array) : void
      {
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(param2);
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_);
         param1.filters = _loc4_;
      }
      
      private function initGoods(param1:Vector.<DayRewaidData>, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:BagCell = null;
         var _loc7_:ScaleBitmapImage = null;
         var _loc8_:ItemTemplateInfo = null;
         if(!param1)
         {
            return;
         }
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            if(param2 == DayActivityManager.Instance.reweadDataList[_loc5_].RewardID)
            {
               _loc6_ = new BagCell(_loc5_);
               _loc7_ = ComponentFactory.Instance.creat("dayActivityView.right.goodsBack");
               _loc8_ = ItemManager.Instance.getTemplateById(DayActivityManager.Instance.reweadDataList[_loc5_].RewardItemID);
               _loc6_.info = _loc8_;
               addChild(_loc7_);
               addChild(_loc6_);
               _loc7_.x = (_loc7_.width + 4) * _loc4_ + 10;
               _loc7_.y = this._back.height / 2 - _loc7_.height / 2;
               _loc6_.x = _loc7_.x + 2.5;
               _loc6_.y = _loc7_.y + 2.5;
               _loc4_++;
               _loc6_.setCount(DayActivityManager.Instance.reweadDataList[_loc5_].RewardItemCount);
               this._list.push(_loc6_);
            }
            _loc5_++;
         }
      }
      
      public function dispose() : void
      {
         this._btn1.removeEventListener(MouseEvent.CLICK,this.clickHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._list = null;
      }
   }
}

