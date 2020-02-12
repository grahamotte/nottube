import {
  Button,
  Card,
  CardContent,
  CardImage,
  Column,
  Columns,
  Content,
  Control,
  Field,
  Image,
  Label,
  Select
} from "bloomer";
import { FaTh, FaThLarge } from "react-icons/fa";

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

const Code = observer((props: any) => {
  return (
    <Content
      style={{
        borderTop: `1px solid ${colors.lightGray}`,
        borderBottom: `1px solid ${colors.lightGray}`,
        whiteSpace: "pre-wrap",
        wordWrap: "break-word",
        maxHeight: "10em",
        overflow: "auto",
        padding: "1.5em",
        backgroundColor: props.color || "white"
      }}
    >
      {props.children}
    </Content>
  );
});

const VideoCard = observer((props: any) => {
  return (
    <Card>
      <CardImage>
        <Image src={props.video.thumbnailUrl} />
      </CardImage>
      <CardContent style={{ overflow: "hidden" }}>
        <Content>{props.video.title}</Content>
      </CardContent>
      {store.ui.videosSize === "large" && (
        <Content
          style={{
            borderTop: `1px solid ${colors.lightGray}`,
            borderBottom: `1px solid ${colors.lightGray}`,
            whiteSpace: "pre-wrap",
            wordWrap: "break-word",
            maxHeight: "10em",
            overflow: "auto",
            padding: "1.5em",
            backgroundColor: props.color || "white"
          }}
        >
          {props.video.description}
        </Content>
      )}
      {store.ui.videosSize === "large" && (
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
  if (store.ui.videosSize === "large") {
    columnClass =
      "card-columns columns-2-desktop columns-2-tablet columns-1-mobile";
  }

  return (
    <div>
      <hr />

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
          <span
            className="buttons has-addons"
            style={{ textAlign: "right", display: "block" }}
          >
            <Button
              isOutlined
              onClick={() => (store.ui.videosSize = "small")}
              isHovered={store.ui.videosSize === "small"}
            >
              <FaTh />
            </Button>
            <Button
              isOutlined
              onClick={() => (store.ui.videosSize = "large")}
              isHovered={store.ui.videosSize === "large"}
            >
              <FaThLarge />
            </Button>
          </span>
        </Column>
      </Columns>

      {content(store.videos.filterSubscriptionId)}
    </Layout>
  );
});
