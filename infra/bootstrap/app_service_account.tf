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

resource "google_service_account" "service" {
  account_id   = "service"
  display_name = "App service account"
  project      = google_project.project.project_id
  depends_on   = [google_project_service.iam]
}

data "google_iam_policy" "app_service_account" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = ["group:${local.deployers_group_name}"]
  }
}

resource "google_service_account_iam_policy" "service" {
  service_account_id = google_service_account.service.name
  policy_data        = data.google_iam_policy.app_service_account.policy_data
}

resource "google_project_iam_member" "app_tracing_access" {
  member = "serviceAccount:${google_service_account.service.email}"
  role   = "roles/cloudtrace.agent"
}

resource "google_project_iam_member" "app_profiler_access" {
  member = "serviceAccount:${google_service_account.service.email}"
  role   = "roles/cloudprofiler.agent"
}
