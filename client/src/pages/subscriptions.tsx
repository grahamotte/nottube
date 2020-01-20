import { Column, Columns, Content, Control, Field, Input } from "bloomer";

import Layout from "../components/layout";
import LoadedButton from "../components/loadedButton";
import React from "react";
import SubscriptionCard from "../components/subscriptionCard";
import { observer } from "mobx-react";
import store from "../stores";

class Klass extends React.Component {
  state = {
    addUrl: ""
  };

  render() {
    return (
      <Layout>
        <Field hasAddons>
          <Control>
            <Input
              type="text"
              placeholder="Add by URL"
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
              url="http://localhost:3000/subscriptions"
              method="post"
              data={{ url: this.state.addUrl }}
              then={() => {
                store.ui.successNotification(`Added ${this.state.addUrl}!`);
                this.setState({ addUrl: "" });
              }}
            />
          </Control>
        </Field>
        <div className="card-columns columns-3-desktop columns-2-tablet columns-1-mobile">
          {store.subscriptions.all.map((s, si) => {
            return <SubscriptionCard s={s} />;
          })}
        </div>
      </Layout>
    );
  }
}

export default observer(Klass);
