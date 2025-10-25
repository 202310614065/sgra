package cmodule.decry
{
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si16;
   import avm2.intrinsics.memory.si32;
   
   public final class FSM_imalloc extends Machine
   {
      
      public function FSM_imalloc()
      {
         super();
      }
      
      public static function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         cmodule.decry.mstate.esp -= 4;
         si32(cmodule.decry.mstate.ebp,cmodule.decry.mstate.esp);
         cmodule.decry.mstate.ebp = cmodule.decry.mstate.esp;
         cmodule.decry.mstate.esp -= 0;
         _loc1_ = li32(cmodule.decry.mstate.ebp + 8);
         _loc2_ = _loc1_ + 4096;
         if(uint(_loc2_) >= uint(_loc1_))
         {
            if(uint(_loc1_) <= uint(2048))
            {
               _loc2_ = _loc1_ + -1;
               _loc2_ = uint(_loc1_) < uint(16) ? 15 : _loc2_;
               if(uint(_loc2_) >= uint(2))
               {
                  _loc3_ = -1;
                  do
                  {
                     _loc3_ += 1;
                     _loc2_ >>= 1;
                  }
                  while(uint(_loc2_) >= uint(2));
                  
                  _loc2_ = _loc3_ + 2;
               }
               else
               {
                  _loc2_ = 1;
               }
               _loc3_ = li32(cmodule.decry._page_dir);
               _loc4_ = _loc2_ << 2;
               _loc4_ = _loc3_ + _loc4_;
               _loc4_ = li32(_loc4_);
               if(_loc4_ == 0)
               {
                  _loc3_ = 4096;
                  cmodule.decry.mstate.esp -= 4;
                  si32(_loc3_,cmodule.decry.mstate.esp);
                  cmodule.decry.mstate.esp -= 4;
                  FSM_malloc_pages.start();
                  _loc3_ = int(cmodule.decry.mstate.eax);
                  cmodule.decry.mstate.esp += 4;
                  if(_loc3_ != 0)
                  {
                     _loc4_ = 4096;
                     _loc4_ >>>= _loc2_;
                     _loc5_ = _loc4_ + 31;
                     _loc5_ >>>= 3;
                     _loc6_ = 1;
                     _loc5_ &= 536870908;
                     _loc7_ = _loc5_ + 16;
                     _loc6_ <<= _loc2_;
                     _loc8_ = _loc7_ << 1;
                     if(_loc6_ <= _loc8_)
                     {
                        _loc8_ = _loc3_;
                     }
                     else
                     {
                        cmodule.decry.mstate.esp -= 4;
                        si32(_loc7_,cmodule.decry.mstate.esp);
                        cmodule.decry.mstate.esp -= 4;
                        FSM_imalloc.start();
                        _loc8_ = int(cmodule.decry.mstate.eax);
                        cmodule.decry.mstate.esp += 4;
                        if(_loc8_ != 0)
                        {
                           addr024e:
                           si16(_loc6_,_loc8_ + 8);
                           si16(_loc2_,_loc8_ + 10);
                           si16(_loc4_,_loc8_ + 12);
                           si16(_loc4_,_loc8_ + 14);
                           si32(_loc3_,_loc8_ + 4);
                           _loc9_ = _loc4_ & 0xFFFF;
                           _loc10_ = _loc8_ + 14;
                           _loc11_ = _loc8_ + 12;
                           _loc12_ = _loc8_;
                           if(uint(_loc9_) <= uint(31))
                           {
                              _loc13_ = 0;
                           }
                           else
                           {
                              _loc13_ = 0;
                              _loc14_ = _loc9_;
                              _loc15_ = _loc13_;
                              do
                              {
                                 _loc16_ = -1;
                                 _loc17_ = _loc13_ & 0x07FFFFFF;
                                 _loc17_ <<= 2;
                                 _loc17_ = _loc12_ + _loc17_;
                                 si32(_loc16_,_loc17_ + 16);
                                 _loc14_ += -32;
                                 _loc15_ += 32;
                                 _loc13_ += 1;
                              }
                              while(uint(_loc14_) > uint(31));
                              
                              _loc13_ = _loc15_;
                           }
                           if(_loc13_ < _loc9_)
                           {
                              _loc14_ = 0;
                              _loc9_ -= _loc13_;
                              do
                              {
                                 _loc15_ = 1;
                                 _loc16_ = _loc13_ + _loc14_;
                                 _loc17_ = _loc16_ & -32;
                                 _loc17_ >>>= 3;
                                 _loc16_ &= 31;
                                 _loc17_ = _loc12_ + _loc17_;
                                 _loc18_ = li32(_loc17_ + 16);
                                 _loc15_ <<= _loc16_;
                                 _loc15_ = _loc18_ | _loc15_;
                                 si32(_loc15_,_loc17_ + 16);
                                 _loc14_ += 1;
                              }
                              while(_loc14_ != _loc9_);
                              
                           }
                           if(_loc3_ == _loc8_)
                           {
                              if(_loc7_ >= 1)
                              {
                                 _loc7_ = 0;
                                 _loc5_ += 16;
                                 do
                                 {
                                    _loc9_ = 1;
                                    _loc13_ = _loc7_ & -32;
                                    _loc14_ = _loc7_ & 0x1F;
                                    _loc13_ >>>= 3;
                                    _loc9_ <<= _loc14_;
                                    _loc13_ = _loc12_ + _loc13_;
                                    _loc14_ = li32(_loc13_ + 16);
                                    _loc9_ ^= -1;
                                    _loc9_ = _loc14_ & _loc9_;
                                    si32(_loc9_,_loc13_ + 16);
                                    _loc9_ = li16(_loc10_);
                                    _loc9_ += -1;
                                    si16(_loc9_,_loc10_);
                                    _loc5_ -= _loc6_;
                                    _loc7_ += 1;
                                 }
                                 while(_loc5_ >= 1);
                                 
                                 _loc5_ = _loc7_ + -1;
                                 _loc4_ -= _loc5_;
                                 _loc4_ += -1;
                                 si16(_loc4_,_loc11_);
                              }
                           }
                           _loc4_ = li32(cmodule.decry._malloc_origo);
                           _loc3_ >>>= 12;
                           _loc3_ -= _loc4_;
                           _loc4_ = li32(cmodule.decry._page_dir);
                           _loc3_ <<= 2;
                           _loc5_ = _loc2_ << 2;
                           _loc3_ = _loc4_ + _loc3_;
                           si32(_loc12_,_loc3_);
                           _loc3_ = _loc4_ + _loc5_;
                           _loc5_ = li32(_loc3_);
                           si32(_loc5_,_loc8_);
                           si32(_loc12_,_loc3_);
                           _loc3_ = li32(_loc12_ + 16);
                           _loc5_ = _loc12_ + 16;
                           if(_loc3_ != 0)
                           {
                              _loc3_ = _loc4_;
                              _loc4_ = _loc12_;
                           }
                           else
                           {
                              _loc3_ = _loc4_;
                              _loc4_ = _loc12_;
                              while(true)
                              {
                                 _loc6_ = li32(_loc5_ + 4);
                                 _loc5_ += 4;
                                 _loc7_ = _loc5_;
                                 if(_loc6_ != 0)
                                 {
                                    break;
                                 }
                                 _loc5_ = _loc7_;
                              }
                              addr0553:
                              addr04ea:
                           }
                           _loc6_ = _loc5_;
                           _loc8_ = li32(_loc6_);
                           _loc5_ = _loc8_ & 1;
                           if(_loc5_ != 0)
                           {
                              _loc7_ = 0;
                              _loc5_ = 1;
                           }
                           else
                           {
                              _loc5_ = 1;
                              _loc7_ = 0;
                              do
                              {
                                 _loc7_ += 1;
                                 _loc5_ <<= 1;
                                 _loc9_ = _loc8_ & _loc5_;
                              }
                              while(_loc9_ == 0);
                              
                           }
                           _loc5_ = _loc8_ ^ _loc5_;
                           si32(_loc5_,_loc6_);
                           _loc5_ = li16(_loc4_ + 12);
                           _loc5_ += -1;
                           si16(_loc5_,_loc4_ + 12);
                           _loc5_ &= 65535;
                           if(_loc5_ == 0)
                           {
                              _loc5_ = 0;
                              _loc2_ <<= 2;
                              _loc8_ = li32(_loc4_);
                              _loc2_ = _loc3_ + _loc2_;
                              si32(_loc8_,_loc2_);
                              si32(_loc5_,_loc4_);
                           }
                           _loc2_ = _loc4_ + 16;
                           _loc2_ = _loc6_ - _loc2_;
                           _loc2_ <<= 3;
                           _loc3_ = li8(cmodule.decry._malloc_junk_2E_b);
                           _loc5_ = li16(_loc4_ + 10);
                           _loc2_ += _loc7_;
                           _loc3_ ^= 1;
                           _loc2_ <<= _loc5_;
                           _loc3_ &= 1;
                           if(_loc3_ == 0)
                           {
                              _loc3_ = -48;
                              _loc5_ = li16(_loc4_ + 8);
                              _loc6_ = li32(_loc4_ + 4);
                              _loc6_ += _loc2_;
                              memset(_loc6_,_loc3_,_loc5_);
                              _loc4_ = li32(_loc4_ + 4);
                              _loc3_ = li8(cmodule.decry._malloc_zero_2E_b);
                              _loc2_ = _loc4_ + _loc2_;
                              if(_loc2_ != 0)
                              {
                                 _loc4_ = _loc3_ & 1;
                                 if(_loc4_ == 0)
                                 {
                                    addr07b7:
                                    _loc1_ = _loc2_;
                                    cmodule.decry.mstate.eax = _loc1_;
                                 }
                                 else
                                 {
                                    addr06af:
                                    _loc3_ = 0;
                                    _loc4_ = _loc2_;
                                    memset(_loc4_,_loc3_,_loc1_);
                                    addr06cc:
                                    cmodule.decry.mstate.eax = _loc2_;
                                 }
                                 §§goto(addr06dc);
                              }
                           }
                           else
                           {
                              _loc3_ = li32(_loc4_ + 4);
                              _loc4_ = li8(cmodule.decry._malloc_zero_2E_b);
                              _loc2_ = _loc3_ + _loc2_;
                              if(_loc2_ != 0)
                              {
                                 _loc3_ = _loc4_ & 1;
                                 if(_loc3_ == 0)
                                 {
                                    §§goto(addr07b7);
                                 }
                                 else
                                 {
                                    addr06ae:
                                    §§goto(addr06af);
                                 }
                              }
                           }
                           §§goto(addr07b7);
                        }
                        else
                        {
                           _loc2_ = 0;
                           cmodule.decry.mstate.esp -= 4;
                           si32(_loc3_,cmodule.decry.mstate.esp);
                           cmodule.decry.mstate.esp -= 4;
                           FSM_ifree.start();
                           cmodule.decry.mstate.esp += 4;
                        }
                        §§goto(addr06cc);
                     }
                     §§goto(addr024e);
                  }
                  else
                  {
                     addr00a8:
                     _loc2_ = 0;
                     addr078e:
                     _loc3_ = li8(cmodule.decry._malloc_zero_2E_b);
                     _loc3_ ^= 1;
                     _loc3_ &= 1;
                     if(_loc3_ == 0)
                     {
                        if(_loc2_ == 0)
                        {
                           §§goto(addr07b7);
                        }
                        else
                        {
                           §§goto(addr06ae);
                        }
                        cmodule.decry.mstate.esp += 4;
                        cmodule.decry.mstate.esp += 4;
                        return;
                     }
                  }
                  §§goto(addr07b7);
               }
               else
               {
                  _loc5_ = li32(_loc4_ + 16);
                  _loc6_ = _loc4_ + 16;
                  if(_loc5_ != 0)
                  {
                     _loc5_ = _loc6_;
                  }
                  else
                  {
                     _loc5_ = _loc6_;
                     §§goto(addr0553);
                  }
                  §§goto(addr04ea);
               }
            }
            else
            {
               cmodule.decry.mstate.esp -= 4;
               si32(_loc1_,cmodule.decry.mstate.esp);
               cmodule.decry.mstate.esp -= 4;
               FSM_malloc_pages.start();
               _loc2_ = int(cmodule.decry.mstate.eax);
               cmodule.decry.mstate.esp += 4;
            }
            §§goto(addr078e);
         }
         §§goto(addr00a8);
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

