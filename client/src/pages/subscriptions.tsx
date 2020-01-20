import { Column, Columns, Control, Field, Input } from "bloomer";

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
        <Columns isCentered>
          <Column>
            <Field>
              <Control>
                <Input
                  type="text"
                  placeholder="Add URL"
                  onChange={event => {
                    let element = event.currentTarget as HTMLInputElement;
                    this.setState({ addUrl: element.value });
                  }}
                />
              </Control>
            </Field>
          </Column>
          <Column>
            <Field isGrouped>
              <Control>
                <LoadedButton
                  label="Add"
                  color="primary"
                  url="http://localhost:3001/subscriptions"
                  method="post"
                  data={{ url: this.state.addUrl }}
                  then={() => {
                    store.ui.successNotification(`Added ${this.state.addUrl}!`);
                    this.setState({ addUrl: "" });
                  }}
                />
              </Control>
            </Field>
          </Column>
        </Columns>

        <Columns isMultiline={true} isCentered={true}>
          {store.subscriptions.all.map((s, si) => {
            return (
              <Column isSize="1/4" key={si}>
                <SubscriptionCard s={s} />
              </Column>
            );
          })}
        </Columns>
      </Layout>
    );
  }
}

export default observer(Klass);
