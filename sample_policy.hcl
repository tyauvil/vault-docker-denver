path "secret/app1/*" {
policy = "write"
}

path "secret/app1/passwords/*" {
policy = "deny"
}
