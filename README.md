# PLEXTUBE

Plextube is a subscription manager and video downloader for youtube and nebula. Videos are saved in a plex-parsable format allowing plex to be a full-featured frontend for your video subscriptions.

<img width="100%" alt="Screen Shot 2020-02-01 at 1 55 05 PM" src="https://user-images.githubusercontent.com/6063967/73599660-9f19c380-44fa-11ea-80ee-9be0892925f0.png">

Build:
```
docker-compose up
```

Deploy:
```
export API_HOST=<your server>
export DATA_DIR=<videos path>
docker-compose -H "ssh://<user>@<your server>" up --build --detach
```

---

![](https://github.com/grahamotte/plextube/workflows/Test/badge.svg)
