import { isServer } from "config";

// Write some custom error handling here...

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

function prettyAxiosError(error) {
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

export { prettyAxiosError };
