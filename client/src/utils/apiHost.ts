const react_app_api_host = process.env.REACT_APP_API_HOST || "localhost:3000";

const httpHost = `http://${react_app_api_host}`;
const cableHost = `ws://${react_app_api_host}`;

console.log(process.env);
console.log(httpHost);
console.log(cableHost);

export { httpHost, cableHost };
export default httpHost;
