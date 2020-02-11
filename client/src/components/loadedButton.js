import { Button } from "bloomer";
import React from "react";
import axios from "axios";
import { capitalize } from "lodash";
import { observer } from "mobx-react";
import store from "../stores";

export default observer(
  class Klass extends React.Component {
    state = {
      loading: false
    };

    data = () => {
      if (this.props.data) {
        return this.props.data;
      }

      if (this.props.getData) {
        return this.props.getData();
      }

      return {};
    };

    handleCatch = response => {
      this.setState({ loading: false });

      if (this.props.catch) {
        this.props.catch(response);
      } else if (response.data && response.data.error) {
        store.ui.errorNotification(capitalize(response.data.error));
      } else {
        store.ui.errorNotification(response.message);
      }
    };

    handleThen = response => {
      this.setState({ loading: false });

      if (response.data.error) {
        this.handleCatch(response);
      } else if (this.props.then) {
        this.props.then(response);
      }
    };

    onClick = () => {
      this.setState({ loading: true });

      axios({
        method: this.props.method || "get",
        url: this.props.url,
        data: this.data()
      })
        .then(this.handleThen)
        .catch(this.handleCatch);
    };

    render() {
      const label = this.props.label || "Submit";
      const loadingText = this.props.loadingText || "...";

      return (
        <Button
          isColor={this.props.color || this.props.isColor}
          isOutlined={this.props.isOutlined}
          onClick={this.onClick}
          isLoading={this.state.loading}
          style={this.props.style}
          disabled={this.props.disabled}
        >
          {this.state.loading ? loadingText : label}
        </Button>
      );
    }
  }
);
