package cmodule.decry
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class CSystemLocal implements CSystem
   {
      
      private const statCache:Object = {};
      
      private var forceSync:Boolean;
      
      private const fds:Array = [];
      
      public function CSystemLocal(param1:Boolean = false)
      {
         super();
         this.forceSync = param1;
         cmodule.decry.gtextField = new TextField();
         cmodule.decry.gtextField.width = cmodule.decry.gsprite ? Number(cmodule.decry.gsprite.stage.stageWidth) : 800;
         cmodule.decry.gtextField.height = cmodule.decry.gsprite ? Number(cmodule.decry.gsprite.stage.stageHeight) : 600;
         cmodule.decry.gtextField.multiline = true;
         cmodule.decry.gtextField.defaultTextFormat = new TextFormat("Courier New");
         cmodule.decry.gtextField.type = TextFieldType.INPUT;
         cmodule.decry.gtextField.doubleClickEnabled = true;
         this.fds[0] = new TextFieldI(cmodule.decry.gtextField);
         this.fds[1] = new TextFieldO(cmodule.decry.gtextField,cmodule.decry.gsprite == null);
         this.fds[2] = new TextFieldO(cmodule.decry.gtextField,true);
         if(cmodule.decry.gsprite && cmodule.decry.gtextField)
         {
            cmodule.decry.gsprite.addChild(cmodule.decry.gtextField);
         }
         else
         {
            log(3,"local system w/o gsprite");
         }
      }
      
      public function getargv() : Array
      {
         return cmodule.decry.gargs;
      }
      
      public function lseek(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:IO = this.fds[param1];
         if(param3 == 0)
         {
            _loc4_.position = param2;
         }
         else if(param3 == 1)
         {
            _loc4_.position += param2;
         }
         else if(param3 == 2)
         {
            _loc4_.position = _loc4_.size + param2;
         }
         return _loc4_.position;
      }
      
      public function open(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:String = cmodule.decry.gstate.gworker.stringFromPtr(param1);
         if(param2 != 0)
         {
            log(3,"failed open(" + _loc4_ + ") flags(" + param2 + ")");
            return -1;
         }
         var _loc5_:Object = this.fetch(_loc4_);
         if(Boolean(_loc5_.pending))
         {
            throw new AlchemyBlock();
         }
         if(_loc5_.size < 0)
         {
            log(3,"failed open(" + _loc4_ + ") doesn\'t exist");
            return -1;
         }
         var _loc6_:int = 0;
         while(Boolean(this.fds[_loc6_]))
         {
            _loc6_++;
         }
         var _loc7_:ByteArrayIO = new ByteArrayIO();
         _loc7_.byteArray = new ByteArray();
         _loc7_.byteArray.writeBytes(_loc5_.data);
         _loc7_.byteArray.position = 0;
         this.fds[_loc6_] = _loc7_;
         log(4,"open(" + _loc4_ + "): " + _loc7_.size);
         return _loc6_;
      }
      
      public function psize(param1:int) : int
      {
         var _loc2_:String = cmodule.decry.gstate.gworker.stringFromPtr(param1);
         var _loc3_:Object = this.fetch(_loc2_);
         if(Boolean(_loc3_.pending))
         {
            throw new AlchemyBlock();
         }
         if(_loc3_.size < 0)
         {
            log(3,"psize(" + _loc2_ + ") failed");
         }
         else
         {
            log(3,"psize(" + _loc2_ + "): " + _loc3_.size);
         }
         return _loc3_.size;
      }
      
      public function read(param1:int, param2:int, param3:int) : int
      {
         return this.fds[param1].read(param2,param3);
      }
      
      public function getenv() : Object
      {
         return cmodule.decry.genv;
      }
      
      public function write(param1:int, param2:int, param3:int) : int
      {
         return this.fds[param1].write(param2,param3);
      }
      
      public function access(param1:int, param2:int) : int
      {
         var _loc3_:String = cmodule.decry.gstate.gworker.stringFromPtr(param1);
         if(Boolean(param2 & ~4))
         {
            log(3,"failed access(" + _loc3_ + ") mode(" + param2 + ")");
            return -1;
         }
         var _loc4_:Object = this.fetch(_loc3_);
         if(Boolean(_loc4_.pending))
         {
            throw new AlchemyBlock();
         }
         log(3,"access(" + _loc3_ + "): " + (_loc4_.size >= 0));
         if(_loc4_.size < 0)
         {
            return -1;
         }
         return 0;
      }
      
      public function exit(param1:int) : void
      {
         log(3,"exit: " + param1);
         shellExit(param1);
      }
      
      public function fsize(param1:int) : int
      {
         return this.fds[param1].size;
      }
      
      public function tell(param1:int) : int
      {
         return this.fds[param1].position;
      }
      
      public function ioctl(param1:int, param2:int, param3:int) : int
      {
         return -1;
      }
      
      public function close(param1:int) : int
      {
         var _loc2_:int = int(this.fds[param1].close());
         this.fds[param1] = null;
         return _loc2_;
      }
      
      private function fetch(param1:String) : Object
      {
         var gf:ByteArray = null;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var path:String = param1;
         var res:Object = this.statCache[path];
         if(!res)
         {
            gf = cmodule.decry.gfiles[path];
            if(Boolean(gf))
            {
               res = {
                  "pending":false,
                  "size":gf.length,
                  "data":gf
               };
               this.statCache[path] = res;
               return res;
            }
         }
         if(this.forceSync)
         {
            return res || {
               "size":-1,
               "pending":false
            };
         }
         if(!res)
         {
            request = new URLRequest(path);
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               statCache[path].data = loader.data;
               statCache[path].size = loader.data.length;
               statCache[path].pending = false;
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
            {
               statCache[path].size = -1;
               statCache[path].pending = false;
            });
            this.statCache[path] = res = {"pending":true};
            loader.load(request);
         }
         return res;
      }
      
      public function setup(param1:Function) : void
      {
         param1();
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

