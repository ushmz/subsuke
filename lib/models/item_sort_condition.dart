enum ItemSortCondition {
  None,
  PriceASC,
  PriceDESC,
  NextASC,
  NextDESC,
}

extension ItemSortConditionIDExt on ItemSortCondition {
  int get sortConditionID {
    switch (this) {
      case ItemSortCondition.None:
        return 0;
      case ItemSortCondition.PriceASC:
        return 1;
      case ItemSortCondition.PriceDESC:
        return 2;
      case ItemSortCondition.NextASC:
        return 3;
      case ItemSortCondition.NextDESC:
        return 4;
    }
  }
}

extension ItemSortConditionNameExt on ItemSortCondition {
  String get sortConditionName {
    switch (this) {
      case ItemSortCondition.None:
        return "";
      case ItemSortCondition.PriceASC:
        return "お支払い金額が小さい順";
      case ItemSortCondition.PriceDESC:
        return "お支払い金額が大きい順";
      case ItemSortCondition.NextASC:
        return "お支払日が近い順";
      case ItemSortCondition.NextDESC:
        return "お支払日が遠い順";
    }
  }
}
