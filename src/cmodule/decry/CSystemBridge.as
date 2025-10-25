package cmodule.decry
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class CSystemBridge implements CSystem
   {
      
      internal static const FSIZE:int = 1;
      
      internal static const PSIZE:int = 2;
      
      internal static const ACCESS:int = 3;
      
      internal static const OPEN:int = 4;
      
      internal static const CLOSE:int = 5;
      
      internal static const WRITE:int = 6;
      
      internal static const READ:int = 7;
      
      internal static const LSEEK:int = 8;
      
      internal static const TELL:int = 9;
      
      internal static const EXIT:int = 10;
      
      internal static const SETUP:int = 11;
      
      private var curPackBuf:ByteArray = new LEByteArray();
      
      private var sock:Socket;
      
      private var requests:Object = {};
      
      private var sentPackId:int = 1;
      
      private var curPackLen:int;
      
      internal var argv:Array;
      
      private var handlers:Object = {};
      
      internal var env:Object;
      
      private var curPackId:int;
      
      public function CSystemBridge(param1:String, param2:int)
      {
         super();
         this.sock = new Socket();
         this.sock.endian = "littleEndian";
         this.sock.addEventListener(Event.CONNECT,this.sockConnect);
         this.sock.addEventListener(ProgressEvent.SOCKET_DATA,this.sockData);
         this.sock.addEventListener(IOErrorEvent.IO_ERROR,this.sockError);
         this.sock.connect(param1,param2);
      }
      
      public function psize(param1:int) : int
      {
         var p:int = param1;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(PSIZE);
            param1.writeUTFBytes(cmodule.decry.gstate.gworker.stringFromPtr(p));
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      private function asyncReq(param1:Function, param2:Function) : *
      {
         var req:Object = null;
         var pack:ByteArray = null;
         var create:Function = param1;
         var handle:Function = param2;
         var rid:String = String(cmodule.decry.gstate.esp);
         req = this.requests[rid];
         if(Boolean(req))
         {
            if(Boolean(req.pending))
            {
               throw new AlchemyBlock();
            }
            delete this.requests[rid];
            return req.result;
         }
         req = {"pending":true};
         this.requests[rid] = req;
         pack = new LEByteArray();
         create(pack);
         this.sendRequest(pack,function(param1:ByteArray):void
         {
            req.result = handle(param1);
            req.pending = false;
         });
         if(Boolean(req.pending))
         {
            throw new AlchemyBlock();
         }
      }
      
      public function setup(param1:Function) : void
      {
         var f:Function = param1;
         var pack:ByteArray = new LEByteArray();
         pack.writeInt(SETUP);
         this.sendRequest(pack,function(param1:ByteArray):void
         {
            var _loc4_:Array = null;
            var _loc2_:int = param1.readInt();
            argv = [];
            while(Boolean(_loc2_--))
            {
               argv.push(param1.readUTF());
            }
            var _loc3_:int = param1.readInt();
            env = {};
            while(Boolean(_loc3_--))
            {
               _loc4_ = /([^\=]*)\=(.*)/.exec(param1.readUTF());
               if(Boolean(_loc4_) && _loc4_.length == 3)
               {
                  env[_loc4_[1]] = _loc4_[2];
               }
            }
            f();
         });
      }
      
      private function sockConnect(param1:Event) : void
      {
         log(2,"bridge connected");
      }
      
      private function sockData(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         while(Boolean(this.sock.bytesAvailable))
         {
            if(!this.curPackLen)
            {
               if(this.sock.bytesAvailable < 8)
               {
                  break;
               }
               this.curPackId = this.sock.readInt();
               this.curPackLen = this.sock.readInt();
               log(3,"bridge packet id: " + this.curPackId + " len: " + this.curPackLen);
               this.curPackBuf.length = this.curPackLen;
               this.curPackBuf.position = 0;
            }
            else
            {
               _loc2_ = int(this.sock.bytesAvailable);
               if(_loc2_ > this.curPackLen)
               {
                  _loc2_ = this.curPackLen;
               }
               this.curPackLen -= _loc2_;
               while(Boolean(_loc2_--))
               {
                  this.curPackBuf.writeByte(this.sock.readByte());
               }
               if(!this.curPackLen)
               {
                  this.handlePacket();
               }
            }
         }
      }
      
      public function read(param1:int, param2:int, param3:int) : int
      {
         var fd:int = param1;
         var buf:int = param2;
         var nbytes:int = param3;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(READ);
            param1.writeInt(fd);
            param1.writeInt(nbytes);
         },function(param1:ByteArray):int
         {
            var _loc4_:* = undefined;
            var _loc2_:* = param1.readInt();
            var _loc3_:* = "";
            cmodule.decry.gstate.ds.position = buf;
            while(Boolean(param1.bytesAvailable))
            {
               _loc4_ = param1.readByte();
               _loc3_ += String.fromCharCode(_loc4_);
               cmodule.decry.gstate.ds.writeByte(_loc4_);
            }
            log(4,"read from: " + fd + " : [" + _loc3_ + "]");
            return _loc2_;
         });
      }
      
      public function exit(param1:int) : void
      {
         var _loc2_:ByteArray = new LEByteArray();
         _loc2_.writeInt(EXIT);
         _loc2_.writeInt(param1);
         this.sendRequest(_loc2_,null);
         shellExit(param1);
      }
      
      private function sockError(param1:IOErrorEvent) : void
      {
         log(2,"bridge error");
      }
      
      public function tell(param1:int) : int
      {
         var fd:int = param1;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(TELL);
            param1.writeInt(fd);
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      public function ioctl(param1:int, param2:int, param3:int) : int
      {
         return -1;
      }
      
      public function getargv() : Array
      {
         return this.argv;
      }
      
      public function open(param1:int, param2:int, param3:int) : int
      {
         var path:int = param1;
         var flags:int = param2;
         var mode:int = param3;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(OPEN);
            param1.writeInt(flags);
            param1.writeInt(mode);
            param1.writeUTFBytes(cmodule.decry.gstate.gworker.stringFromPtr(path));
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      private function handlePacket() : void
      {
         this.curPackBuf.position = 0;
         this.handlers[this.curPackId](this.curPackBuf);
         if(Boolean(this.curPackId))
         {
            delete this.handlers[this.curPackId];
         }
      }
      
      public function getenv() : Object
      {
         return this.env;
      }
      
      public function write(param1:int, param2:int, param3:int) : int
      {
         var fd:int = param1;
         var buf:int = param2;
         var nbytes:int = param3;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(WRITE);
            param1.writeInt(fd);
            if(nbytes > 4096)
            {
               nbytes = 4096;
            }
            param1.writeBytes(cmodule.decry.gstate.ds,buf,nbytes);
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      private function sendRequest(param1:ByteArray, param2:Function) : void
      {
         if(Boolean(param2))
         {
            this.handlers[this.sentPackId] = param2;
         }
         this.sock.writeInt(this.sentPackId);
         this.sock.writeInt(param1.length);
         this.sock.writeBytes(param1,0);
         this.sock.flush();
         ++this.sentPackId;
      }
      
      public function lseek(param1:int, param2:int, param3:int) : int
      {
         var fd:int = param1;
         var offset:int = param2;
         var whence:int = param3;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(LSEEK);
            param1.writeInt(fd);
            param1.writeInt(offset);
            param1.writeInt(whence);
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      public function fsize(param1:int) : int
      {
         var fd:int = param1;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(FSIZE);
            param1.writeInt(fd);
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      public function access(param1:int, param2:int) : int
      {
         var path:int = param1;
         var mode:int = param2;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(ACCESS);
            param1.writeInt(mode);
            param1.writeUTFBytes(cmodule.decry.gstate.gworker.stringFromPtr(path));
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
      }
      
      public function close(param1:int) : int
      {
         var fd:int = param1;
         return this.asyncReq(function(param1:ByteArray):void
         {
            param1.writeInt(CLOSE);
            param1.writeInt(fd);
         },function(param1:ByteArray):int
         {
            return param1.readInt();
         });
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

