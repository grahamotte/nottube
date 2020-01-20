import Queue from "./pages/queue";
import React from "react";
import Subscriptions from "./pages/subscriptions";
import { observer } from "mobx-react";
import store from "./stores";

export default observer(props => {
  if (store.ui.page === "subscriptions") {
    return <Subscriptions />;
  }

  if (store.ui.page === "queue") {
    return <Queue />;
  }
});
