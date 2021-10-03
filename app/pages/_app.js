import { LayoutTree } from "@moxy/next-layout";
import { Provider } from "next-auth/client";
import { ClientTokenRefresher } from "lib/client";
import "../styles/globals.css";

function App({ Component, pageProps }) {
	return (
		<Provider session={pageProps.session}>
			<ClientTokenRefresher />
			<LayoutTree
				Component={Component}
				pageProps={pageProps}
				/* defaultLayout={<Shell />} */
			/>
		</Provider>
	);
}

export default App;
