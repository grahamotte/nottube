import { Column, Columns, Content } from "bloomer";

import React from "react";

export default (props: any) => {
  const colStyle = { paddingTop: 0, paddingBottom: 0 };

  const datapairs = Object.keys(props.pairs).map((p: any, pi: number) => {
    return (
      <Columns key={pi}>
        <Column style={colStyle} isSize="1/3">
          <small>
            <b>{p}</b>
          </small>
        </Column>
        <Column style={colStyle} isSize="2/3">
          <small>{props.pairs[p]}</small>
        </Column>
      </Columns>
    );
  });

  return (
    <Content style={{ paddingTop: "0.5rem", paddingBottom: "0.5rem" }}>
      {datapairs}
    </Content>
  );
};
