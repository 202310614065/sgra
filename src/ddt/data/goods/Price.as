package ddt.data.goods
{
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class Price
   {
      
      public static var ONLYMONEY:Boolean = false;
      
      public static var ONLYDDT_MONEY:Boolean = false;
      
      public static const MONEY2:int = -8;
      
      public static const MONEY3:int = -9;
      
      public static const MONEY:int = -1;
      
      public static const DDT_MONEY:int = -2;
      
      public static const NEW_DDT_MONEY:int = -11;
      
      public static const GOLD:int = -3;
      
      public static const GESTE:int = -4;
      
      public static const SCORE:int = -6;
      
      public static const WORLDBOSS_SCORE:int = -7;
      
      public static const HARD_CURRENCY:int = -9;
      
      public static const LEAGUE:int = -10;
      
      public static const PETSCORE:int = -8;
      
      public static const PETSCORETOSTRING:String = LanguageMgr.GetTranslation("ddt.farm.petScore");
      
      public static const LIGHT_STONE:int = -11;
      
      public static const LIGHT_STONE_STRING:String = LanguageMgr.GetTranslation("buried.alertInfo.ligthStone");
      
      public static const MONEYTOSTRING:String = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
      
      public static const DDTMONEYTOSTRING:String = LanguageMgr.GetTranslation("ddtMoney");
      
      public static const BANDMONEYTOSTRING:String = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
      
      public static const ORDERMONEYTOSTRING:String = LanguageMgr.GetTranslation("newDdtMoney");
      
      public static const NEWDDTMONEYTOSTRING:String = LanguageMgr.GetTranslation("ddtMoney");
      
      public static const GOLDTOSTRING:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold");
      
      public static const GESTETOSTRING:String = LanguageMgr.GetTranslation("gongxun");
      
      public static const SCORETOSTRING:String = LanguageMgr.GetTranslation("tank.gameover.takecard.score");
      
      public static const HARD_CURRENCY_TO_STRING:String = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
      
      public static const LEAGUESTRING:String = LanguageMgr.GetTranslation("ddt.league.moneyTypeTxt");
      
      private var _value:int;
      
      private var _unit:int;
      
      public function Price(param1:int, param2:int)
      {
         super();
         this._value = param1;
         this._unit = param2;
      }
      
      public function clone() : Price
      {
         return new Price(this._value,this._unit);
      }
      
      public function get Value() : int
      {
         return this._value;
      }
      
      public function set Unit(param1:int) : void
      {
         this._unit = param1;
      }
      
      public function get Unit() : int
      {
         return this._unit;
      }
      
      public function get UnitToString() : String
      {
         if(this._unit == MONEY)
         {
            return MONEYTOSTRING;
         }
         if(this._unit == GOLD)
         {
            return GOLDTOSTRING;
         }
         if(this._unit == GESTE)
         {
            return GESTETOSTRING;
         }
         if(this._unit == SCORE || this._unit == WORLDBOSS_SCORE)
         {
            return SCORETOSTRING;
         }
         if(this._unit == DDT_MONEY)
         {
            return DDTMONEYTOSTRING;
         }
         if(this._unit == NEW_DDT_MONEY)
         {
            return NEWDDTMONEYTOSTRING;
         }
         if(this._unit == HARD_CURRENCY)
         {
            return HARD_CURRENCY_TO_STRING;
         }
         if(this._unit == PETSCORE)
         {
            return PETSCORETOSTRING;
         }
         if(this._unit == LIGHT_STONE)
         {
            return LIGHT_STONE_STRING;
         }
         if(Boolean(ItemManager.Instance.getTemplateById(this._unit)))
         {
            return ItemManager.Instance.getTemplateById(this._unit).Name;
         }
         if(this._unit == LEAGUE)
         {
            return LEAGUESTRING;
         }
         return LanguageMgr.GetTranslation("wrongUnit");
      }
   }
}

