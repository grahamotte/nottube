import Jobs from './jobs'
import Subscriptions from './subscriptions'
import Ui from './ui'
import { observable } from "mobx";

class Klass {
  @observable ui = new Ui()
  @observable subscriptions = new Subscriptions()
  @observable jobs = new Jobs()
}

export default new Klass()
