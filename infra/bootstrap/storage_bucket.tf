// Copyright 2019-2020 Charles Korn.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// and the Commons Clause License Condition v1.0 (the "Condition");
// you may not use this file except in compliance with both the License and Condition.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// You may obtain a copy of the Condition at
//
//     https://commonsclause.com/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License and the Condition is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See both the License and the Condition for the specific language governing permissions and
// limitations under the License and the Condition.

resource "google_storage_bucket" "session_storage" {
  name               = "${var.project_name}-sessions"
  project            = google_project.project.project_id
  location           = var.region
  storage_class      = "STANDARD"
  bucket_policy_only = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_binding" "session_storage_creation_access" {
  bucket  = google_storage_bucket.session_storage.name
  role    = "roles/storage.objectCreator"
  members = ["serviceAccount:${google_service_account.service.email}"]
}

resource "google_storage_bucket_iam_binding" "session_storage_read_access" {
  bucket = google_storage_bucket.session_storage.name
  role   = "roles/storage.objectViewer"

  members = [
    "group:${local.deployers_group_name}", # For smoke test
    "serviceAccount:${google_service_account.bigquery_transfer_service.email}",
  ]
}
