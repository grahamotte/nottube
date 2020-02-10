import { Column, Columns, Control, Field, Input } from "bloomer";

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
              label="Sync All"
              style={{ marginLeft: "0.25em" }}
              isColor="primary"
              isOutlined
              url={`${host}/subscriptions/sync_all`}
              method="post"
            />
          </Column>
        </Columns>
        <div className="card-columns columns-3-desktop columns-2-tablet columns-1-mobile">
          {store.subscriptions.all.map((s, si) => {
            return <SubscriptionCard key={si} subscription={s} />;
          })}
        </div>
      </Layout>
    );
  }
}

export default observer(Klass);
