import { action, observable } from "mobx";

export default class Klass {
  @observable page : string = 'subscriptions'
  @observable notification : string = ''
  @observable notificationType : string = ''

  @action clearNotification = () => {
    this.notification = ''
    this.notificationType = ''
  }

  @action successNotification = (notification : string) => {
    this.notification = notification
    this.notificationType = 'success'
  }

  @action errorNotification = (notification : string) => {
    this.notification = notification
    this.notificationType = 'danger'
  }
}
