import { Column, Columns, Control, Field, Input, Label } from "bloomer";

import Layout from "../components/layout";
import LoadedButton from "../components/loadedButton";
import React from "react";
import host from "../utils/apiHost";
import { observer } from "mobx-react";
import store from "../stores";

const field = (label: string, key: any) => {
  return (
    <Columns className="is-flex is-vcentered">
      <Column isSize="1/2" hasTextAlign="right">
        <Label>{label}</Label>
      </Column>
      <Column isSize="1/2">
        <Field>
          <Control>
            <Input
              type="text"
              placeholder={store.settings.get(key)}
              onChange={event => {
                let element = event.currentTarget as HTMLInputElement;
                store.settings.set(key, element.value);
                console.log(store.settings.attrs);
              }}
            />
          </Control>
        </Field>
      </Column>
    </Columns>
  );
};

export default observer(
  class Klass extends React.Component {
    render() {
      return (
        <Layout>
          {field("YouTube API Key", "yt_api_key")}
          {field("Videos Directory", "videos_path")}
          <Columns>
            <Column hasTextAlign="right">
              <LoadedButton
                label="Update"
                isColor="primary"
                method="post"
                url={`${host}/settings`}
                data={store.settings.attrs}
                then={() => {
                  store.ui.successNotification("Updated settings!");
                }}
              />
            </Column>
          </Columns>
        </Layout>
      );
    }
  }
);
