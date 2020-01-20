import { Column, Columns, Content, Tile } from "bloomer";

import React from "react";

export default (props: any) => {
  const colStyle = {};

  const datapairs = Object.keys(props.pairs).map((p: any, pi: number) => {
    return (
      <div>
        <Tile>
          <small>
            <b>{p}</b>
          </small>
        </Tile>
        <Tile>
          <small>{props.pairs[p]}</small>
        </Tile>
      </div>
    );
  });

  return <Content>{datapairs}</Content>;
};
