@Observed
export class PlayControlModel {
  icon: Resource;
  key?: string;

  constructor(icon: Resource, key?: string) {
    this.icon = icon;
    this.key = key;
  }
}