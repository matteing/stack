import axios from "axios";
import { API_URL } from "config";
// import { getLogger } from "./logging";

//const log = getLogger("axiosWrapper");

const client = axios.create({
	baseURL: API_URL,
});

export default client;
