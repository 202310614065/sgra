package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _3a128833467b196de2efe7aa72f1b25877bab4c1f458116624ee5c7ec0776d69_flash_display_Sprite extends Sprite
   {
      
      public function _3a128833467b196de2efe7aa72f1b25877bab4c1f458116624ee5c7ec0776d69_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}

