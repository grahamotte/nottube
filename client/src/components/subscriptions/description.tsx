import { Content } from "bloomer";
import React from "react";
import { observer } from "mobx-react";

export default observer((props: any) => {
  return (
    <Content style={{ overflow: "hidden" }}>
      <small>{props.subscription.description}</small>
    </Content>
  );
});
