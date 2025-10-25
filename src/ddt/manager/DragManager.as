package ddt.manager
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DragManager extends EventDispatcher
   {
      
      private static var _isDraging:Boolean;
      
      private static var _proxy:Sprite;
      
      private static var _dragEffect:DragEffect;
      
      private static var _source:IDragable;
      
      private static var _throughAll:Boolean;
      
      private static var _wheelFun:Function;
      
      private static var _passSelf:Boolean;
      
      private static var _isUpDrag:Boolean;
      
      private static var _changCardStateFun:Function;
      
      private static var _responseRectangle:DisplayObject;
      
      private static var _responseRange:int;
      
      private static var _isContinue:Boolean;
      
      public static const DRAG_IN_RANGE_TOP:String = "dragInRangeTop";
      
      public static const DRAG_IN_RANGE_BUTTOM:String = "dragOutRangeButtom";
      
      public static const DRAG_IN_HOT:String = "dragInHot";
      
      public function DragManager()
      {
         super();
      }
      
      public static function get proxy() : Sprite
      {
         return _proxy;
      }
      
      public static function get isDraging() : Boolean
      {
         return _isDraging;
      }
      
      public static function startDrag(param1:IDragable, param2:Object, param3:DisplayObject, param4:int, param5:int, param6:String = "none", param7:Boolean = true, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:DisplayObject = null, param13:int = 0, param14:Boolean = false) : Boolean
      {
         if(!_isDraging && Boolean(param3))
         {
            _responseRectangle = param12;
            _responseRange = param13;
            _isContinue = param14;
            _passSelf = param10;
            _isUpDrag = param11;
            _isDraging = true;
            _proxy = new Sprite();
            param3.x = -param3.width / 2;
            param3.y = -param3.height / 2;
            _proxy.addChild(param3);
            InGameCursor.hide();
            _proxy.x = param4;
            _proxy.y = param5;
            _proxy.mouseEnabled = param7;
            _proxy.mouseChildren = false;
            _proxy.startDrag();
            _throughAll = param9;
            _dragEffect = new DragEffect(param1.getSource(),param2,param6);
            _source = param1;
            LayerManager.Instance.addToLayer(_proxy,LayerManager.STAGE_DYANMIC_LAYER);
            if(param7)
            {
               _proxy.addEventListener(MouseEvent.CLICK,__stopDrag);
               _proxy.addEventListener(MouseEvent.MOUSE_UP,__upDrag);
               _proxy.addEventListener(MouseEvent.MOUSE_WHEEL,__dispatchWheel);
            }
            else
            {
               if(!param8)
               {
                  _proxy.stage.addEventListener(MouseEvent.MOUSE_DOWN,__stageMouseDown,true);
               }
               _proxy.stage.addEventListener(MouseEvent.CLICK,__stopDrag,true);
               _proxy.stage.addEventListener(MouseEvent.MOUSE_UP,__upDrag,true);
               _proxy.parent.mouseEnabled = false;
            }
            if(_responseRectangle != null && _responseRange != 0)
            {
               _proxy.addEventListener(Event.ENTER_FRAME,__checkResponse);
            }
            _proxy.addEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
            return true;
         }
         return false;
      }
      
      protected static function __checkResponse(param1:Event) : void
      {
         var _loc2_:Boolean = _proxy.stage.mouseY > _responseRectangle.y && _proxy.stage.mouseY < _responseRectangle.y + _responseRange;
         var _loc3_:Boolean = _proxy.stage.mouseY > _responseRectangle.y + _responseRectangle.height - _responseRange && _proxy.stage.mouseY < _responseRectangle.y + _responseRectangle.height;
         var _loc4_:Boolean = _proxy.stage.mouseX > _responseRectangle.x && _proxy.stage.mouseX < _responseRectangle.x + _responseRectangle.width;
         if(_loc2_ && _loc4_)
         {
            _responseRectangle.dispatchEvent(new Event(DRAG_IN_RANGE_TOP));
         }
         else if(_loc3_ && _loc4_)
         {
            _responseRectangle.dispatchEvent(new Event(DRAG_IN_RANGE_BUTTOM));
         }
      }
      
      public static function ListenWheelEvent(param1:Function) : void
      {
         _wheelFun = param1;
      }
      
      public static function removeListenWheelEvent() : void
      {
         _wheelFun = null;
         _changCardStateFun = null;
      }
      
      private static function __dispatchWheel(param1:MouseEvent) : void
      {
         if(_passSelf && _wheelFun != null)
         {
            _wheelFun(param1);
         }
      }
      
      public static function changeCardState(param1:Function) : void
      {
         _changCardStateFun = param1;
      }
      
      private static function __stageMouseDown(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         if(Boolean(_proxy.stage))
         {
            _proxy.stage.removeEventListener(MouseEvent.MOUSE_DOWN,__stageMouseDown,true);
         }
      }
      
      private static function __removeFromStage(param1:Event) : void
      {
         _proxy.removeEventListener(MouseEvent.CLICK,__stopDrag);
         _proxy.removeEventListener(MouseEvent.MOUSE_UP,__upDrag);
         _proxy.removeEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
         _proxy.stage.removeEventListener(MouseEvent.MOUSE_DOWN,__stageMouseDown,true);
         _proxy.removeEventListener(MouseEvent.MOUSE_WHEEL,__dispatchWheel);
         if(_responseRectangle != null && _responseRange != 0)
         {
            _proxy.removeEventListener(Event.ENTER_FRAME,__checkResponse);
         }
         InGameCursor.show();
         acceptDrag(null);
      }
      
      public static function __upDrag(param1:MouseEvent) : void
      {
         if(_isUpDrag)
         {
            __stopDrag(param1);
         }
      }
      
      private static function __stopDrag(param1:MouseEvent) : void
      {
         var list:Array = null;
         var _stage:Stage = null;
         var ex:Boolean = false;
         var isDragdrop:Boolean = false;
         var ds:DisplayObject = null;
         var temp:DisplayObject = null;
         var flag:Boolean = false;
         var ad:IAcceptDrag = null;
         var evt:MouseEvent = param1;
         try
         {
            if(_passSelf && _changCardStateFun != null)
            {
               _changCardStateFun();
            }
            list = _proxy.stage.getObjectsUnderPoint(new Point(evt.stageX,evt.stageY));
            _stage = _proxy.stage;
            ex = true;
            InGameCursor.show();
            if(Boolean(_stage))
            {
               _stage.removeEventListener(MouseEvent.CLICK,__stopDrag);
               _stage.removeEventListener(MouseEvent.MOUSE_UP,__upDrag);
            }
            _proxy.removeEventListener(MouseEvent.CLICK,__stopDrag);
            _proxy.removeEventListener(MouseEvent.MOUSE_UP,__upDrag);
            _proxy.removeEventListener(MouseEvent.MOUSE_WHEEL,__dispatchWheel);
            _proxy.removeEventListener(Event.REMOVED_FROM_STAGE,__removeFromStage);
            if(_responseRectangle != null && _responseRange != 0)
            {
               _proxy.removeEventListener(Event.ENTER_FRAME,__checkResponse);
            }
            evt.stopImmediatePropagation();
            if(Boolean(_proxy.parent))
            {
               _proxy.parent.removeChild(_proxy);
            }
            list = list.reverse();
            isDragdrop = false;
            for each(ds in list)
            {
               if(!_proxy.contains(ds))
               {
                  temp = ds;
                  flag = false;
                  while(Boolean(temp) && temp != _stage)
                  {
                     if(!_passSelf && temp == _source)
                     {
                        _dragEffect.action = DragEffect.NONE;
                        flag = true;
                        break;
                     }
                     ad = temp as IAcceptDrag;
                     if(Boolean(ad))
                     {
                        if(ex)
                        {
                           ad.dragDrop(_dragEffect);
                           isDragdrop = true;
                           if(_throughAll == false)
                           {
                              ex = false;
                           }
                        }
                        if(!_isDraging)
                        {
                           flag = true;
                           break;
                        }
                     }
                     temp = temp.parent;
                  }
                  if(flag)
                  {
                     break;
                  }
               }
            }
            if(!_isContinue || !isDragdrop)
            {
               ObjectUtils.disposeAllChildren(_proxy);
            }
         }
         catch(e:Error)
         {
         }
         if(Boolean(_source))
         {
            acceptDrag(null);
         }
      }
      
      public static function acceptDrag(param1:IAcceptDrag, param2:String = null) : void
      {
         var target:IAcceptDrag = param1;
         var action:String = param2;
         _isDraging = false;
         var source:IDragable = _source;
         var effect:DragEffect = _dragEffect;
         try
         {
            effect.target = target;
            if(Boolean(action))
            {
               effect.action = action;
            }
            source.dragStop(effect);
         }
         catch(e:Error)
         {
         }
         if(!_isContinue)
         {
            _source = null;
            _dragEffect = null;
         }
      }
   }
}

