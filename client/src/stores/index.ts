import Jobs from "./jobs";
import Settings from "./settings";
import Subscriptions from "./subscriptions";
import Ui from "./ui";
import Videos from "./videos";
import { observable } from "mobx";

class Klass {
  @observable ui = new Ui();
  @observable subscriptions = new Subscriptions();
  @observable videos = new Videos();
  @observable jobs = new Jobs();
  @observable settings = new Settings();
}

export default new Klass();
