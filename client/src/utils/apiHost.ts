const base = process.env.REACT_APP_API_BASE || "http://localhost";
const port = process.env.REACT_APP_API_PORT || '3000';

export default `${base}:${port}`
