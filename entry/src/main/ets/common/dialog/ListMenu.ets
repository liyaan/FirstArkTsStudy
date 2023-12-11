/**
 * 菜单
 */
export interface ListMenu {
  id: string;
  text: string | Resource;
  icon?: Resource;
  fontColor?: ResourceColor;
  onItemClick?: () => void;
}
