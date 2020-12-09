// TODO: Re-add outputs


// Github Actions AWS Credentials
output access_key_id {
  value = module.github_action.access_key_id
}

output secret_access_key_id {
  value = module.github_action.secret_access_key_id
}