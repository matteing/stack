import React from "react";
import { LayoutTree } from "@moxy/next-layout";
import { Provider } from "next-auth/client";
import { ClientTokenRefresher } from "lib/client";
import { QueryClient, QueryClientProvider } from "react-query";
import { Hydrate } from "react-query/hydration";
import "../styles/globals.css";

function App({ Component, pageProps }) {
	const [queryClient] = React.useState(() => new QueryClient());
	return (
		<Provider session={pageProps.session}>
			<ClientTokenRefresher />
			<QueryClientProvider client={queryClient}>
				<Hydrate state={pageProps.dehydratedState}>
					<LayoutTree
						Component={Component}
						pageProps={pageProps}
						/* defaultLayout={<Layout />} */
					/>
				</Hydrate>
			</QueryClientProvider>
		</Provider>
	);
}

export default App;
