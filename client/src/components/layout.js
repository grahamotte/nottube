import {
  Container,
  Delete,
  Navbar,
  NavbarBrand,
  NavbarItem,
  NavbarMenu,
  NavbarStart,
  Notification
} from "bloomer";

import React from "react";
import colors from "../utils/colors";
import { observer } from "mobx-react";
import store from "../stores";

export default observer(props => {
  const navbarStyle = {
    borderBottom: `solid 1px ${colors.accent}`,
    marginBottom: "1em"
  };

  return (
    <Container>
      <Navbar style={navbarStyle}>
        <NavbarBrand>
          <NavbarItem>
            <b>plextube</b>
          </NavbarItem>
        </NavbarBrand>
        <NavbarMenu isActive={true}>
          <NavbarStart>
            <NavbarItem
              href="#/"
              onClick={() => (store.ui.page = "subscriptions")}
            >
              subscriptions
            </NavbarItem>
            <NavbarItem href="#/" onClick={() => (store.ui.page = "queue")}>
              queue
            </NavbarItem>
          </NavbarStart>
        </NavbarMenu>
      </Navbar>

      {store.ui.notification && (
        <Notification isColor={store.ui.notificationType || "danger"}>
          <Delete onClick={store.ui.clearNotification} />
          {store.ui.notification}
        </Notification>
      )}

      {props.children}
    </Container>
  );
});
