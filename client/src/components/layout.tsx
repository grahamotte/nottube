import {
  Container,
  Content,
  Navbar,
  NavbarBrand,
  NavbarItem,
  NavbarMenu,
  NavbarStart
} from "bloomer";

import { FaBeer } from "react-icons/fa";
import React from "react";
import colors from "../utils/colors";
import { observer } from "mobx-react";
import store from "../stores";

const logo = (seed: any) => {
  return ["P", "L", "E", "X", "T", "U", "B", "E"].map((l, k) => {
    return Math.random() >= 0.5 ? (
      <span style={{ color: colors.accent }} key={k}>
        {l}
      </span>
    ) : (
      <span key={k}>{l}</span>
    );
  });
};

const navItem = (page: string) => {
  return (
    <NavbarItem
      href="#/"
      onClick={() => (store.ui.page = page)}
      style={{
        color: store.ui.page === page ? colors.accent : undefined
      }}
    >
      {page}
    </NavbarItem>
  );
};

export default observer(props => {
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
            {navItem("subscriptions")}
            {navItem("videos")}
            {navItem("queue")}
            {navItem("settings")}
          </NavbarStart>
        </NavbarMenu>
      </Navbar>

      {props.children}

      <Content style={{ marginTop: "2em", ...barStyle }} />
      <Content className="has-text-centered">
        <FaBeer />
      </Content>
    </Container>
  );
});
