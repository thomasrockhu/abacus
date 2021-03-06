#! /usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VARS_FILE="$SCRIPT_DIR/../generated.auto.tfvars"

cat <<EOF > "$VARS_FILE"
project_name          = "$GOOGLE_PROJECT"
organization_id       = "$GOOGLE_ORGANIZATION"
billing_account_id    = "$GOOGLE_BILLING_ACCOUNT_ID"
region                = "$GOOGLE_REGION"
cloud_sdk_config_name = "$CLOUDSDK_ACTIVE_CONFIG_NAME"
EOF
