provider "google" {
  credentials = file("account_key.json")
  project     = "YOUR_PROJECT_ID"
  region      = "YOUR_REGION"
}

resource "google_logging_folder" "folder" {
  name = "Logging folder"
}

resource "google_logging_metric" "metric" {
  name         = "Error count" //Looks for error count
  filter       = "severity = ERROR" //This can be used to apply filter.
  folder       = google_logging_folder.folder.name //folder parameter specifies the Cloud Logging folder where the metric will be created.
  value_extractor = "ERROR_COUNT" //value_extractor parameter specifies the value to extract from the logs like the count of error logs.
}

resource "google_logging_alert_policy" "alert" {
  name       = "Error count alert"
  condition {
    metric    = google_logging_metric.metric.name
    filter    = "severity = ERROR"
    threshold = 1 //Means all notifications
  }

  notification_channels = ["YOUR_EMAIL_ADDRESS"]/[Slack_Channel]
}

//Ref-1: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric

//Ref-2: https://stackoverflow.com/questions/68938876/terraform-google-provider-create-log-based-alerting-policy
