import {
  Card,
  CardContent,
  CardFooter,
  CardFooterItem,
  Column,
  Columns,
  Content,
  Media,
  MediaContent,
  MediaLeft,
  Modal,
  ModalBackground,
  ModalContent,
  Subtitle,
  Tag,
  Title
} from "bloomer";

import DatapairGroup from "./datapairGroup";
import React from "react";
import colors from "../utils/colors";
import { format } from "timeago.js";
import { observer } from "mobx-react";

const abreviateNumber = (value: number) => {
  var length = (value + "").length,
    index = Math.ceil((length - 3) / 3),
    suffix = ["K", "M", "B", "T"];

  if (length < 4) return value;
  return (value / Math.pow(1000, index)).toFixed(1) + suffix[index - 1];
};

interface KlassInterface {
  s: any;
}

export default observer(
  class Klass extends React.Component<KlassInterface> {
    state = {
      videosActive: false
    };

    videoRow = (v: any, vi: number) => {
      var downloadTag;
      if (v.downloaded) {
        downloadTag = <Tag isColor="success">Downloaded</Tag>;
      } else if (v.toDownload) {
        downloadTag = <Tag isColor="info">Scheduled for download</Tag>;
      } else {
        downloadTag = <Tag isColor="warning">Not downloaded</Tag>;
      }

      return (
        <Columns>
          <Column isSize="1/4">
            <img src={v.thumbnailUrl} alt="video thumbnail" />
          </Column>
          <Column isSize="1/4">
            <DatapairGroup
              pairs={{
                Duration: `${(v.duration / 60).toFixed(2)} min`,
                Published: format(v.publishedAt)
              }}
            />
            {downloadTag}
          </Column>
          <Column>
            <b>{v.title}</b>
            <p>
              <small>{v.description}</small>
            </p>
          </Column>
        </Columns>
      );
    };

    render() {
      const s = this.props.s;

      const nameAndThumb = (
        <Media>
          <MediaLeft>
            <img
              width="50px"
              height="50px"
              src={s.thumbnailUrl}
              style={{ borderRadius: "50%" }}
              alt="subscription thumbnail"
            />
          </MediaLeft>
          <MediaContent>
            <a href={s.url}>
              <small>
                <Title isSize={4}>{s.title}</Title>
                <Subtitle>
                  <i>{abreviateNumber(s.subscriberCount)} subs</i>
                </Subtitle>
              </small>
            </a>
          </MediaContent>
        </Media>
      );

      const description = (
        <Content style={{ overflow: "hidden" }}>
          <small>{s.description}</small>
        </Content>
      );

      const subData = (
        <DatapairGroup
          pairs={{
            Videos: s.videoCount,
            Updated: format(s.updatedAt)
          }}
        />
      );

      return (
        <div>
          <Card>
            <CardContent>
              {nameAndThumb}
              {description}
              <Content>{subData}</Content>
            </CardContent>
            <CardFooter>
              <CardFooterItem href="#" style={{ color: colors.text }}>
                Update
              </CardFooterItem>
              {s.videoCount > 0 && (
                <CardFooterItem
                  href="#"
                  onClick={() => {
                    s.getVideos();
                    this.setState({ videosActive: true });
                  }}
                  style={{ color: colors.text }}
                >
                  Videos
                </CardFooterItem>
              )}
              <CardFooterItem href="#" style={{ color: colors.danger }}>
                Remove
              </CardFooterItem>
            </CardFooter>
          </Card>

          <Modal isActive={this.state.videosActive}>
            <ModalBackground
              onClick={() => this.setState({ videosActive: false })}
            />
            <ModalContent style={{ width: "80%" }}>
              <Card>
                <CardContent>
                  <Columns>
                    <Column>
                      {nameAndThumb}
                      {subData}
                    </Column>
                    <Column>{description}</Column>
                  </Columns>
                  <hr />
                  {s.videos.map((v: any, vi: number) => this.videoRow(v, vi))}
                </CardContent>
              </Card>
            </ModalContent>
          </Modal>
        </div>
      );
    }
  }
);
