import { action, observable } from "mobx";

import Subscription from './subscription'
import axios from 'axios'
import store from './index'

export default class Klass {
  @observable all : Subscription[] = []

  constructor() {
    this.refresh()
  }

  @action refresh = () => {
    axios.get('http://localhost:3001/subscriptions')
    .then(response => {
      this.all = response.data.map((s : any) => new Subscription(s))
    })
    .catch(() => {
      store.ui.errorNotification("Unable to load subscriptions")
    })
  }
}
