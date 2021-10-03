import NextAuth from "next-auth";
import Providers from "next-auth/providers";
import client from "lib/client";

export default NextAuth({
	providers: [
		Providers.Credentials({
			name: "Credentials",
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
					const res = await client.post("/auth/login/", {
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
