import { action, observable } from "mobx";

import Subscription from './subscription'
import axios from 'axios'
import host from '../utils/apiHost'
import store from './index'

export default class Klass {
  @observable all : Subscription[] = []

  constructor() {
    this.refresh()
  }

  @action refresh = () => {
    axios.get(`${host}/subscriptions`)
    .then(response => {
      this.all = response.data.map((s : any) => new Subscription(s))
    })
    .catch(() => {
      store.ui.errorNotification("Unable to load subscriptions")
    })
  }
}
