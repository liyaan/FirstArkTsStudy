/**
 * Comment entity class.
 */
export class Comment {
  /**
   * Comment nickname.
   */
  nickname: string;

  /**
   * Comment content.
   */
  content: string;

  /**
   * Comment time.
   */
  time: string;

  /**
   * Comment image.
   */
  icon: ResourceStr;

  /**
   * Reply to a list of comments.
   */
  commentList?: Comment[];

  constructor(nickname: string, content: string, time: string, icon: ResourceStr, commentList?: Comment[]) {
    this.nickname = nickname;
    this.content = content;
    this.time = time;
    this.icon = icon;
    this.commentList = commentList;
  }
}