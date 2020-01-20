import { action, observable } from "mobx";

import axios from 'axios'
import store from './index'

export default class Klass {
  @observable all = []

  @action refresh = () => {
    axios.get('http://localhost:3000/jobs')
    .then(response => {
      this.all = response.data
    })
    .catch(() => {
      store.ui.errorNotification("Unable to load jobs")
    })
  }
}
