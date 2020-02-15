import { Column, Columns, Table } from "bloomer";

import Layout from "../components/layout";
import LoadedButton from "../components/loadedButton";
import React from "react";
import Spinner from "../components/spinner";
import colors from "../utils/colors";
import { format } from "timeago.js";
import host from "../utils/apiHost";
import { observer } from "mobx-react";
import store from "../stores";

const Code = observer((props: any) => {
  return (
    <pre
      style={{
        whiteSpace: "pre-wrap",
        wordWrap: "break-word",
        maxHeight: "10em",
        overflow: "auto",
        padding: "1em",
        backgroundColor: props.color || "white"
      }}
    >
      <code>{props.children}</code>
    </pre>
  );
});

class Klass extends React.Component {
  render() {
    if (store.jobs.all.length === 0) {
      return (
        <Layout>
          <i>No jobs in the queue.</i>
        </Layout>
      );
    }

    const tdStyle: Object = {
      // verticalAlign: "middle",
      whiteSpace: "nowrap"
    };

    return (
      <Layout>
        <Columns>
          <Column isSize="2/3"></Column>
          <Column isSize="1/3" className="has-text-right">
            <LoadedButton
              label="Clear All"
              style={{ marginLeft: "0.25em" }}
              isColor="primary"
              isOutlined
              url={`${host}/jobs/destroy_all`}
              method="post"
            />
          </Column>
        </Columns>

        <Table className="is-fullwidth">
          <thead>
            <tr>
              <th></th>
              <th>Job</th>
              <th>Age</th>
              <th>Error</th>
            </tr>
          </thead>

          <tbody>
            {store.jobs.all
              .sort((a: any, b: any) => a.created_at - b.created_at)
              .map((j: any, ji) => {
                return (
                  <tr key={ji}>
                    <td style={tdStyle}>{j.running && <Spinner />}</td>
                    <td style={tdStyle}>
                      {j.class}({j.arguments})
                    </td>
                    <td style={tdStyle}>
                      {format(new Date(j.created_at * 1000))}
                    </td>
                    <td style={tdStyle}>
                      {j.error && j.error.length > 0 && (
                        <Code color={colors.lightDanger}>{j.error}</Code>
                      )}
                    </td>
                  </tr>
                );
              })}
          </tbody>
        </Table>
      </Layout>
    );
  }
}

export default observer(Klass);
