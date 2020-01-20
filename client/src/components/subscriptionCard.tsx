import {
  Box,
  Card,
  CardContent,
  CardFooter,
  CardFooterItem,
  Column,
  Columns,
  Content,
  Image,
  Media,
  MediaContent,
  MediaLeft,
  Modal,
  ModalBackground,
  ModalContent,
  Table,
  Tag,
  Title
} from "bloomer";

import DatapairGroup from "./datapairGroup";
import React from "react";
import { format } from "timeago.js";
import { observer } from "mobx-react";

interface KlassInterface {
  s: any;
}

export default observer(
  class Klass extends React.Component<KlassInterface> {
    state = {
      videosActive: false
    };

    videoRow = (v: any, vi: number) => {
      var description = "";
      if (v.description) {
        description = `${v.description.substring(0, 250)} ${
          v.description.length > 250 ? "..." : ""
        }`;
      }

      var downloadTag;
      if (v.downloaded) {
        downloadTag = <Tag isColor="success">Downloaded</Tag>;
      } else if (v.toDownload) {
        downloadTag = <Tag isColor="info">Scheduled for download</Tag>;
      } else {
        downloadTag = <Tag isColor="warning">Not downloaded</Tag>;
      }

      return (
        <tr key={vi}>
          <td style={{ width: "10%" }}>
            <Image isSize="128x128" src={v.thumbnailUrl}></Image>
          </td>

          <td>
            <DatapairGroup
              pairs={{
                ID: v.videoId,
                Duration: `${(v.duration / 60).toFixed(2)} min`,
                Published: format(v.publishedAt)
              }}
            />
            {downloadTag}
          </td>

          <td style={{ width: "50%" }}>
            <small>
              <b>{v.title}</b> {description}
            </small>
          </td>
        </tr>
      );
    };

    render() {
      const s = this.props.s;

      const nameAndThumb = (
        <Media>
          <MediaLeft>
            <Image isSize="48x48" src={s.thumbnailUrl} />
          </MediaLeft>
          <MediaContent>
            <a href={s.url}>
              <Title isSize={4}>{s.title}</Title>
            </a>
          </MediaContent>
        </Media>
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
              <Content style={{ overflow: "hidden" }}>
                <small>{s.description}</small>
              </Content>
              <Content>{subData}</Content>
            </CardContent>
            <CardFooter>
              <CardFooterItem
                href="#"
                onClick={() => {
                  s.getVideos();
                  this.setState({ videosActive: true });
                }}
              >
                Videos
              </CardFooterItem>
              <CardFooterItem href="#">Delete</CardFooterItem>
            </CardFooter>
          </Card>

          <Modal isActive={this.state.videosActive}>
            <ModalBackground
              onClick={() => this.setState({ videosActive: false })}
            />
            <ModalContent style={{ width: "80%" }}>
              <Box>
                <Columns>
                  <Column>{nameAndThumb}</Column>
                  <Column>{subData}</Column>
                </Columns>
                <hr />
                <Table>
                  <tbody>
                    {s.videos.map((v: any, vi: number) => this.videoRow(v, vi))}
                  </tbody>
                </Table>
              </Box>
            </ModalContent>
          </Modal>
        </div>
      );
    }
  }
);
