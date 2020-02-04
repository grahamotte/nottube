import { action, computed, observable } from "mobx";

export default class Video {
  @observable id: number = 0;
  @observable subscriptionId: number = 0;
  @observable remoteId: string = "";
  @observable title: string = "";
  @observable thumbnailUrl: string = "";
  @observable descriptionText: string = "";
  @observable duration: number = 0;
  @observable publishedAt: string = "";
  @observable createdAt: string = "";
  @observable updatedAt: string = "";
  @observable scheduled: boolean = false;
  @observable downloaded: boolean = false;

  constructor(params: any) {
    this.id = params.id;
    this.subscriptionId = params.subscription_id;
    this.remoteId = params.remote_id;
    this.publishedAt = params.published_at;
    this.title = params.title;
    this.thumbnailUrl = params.thumbnail_url;
    this.descriptionText = params.description;
    this.duration = params.duration;
    this.createdAt = params.created_at;
    this.updatedAt = params.updated_at;
    this.scheduled = params.scheduled;
    this.downloaded = params.downloaded;
  }

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
}
