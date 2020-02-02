import { action, observable } from "mobx";

import axios from "axios";
import host from "../utils/apiHost";
import store from "./index";

export default class Klass {
  @observable attrs: { [key: string]: string } = {};

  get(key: string) {
    return this.attrs[key];
  }

  @action set = (key: string, value: string) => {
    this.attrs[key] = value;
  };

  @action refresh = () => {
    axios
      .get(`${host}/settings`)
      .then(response => {
        this.attrs = response.data;
      })
      .catch(() => {
        store.ui.errorNotification("Unable to load settings");
      });
  };
}
