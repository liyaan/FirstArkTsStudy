import { UserInfoBean } from './UserInfoBean'
export class PersonDynamicList {
  code: number
  message: string
  result: PersonDynamicBean
}

export class PersonDynamicBean {
  total: number
  list: Array<PersonDynamicBeanList>
}

export class PersonDynamicBeanList {
  id: number
  text: string
  images: Array<PersonDynamicBeanListImage>
  userInfo:UserInfoBean
}

export class PersonDynamicBeanListImage {
  url: string
}