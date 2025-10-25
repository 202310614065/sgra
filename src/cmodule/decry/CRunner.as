package cmodule.decry
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class CRunner implements Debuggee
   {
      
      internal var timer:Timer;
      
      internal var forceSyncSystem:Boolean;
      
      internal var suspended:int = 0;
      
      internal var debugger:GDBMIDebugger;
      
      public function CRunner(param1:Boolean = false)
      {
         super();
         if(cmodule.decry.grunner)
         {
            log(1,"More than one CRunner!");
         }
         cmodule.decry.grunner = this;
         this.forceSyncSystem = param1;
      }
      
      public function cancelDebug() : void
      {
         this.debugger = null;
      }
      
      public function get isRunning() : Boolean
      {
         return this.suspended <= 0;
      }
      
      public function createArgv(param1:Array) : Array
      {
         return this.rawAllocStringArray(param1).concat(0);
      }
      
      public function createEnv(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_ + "=" + param1[_loc3_]);
         }
         return this.rawAllocStringArray(_loc2_).concat(0);
      }
      
      public function startInit() : void
      {
         var argv:Array;
         var envp:Array;
         var args:Array;
         var ap:int;
         var env:Object;
         var startArgs:Array;
         log(2,"Static init...");
         modStaticInit();
         args = cmodule.decry.gstate.system.getargv();
         env = cmodule.decry.gstate.system.getenv();
         argv = this.createArgv(args);
         envp = this.createEnv(env);
         startArgs = [args.length].concat(argv,envp);
         ap = this.rawAllocIntArray(startArgs);
         cmodule.decry.gstate.ds.length = cmodule.decry.gstate.ds.length + 4095 & ~0x0FFF;
         cmodule.decry.gstate.push(ap);
         cmodule.decry.gstate.push(0);
         log(2,"Starting work...");
         this.timer = new Timer(1);
         this.timer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
         {
            work();
         });
         try
         {
            FSM__start.start();
         }
         catch(e:AlchemyExit)
         {
            cmodule.decry.gstate.system.exit(e.rv);
            return;
         }
         catch(e:AlchemyYield)
         {
         }
         catch(e:AlchemyDispatch)
         {
         }
         catch(e:AlchemyBlock)
         {
         }
         this.startWork();
      }
      
      private function startWork() : void
      {
         if(!this.timer.running)
         {
            this.timer.delay = 1;
            this.timer.start();
         }
      }
      
      public function work() : void
      {
         var startTime:Number = NaN;
         var checkInterval:int = 0;
         var ms:int = 0;
         if(!this.isRunning)
         {
            return;
         }
         try
         {
            startTime = new Date().time;
            while(true)
            {
               checkInterval = 1000;
               while(checkInterval > 0)
               {
                  while(checkInterval-- > 0)
                  {
                     cmodule.decry.gstate.gworker.work();
                  }
               }
               if(new Date().time - startTime >= 1000 * 10)
               {
                  throw new AlchemyYield();
               }
            }
         }
         catch(e:AlchemyExit)
         {
            timer.stop();
            cmodule.decry.gstate.system.exit(e.rv);
         }
         catch(e:AlchemyYield)
         {
            ms = int(e.ms);
            timer.delay = ms > 0 ? ms : 1;
         }
         catch(e:AlchemyBlock)
         {
            timer.delay = 10;
         }
         catch(e:AlchemyBreakpoint)
         {
            throw e;
         }
      }
      
      public function startSystemBridge(param1:String, param2:int) : void
      {
         log(3,"bridge: " + param1 + " port: " + param2);
         cmodule.decry.gstate.system = new CSystemBridge(param1,param2);
         cmodule.decry.gstate.system.setup(this.startInit);
      }
      
      public function rawAllocString(param1:String) : int
      {
         var _loc2_:int = int(cmodule.decry.gstate.ds.length);
         cmodule.decry.gstate.ds.length += param1.length + 1;
         cmodule.decry.gstate.ds.position = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            cmodule.decry.gstate.ds.writeByte(param1.charCodeAt(_loc3_));
            _loc3_++;
         }
         cmodule.decry.gstate.ds.writeByte(0);
         return _loc2_;
      }
      
      public function rawAllocStringArray(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.rawAllocString(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function resume() : void
      {
         if(!--this.suspended)
         {
            this.startWork();
         }
      }
      
      public function startSystem() : void
      {
         var request:URLRequest = null;
         var loader:URLLoader = null;
         if(!this.forceSyncSystem)
         {
            request = new URLRequest(".swfbridge");
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               var _loc2_:XML = new XML(loader.data);
               if(_loc2_ && _loc2_.name() == "bridge" && Boolean(_loc2_.host) && Boolean(_loc2_.port))
               {
                  startSystemBridge(_loc2_.host,_loc2_.port);
               }
               else
               {
                  startSystemLocal();
               }
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
            {
               startSystemLocal();
            });
            loader.load(request);
            return;
         }
         this.startSystemLocal(true);
      }
      
      public function rawAllocIntArray(param1:Array) : int
      {
         var _loc2_:int = int(cmodule.decry.gstate.ds.length);
         cmodule.decry.gstate.ds.length += (param1.length + 1) * 4;
         cmodule.decry.gstate.ds.position = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            cmodule.decry.gstate.ds.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function startSystemLocal(param1:Boolean = false) : void
      {
         log(3,"local system");
         cmodule.decry.gstate.system = new CSystemLocal(param1);
         cmodule.decry.gstate.system.setup(this.startInit);
      }
      
      public function suspend() : void
      {
         ++this.suspended;
         if(Boolean(this.timer) && this.timer.running)
         {
            this.timer.stop();
         }
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

