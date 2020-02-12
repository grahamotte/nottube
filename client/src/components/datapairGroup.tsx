import { Column, Columns } from "bloomer";

import React from "react";
import { observer } from "mobx-react";

export default observer((props: any) => {
  const keys = Object.keys(props.pairs).map((p: any, pi: number) => {
    return (
      <Column isSize="1/3" key={`key${pi}`}>
        <small>
          <b>{p}</b>
        </small>
      </Column>
    );
  });

  const values = Object.keys(props.pairs).map((p: any, pi: number) => {
    return (
      <Column isSize="2/3" key={`value${pi}`}>
        <small>{props.pairs[p]}</small>
      </Column>
    );
  });

  return (
    <Columns isMultiline isGapless>
      {keys.flatMap((p, i) => {
        return [p, values[i]];
      })}
    </Columns>
  );
});
