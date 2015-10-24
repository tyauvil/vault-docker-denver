# vault-docker-denver

Repository for Vault demos. Vault and Consul containers based on Alpine Linux.

#### Vault in four easy steps
1. docker-compose up
2. export VAULT_ADDR=$docker_host_IP
3. vault init
4. vault unseal 

#### Write a secret, then read it, then delete it

    $ export VAULT_TOKEN=$vault_root_token
    $ vault write secret/foo value=bar
    Success! Data written to: secret/foo
    $ vault read secret/foo
    Key           	Value
    lease_duration	2592000
    value         	bar
    $ vault delete secret/foo
    Success! Deleted 'secret/foo'

#### Create a policy, generate a token

$ vi sample_policy.hcl
$ cat sample_policy.hcl
path "secret/app1/*" {
policy = "write"
}

path "secret/app1/passwords/*" {
policy = "deny"
}
