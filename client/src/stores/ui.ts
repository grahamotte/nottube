import { action, observable } from "mobx";

import { toast } from "react-toastify";

export default class Klass {
  @observable page: string = "subscriptions";
  @observable seed: number = Math.random();
  @observable persistent: { [key: string]: string } = {};
  persistentDefaults: { [key: string]: string } = {
    videosSize: "small",
    subscriptionsSize: "small"
  };

  constructor() {
    Object.keys(this.persistentDefaults).forEach((k: string) => {
      this.persistent[k] =
        localStorage.getItem(k) || this.persistentDefaults[k];
    });
  }

  getPersistent(key: string) {
    return this.persistent[key];
  }

  @action setPersistent = (key: string, value: string) => {
    localStorage.setItem(key, value);
    this.persistent[key] = value;
  };

  @action resetSeed = () => (this.seed = Math.random());

  @action successNotification = (notification: string) => {
    toast(notification, { type: "success" });
  };

  @action errorNotification = (notification: string) => {
    toast(notification, { type: "error" });
  };
}
