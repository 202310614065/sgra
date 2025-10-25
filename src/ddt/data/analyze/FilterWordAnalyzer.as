package ddt.data.analyze
{
   import com.hurlant.util.Base64;
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.manager.LanguageMgr;
   
   public class FilterWordAnalyzer extends DataAnalyzer
   {
      
      public var words:Array = [];
      
      public var serverWords:Array = [];
      
      public var unableChar:String;
      
      public function FilterWordAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:RegExp = null;
         var _loc2_:String = Base64.decode(String(param1));
         _loc2_ = _loc2_.toLocaleLowerCase();
         var _loc3_:Array = LanguageMgr.GetTranslation("zangNoFilterWords").split(",");
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = new RegExp(_loc4_,"g");
            _loc2_ = _loc2_.replace(_loc6_,"");
         }
         _loc5_ = _loc2_.toLocaleLowerCase().split("\n");
         if(Boolean(_loc5_))
         {
            if(Boolean(_loc5_[0]))
            {
               this.unableChar = _loc5_[0];
            }
            if(Boolean(_loc5_[1]))
            {
               this.words = _loc5_[1].split("|");
            }
            if(Boolean(_loc5_[2]))
            {
               this.serverWords = _loc5_[2].split("|");
            }
         }
         onAnalyzeComplete();
      }
   }
}

