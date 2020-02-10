import { action, observable } from "mobx";

import Subscription from "./subscription";
import axios from "axios";
import host from "../utils/apiHost";
import store from "./index";

export default class Klass {
  @observable all: Subscription[] = [];

  constructor() {
    this.refresh();
  }

  fromId = (id: number) => {
    return this.all.find(x => Number(x.id) === Number(id));
  };

  @action refresh = () => {
    axios
      .get(`${host}/subscriptions`)
      .then(response => {
        this.all = response.data.map((s: any) => new Subscription(s));
      })
      .catch(() => {
        store.ui.errorNotification("Unable to load subscriptions");
      });
  };

  @action update = (params: any) => {
    if (!params.id) {
      return;
    }

    const existing = this.all.find(x => x.id === params.id);

    if (existing) {
      existing.setParams(params);
    } else {
      this.all.push(new Subscription(params));
    }
  };
}
