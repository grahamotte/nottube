import { action, computed, observable } from "mobx";

import axios from 'axios'
import store from './index'

class Video {
  @observable id : number = 0
  @observable subscriptionId : number = 0
  @observable videoId : string = ''
  @observable title : string = ''
  @observable thumbnailUrl : string = ''
  @observable descriptionText : string = ''
  @observable duration : number = 0
  @observable publishedAt : string = ''
  @observable createdAt : string = ''
  @observable updatedAt : string = ''
  @observable toDownload : boolean = false
  @observable downloaded : boolean = false

  constructor(params : any) {
    this.id = params.id
    this.subscriptionId = params.subscription_id
    this.videoId = params.video_id
    this.publishedAt = params.published_at
    this.title = params.title
    this.thumbnailUrl = params.thumbnail_url
    this.descriptionText = params.description
    this.duration = params.duration
    this.createdAt = params.created_at
    this.updatedAt = params.updated_at
    this.toDownload = params.to_download
    this.downloaded = params.downloaded
  }

  @computed
  get description() {
    const maxLen = 250

    if (this.descriptionText) {
      return `${this.descriptionText.substring(0, maxLen)} ${this.descriptionText.length > maxLen ? "..." : ""}`;
    }

    return 'No Description'
  }
}

export default class Subscription {
  @observable id : number = 0
  @observable channelId : string = ''
  @observable url : string = ''
  @observable title : string = ''
  @observable thumbnailUrl : string = ''
  @observable descriptionText : string = ''
  @observable videoCount : number = 0
  @observable updatedAt : string = ''
  @observable subscriberCount : number = 0
  @observable videos : Video[] = []

  constructor(params : any) {
    this.id = params.id
    this.channelId = params.channel_id
    this.url = params.url
    this.title = params.title
    this.thumbnailUrl = params.thumbnail_url
    this.descriptionText = params.description
    this.videoCount = params.video_count
    this.updatedAt = params.updated_at
    this.subscriberCount = params.subscriber_count
  }

  @computed
  get description() {
    const maxLen = 350

    if (this.descriptionText) {
      return `${this.descriptionText.substring(0, maxLen)} ${this.descriptionText.length > maxLen ? "..." : ""}`;
    }

    return 'No Description'
  }

  @action getVideos = () => {
    axios
      .get(`http://localhost:3001/videos?subscription_id=${this.id}`)
      .then(response => {
        this.videos = response.data.map((v : any) => new Video(v))
      })
      .catch(() => {
        store.ui.errorNotification(`Unable to load videos for ${this.title}`)
      })
  }
}
