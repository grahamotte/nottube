import Layout from "../components/layout";
import React from "react";
import { observer } from "mobx-react";

class Klass extends React.Component {
  render() {
    return (
      <Layout>
        <div> ass </div>
      </Layout>
    );
  }
}

export default observer(Klass);
