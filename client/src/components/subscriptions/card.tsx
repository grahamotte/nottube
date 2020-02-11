import {
  Card,
  CardContent,
  CardFooter,
  CardFooterItem,
  Content
} from "bloomer";
import {
  FaCheck,
  FaList,
  FaMinus,
  FaRegTrashAlt,
  FaSync
} from "react-icons/fa";

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
      syncing: false,
      deleting: false
    };

    render() {
      const sync = (
        <CardFooterItem
          href="#"
          style={{ color: colors.text }}
          onClick={() => {
            axios
              .post(`${host}/subscriptions/${this.props.subscription.id}/sync`)
              .then(response => {
                this.setState({ syncing: true });
              })
              .catch(() => {
                store.ui.errorNotification(
                  `Sync request for ${this.props.subscription.title} failed!`
                );
              });
          }}
        >
          {this.state.syncing ? <FaCheck /> : <FaSync />}
        </CardFooterItem>
      );

      const videos = (
        <CardFooterItem
          href="#"
          onClick={() => {
            store.ui.page = "videos";
            store.videos.setFilterSubcriptionId(this.props.subscription.id);
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
              .delete(`${host}/subscriptions/${this.props.subscription.id}`)
              .then(() => {
                store.subscriptions.refresh();
                this.setState({ deleting: false });
              })
              .catch(() => {
                store.ui.errorNotification(
                  `Delete for ${this.props.subscription.title} failed! Some files may still remain.`
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
          <CardContent>
            <Name subscription={this.props.subscription} />
            <Description subscription={this.props.subscription} />
            <Content>
              <Detail subscription={this.props.subscription} />
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
