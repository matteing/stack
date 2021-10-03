import client from "lib/client";
import { useQuery } from "react-query";

export function useMetrics() {
	return useQuery(["metrics.getMetrics"], async () => {
		const { data } = await client.get("/metrics");
		return data;
	});
}
