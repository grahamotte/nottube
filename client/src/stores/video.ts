import { computed, observable } from "mobx";

export default class Video {
  @observable id: number = 0;
  @observable subscriptionId: number = 0;
  @observable remoteId: string = "";
  @observable title: string = "";
  @observable thumbnailUrl: string = "";
  @observable description: string = "";
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
    this.description = params.description || "No Description";
    this.duration = params.duration;
    this.createdAt = params.created_at;
    this.updatedAt = params.updated_at;
    this.scheduled = params.scheduled;
    this.downloaded = params.downloaded;
  }

  @computed get status() {
    if (this.downloaded) {
      return "Downloaded";
    }

    if (this.scheduled) {
      return "Scheduled";
    }

    return undefined;
  }
}
