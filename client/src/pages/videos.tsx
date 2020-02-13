import {
  Card,
  CardContent,
  CardImage,
  Column,
  Columns,
  Content,
  Control,
  Field,
  Image,
  Select
} from "bloomer";

import BigSmall from "../components/bigSmall";
import DatapairGroup from "../components/datapairGroup";
import Layout from "../components/layout";
import React from "react";
import SubDescription from "../components/subscriptions/description";
import SubDetail from "../components/subscriptions/detail";
import SubName from "../components/subscriptions/name";
import colors from "../utils/colors";
import { format } from "timeago.js";
import { observer } from "mobx-react";
import store from "../stores";

const VideoCard = observer((props: any) => {
  return (
    <Card>
      <CardImage>
        <Image src={props.video.thumbnailUrl} />
      </CardImage>
      <CardContent style={{ overflow: "hidden" }}>
        <Content>{props.video.title}</Content>
        {store.ui.persistent.videosSize === "small" && (
          <Content> {props.video.status}</Content>
        )}
      </CardContent>
      {store.ui.persistent.videosSize === "large" && (
        <Content
          style={{
            whiteSpace: "pre-wrap",
            wordWrap: "break-word",
            maxHeight: "20em",
            overflow: "auto",
            padding: "1.5em",
            backgroundColor: props.color || "white",
            margin: 0
          }}
        >
          {props.video.description}
        </Content>
      )}
      {store.ui.persistent.videosSize === "large" && (
        <CardContent style={{ overflow: "hidden" }}>
          <DatapairGroup
            pairs={{
              Status: props.video.status,
              Duration: `${(props.video.duration / 60).toFixed(2)} min`,
              Published: format(props.video.publishedAt),
              ID: props.video.remoteId,
              Updated: format(props.video.updatedAt)
            }}
          />
        </CardContent>
      )}
    </Card>
  );
});

const content = (filterSubscriptionId: number) => {
  if (!Number(filterSubscriptionId)) {
    return (
      <div className="has-text-centered">
        <i>Select a subscription to show videos</i>
      </div>
    );
  }

  const s = store.subscriptions.fromId(store.videos.filterSubscriptionId);

  var columnClass =
    "card-columns columns-4-desktop columns-2-tablet columns-1-mobile";
  if (store.ui.persistent.videosSize === "large") {
    columnClass =
      "card-columns columns-2-desktop columns-2-tablet columns-1-mobile";
  }

  return (
    <div>
      <Columns>
        <Column>
          <Columns>
            <Column>
              <SubName subscription={s} />
            </Column>
          </Columns>
          <Columns>
            <Column>
              <SubDetail subscription={s} />
            </Column>
          </Columns>
        </Column>
        <Column>
          <SubDescription subscription={s} />
        </Column>
      </Columns>

      <hr />

      <div className={columnClass}>
        {store.videos.filteredResults.map((v, i) => {
          return <VideoCard key={i} video={v} />;
        })}
      </div>
    </div>
  );
};

export default observer(() => {
  return (
    <Layout>
      <Columns className="is-flex is-vcentered">
        <Column isSize="2/3">
          <Field>
            <Control>
              <Select
                isColor="primary"
                value={store.videos.filterSubscriptionId}
                onChange={event => {
                  let element = event.currentTarget as HTMLInputElement;
                  store.videos.setFilterSubcriptionId(element.value as any);
                }}
              >
                <option value={0}>Subscription</option>
                {store.subscriptions.all.map((s, i) => (
                  <option key={i} value={s.id}>
                    {s.title}
                  </option>
                ))}
              </Select>
            </Control>
          </Field>
        </Column>
        <Column isSize="1/3" hasTextAlign="right">
          <BigSmall
            onBig={() => store.ui.setPersistent("videosSize", "large")}
            isBig={store.ui.persistent.videosSize === "large"}
            onSmall={() => store.ui.setPersistent("videosSize", "small")}
            isSmall={store.ui.persistent.videosSize === "small"}
          />
        </Column>
      </Columns>

      {content(store.videos.filterSubscriptionId)}
    </Layout>
  );
});
