import Queue from "./pages/queue";
import React from "react";
import Settings from "./pages/settings";
import Subscriptions from "./pages/subscriptions";
import { observer } from "mobx-react";
import store from "./stores";
import { toast } from "react-toastify";

toast.configure();

export default observer(props => {
  if (store.ui.page === "subscriptions") {
    return <Subscriptions />;
  }

  if (store.ui.page === "queue") {
    return <Queue />;
  }

  if (store.ui.page === "settings") {
    return <Settings />;
  }
});
