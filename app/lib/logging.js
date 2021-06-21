import debug from "debug";

export function getLogger(namespace = null) {
	return debug(namespace ? `makerlog:${namespace}` : `makerlog`);
}
