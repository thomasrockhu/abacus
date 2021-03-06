#!/usr/bin/env bash

set -euo pipefail

function main() {
  echo "Logging in..."
  gcloud auth login --brief

  echo "Checking project..."

  if projectExists; then
    echo "Project already exists, nothing to do."
  else
    createProject
  fi

  echo "Logging out..."
  gcloud auth revoke

  echo
  echo "Done."
}

function projectExists() {
  ! gcloud projects list --filter "$GOOGLE_PROJECT" 2>&1 | grep -q 'Listed 0 items.'
}

function createProject() {
  echo "Project does not exist, creating it..."
  gcloud projects create "$GOOGLE_PROJECT"
  echo
  echo "Enabling billing API..."
  gcloud services enable cloudbilling.googleapis.com --project "$GOOGLE_PROJECT"
  echo
  echo "Enabling IAM API..."
  gcloud services enable iam.googleapis.com --project "$GOOGLE_PROJECT"
  echo
  echo "Enabling Resource Manager API..."
  gcloud services enable cloudresourcemanager.googleapis.com --project "$GOOGLE_PROJECT"
  echo
  echo "Enabling Cloud Identity API..."
  gcloud services enable cloudidentity.googleapis.com --project "$GOOGLE_PROJECT"
  echo
  echo "Linking project to billing account..."
  gcloud beta billing projects link "$GOOGLE_PROJECT" --billing-account="$GOOGLE_BILLING_ACCOUNT_ID"
  echo
  echo "Creating deployers group..."
  DEPLOYERS_GROUP_EMAIL="$GOOGLE_PROJECT-deployers@batect.dev"
  gcloud beta identity groups create --organization "$GOOGLE_ORGANIZATION" --labels cloudidentity.googleapis.com/groups.discussion_forum --project "$GOOGLE_PROJECT" --display-name "$GOOGLE_PROJECT deployers" "$DEPLOYERS_GROUP_EMAIL"
  echo
  echo "Adding deployers group to organization viewers..."
  gcloud organizations add-iam-policy-binding "$GOOGLE_ORGANIZATION" --member "group:$DEPLOYERS_GROUP_EMAIL" --role roles/resourcemanager.organizationViewer
  echo
  echo "Creating bootstrap state bucket..."
  gsutil mb -b on -c Standard -l "$GOOGLE_REGION" -p "$GOOGLE_PROJECT" "gs://$GOOGLE_PROJECT-bootstrap-terraform-state"
}

main
