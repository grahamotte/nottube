import { action, observable } from "mobx";

export default class Klass {
  @observable page: string = "subscriptions";
  @observable seed: number = Math.random();
  @observable notification: string = "";
  @observable notificationType: string = "";

  constructor() {
    setInterval(this.resetSeed, 1000);
  }

  @action resetSeed = () => (this.seed = Math.random());

  @action clearNotification = () => {
    this.notification = "";
    this.notificationType = "";
  };

  @action successNotification = (notification: string) => {
    this.notification = notification;
    this.notificationType = "success";
  };

  @action errorNotification = (notification: string) => {
    this.notification = notification;
    this.notificationType = "danger";
  };
}
