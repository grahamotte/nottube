import { Column, Columns, Control, Field, Input } from "bloomer";

import BigSmall from "../components/bigSmall";
import { FaCheck } from "react-icons/fa";
import Layout from "../components/layout";
import LoadedButton from "../components/loadedButton";
import React from "react";
import SubscriptionCard from "../components/subscriptions/card";
import host from "../utils/apiHost";
import { observer } from "mobx-react";
import store from "../stores";

class Klass extends React.Component {
  state = {
    addUrl: ""
  };

  render() {
    const allSyncing = store.subscriptions.all.every(s => s.syncing);

    return (
      <Layout>
        <Columns>
          <Column isSize="2/3">
            <Field hasAddons>
              <Control style={{ width: "100%" }}>
                <Input
                  type="text"
                  isColor="primary"
                  placeholder="Add by URL"
                  value={this.state.addUrl}
                  onChange={event => {
                    let element = event.currentTarget as HTMLInputElement;

                    this.setState({ addUrl: element.value });
                  }}
                />
              </Control>
              <Control>
                <LoadedButton
                  label="Add"
                  color="primary"
                  url={`${host}/subscriptions`}
                  method="post"
                  data={{ url: this.state.addUrl }}
                  then={() => {
                    store.subscriptions.refresh();
                    store.ui.successNotification(`Added ${this.state.addUrl}!`);
                  }}
                />
              </Control>
            </Field>
          </Column>
          <Column isSize="1/3" className="has-text-right">
            <LoadedButton
              label={allSyncing ? <FaCheck /> : "Sync All"}
              disabled={allSyncing}
              style={{ marginLeft: "0.25em" }}
              isColor="primary"
              isOutlined
              url={`${host}/subscriptions/sync_all`}
              method="post"
              then={() => {
                store.subscriptions.all
                  .sort((a: any, b: any) => a.title - b.title)
                  .forEach(s => (s.syncing = true));
                store.ui.successNotification("Syncing all subscriptions!");
              }}
            />
            <BigSmall
              onBig={() => store.ui.setPersistent("subscriptionsSize", "large")}
              isBig={store.ui.persistent.subscriptionsSize === "large"}
              onSmall={() =>
                store.ui.setPersistent("subscriptionsSize", "small")
              }
              isSmall={store.ui.persistent.subscriptionsSize === "small"}
            />
          </Column>
        </Columns>
        <Columns isMultiline>
          {store.subscriptions.all.map((s, si) => {
            return (
              <Column key={si} isSize="1/3">
                <SubscriptionCard subscription={s} />
              </Column>
            );
          })}
        </Columns>
      </Layout>
    );
  }
}

export default observer(Klass);
