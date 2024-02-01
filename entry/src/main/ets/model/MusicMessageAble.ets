
import rpc from '@ohos.rpc';

/**
 * Music Message
 */
export class MusicMessageAble implements rpc.Parcelable {
  status: string = 'success';

  setStatus(status: string) {
    this.status = status;
  }

  marshalling(messageSequence: rpc.MessageSequence) {
    messageSequence.writeString(this.status);
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence) {
    this.status = messageSequence.readString();
    return true;
  }
}