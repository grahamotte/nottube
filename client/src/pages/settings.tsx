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
              }}
            />
          </Control>
        </Field>
      </Column>
    </Columns>
  );
};

// const info = (label: string, key: any) => {
//   return (
//     <Columns className="is-flex is-vcentered">
//       <Column isSize="1/2" hasTextAlign="right">
//         <Label>{label}</Label>
//       </Column>
//       <Column isSize="1/2">
//         <pre>{JSON.stringify(store.settings.get(key))}</pre>
//       </Column>
//     </Columns>
//   );
// };

export default observer(
  class Klass extends React.Component {
    constructor(props: any) {
      super(props);

      store.settings.refresh();
    }

    render() {
      return (
        <Layout>
          {field("Number of videos to keep", "keep_count")}
          {field(
            "Number of videos to look back when syncing",
            "look_back_count"
          )}
          <hr />
          {field("Nebula Email", "nebula_user")}
          {field("Nebula Password", "nebula_pass")}
          <Columns>
            <Column hasTextAlign="right">
              <LoadedButton
                label="Update"
                isColor="primary"
                method="post"
                url={`${host}/settings`}
                data={store.settings.attrs}
                then={() => {
                  store.settings.refresh();
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
