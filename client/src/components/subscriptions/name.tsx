import { Media, MediaContent, MediaLeft, Subtitle, Title } from "bloomer";

import React from "react";
import { observer } from "mobx-react";

const abreviateNumber = (value: number) => {
  var length = (value + "").length,
    index = Math.ceil((length - 3) / 3),
    suffix = ["K", "M", "B", "T"];

  if (length < 4) return value;
  return (value / Math.pow(1000, index)).toFixed(1) + suffix[index - 1];
};

export default observer((props: any) => {
  return (
    <Media>
      <MediaLeft>
        <img
          width="50px"
          height="50px"
          src={props.subscription.thumbnailUrl}
          style={{ borderRadius: "50%" }}
          alt="subscription thumbnail"
        />
      </MediaLeft>
      <MediaContent>
        <a href={props.subscription.url}>
          <small>
            <Title isSize={4}>{props.subscription.title}</Title>
            {props.subscription.subscriberCount && (
              <Subtitle>
                <i>
                  {abreviateNumber(props.subscription.subscriberCount)} subs
                </i>
              </Subtitle>
            )}
          </small>
        </a>
      </MediaContent>
    </Media>
  );
});
