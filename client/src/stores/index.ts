import Jobs from "./jobs";
import Settings from "./settings";
import Subscriptions from "./subscriptions";
import Ui from "./ui";
import { observable } from "mobx";

class Klass {
  @observable ui = new Ui();
  @observable subscriptions = new Subscriptions();
  @observable jobs = new Jobs();
  @observable settings = new Settings();
}

export default new Klass();
