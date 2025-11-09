#!/bin/bash

# Next.js Deployment Script for localhost:3000
# Exit on any error
set -e

echo "======================================="
echo "Next.js Deployment Script"
echo "======================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js 18.17.0 or above."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "Error: Node.js version must be 18.17.0 or above. Current version: $(node -v)"
    exit 1
fi

# Check if package.json exists
if [ ! -f package.json ]; then
    echo "Error: package.json not found. Make sure you're in the Next.js project directory."
    exit 1
fi

# Clean previous build and node_modules (optional)
echo "Cleaning previous build artifacts..."
rm -rf .next node_modules

# Clear npm cache (optional, for clean install)
echo "Clearing npm cache..."
npm cache clean --force

# Install dependencies
echo "Installing dependencies..."
pnpm install

# Verify Next.js is installed
if ! grep -q '"next"' package.json; then
    echo "Warning: Next.js doesn't appear to be in package.json dependencies."
fi

# Start the development server on localhost:3000
echo "Starting Next.js development server on http://localhost:3000..."
pnpm run dev
