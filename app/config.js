export const isServer = !process.browser;
export const isDev = !(process.env.NODE_ENV === "production");

export const API_URL = process.env.NEXT_PUBLIC_API_URL
	? process.env.NEXT_PUBLIC_API_URL
	: "http://localhost:4000";
