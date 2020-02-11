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
  Label,
  Select
} from "bloomer";

import DatapairGroup from "../components/datapairGroup";
import Layout from "../components/layout";
import React from "react";
import SubDescription from "../components/subscriptions/description";
import SubDetail from "../components/subscriptions/detail";
import SubName from "../components/subscriptions/name";
import { format } from "timeago.js";
import { observer } from "mobx-react";
import store from "../stores";

interface KlassInterface {
  video: any;
}

const VideoCard = observer((video: any) => {
  return (
    <Card>
      <CardImage>
        <Image src={video.thumbnailUrl} />
      </CardImage>
      <CardContent>
        <Content>{video.title}</Content>
        <Columns>
          <Column>
            <DatapairGroup
              pairs={{
                Published: format(video.publishedAt),
                "Last Updated": format(video.updatedAt)
              }}
            />
          </Column>
          <Column>
            <DatapairGroup
              pairs={{
                status: video.status,
                Duration: `${(video.duration / 60).toFixed(2)} min`
              }}
            />
          </Column>
        </Columns>
      </CardContent>
    </Card>
  );
});

const content = (filterSubscriptionId: number) => {
  if (!filterSubscriptionId) {
    return undefined;
  }

  const s = store.subscriptions.fromId(store.videos.filterSubscriptionId);

  return (
    <div>
      <hr />

      <Columns>
        <Column>
          <SubName subscription={s} />
          <SubDetail subscription={s} />
        </Column>
        <Column>
          <SubDescription subscription={s} />
        </Column>
      </Columns>

      <hr />

      <div className="card-columns columns-4-desktop columns-3-tablet columns-2-mobile">
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
        <Column isSize="1/2" hasTextAlign="right">
          <Label>Subscription</Label>
        </Column>
        <Column isSize="1/2">
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
                <option value={undefined}></option>
                {store.subscriptions.all.map((s, i) => (
                  <option key={i} value={s.id}>
                    {s.title}
                  </option>
                ))}
              </Select>
            </Control>
          </Field>
        </Column>
      </Columns>

      {content(store.videos.filterSubscriptionId)}
    </Layout>
  );
});
