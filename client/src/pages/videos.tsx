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
import { format } from "timeago.js";
import { observer } from "mobx-react";
import store from "../stores";

const SmallVideoCard = observer((props: any) => {
  return (
    <Card>
      <CardImage>
        <Image src={props.video.thumbnailUrl} />
      </CardImage>
      {props.video.status && (
        <CardContent style={{ overflow: "hidden" }}>
          <Content>{props.video.status}</Content>
        </CardContent>
      )}
    </Card>
  );
});

const LargeVideoCard = observer((props: any) => {
  return (
    <Card>
      <CardImage>
        <Image src={props.video.thumbnailUrl} />
      </CardImage>
      <CardContent style={{ overflow: "hidden" }}>
        <Content>
          <b>{props.video.title}</b>
        </Content>
      </CardContent>
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
        <small>{props.video.description}</small>
      </Content>
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

      <Columns isMultiline>
        {store.videos.filteredResults.map((v, i) => {
          return (
            <Column
              key={i}
              isSize={
                store.ui.persistent.videosSize === "large" ? "1/3" : "1/4"
              }
            >
              {store.ui.persistent.videosSize === "large" ? (
                <LargeVideoCard video={v} />
              ) : (
                <SmallVideoCard video={v} />
              )}
            </Column>
          );
        })}
      </Columns>
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
