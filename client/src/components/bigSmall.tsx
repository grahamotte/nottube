import { FaTh, FaThLarge } from "react-icons/fa";

import { Button } from "bloomer";
import React from "react";

export default (props: any) => {
  return (
    <span
      className="buttons has-addons"
      style={{ display: "inline-block", marginLeft: "0.25em" }}
    >
      <Button isOutlined onClick={props.onSmall} isHovered={props.isSmall}>
        <FaTh />
      </Button>
      <Button isOutlined onClick={props.onBig} isHovered={props.isBig}>
        <FaThLarge />
      </Button>
    </span>
  );
};
