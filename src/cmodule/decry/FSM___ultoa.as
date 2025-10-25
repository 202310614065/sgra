package cmodule.decry
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   import avm2.intrinsics.memory.sxi8;
   
   public final class FSM___ultoa extends Machine
   {
      
      public static const intRegCount:int = 11;
      
      public static const NumberRegCount:int = 0;
      
      public var i10:int;
      
      public var i0:int;
      
      public var i1:int;
      
      public var i2:int;
      
      public var i3:int;
      
      public var i4:int;
      
      public var i5:int;
      
      public var i6:int;
      
      public var i8:int;
      
      public var i7:int;
      
      public var i9:int;
      
      public function FSM___ultoa()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:FSM___ultoa = null;
         _loc1_ = new FSM___ultoa();
         cmodule.decry.gstate.gworker = _loc1_;
      }
      
      final override public function work() : void
      {
         loop5:
         switch(state)
         {
            case 0:
               mstate.esp -= 4;
               si32(mstate.ebp,mstate.esp);
               mstate.ebp = mstate.esp;
               mstate.esp -= 0;
               this.i0 = li32(mstate.ebp + 8);
               this.i1 = li32(mstate.ebp + 12);
               this.i2 = li32(mstate.ebp + 16);
               this.i3 = li32(mstate.ebp + 20);
               this.i4 = li32(mstate.ebp + 24);
               this.i5 = li32(mstate.ebp + 28);
               this.i6 = si8(li8(mstate.ebp + 32));
               this.i7 = li32(mstate.ebp + 36);
               if(this.i2 != 8)
               {
                  if(this.i2 != 10)
                  {
                     if(this.i2 != 16)
                     {
                        state = 1;
                        mstate.esp -= 4;
                        FSM_abort1.start();
                        return;
                     }
                     this.i3 = 0;
                     while(true)
                     {
                        this.i2 = this.i0 & 0x0F;
                        this.i5 = this.i3 ^ -1;
                        this.i2 = this.i4 + this.i2;
                        this.i2 = li8(this.i2);
                        this.i5 = this.i1 + this.i5;
                        si8(this.i2,this.i5);
                        this.i3 += 1;
                        this.i2 = this.i0 >>> 4;
                        if(uint(this.i0) < uint(16))
                        {
                           break loop5;
                        }
                        this.i0 = this.i2;
                     }
                  }
                  else
                  {
                     if(uint(this.i0) <= uint(9))
                     {
                        this.i0 += 48;
                        si8(this.i0,this.i1 + -1);
                        this.i0 = this.i1 + -1;
                     }
                     else
                     {
                        if(this.i0 >= 0)
                        {
                           this.i3 = 0;
                           this.i4 = this.i1;
                        }
                        else
                        {
                           this.i3 = 1;
                           this.i2 = uint(this.i0) / uint(10);
                           this.i4 = this.i2 * 10;
                           this.i0 -= this.i4;
                           this.i0 += 48;
                           si8(this.i0,this.i1 + -1);
                           this.i0 = this.i1 + -1;
                           this.i4 = this.i0;
                           this.i0 = this.i2;
                        }
                        this.i1 = this.i7;
                        loop1:
                        while(true)
                        {
                           this.i2 = this.i1 + 1;
                           this.i7 = this.i1;
                           if(this.i5 != 0)
                           {
                              while(true)
                              {
                                 this.i8 = this.i0 / 10;
                                 this.i8 *= 10;
                                 this.i8 = this.i0 - this.i8;
                                 this.i8 += 48;
                                 si8(this.i8,this.i4 + -1);
                                 this.i8 = li8(this.i7);
                                 this.i3 += 1;
                                 this.i9 = this.i4 + -1;
                                 this.i10 = this.i8 << 24;
                                 this.i10 >>= 24;
                                 if(this.i10 == this.i3)
                                 {
                                    this.i8 &= 255;
                                    if(this.i8 != 127)
                                    {
                                       if(this.i0 >= 10)
                                       {
                                          si8(this.i6,this.i4 + -2);
                                          this.i3 = li8(this.i2);
                                          this.i4 += -2;
                                          if(this.i3 != 0)
                                          {
                                             this.i3 = this.i1 + 1;
                                             this.i2 = this.i0 / 10;
                                             this.i0 += 9;
                                             if(uint(this.i0) <= uint(18))
                                             {
                                                this.i3 = this.i4;
                                                break loop1;
                                             }
                                             continue loop1;
                                          }
                                          this.i3 = 0;
                                       }
                                       else
                                       {
                                          addr0310:
                                          this.i4 = this.i9;
                                          addr030f:
                                       }
                                       this.i8 = this.i0 / 10;
                                       this.i0 += 9;
                                       if(uint(this.i0) <= uint(18))
                                       {
                                          break;
                                       }
                                       continue;
                                    }
                                    §§goto(addr030f);
                                 }
                                 §§goto(addr0310);
                                 this.i0 = this.i8;
                              }
                              this.i3 = this.i4;
                              break;
                           }
                           this.i3 = this.i4;
                           while(true)
                           {
                              this.i4 = this.i0 / 10;
                              this.i1 = this.i4 * 10;
                              this.i1 = this.i0 - this.i1;
                              this.i1 += 48;
                              si8(this.i1,this.i3 + -1);
                              this.i3 += -1;
                              this.i0 += 9;
                              if(uint(this.i0) <= uint(18))
                              {
                                 break;
                              }
                              this.i0 = this.i4;
                           }
                           break;
                           this.i7 = 0;
                           this.i1 = this.i3;
                           this.i0 = this.i2;
                           this.i3 = this.i7;
                        }
                        addr05ba:
                        this.i0 = this.i3;
                     }
                     §§goto(addr05c2);
                  }
               }
               else
               {
                  this.i4 = 0;
                  while(true)
                  {
                     this.i2 = this.i0 | 0x30;
                     this.i5 = this.i4 ^ -1;
                     this.i2 &= 55;
                     this.i5 = this.i1 + this.i5;
                     si8(this.i2,this.i5);
                     this.i4 += 1;
                     this.i6 = this.i0 >>> 3;
                     if(uint(this.i0) < uint(8))
                     {
                        break;
                     }
                     this.i0 = this.i6;
                  }
                  if(this.i3 != 0)
                  {
                     this.i3 = this.i2 & 0xFF;
                     if(this.i3 == 48)
                     {
                        addr0546:
                        this.i3 = this.i5;
                        §§goto(addr05ba);
                     }
                     else
                     {
                        this.i3 = 48;
                        this.i0 = this.i4 + -1;
                        this.i0 = -2 - this.i0;
                        this.i0 = this.i1 + this.i0;
                        si8(this.i3,this.i0);
                     }
                     addr05c2:
                     mstate.eax = this.i0;
                     mstate.esp = mstate.ebp;
                     mstate.ebp = li32(mstate.esp);
                     mstate.esp += 4;
                     mstate.esp += 4;
                     mstate.gworker = caller;
                     return;
                  }
                  §§goto(addr0546);
               }
               §§goto(addr05ba);
            case 1:
               break;
            default:
               throw "Invalid state in ___ultoa";
         }
         this.i3 = this.i5;
         §§goto(addr05ba);
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

