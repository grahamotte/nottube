import DatapairGroup from "../datapairGroup";
import React from "react";
import { format } from "timeago.js";

export default (props: any) => {
  const s = props.subscription;

  return (
    <DatapairGroup
      pairs={{
        Videos: `${s.videosKnown} seen,  ${s.videoCount} total`,
        Downloads: `${s.videosDownloaded} downloaded, ${s.keepCount} scheduled`,
        Source: s.source,
        Updated: format(s.updatedAt)
      }}
    />
  );
};
