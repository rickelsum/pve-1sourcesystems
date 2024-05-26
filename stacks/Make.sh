#!/bin/bash

# Load environment variables
source .env

# Define service names to be included (modify as needed)
SERVICES="
        python
        golang
        node
        php
        "  # Adjust based on your needs

# Function to check if a service should be built/deployed based on environment variable
should_build_deploy() {
  local service="$1"
  local env_var="BUILD_DEPLOY_$service"
  if [[ -n "${!env_var}" && "${!env_var}" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

# Function to build and deploy specific application service
build_deploy_app() {
  local app_dir="$1"
  if [ -f "$app_dir/docker-compose.yml" ]; then
    # Build and deploy using application-specific docker-compose
    podman network create --opt vlan.id=$(get_vlan_id "$app_dir") "$app_dir-net"  # Create VLAN network
    podman-compose -p "$app_dir" -v "$app_dir-net:/net" up -d  # Mount network volume
  else
    echo "Error: '$app_dir' does not contain a docker-compose.yml file."
  fi
}

# Function to get VLAN ID for a service directory (assuming service_vlans.tfvars structure)
get_vlan_id() {
  local app_dir="$1"
  local service_name=$(basename "$app_dir")
 # ToDo Flesh out better method to determine vlan_id
 # local vlan_id=$(
}

# Function to build and deploy all services

build_deploy() {
  for service in $SERVICES; do
    if should_build_deploy "$service"; then
      build_deploy_app "./pods/apps/$service"
    fi
  done
}

# Function to start Traefik service
start_traefik() {
  podman-compose up -d traefik
}

# Function to stop Traefik service
stop_traefik() {
  podman-compose stop traefik
}

# Function to run Terraform plan/apply based on environment variable
run_terraform() {
  local env="$1"
  if [[ "$env" == "dev" || "$env" == "staging" || "$env" == "production" ]]; then
    # Assuming Terraform configuration is in the root directory
    terraform init -backend-config="./backend.tfvars"  # Adjust backend config path if needed
    case "$CI_ENVIRONMENT_NAME" in
      dev)
        # Run Terraform plan in dev environment
        terraform plan
        ;;
      staging)
        # Run Terraform apply in staging environment (if feature branch merged)
        if [[ "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" == "staging" ]]; then
          terraform apply -var-file="./environments/$env.tfvars"
        fi
        ;;
      production)
        # Run Terraform apply in production environment (if dev merged to prod)
        if [[ "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" == "master" ]]; then
          terraform apply -var-file="./environments/$env.tfvars"
        fi
        ;;
    esac
  fi
}

# Function to show usage instructions
help() {
  echo "Usage:"
  echo "  make start_traefik   Start Traefik service"
  echo "  make stop_traefik    Stop Traefik service"
  echo "  make build_deploy    Build and deploy services (based on BUILD_DEPLOY_* environment variables)"
  echo "  make help            Show this help message"
}

# Default action (if no argument is provided)
if [ $# -eq 0 ]; then
  help
fi
