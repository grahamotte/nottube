import { action, computed, observable } from "mobx";

import Video from "./video";
import axios from "axios";
import host from "../utils/apiHost";
import store from "./index";

export default class Subscription {
  @observable id: number = 0;
  @observable remoteId: string = "";
  @observable url: string = "";
  @observable title: string = "";
  @observable thumbnailUrl: string = "";
  @observable descriptionText: string = "";
  @observable videoCount: number = 0;
  @observable updatedAt: string = "";
  @observable subscriberCount: number = 0;
  @observable videos: Video[] = [];
  @observable videosKnown: number = 0;
  @observable videosDownloaded: number = 0;
  @observable videosScheduled: number = 0;
  @observable keepCount: number = 0;
  @observable source: boolean = false;

  constructor(params: any) {
    this.setParams(params);
  }

  @action setParams = (params: any) => {
    this.id = params.id;
    this.remoteId = params.remote_id;
    this.url = params.url;
    this.title = params.title;
    this.thumbnailUrl = params.thumbnail_url;
    this.descriptionText = params.description;
    this.videoCount = params.video_count;
    this.updatedAt = params.updated_at;
    this.subscriberCount = params.subscriber_count;
    this.videosKnown = params.videos_known;
    this.videosDownloaded = params.videos_downloaded;
    this.videosScheduled = params.videos_scheduled;
    this.keepCount = params.keep_count;
    this.source = params.source;
  };

  @computed
  get description() {
    const maxLen = 1000;

    if (this.descriptionText) {
      return `${this.descriptionText.substring(0, maxLen)} ${
        this.descriptionText.length > maxLen ? "..." : ""
      }`;
    }

    return "No Description";
  }

  @action getVideos = () => {
    axios
      .get(`${host}/videos?subscription_id=${this.id}`)
      .then(response => {
        this.videos = response.data.map((v: any) => new Video(v));
      })
      .catch(() => {
        store.ui.errorNotification(`Unable to load videos for ${this.title}`);
      });
  };
}
