#!/bin/bash

# --- Istio Ambient Mesh Namespace Setup ---
#
# Script to verify or create a Kubernetes namespace and label it
# for automatic enrollment into the Istio Ambient Mesh.
#
# ------------------------------------------

# Set up strict error handling: exit immediately if a command exits with a non-zero status.
set -euo pipefail

# Configuration Variables
TARGET_NAMESPACE="magicpharmacy"
# Istio label for Ambient Mesh enrollment
AMBIENT_LABEL_KEY="istio.io/dataplane-mode"
AMBIENT_LABEL_VALUE="ambient"

# Function to print error messages and exit
error() {
    echo "❌ ERROR: $1" >&2
    exit 1
}

# Function to check for kubectl availability
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        error "The 'kubectl' command was not found. Please ensure it is installed and in your PATH."
    fi
}

# --- Execution Start ---
echo "--- Istio Ambient Namespace Setup for '${TARGET_NAMESPACE}' ---"

# 1. Check dependencies
check_kubectl

# 2. Verify and Create Namespace
echo "🌐 INFO: Checking if the target namespace '${TARGET_NAMESPACE}' exists..."

if kubectl get namespace "${TARGET_NAMESPACE}" &> /dev/null; then
    echo "✅ SUCCESS: Namespace '${TARGET_NAMESPACE}' already exists."
else
    echo "🆕 INFO: Namespace '${TARGET_NAMESPACE}' not found. Creating it now..."
    if kubectl create namespace "${TARGET_NAMESPACE}"; then
        echo "✅ SUCCESS: Namespace '${TARGET_NAMESPACE}' created successfully."
    else
        error "Failed to create namespace '${TARGET_NAMESPACE}'. Check your Kubernetes configuration or permissions."
    fi
fi

# 3. Labeling for Ambient Mesh Enrollment
FULL_LABEL="${AMBIENT_LABEL_KEY}=${AMBIENT_LABEL_VALUE}"
echo "🏷️  INFO: Labeling namespace '${TARGET_NAMESPACE}' to enroll it into Ambient Mesh (${FULL_LABEL})..."

# Check if the label is already present with the correct value
# Use '|| true' to prevent 'set -e' from exiting if the label doesn't exist (jsonpath error)
CURRENT_LABEL=$(kubectl get namespace "${TARGET_NAMESPACE}" -o jsonpath="{.metadata.labels['${AMBIENT_LABEL_KEY}']}" 2>/dev/null || true)

if [ "${CURRENT_LABEL}" == "${AMBIENT_LABEL_VALUE}" ]; then
    echo "✨ INFO: Label '${FULL_LABEL}' is already correctly set. No changes required."
else
    # Apply the label. Use --overwrite for idempotency.
    if kubectl label namespace "${TARGET_NAMESPACE}" "${FULL_LABEL}" --overwrite; then
        echo "✨ SUCCESS: Namespace '${TARGET_NAMESPACE}' labeled for Ambient Mesh enrollment."
    else
        error "Failed to label the namespace '${TARGET_NAMESPACE}'. Check cluster connectivity or permissions."
    fi
fi

echo "--- Setup Complete ---"
# The namespace is now ready for application deployment.