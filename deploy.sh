#!/bin/bash
# Deployment script for Google Cloud Summit Nord 2025 Masterclass
# This script automates the Terraform initialization and deployment process

set -e  # Exit immediately if a command fails

# Print colored output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set the terraform directory path
TERRAFORM_DIR="$(pwd)/terraform"
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo -e "${RED}Error: Terraform directory not found at $TERRAFORM_DIR${NC}"
  exit 1
fi

echo -e "${BLUE}Google Cloud Summit Nord 2025 Masterclass - Terraform Deployment${NC}"
echo -e "${BLUE}============================================================${NC}"

# Check if Google Cloud SDK is installed
if ! command -v gcloud &> /dev/null; then
  echo -e "${RED}Error: Google Cloud SDK (gcloud) is not installed.${NC}"
  echo "Please install it first: https://cloud.google.com/sdk/docs/install"
  exit 1
fi

# Check if user is logged in
echo -e "${BLUE}Checking Google Cloud authentication...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
  echo -e "${RED}You are not logged into Google Cloud. Please login first:${NC}"
  gcloud auth login
else
  echo -e "${GREEN}Already logged in to Google Cloud.${NC}"
fi

# Check and enable application default credentials if needed
echo -e "${BLUE}Checking application default credentials...${NC}"
if ! gcloud auth application-default print-access-token &> /dev/null; then
  echo -e "${RED}Application Default Credentials are not set up.${NC}"
  echo -e "${BLUE}Setting up application default credentials...${NC}"
  gcloud auth application-default login
else
  echo -e "${GREEN}Application Default Credentials are already set up.${NC}"
fi

# Change to the terraform directory
cd "$TERRAFORM_DIR"
echo -e "${BLUE}Changed to directory: $TERRAFORM_DIR${NC}"

# Set the project
if [ -f "terraform.auto.tfvars" ]; then
  PROJECT_ID=$(grep project_id terraform.auto.tfvars | cut -d '=' -f2 | tr -d ' "')
  if [ -n "$PROJECT_ID" ]; then
    echo -e "${BLUE}Setting active project to: ${PROJECT_ID}${NC}"
    gcloud config set project "$PROJECT_ID"
  else
    echo -e "${RED}Could not determine project_id from terraform.auto.tfvars${NC}"
    echo -e "${BLUE}Please enter your project ID:${NC}"
    read -r PROJECT_ID
    gcloud config set project "$PROJECT_ID"
  fi
else
  echo -e "${RED}terraform.auto.tfvars file not found.${NC}"
  if [ "$GOOGLE_CLOUD_SHELL" = true ]; then
    echo -e "${BLUE}But your are running in Google Cloud Shell.${NC}"
    echo "project_id = \"$GOOGLE_CLOUD_PROJECT\"" > terraform.auto.tfvars
    echo "runtime_owner = \"$USER_EMAIL\"" >> terraform.auto.tfvars
    echo "notebook_bucket_name = \"$GOOGLE_CLOUD_PROJECT\"" >> terraform.auto.tfvars
    echo -e "${GREEN}Created terraform.auto.tfvars with project_id = $GOOGLE_CLOUD_PROJECT and runtime_owner = $USER_EMAIL${NC}"
  else
    echo -e "${BLUE}Please enter your project ID:${NC}"
    read -r PROJECT_ID
    gcloud config set project "$PROJECT_ID"

    echo -e "${BLUE}Please enter your GCP user account email:${NC}"
    read -r GCP_USER_EMAIL
  
    # Create a minimal tfvars file
    echo "project_id = \"$PROJECT_ID\"" > terraform.auto.tfvars
    echo "runtime_owner = \"$GCP_USER_EMAIL\"" >> terraform.auto.tfvars
    echo "notebook_bucket_name = \"$PROJECT_ID\"" >> terraform.auto.tfvars
    echo -e "${GREEN}Created terraform.auto.tfvars with project_id = $PROJECT_ID and runtime_owner = $GCP_USER_EMAIL${NC}"
  fi
fi

# Initialize Terraform
echo -e "${BLUE}Initializing Terraform...${NC}"
terraform init

# Validate the configuration
echo -e "${BLUE}Validating Terraform configuration...${NC}"
terraform validate

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Terraform configuration is valid.${NC}"
else
  echo -e "${RED}Terraform validation failed.${NC}"
  exit 1
fi

# Apply the configuration
echo -e "${BLUE}Applying Terraform configuration...${NC}"
echo -e "${RED}This will create resources in your Google Cloud project.${NC}"
echo -e "${RED}Are you sure you want to continue? (y/n)${NC}"
read -r CONTINUE

if [ "$CONTINUE" = "y" ] || [ "$CONTINUE" = "Y" ]; then
  terraform apply --auto-approve
  
  # Check if apply was successful
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Deployment successful!${NC}"
    
    # Output the Colab Enterprise console URL
    BIGQUERY_URL=$(terraform output -raw bigquery_console_url)
    if [ -n "$BIGQUERY_URL" ]; then
      echo -e "${GREEN}Access your BigQuery environment at:${NC}"
      echo -e "${BLUE}$BIGQUERY_URL${NC}"
    fi
  else
    echo -e "${RED}Deployment failed.${NC}"
    exit 1
  fi
else
  echo -e "${BLUE}Deployment cancelled.${NC}"
  exit 0
fi
