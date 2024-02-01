
import { MediaService } from './MediaService';

export class CardControlUtil {
  /**
   * Control by message.
   *
   * @param {string} message ,{number} index.
   */
  controlByMessage(message: string, index: number): void {
    switch (message) {
      case 'play':
        if (MediaService.getInstance().getFirst()) {
          MediaService.getInstance().loadAssent(0)
        } else {
          MediaService.getInstance().play();
        }
        break;
      case 'pause':
        MediaService.getInstance().pause();
        break;
      case 'next':
        MediaService.getInstance().playNextAuto(true);
        break;
      case 'last':
        MediaService.getInstance().playPrevious();
        break;
      case 'index':
        MediaService.getInstance().loadAssent(index);
        break;
      default:
        break;
    }
  }
}

let controlMusicPlayUtil = new CardControlUtil();

export default controlMusicPlayUtil as CardControlUtil;