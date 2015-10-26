# Denver Docker Meetup - Vault

[![](https://badge.imagelayers.io/tyauvil/alpine-vault-consul:latest.svg)](https://imagelayers.io/?images=tyauvil/alpine-vault-consul:latest 'Get your own badge on imagelayers.io')

Repository for Vault demos. Vault/Consul container based on Alpine Linux.

Download the Vault client for your laptop here (or use Homebrew):
https://vaultproject.io/downloads.html

#### The Vault client will need two environment variables to function:
##### VAULT_ADDR
This is the IP address of the Docker host including the port that the Vault server is listening on, 8200 by default. For docker-machine it would be:

    VAULT_ADDR="http://192.168.99.100:8200"

##### VAULT_TOKEN
This is the authentication token needed to access Vault. The root token is created upon initialization of Vault. Using the root token from the next example would look like:

    VAULT_TOKEN=1845d3df-0d21-ac4a-84de-b444e7540927

### Vault in four easy steps
    $ docker-compose up
    $ export VAULT_ADDR="http://$docker_host_ip:8200"
    $ vault init -key-shares=1 -key-threshold=1
    Key 1: ec07477efcf07a319977e45cf3d3925f36f83ccbf1a092ff5f5c1e582b5ec042
    Initial Root Token: 1845d3df-0d21-ac4a-84de-b444e7540927

    Vault initialized with 1 keys and a key threshold of 1. Please
    securely distribute the above keys. When the Vault is re-sealed,
    restarted, or stopped, you must provide at least 1 of these keys
    to unseal it again.

    Vault does not store the master key. Without at least 1 keys,
    your Vault will remain permanently sealed.
    $ vault unseal

### Write a secret, read it, then delete it

    $ export VAULT_TOKEN=$vault_root_token
    $ vault write secret/foo value=bar
    Success! Data written to: secret/foo
    $ vault read secret/foo
    Key           	Value
    lease_duration	2592000
    value         	bar
    $ vault delete secret/foo
    Success! Deleted 'secret/foo'

### Create a policy, generate a token, test permissions

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

### Dynamic secrets: use Vault to create a dynamic MySQL user account

    $ vault mount mysql
    Successfully mounted 'mysql' at 'mysql'!
    $ vault write mysql/config/connection value="root:secret@tcp(mysql:3306)/"
    Success! Data written to: mysql/config/connection
    $ vault write mysql/roles/select sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT SELECT ON *.* TO '{{name}}'@'%';"
    Success! Data written to: mysql/roles/select
    $ vault read mysql/creds/select
    Key            	Value
    lease_id       	mysql/creds/select/47ff1f5f-be45-9ddd-40da-426e92bac023
    lease_duration 	3600
    lease_renewable	true
    password       	bc8f8fd6-d4b1-dc23-525b-fca6da5ccae3
    username       	root-a0128255-b6
    $ mysql -u root-a0128255-b6 -pbc8f8fd6-d4b1-dc23-525b-fca6da5ccae3 -h $"$docker_host_ip"
    mysql> use mysql;
    mysql> select User from user;
    +------------------+
    | User             |
    +------------------+
    | root             |
    | root-a0128255-b6 |
    +------------------+
    2 rows in set (0.00 sec)
