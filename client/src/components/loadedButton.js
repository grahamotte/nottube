import { Button } from "bloomer";
import React from "react";
import axios from "axios";
import { observer } from "mobx-react";
import store from "../stores";

export default observer(
  class Klass extends React.Component {
    state = {
      loading: false
    };

    onClick = () => {
      this.setState({ loading: true });

      var data;
      if (this.props.data) {
        data = this.props.data;
      } else if (this.props.getData) {
        data = this.props.getData();
      } else {
        data = {};
      }

      axios({
        method: this.props.method || "get",
        url: this.props.url,
        data: data
      })
        .then(response => {
          this.setState({ loading: false });

          if (this.props.then) {
            this.props.then(response);
          }
        })
        .catch(response => {
          this.setState({ loading: false });

          if (this.props.catch) {
            this.props.catch(response);
          } else {
            store.ui.errorNotification(response.message);
          }
        });
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
        >
          {this.state.loading ? loadingText : label}
        </Button>
      );
    }
  }
);
