import client from "lib/client";
import { useQuery } from "react-query";

export const METRICS_QUERIES = {
	getMetrics: "metrics.getMetrics",
};

export function useMetrics() {
	return useQuery([METRICS_QUERIES.getMetrics], async () => {
		const { data } = await client.get("/metrics");
		return data;
	});
}
