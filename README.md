# vault-docker-denver

Repository for Vault demos. Vault and Consul containers based on Alpine Linux.

#### Vault in four easy steps
    $ docker-compose up
    $ export VAULT_ADDR=$docker_host_IP
    $ vault init -key-shares=1 -key-threshold=1
    $ vault unseal

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
    $ vault policy-write sample sample_policy.hcl
    Policy 'sample' written.
    $ vault token-create -policy=sample
    Key            	Value
    token          	d0d56c63-bc88-2e5a-0fbe-26eec7cb5755
    token_duration 	2592000
    token_renewable	true
    token_policies 	[sample]    
    $ vault write secret/app1/usernames/bob email=bob@bob.com
    Success! Data written to: secret/app1/usernames/bob
    $ vault read secret/app1/passwords/bob
    Error reading secret/app1/passwords/bob: Error making API request.

    URL: GET http://192.168.99.100:8200/v1/secret/app1/passwords/bob
    Code: 403. Errors:

    * permission denied
