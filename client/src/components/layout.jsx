import {
  Column,
  Columns,
  Container,
  Content,
  Contents,
  Delete,
  Navbar,
  NavbarBrand,
  NavbarItem,
  NavbarMenu,
  NavbarStart,
  Notification
} from "bloomer";

import { FaBeer } from "react-icons/fa";
import React from "react";
import colors from "../utils/colors";
import { observer } from "mobx-react";
import store from "../stores";

const logo = seed => {
  return ["P", "L", "E", "X", "-", "T", "U", "B", "E"].map(l => {
    return Math.random() >= 0.5 ? (
      <span style={{ color: colors.accent }}>{l}</span>
    ) : (
      <span>{l}</span>
    );
  });
};

export default observer(
  props => {

      const barStyle = {
        borderBottom: `solid 1PX ${colors.lightGray}`,
        marginBottom: "1em"
      };

      return (
        <Container>
          <Navbar style={barStyle}>
            <NavbarBrand>
              <NavbarItem>
                <b className="disable-select">{logo(store.ui.seed)}</b>
              </NavbarItem>
            </NavbarBrand>
            <NavbarMenu isActive={true}>
              <NavbarStart>
                <NavbarItem
                  href="#/"
                  onClick={() => (store.ui.page = "subscriptions")}
                  style={{
                    color:
                      store.ui.page === "subscriptions"
                        ? colors.accent
                        : undefined
                  }}
                >
                  subscriptions
                </NavbarItem>
                <NavbarItem
                  href="#/"
                  onClick={() => (store.ui.page = "queue")}
                  style={{
                    color: store.ui.page === "queue" ? colors.accent : undefined
                  }}
                >
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

          <Content style={{ marginTop: "2em", ...barStyle }} />
          <Content className="has-text-centered">
            <FaBeer />
          </Content>
        </Container>
      );
  }
);
