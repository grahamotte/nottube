import {
  ActionCableConsumer,
  ActionCableProvider
} from "react-actioncable-provider";

import ActionCable from "actioncable";
import Queue from "./pages/queue";
import React from "react";
import Settings from "./pages/settings";
import Subscriptions from "./pages/subscriptions";
import { cableHost } from "./utils/apiHost";
import { observer } from "mobx-react";
import store from "./stores";
import { toast } from "react-toastify";

toast.configure();

export default observer(props => {
  return (
    <div>
      <ActionCableProvider cable={ActionCable.createConsumer(cableHost)}>
        <ActionCableConsumer
          channel="SubscriptionsChannel"
          onReceived={store.subscriptions.update}
        ></ActionCableConsumer>

        {store.ui.page === "subscriptions" && <Subscriptions />}
        {store.ui.page === "queue" && <Queue />}
        {store.ui.page === "settings" && <Settings />}
      </ActionCableProvider>
    </div>
  );
});
