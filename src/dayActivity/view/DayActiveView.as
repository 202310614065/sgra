package dayActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayActiveData;
   import dayActivity.items.DayActivieListItem;
   import dayActivity.items.DayActivieTitle;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DayActiveView extends Sprite implements Disposeable
   {
      
      private var _title:DayActivieTitle;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _treeImage2:Scale9CornerImage;
      
      private var _itemList:Vector.<DayActivieListItem>;
      
      private var _bitMap:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _dataList:Vector.<DayActiveData>;
      
      private var _timer:Timer;
      
      private var _backGround:Bitmap;
      
      public function DayActiveView(param1:Vector.<DayActiveData>)
      {
         super();
         this._dataList = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc3_:int = 0;
         var _loc4_:DayActivieListItem = null;
         var _loc5_:String = null;
         this._timer = new Timer(10000);
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         var _loc1_:int = int(this._dataList.length);
         this._itemList = new Vector.<DayActivieListItem>();
         this._backGround = ComponentFactory.Instance.creat("day.actiity.groundBack");
         this._backGround.x = 22;
         this._backGround.y = 82;
         addChild(this._backGround);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.luckpaihangBox");
         this._list.spacing = 1;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.left.scrollpanel");
         this._panel.x = 28;
         this._panel.y = 128;
         this._panel.width = 713;
         this._panel.height = 325;
         this._panel.setView(this._list);
         addChild(this._panel);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc4_ = new DayActivieListItem(_loc2_);
            _loc4_.setData(this._dataList[_loc2_]);
            _loc4_.seleLigthFun = this.seletLight;
            _loc5_ = this._dataList[_loc2_].ActiveTime.slice(0,7);
            if(_loc5_ == LanguageMgr.GetTranslation("ddt.dayActivity.allDay"))
            {
               _loc4_.initTxt(false);
            }
            else
            {
               _loc4_.initTxt(true);
            }
            _loc4_.y = (_loc4_.height + 1) * _loc2_;
            this._list.addChild(_loc4_);
            this._itemList.push(_loc4_);
            _loc2_++;
         }
         this._txt = ComponentFactory.Instance.creatComponentByStylename("day.activieView.txt");
         addChild(this._txt);
         DayActivityManager.Instance.initActivityStata(this._itemList);
         this._itemList = this.updataList(this._itemList);
         _loc3_ = 0;
         while(_loc3_ < this._itemList.length)
         {
            this._itemList[_loc3_].y = (this._itemList[_loc3_].height + 1) * _loc3_;
            this._itemList[_loc3_].setBg(_loc3_);
            this._list.addChild(this._itemList[_loc3_]);
            _loc3_++;
         }
         this._txt.text = LanguageMgr.GetTranslation("ddt.dayActivity.leavlOver20") + this._itemList[0].data.LevelLimit;
         this.updata(DayActivityManager.Instance.sessionArr);
         this._itemList[0].setLigthVisible(true);
         this._panel.invalidateViewport();
      }
      
      private function seletLight(param1:DayActivieListItem, param2:int) : void
      {
         var _loc3_:DayActivieListItem = null;
         for each(_loc3_ in this._itemList)
         {
            if(_loc3_ == param1)
            {
               _loc3_.setLigthVisible(true);
            }
            else
            {
               _loc3_.setLigthVisible(false);
            }
         }
         this._txt.text = LanguageMgr.GetTranslation("ddt.dayActivity.leavlOver20") + param2;
      }
      
      private function updataList(param1:Vector.<DayActivieListItem>) : Vector.<DayActivieListItem>
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Vector.<DayActivieListItem> = new Vector.<DayActivieListItem>();
         var _loc4_:Vector.<DayActivieListItem> = new Vector.<DayActivieListItem>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if(param1[_loc5_].getTxt5str() == LanguageMgr.GetTranslation("ddt.dayActivity.close"))
            {
               _loc4_.push(param1[_loc5_]);
            }
            else
            {
               _loc3_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc3_.push(_loc4_[_loc6_]);
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function updata(param1:Array) : void
      {
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < this._itemList.length)
            {
               if(Boolean(param1[_loc3_]))
               {
                  if(param1[_loc3_][0] == this._itemList[_loc4_].id)
                  {
                     this._itemList[_loc4_].updataCount(param1[_loc3_][1]);
                     break;
                  }
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      protected function timerHander(param1:TimerEvent) : void
      {
         DayActivityManager.Instance.initActivityStata(this._itemList);
         this.updata(DayActivityManager.Instance.sessionArr);
         this._itemList = this.updataList(this._itemList);
         var _loc2_:int = 0;
         while(_loc2_ < this._itemList.length)
         {
            this._itemList[_loc2_].y = (this._itemList[_loc2_].height + 1) * _loc2_;
            this._itemList[_loc2_].setBg(_loc2_);
            this._list.addChild(this._itemList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function upDataList() : void
      {
         this.clearList();
      }
      
      private function clearList() : void
      {
         while(Boolean(this._list) && Boolean(this._list.numChildren))
         {
            ObjectUtils.disposeObject(this._list.getChildAt(0));
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
         }
         this._timer = null;
         this.clearList();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._list = null;
         this._panel = null;
         this._itemList = null;
      }
   }
}

