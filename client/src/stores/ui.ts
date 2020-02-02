import { action, observable } from "mobx";

import { toast } from "react-toastify";

export default class Klass {
  @observable page: string = "subscriptions";
  @observable seed: number = Math.random();

  constructor() {
    setInterval(this.resetSeed, 1000);
  }

  @action resetSeed = () => (this.seed = Math.random());

  @action successNotification = (notification: string) => {
    toast(notification, { type: "success" });
  };

  @action errorNotification = (notification: string) => {
    toast(notification, { type: "error" });
  };
}
