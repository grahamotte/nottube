import { action, computed, observable } from "mobx";

import store from "./index";

export default class Klass {
  @observable filterSubscriptionId: number = 0;

  @action setFilterSubcriptionId = (newId: number) => {
    const sub = store.subscriptions.fromId(newId);

    if (sub) {
      sub.getVideos();
    }

    this.filterSubscriptionId = newId;
  };

  @computed get filteredResults() {
    const sub = store.subscriptions.fromId(this.filterSubscriptionId);

    if (!sub) {
      return [];
    }

    return sub.videos;
  }
}
