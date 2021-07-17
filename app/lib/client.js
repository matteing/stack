import axios from "axios";
import { API_URL } from "config";
import { useSession } from "next-auth/client";
import { QueryClient } from "react-query";
import { dehydrate } from "react-query/hydration";
import { isServer } from "config";
import { useEffect } from "react";
import { getLogger } from "./logging";

const log = getLogger("client");

class AxiosError extends Error {
	constructor(message, status_code = false, field_errors = null) {
		super(message);
		this.name = this.constructor.name;
		if (typeof Error.captureStackTrace === "function") {
			Error.captureStackTrace(this, this.constructor);
		} else {
			this.stack = new Error(message).stack;
		}

		this.status_code = status_code;
		this.field_errors = field_errors;
	}
}

export function prettyAxiosError(error) {
	if (error.response) {
		if (error.response.data["non_field_errors"]) {
			return new AxiosError(
				error.response.data["non_field_errors"],
				error.response.status
			);
		}
		// The request was made and the server responded with a status code
		// that falls out of the range of 2xx
		if (error.response.status === 500) {
			return new AxiosError(
				"A server error ocurred.",
				error.response.status
			);
		}

		if (error.response.status === 404) {
			return new AxiosError("Not found.", error.response.status);
		}

		if (
			error.response.status === 400 &&
			Object.keys(error.response.data).length > 0
		) {
			return new AxiosError(
				"Please fill or correct the following fields to continue.",
				error.response.status,
				error.response.data
			);
		}

		return new AxiosError(
			"An error occurred sending this request. Try again later.",
			error.response.status
		);
	} else if (error.request) {
		// The request was made but no response was received
		// `error.request` is an instance of XMLHttpRequest in the browser and an instance of
		// http.ClientRequest in node.js
		if (!isServer && !navigator.onLine) {
			return new Error("No internet connection found. Try again later.");
		} else if (error.message.includes("413")) {
			return new AxiosError("This file is too large!");
		} else {
			return new Error(
				"Oh no! The server seems to be down. Please try again later."
			);
		}
	} else {
		// Something happened in setting up the request that triggered an Error
		return new Error("Unknown error. Try again later.");
	}
}

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

export function useTokenRefresh() {
	const [session, _] = useSession();

	useEffect(() => {
		if (!isServer && session) {
			const {
				user: { token },
			} = session;
			if (
				!axios.defaults.headers.common["Authorization"] ||
				axios.defaults.headers.common["Authorization"] !== token
			) {
				log("Setting session token.");
				axios.defaults.headers.common["Authorization"] = token;
			}
		} else {
			log("Deleting session token.");
			delete axios.defaults.headers.common["Authorization"];
		}
	}, [session]);
}

export function ClientTokenRefresher() {
	useTokenRefresh();
	return null;
}

/* client.interceptors.request.use(
	async (config) => {
		if (!isServer) {
			const session = await getSession();
			if (session) {
				const {
					user: { token },
				} = session;
				config.headers["Authorization"] = `Token ${token}`;
			}
		}
		return config;
	},
	(error) => {
		Promise.reject(error);
	}
); */

client.interceptors.response.use(
	(response) => response,
	(error) => {
		throw prettyAxiosError(error);
	}
);

export default client;
