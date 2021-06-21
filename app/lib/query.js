import { QueryClient } from "react-query";
import { dehydrate } from "react-query/hydration";

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
