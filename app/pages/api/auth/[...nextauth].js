import NextAuth from "next-auth";
import Providers from "next-auth/providers";
import axios from "lib/axios";
import { session } from "next-auth/client";

export default NextAuth({
	providers: [
		Providers.Credentials({
			// The name to display on the sign in form (e.g. 'Sign in with...')
			name: "Credentials",
			// The credentials is used to generate a suitable form on the sign in page.
			// You can specify whatever fields you are expecting to be submitted.
			// e.g. domain, username, password, 2FA token, etc.
			credentials: {
				email: {
					label: "Email",
					type: "text",
					placeholder: "maker@maker.com",
				},
				password: { label: "Password", type: "password" },
			},
			async authorize(credentials, req) {
				try {
					const res = await axios.post("/auth/login/", {
						email: credentials.email,
						password: credentials.password,
					});
					return { ...res.data.data.user, token: res.data.token };
				} catch (e) {
					return null;
				}
			},
		}),
	],
	callbacks: {
		async jwt(token, user) {
			return { ...user, ...token };
		},

		async session(session, user) {
			return { ...session, user };
		},
	},
});
