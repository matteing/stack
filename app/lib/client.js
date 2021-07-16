import axios from "axios";
import { API_URL } from "config";
import { getSession } from "next-auth/client";
import { prettyAxiosError } from "./error";

const client = axios.create({
	baseURL: API_URL,
});

client.interceptors.request.use(
	async (config) => {
		// This makes a get request too!
		const session = await getSession();
		if (session) {
			const {
				user: { token },
			} = session;
			config.headers["Authorization"] = `Token ${token}`;
		}
		return config;
	},
	(error) => {
		Promise.reject(error);
	}
);

client.interceptors.response.use(
	(response) => response,
	(error) => {
		throw prettyAxiosError(error);
	}
);

export default client;
