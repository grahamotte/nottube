import { Content } from "bloomer";
import React from "react";

export default (props: any) => {
  return (
    <Content style={{ overflow: "hidden" }}>
      <small>{props.subscription.description}</small>
    </Content>
  );
};
