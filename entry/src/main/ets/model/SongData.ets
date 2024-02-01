
/**
 * Music information entity class.
 */
export class SongItem {
  /**
   * Primary key ID.
   */
  id: number = 0;

  /**
   * Music name.
   */
  title: string = '';

  /**
   * Music author name.
   */
  singer: string = '';

  /**
   * Music logo information.
   */
  mark: Resource = $r('app.media.ic_vip');

  /**
   * Music avatar information.
   */
  label: Resource = $r('app.media.ic_avatar1');

  /**
   * Music file path information.
   */
  src: string = '';

  /**
   * Index of the current music list.
   */
  index: number = 0;
}
