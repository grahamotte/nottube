import DatapairGroup from "../datapairGroup";
import React from "react";
import { format } from "timeago.js";
import { observer } from "mobx-react";

export default observer((props: any) => {
  const s = props.subscription;

  return (
    <DatapairGroup
      pairs={{
        ID: s.remoteId,
        Videos: `${s.videosKnown} seen of ${s.videoCount || "?"} total`,
        Downloads: `${s.videosDownloaded} ready of ${s.videosScheduled} scheduled`,
        "Last Updated": format(s.updatedAt)
      }}
    />
  );
});
