import axios from "axios";
import { API_URL } from "config";
import { getSession } from "next-auth/client";
import { prettyAxiosError } from "./error";
import { QueryClient } from "react-query";
import { dehydrate } from "react-query/hydration";

const client = axios.create({
	baseURL: API_URL,
});

export async function fetchQueriesOnServer(...queries) {
	const queryClient = new QueryClient();

	const collectedQueries = queries.map((query) =>
		queryClient.prefetchQuery(query[0], query[1])
	);
	await Promise.all(collectedQueries);

	return {
		props: {
			dehydratedState: dehydrate(queryClient),
		},
	};
}

client.interceptors.request.use(
	async (config) => {
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
