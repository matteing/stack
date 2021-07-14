import { LayoutTree } from "@moxy/next-layout";
import { Provider } from "next-auth/client";
import Shell from "components/Shell";
import "../styles/globals.css";

function MyApp({ Component, pageProps }) {
	return (
		<Provider session={pageProps.session}>
			<LayoutTree
				Component={Component}
				pageProps={pageProps}
				defaultLayout={<Shell />}
			/>
		</Provider>
	);
}

export default MyApp;
