import { Column, Columns } from "bloomer";

import DatapairGroup from "../datapairGroup";
import React from "react";
import { format } from "timeago.js";

export default (props: any) => {
  const s = props.subscription;

  return (
    <Columns>
      <Column>
        <DatapairGroup
          pairs={{
            Source: s.source,
            "Last Updated": format(s.updatedAt)
          }}
        />
      </Column>
      <Column>
        <DatapairGroup
          pairs={{
            Videos: `${s.videosKnown} seen of ${s.videoCount} total`,
            Downloads: `${s.videosDownloaded} ready of ${s.keepCount} scheduled`
          }}
        />
      </Column>
    </Columns>
  );
};
