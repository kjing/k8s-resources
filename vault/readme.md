backend "file" {
  path = "/vault"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
  tls_cert_file = "/blah"
  tls_key_file = "blahblah.
}

telemetry {
  statsd_address = "statsd:8125"
  disable_hostname = true
}



❯ export VAULT_ADDR='http://130.211.126.76:8200/'


https://www.vaultproject.io/docs/config/index.html#path
https://stedolan.github.io/jq/
https://github.com/prometheus/statsd_exporter
https://hub.docker.com/_/vault/

https://github.com/hashicorp/vault/pull/1415
http://www.devoperandi.com/vault-in-kubernetes/


Use kubectl to establish local port forwarding:
`$ kubectl port-forward vault-1270652834-c1ghx 8200:8200`

Then export your local address:
`$ export VAULT_ADDR='http://localhost:8200'`

Then you should be able to use your local Vault CLI:
```
$ vault status
Sealed: false
Key Shares: 1
Key Threshold: 1
Unseal Progress: 0
Version:

High-Availability Enabled: false
```

View logs on the vault server:
```
$ k logs vault-1270652834-c1ghx
==> WARNING: Dev mode is enabled!

In this mode, Vault is completely in-memory and unsealed.
Vault is configured to only have a single unseal key. The root
token has already been authenticated with the CLI, so you can
immediately begin using the Vault CLI.

The only step you need to take is to set the following
environment variables:

    export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are reproduced below in case you
want to seal/unseal the Vault or play with authentication.

Unseal Key: 07ca3523f2afc3c256e362e4016f4c9de2a6410b90446fbf40803cf12c406b19
Root Token: 36be02ac-8562-05f0-f1f8-1ff2a468c1b4

==> Vault server configuration:

                 Backend: inmem
              Listener 1: tcp (addr: "127.0.0.1:8200", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
                 Version: Vault v0.6.0

==> Vault server started! Log data will stream in below:
```

next unseal the vault
then authentication
then use it

```
$ vault write secret/hello value=world
Success! Data written to: secret/hello

$ vault read secret/hello
Key                    	Value
---                    	-----
refresh_interval       	720h0m0s
value                  	world

$ vault list secret
Keys
hello
```
