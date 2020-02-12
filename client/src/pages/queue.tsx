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
        height: "10em",
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

        <Table style={{ width: "100%" }}>
          <thead>
            <tr>
              <th></th>
              <th>Attempts</th>
              <th>Age</th>
              <th>Job</th>
              <th>Args</th>
              <th>Error</th>
            </tr>
          </thead>

          <tbody>
            {store.jobs.all.map((j: any, ji) => {
              return (
                <tr key={ji}>
                  <td style={{ verticalAlign: "middle" }}>
                    {j.running && <Spinner />}
                  </td>
                  <td style={{ verticalAlign: "middle" }}>{j.attempts}</td>
                  <td style={{ verticalAlign: "middle", whiteSpace: "nowrap" }}>
                    {format(j.created_at)}
                  </td>
                  <td style={{ verticalAlign: "middle" }}>{j.class}</td>
                  <td style={{ verticalAlign: "middle" }}>
                    <Code>{j.arguments}</Code>
                  </td>
                  <td
                    style={{
                      verticalAlign: "middle"
                    }}
                  >
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
