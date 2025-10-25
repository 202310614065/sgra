package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetAllSkillTemplateInfo;
   
   public class PetAllSkillAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function PetAllSkillAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:PetAllSkillTemplateInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new PetAllSkillTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_);
            this.list[_loc5_.PetTemplateID] = _loc5_;
         }
         onAnalyzeComplete();
      }
   }
}

