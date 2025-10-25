package cmodule.decry
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Machine extends MemUser
   {
      
      public static var sMS:uint;
      
      public static const dbgFileNames:Array = [];
      
      public static const dbgFuncs:Array = [];
      
      public static const dbgFuncNames:Array = [];
      
      public static const dbgLabels:Array = [];
      
      public static const dbgLocs:Array = [];
      
      public static const dbgScopes:Array = [];
      
      public static const dbgGlobals:Array = [];
      
      public static const dbgBreakpoints:Object = {};
      
      public static var dbgFrameBreakLow:int = 0;
      
      public static var dbgFrameBreakHigh:int = -1;
      
      public var dbgFileId:int = 0;
      
      public var mstate:MState;
      
      public var dbgLabel:int = 0;
      
      public var caller:Machine = cmodule.decry.gstate ? cmodule.decry.gstate.gworker : null;
      
      public var state:int = 0;
      
      public var dbgLineNo:int = 0;
      
      public function Machine()
      {
         this.mstate = Boolean(this.caller) ? this.caller.mstate : null;
         super();
      }
      
      public static function debugTraverseScope(param1:Object, param2:int, param3:Function) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1 && param2 >= param1.startLabelId && param2 < param1.endLabelId)
         {
            param3(param1);
            _loc4_ = param1.scopes;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               debugTraverseScope(_loc4_[_loc5_],param2,param3);
               _loc5_++;
            }
         }
      }
      
      public function debugTraceMem(param1:int, param2:int) : void
      {
         trace("");
         trace("*****");
         while(param1 <= param2)
         {
            trace("* " + param1 + " : " + this.mstate._mr32(param1));
            param1 += 4;
         }
         trace("");
      }
      
      public function get dbgFuncId() : int
      {
         return -1;
      }
      
      public function work() : void
      {
         throw new AlchemyYield();
      }
      
      public function stringFromPtr(param1:int) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         while(true)
         {
            _loc3_ = this.mstate._mru8(param1++);
            if(!_loc3_)
            {
               break;
            }
            _loc2_ += String.fromCharCode(_loc3_);
         }
         return _loc2_;
      }
      
      public function get dbgLoc() : Object
      {
         return {
            "fileId":this.dbgFileId,
            "lineNo":this.dbgLineNo
         };
      }
      
      public function get dbgDepth() : int
      {
         var _loc2_:int = 0;
         var _loc1_:Machine = this;
         while(Boolean(_loc1_))
         {
            _loc2_++;
            _loc1_ = _loc1_.caller;
         }
         return _loc2_;
      }
      
      public function get dbgTrace() : String
      {
         return this.dbgFuncName + "(" + (this as Object).constructor + ") - " + this.dbgFileName + " : " + this.dbgLineNo + "(" + this.state + ")";
      }
      
      public function debugTraverseCurrentScope(param1:Function) : void
      {
         debugTraverseScope(dbgScopes[this.dbgFuncId],this.dbgLabel,param1);
      }
      
      public function debugLabel(param1:int) : void
      {
         this.dbgLabel = param1;
      }
      
      public function stringToPtr(param1:int, param2:int, param3:String) : int
      {
         var _loc4_:int = param3.length;
         if(param2 >= 0 && param2 < _loc4_)
         {
            _loc4_ = param2;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            this.mstate._mw8(param1++,param3.charCodeAt(_loc5_));
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function debugBreak(param1:Object) : void
      {
         throw new AlchemyBreakpoint(param1);
      }
      
      public function debugLoc(param1:int, param2:int) : void
      {
         var _loc5_:int = 0;
         if(this.dbgFileId == param1 && this.dbgLineNo == param2)
         {
            return;
         }
         this.dbgFileId = param1;
         this.dbgLineNo = param2;
         var _loc3_:String = param1 + ":" + param2;
         var _loc4_:Object = dbgBreakpoints[_loc3_];
         if(Boolean(_loc4_) && Boolean(_loc4_.enabled))
         {
            if(Boolean(_loc4_.temp))
            {
               delete dbgBreakpoints[_loc3_];
            }
            this.debugBreak(_loc4_);
         }
         else if(dbgFrameBreakHigh >= dbgFrameBreakLow)
         {
            _loc5_ = this.dbgDepth;
            if(_loc5_ >= dbgFrameBreakLow && _loc5_ <= dbgFrameBreakHigh)
            {
               this.debugBreak(null);
            }
         }
      }
      
      public function get dbgFileName() : String
      {
         return dbgFileNames[this.dbgFileId];
      }
      
      public function getSecsSetMS() : uint
      {
         var _loc1_:Number = new Date().time;
         Machine.sMS = _loc1_ % 1000;
         return _loc1_ / 1000;
      }
      
      public function get dbgFuncName() : String
      {
         return dbgFuncNames[this.dbgFuncId];
      }
      
      public function backtrace() : void
      {
         var framePtr:int = 0;
         var cur:Machine = this;
         trace("");
         trace("*** backtrace");
         framePtr = this.mstate.ebp;
         while(Boolean(cur))
         {
            trace(cur.dbgTrace);
            cur.debugTraverseCurrentScope(function(param1:Object):void
            {
               var _loc4_:int = 0;
               var _loc5_:int = 0;
               var _loc6_:String = null;
               var _loc7_:int = 0;
               trace("{{{");
               var _loc2_:Array = param1.vars;
               var _loc3_:int = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = int(_loc2_[_loc3_ + 0]);
                  _loc5_ = mstate._mr32(_loc4_ + 8);
                  _loc6_ = stringFromPtr(_loc5_);
                  _loc7_ = int(_loc2_[_loc3_ + 1]);
                  trace("--- " + _loc6_ + " (" + (_loc7_ + framePtr) + ")");
                  _loc3_ += 2;
               }
            });
            framePtr = this.mstate._mr32(framePtr);
            cur = cur.caller;
         }
         trace("");
      }
   }
}

import cmodule.decry.CLibDummySprite;
import cmodule.decry.CLibInit;
import cmodule.decry.CRunner;
import cmodule.decry.CSystem;
import cmodule.decry.CSystemBridge;
import cmodule.decry.CSystemLocal;
import cmodule.decry.ConSprite;
import cmodule.decry.Debuggee;
import cmodule.decry.DynamicProxy;
import cmodule.decry.FSM__UTF8_wcrtomb;
import cmodule.decry.FSM___Balloc_D2A;
import cmodule.decry.FSM___adddi3;
import cmodule.decry.FSM___anddi3;
import cmodule.decry.FSM___ashldi3;
import cmodule.decry.FSM___ashrdi3;
import cmodule.decry.FSM___cmpdi2;
import cmodule.decry.FSM___diff_D2A;
import cmodule.decry.FSM___divdi3;
import cmodule.decry.FSM___error;
import cmodule.decry.FSM___fflush;
import cmodule.decry.FSM___find_arguments;
import cmodule.decry.FSM___fixdfdi;
import cmodule.decry.FSM___fixsfdi;
import cmodule.decry.FSM___fixunsdfdi;
import cmodule.decry.FSM___fixunssfdi;
import cmodule.decry.FSM___floatdidf;
import cmodule.decry.FSM___floatdisf;
import cmodule.decry.FSM___floatunsdidf;
import cmodule.decry.FSM___gdtoa;
import cmodule.decry.FSM___grow_type_table;
import cmodule.decry.FSM___iordi3;
import cmodule.decry.FSM___lmulq;
import cmodule.decry.FSM___lo0bits_D2A;
import cmodule.decry.FSM___lshift_D2A;
import cmodule.decry.FSM___lshldi3;
import cmodule.decry.FSM___lshrdi3;
import cmodule.decry.FSM___moddi3;
import cmodule.decry.FSM___muldi3;
import cmodule.decry.FSM___mult_D2A;
import cmodule.decry.FSM___multadd_D2A;
import cmodule.decry.FSM___negdi2;
import cmodule.decry.FSM___one_cmpldi2;
import cmodule.decry.FSM___pow5mult_D2A;
import cmodule.decry.FSM___qdivrem;
import cmodule.decry.FSM___quorem_D2A;
import cmodule.decry.FSM___sclose;
import cmodule.decry.FSM___sflush;
import cmodule.decry.FSM___sfvwrite;
import cmodule.decry.FSM___smakebuf;
import cmodule.decry.FSM___sread;
import cmodule.decry.FSM___sseek;
import cmodule.decry.FSM___subdi3;
import cmodule.decry.FSM___swrite;
import cmodule.decry.FSM___swsetup;
import cmodule.decry.FSM___trailz_D2A;
import cmodule.decry.FSM___ucmpdi2;
import cmodule.decry.FSM___udivdi3;
import cmodule.decry.FSM___ultoa;
import cmodule.decry.FSM___umoddi3;
import cmodule.decry.FSM___vfprintf;
import cmodule.decry.FSM___xordi3;
import cmodule.decry.FSM__cleanup;
import cmodule.decry.FSM__exit;
import cmodule.decry.FSM__fini;
import cmodule.decry.FSM__longjmp;
import cmodule.decry.FSM__setjmp;
import cmodule.decry.FSM__sseek;
import cmodule.decry.FSM__start;
import cmodule.decry.FSM__swrite;
import cmodule.decry.FSM_abort1;
import cmodule.decry.FSM_atexit;
import cmodule.decry.FSM_bcopy;
import cmodule.decry.FSM_decry;
import cmodule.decry.FSM_dorounding;
import cmodule.decry.FSM_exit;
import cmodule.decry.FSM_fprintf;
import cmodule.decry.FSM_free;
import cmodule.decry.FSM_fstat;
import cmodule.decry.FSM_getenv;
import cmodule.decry.FSM_ifree;
import cmodule.decry.FSM_imalloc;
import cmodule.decry.FSM_ioctl;
import cmodule.decry.FSM_malloc;
import cmodule.decry.FSM_malloc_pages;
import cmodule.decry.FSM_pubrealloc;
import cmodule.decry.FSM_sprintf;
import cmodule.decry.GDBMIDebugger;
import cmodule.decry.MState;
import cmodule.decry.Machine;
import cmodule.decry.MemUser;
import cmodule.decry.StaticInitter;
import cmodule.decry.§cmodule.decry.__UTF8_wcrtomb§;
import cmodule.decry.§cmodule.decry.___Balloc_D2A§;
import cmodule.decry.§cmodule.decry.___adddi3§;
import cmodule.decry.§cmodule.decry.___anddi3§;
import cmodule.decry.§cmodule.decry.___ashldi3§;
import cmodule.decry.§cmodule.decry.___ashrdi3§;
import cmodule.decry.§cmodule.decry.___cmpdi2§;
import cmodule.decry.§cmodule.decry.___diff_D2A§;
import cmodule.decry.§cmodule.decry.___divdi3§;
import cmodule.decry.§cmodule.decry.___error§;
import cmodule.decry.§cmodule.decry.___fflush§;
import cmodule.decry.§cmodule.decry.___find_arguments§;
import cmodule.decry.§cmodule.decry.___fixdfdi§;
import cmodule.decry.§cmodule.decry.___fixsfdi§;
import cmodule.decry.§cmodule.decry.___fixunsdfdi§;
import cmodule.decry.§cmodule.decry.___fixunssfdi§;
import cmodule.decry.§cmodule.decry.___floatdidf§;
import cmodule.decry.§cmodule.decry.___floatdisf§;
import cmodule.decry.§cmodule.decry.___floatunsdidf§;
import cmodule.decry.§cmodule.decry.___gdtoa§;
import cmodule.decry.§cmodule.decry.___grow_type_table§;
import cmodule.decry.§cmodule.decry.___iordi3§;
import cmodule.decry.§cmodule.decry.___lmulq§;
import cmodule.decry.§cmodule.decry.___lo0bits_D2A§;
import cmodule.decry.§cmodule.decry.___lshift_D2A§;
import cmodule.decry.§cmodule.decry.___lshldi3§;
import cmodule.decry.§cmodule.decry.___lshrdi3§;
import cmodule.decry.§cmodule.decry.___moddi3§;
import cmodule.decry.§cmodule.decry.___muldi3§;
import cmodule.decry.§cmodule.decry.___mult_D2A§;
import cmodule.decry.§cmodule.decry.___multadd_D2A§;
import cmodule.decry.§cmodule.decry.___negdi2§;
import cmodule.decry.§cmodule.decry.___one_cmpldi2§;
import cmodule.decry.§cmodule.decry.___pow5mult_D2A§;
import cmodule.decry.§cmodule.decry.___qdivrem§;
import cmodule.decry.§cmodule.decry.___quorem_D2A§;
import cmodule.decry.§cmodule.decry.___sclose§;
import cmodule.decry.§cmodule.decry.___sflush§;
import cmodule.decry.§cmodule.decry.___sfvwrite§;
import cmodule.decry.§cmodule.decry.___smakebuf§;
import cmodule.decry.§cmodule.decry.___sread§;
import cmodule.decry.§cmodule.decry.___sseek§;
import cmodule.decry.§cmodule.decry.___subdi3§;
import cmodule.decry.§cmodule.decry.___swrite§;
import cmodule.decry.§cmodule.decry.___swsetup§;
import cmodule.decry.§cmodule.decry.___trailz_D2A§;
import cmodule.decry.§cmodule.decry.___ucmpdi2§;
import cmodule.decry.§cmodule.decry.___udivdi3§;
import cmodule.decry.§cmodule.decry.___ultoa§;
import cmodule.decry.§cmodule.decry.___umoddi3§;
import cmodule.decry.§cmodule.decry.___vfprintf§;
import cmodule.decry.§cmodule.decry.___xordi3§;
import cmodule.decry.§cmodule.decry.__cleanup§;
import cmodule.decry.§cmodule.decry.__exit§;
import cmodule.decry.§cmodule.decry.__fini§;
import cmodule.decry.§cmodule.decry.__sseek§;
import cmodule.decry.§cmodule.decry.__start§;
import cmodule.decry.§cmodule.decry.__swrite§;
import cmodule.decry.§cmodule.decry._abort1§;
import cmodule.decry.§cmodule.decry._atexit§;
import cmodule.decry.§cmodule.decry._bcopy§;
import cmodule.decry.§cmodule.decry._decry§;
import cmodule.decry.§cmodule.decry._dorounding§;
import cmodule.decry.§cmodule.decry._exit§;
import cmodule.decry.§cmodule.decry._fprintf§;
import cmodule.decry.§cmodule.decry._free§;
import cmodule.decry.§cmodule.decry._fstat§;
import cmodule.decry.§cmodule.decry._getenv§;
import cmodule.decry.§cmodule.decry._ifree§;
import cmodule.decry.§cmodule.decry._imalloc§;
import cmodule.decry.§cmodule.decry._ioctl§;
import cmodule.decry.§cmodule.decry._malloc§;
import cmodule.decry.§cmodule.decry._malloc_pages§;
import cmodule.decry.§cmodule.decry._pubrealloc§;
import cmodule.decry.§cmodule.decry._sprintf§;
import cmodule.decry.§cmodule.decry.establishEnv§;
import cmodule.decry.§cmodule.decry.exportSym§;
import cmodule.decry.§cmodule.decry.gsetjmpMachine2ESPMap§;
import cmodule.decry.§cmodule.decry.gstackSize§;
import cmodule.decry.§cmodule.decry.gstate§;
import cmodule.decry.§cmodule.decry.gstaticInitter§;
import cmodule.decry.§cmodule.decry.i__longjmp§;
import cmodule.decry.§cmodule.decry.i__setjmp§;
import cmodule.decry.§cmodule.decry.i_longjmp§;
import cmodule.decry.§cmodule.decry.i_setjmp§;
import cmodule.decry.§cmodule.decry.modEnd§;
import cmodule.decry.§cmodule.decry.regFunc§;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.Proxy;

