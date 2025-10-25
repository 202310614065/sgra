package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActivityCell extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _icon:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _info:ActiveEventsInfo;
      
      private var _quanMC:MovieClip;
      
      private var _selected:Boolean = false;
      
      public function ActivityCell(param1:ActiveEventsInfo)
      {
         super();
         this._info = param1;
         buttonMode = true;
         this.configUI();
         this.addEvent();
      }
      
      public function get info() : ActiveEventsInfo
      {
         return this._info;
      }
      
      private function addEvent() : void
      {
      }
      
      private function __detailClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().setState(this._info);
      }
      
      private function removeEvent() : void
      {
      }
      
      private function configUI() : void
      {
         var _loc1_:int = 0;
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
         DisplayUtils.setFrame(this._back,this._selected ? 2 : 1);
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleText");
         this._titleField.htmlText = "<b>·</b> " + this._info.Title;
         if(this._titleField.textWidth > 90)
         {
            _loc1_ = this._titleField.getCharIndexAtPoint(this._titleField.x + 86,this._titleField.y + 2);
            if(_loc1_ != -1)
            {
               this._titleField.htmlText = "<b>·</b> " + this._info.Title.substring(0,_loc1_) + "...";
            }
         }
         addChild(this._titleField);
         if(!this._quanMC)
         {
            this._quanMC = ClassUtils.CreatInstance("asset.ddtActivity.MC");
            this._quanMC.mouseChildren = false;
            this._quanMC.mouseEnabled = false;
            this._quanMC.gotoAndPlay(1);
            this._quanMC.x = -5;
         }
         if(this._info.Type == 2)
         {
            this._quanMC.visible = true;
         }
         else
         {
            this._quanMC.visible = false;
         }
         this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleIcon");
         DisplayUtils.setFrame(this._icon,this.getActivityDispType(this._info.IconID));
         addChild(this._icon);
         addChild(this._quanMC);
      }
      
      private function getActivityDispType(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = 1;
               break;
            case 2:
               _loc2_ = 2;
               break;
            case 3:
               _loc2_ = 3;
               break;
            case 4:
               _loc2_ = 4;
               break;
            case 5:
               _loc2_ = 5;
               break;
            case 6:
               _loc2_ = 6;
               break;
            default:
               _loc2_ = 5;
         }
         return _loc2_;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         DisplayUtils.setFrame(this._back,this._selected ? 2 : 1);
         DisplayUtils.setFrame(this._titleField,this._selected ? 2 : 1);
      }
      
      public function openCell() : void
      {
         this.__detailClick(null);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(Boolean(this._quanMC))
         {
            ObjectUtils.disposeObject(this._quanMC);
         }
         this._quanMC = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

