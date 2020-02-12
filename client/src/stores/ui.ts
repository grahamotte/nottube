import { action, observable } from "mobx";

import { toast } from "react-toastify";

export default class Klass {
  @observable page: string = "videos";
  @observable seed: number = Math.random();
  @observable videosSize = "small";

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
