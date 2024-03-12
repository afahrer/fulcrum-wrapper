import { types as T, compat } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "electrum-tor-address": {
    name: "Electrum Tor Address",
    description: "The Tor address for the electrum interface.",
    type: "pointer",
    subtype: "package",
    "package-id": "fulcrum",
    target: "tor-address",
    interface: "electrum",
  },
  user: {
    type: "pointer",
    name: "RPC Username",
    description: "The username for Bitcoin Core's RPC interface",
    subtype: "package",
    "package-id": "bitcoind",
    target: "config",
    multi: false,
    selector: "$.rpc.username",
  },
  password: {
    type: "pointer",
    name: "RPC Password",
    description: "The password for Bitcoin Core's RPC interface",
    subtype: "package",
    "package-id": "bitcoind",
    target: "config",
    multi: false,
    selector: "$.rpc.password",
  },
});
