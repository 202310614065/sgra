package calendar.view
{
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mainbutton.MainButtnController;
   import road7th.utils.MovieClipWrapper;
   
   public class DayCell extends Sprite implements Disposeable
   {
      
      private var _dayField:FilterFrameText;
      
      private var _date:Date;
      
      private var _model:CalendarModel;
      
      private var _back:DisplayObject;
      
      private var _signShape:DisplayObject;
      
      private var _tweenMax:TweenMax;
      
      private var _signBitmap:Bitmap;
      
      private var isTrue:Boolean;
      
      private var _signBuyFrame:SignBuyFrame;
      
      private var _signed:Boolean;
      
      public function DayCell(param1:Date, param2:CalendarModel)
      {
         super();
         this._model = param2;
         this.configUI();
         this.addEvent();
         buttonMode = true;
         mouseChildren = false;
         this.date = param1;
         this.signed = this._model.hasSigned(this._date);
      }
      
      public function get signed() : Boolean
      {
         return this._signed;
      }
      
      public function set signed(param1:Boolean) : void
      {
         if(this._signed == param1)
         {
            return;
         }
         this._signed = param1;
         if(this._signed && this._signShape == null)
         {
            this._signShape = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.SignShape");
            addChild(this._signShape);
            if(Boolean(this._tweenMax))
            {
               this._tweenMax.pause();
            }
            this._back.filters = null;
         }
         else if(!this._signed)
         {
            if(Boolean(this._tweenMax))
            {
               this._tweenMax.pause();
            }
            this._back.filters = null;
            ObjectUtils.disposeObject(this._signShape);
            this._signShape = null;
         }
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function set date(param1:Date) : void
      {
         if(this._date == param1)
         {
            return;
         }
         this._date = param1;
         this._dayField.text = this._date.date.toString();
         this.isTrue = false;
         if(Boolean(this._signBitmap))
         {
            ObjectUtils.disposeObject(this._signBitmap);
            this._signBitmap = null;
         }
         if(this._date.month == this._model.today.month)
         {
            if(!this._model.hasSigned(this._date) && this._date.date == this._model.today.date)
            {
               DisplayUtils.setFrame(this._back,1);
            }
            else if(!this._model.hasSigned(this._date) && this._date.date <= this._model.today.date)
            {
               this.isTrue = true;
               this._signBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.SignNew");
               addChild(this._signBitmap);
               DisplayUtils.setFrame(this._back,2);
            }
            else
            {
               DisplayUtils.setFrame(this._back,1);
            }
            if(this._date.day == 0)
            {
               this._dayField.setFrame(3);
            }
            else if(this._date.day == 6)
            {
               this._dayField.setFrame(2);
            }
            else
            {
               this._dayField.setFrame(1);
            }
         }
         else
         {
            DisplayUtils.setFrame(this._back,1);
            if(this._date.day == 0)
            {
               this._dayField.setFrame(6);
            }
            else if(this._date.day == 6)
            {
               this._dayField.setFrame(5);
            }
            else
            {
               this._dayField.setFrame(4);
            }
         }
         var _loc2_:Date = this._model.today;
         if(this._date.fullYear == _loc2_.fullYear && this._date.month == _loc2_.month && this._date.date == _loc2_.date && !this._model.hasSigned(this._date))
         {
            this._tweenMax = TweenMax.to(this._back,0.4,{
               "repeat":-1,
               "yoyo":true,
               "glowFilter":{
                  "color":13959168,
                  "alpha":1,
                  "blurX":4,
                  "blurY":4,
                  "strength":3
               }
            });
            this._tweenMax.play();
         }
         else if(Boolean(this._tweenMax))
         {
            this._tweenMax.pause();
            this._back.filters = null;
            ObjectUtils.disposeObject(this._signShape);
            this._signShape = null;
         }
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.Calendar.DayCellBack");
         DisplayUtils.setFrame(this._back,1);
         addChild(this._back);
         this._dayField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.CalendarGrid.DayField");
         addChild(this._dayField);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function __click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(CalendarManager.getInstance().sign(this._date))
         {
            this.signMovie();
         }
         if(CalendarManager.getInstance().times >= 5 && this.isTrue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtcalendar.DayCell.timesIsNo"));
            return;
         }
         if(this.isTrue && !CalendarManager.getInstance().hasSignedIsTrue(this._date))
         {
            this._signBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.DayCell.SignBuyFrame");
            this._signBuyFrame.date = this._date;
            this._signBuyFrame.dayCellClass = this;
            LayerManager.Instance.addToLayer(this._signBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      public function signMovie() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClipWrapper = null;
         if(Boolean(this._signBitmap))
         {
            ObjectUtils.disposeObject(this._signBitmap);
            this._signBitmap = null;
         }
         DisplayUtils.setFrame(this._back,1);
         if(this._date.day == 0)
         {
            this._dayField.setFrame(6);
         }
         else if(this._date.day == 6)
         {
            this._dayField.setFrame(5);
         }
         else
         {
            this._dayField.setFrame(4);
         }
         if(Boolean(this._tweenMax))
         {
            this._tweenMax.pause();
            this._back.filters = null;
         }
         _loc1_ = ClassUtils.CreatInstance("asset.ddtcalendar.Grid.SignAnimation");
         _loc1_.x = 2;
         if(Boolean(_loc1_))
         {
            _loc2_ = new MovieClipWrapper(_loc1_,true,true);
            _loc2_.addEventListener(Event.COMPLETE,this.__signAnimationComplete);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signed"));
            addChild(_loc2_.movie);
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signed"));
         PlayerManager.Instance.Self.Sign = true;
         MainButtnController.instance.dispatchEvent(new Event(MainButtnController.CLOSESIGN));
      }
      
      private function __signAnimationComplete(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.COMPLETE,this.__signAnimationComplete);
         if(Boolean(parent))
         {
            this.signed = true;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.isTrue = false;
         TweenMax.killChildTweensOf(this);
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._dayField);
         this._dayField = null;
         ObjectUtils.disposeObject(this._signShape);
         this._signShape = null;
         if(Boolean(this._signBitmap))
         {
            ObjectUtils.disposeObject(this._signBitmap);
            this._signBitmap = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

