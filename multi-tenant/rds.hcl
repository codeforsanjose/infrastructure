locals {
  db_username        = "postgres"
  db_password        = "povbiuansdajk"
  create_db_instance = false
  db_public_access   = true

  // Create Database from pre-existing snapshot
  // https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.RestoringFromSnapshot.html
  // Defaults to empty string, meaning create fresh database
  db_snapshot_migration = ""
}
