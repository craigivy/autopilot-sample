output "dbconnection" {
  value = google_sql_database_instance.instance.connection_name
}

output "dbpublicip" {
  value = google_sql_database_instance.instance.public_ip_address
}

output "dbprivateip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "dbuser" {
  value = google_sql_user.dbuser.name
}

output "dbpassword" {
  value     = google_sql_user.dbuser.password
  sensitive = true
}