import {
  Card,
  CardContent,
  CardFooter,
  CardFooterItem,
  Content
} from "bloomer";
import { FaList, FaMinus, FaRegTrashAlt, FaSync } from "react-icons/fa";

import Description from "./description";
import Detail from "./detail";
import Name from "./name";
import React from "react";
import axios from "axios";
import colors from "../../utils/colors";
import host from "../../utils/apiHost";
import { observer } from "mobx-react";
import store from "../../stores";

interface KlassInterface {
  subscription: any;
}

export default observer(
  class Klass extends React.Component<KlassInterface> {
    state = {
      deleting: false
    };

    render() {
      const s = this.props.subscription;

      const sync = (
        <CardFooterItem
          href={s.syncing ? undefined : "#"}
          style={{ color: colors.text }}
          onClick={() => {
            if (s.syncing) {
              return;
            }

            axios
              .post(`${host}/subscriptions/${s.id}/sync`)
              .then(() => (s.syncing = true))
              .catch(() => {
                store.ui.errorNotification(
                  `Sync request for ${s.title} failed!`
                );
              });
          }}
        >
          <FaSync className={s.syncing ? "spin" : ""} />
        </CardFooterItem>
      );

      const videos = (
        <CardFooterItem
          href="#"
          onClick={() => {
            store.ui.page = "videos";
            store.videos.setFilterSubcriptionId(s.id);
          }}
          style={{ color: colors.text }}
        >
          <FaList />
        </CardFooterItem>
      );

      const remove = (
        <CardFooterItem
          href="#"
          style={{ color: colors.text }}
          onClick={() => {
            this.setState({ deleting: true });

            axios
              .delete(`${host}/subscriptions/${s.id}`)
              .then(() => {
                store.subscriptions.refresh();
                this.setState({ deleting: false });
              })
              .catch(() => {
                store.ui.errorNotification(
                  `Delete for ${s.title} failed! Some files may still remain.`
                );
                this.setState({ deleting: false });
              });
          }}
        >
          {this.state.deleting ? <FaMinus /> : <FaRegTrashAlt />}
        </CardFooterItem>
      );

      return (
        <Card>
          <CardContent style={{ overflow: "hidden" }}>
            <Name subscription={s} />
            {store.ui.persistent.subscriptionsSize == "small" &&
              `${s.videosDownloaded} ready of ${s.videosScheduled} scheduled`}
            {store.ui.persistent.subscriptionsSize == "large" && (
              <Description subscription={s} />
            )}
            <Content>
              {store.ui.persistent.subscriptionsSize == "large" && (
                <Detail subscription={s} />
              )}
            </Content>
          </CardContent>
          <CardFooter>
            {sync}
            {videos}
            {remove}
          </CardFooter>
        </Card>
      );
    }
  }
);
