package ddt.view.character
{
   import ddt.data.player.PlayerInfo;
   
   public class CharactoryFactory
   {
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const ROOM:String = "room";
      
      private static var _characterloaderfactory:ICharacterLoaderFactory = new CharacterLoaderFactory();
      
      public function CharactoryFactory()
      {
         super();
      }
      
      public static function createCharacter(param1:PlayerInfo, param2:String = "show", param3:Boolean = false, param4:Boolean = true) : ICharacter
      {
         var _loc5_:ICharacter = null;
         switch(param2)
         {
            case SHOW:
               _loc5_ = new ShowCharacter(param1,true,param4,param3);
               break;
            case GAME:
               _loc5_ = new GameCharacter(param1);
               break;
            case ROOM:
               _loc5_ = new RoomCharacter(param1);
         }
         if(_loc5_ != null)
         {
            _loc5_.setFactory(_characterloaderfactory);
         }
         return _loc5_;
      }
   }
}

