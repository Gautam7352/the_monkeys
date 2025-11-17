echo "======================================="
echo "install node"
echo "======================================="
sudo apt update && sudo apt install -y nodejs npm

echo "======================================="
echo "kill process at port 3000"
echo "======================================="
fuser -k 3000/tcp

# Clean previous folder
echo "Cleaning previous build folder"
rm -rf the_monkeys

# Clear npm cache (optional, for clean install)
echo "Clearing npm cache..."
npm cache clean --force

echo "======================================="
echo "downloading repo"
echo "======================================="

gh repo clone Gautam7352/the_monkeys
cd the_monkeys

cat <<EOF > .env.local
NEXT_PUBLIC_API_URL=https://dev.monkeys.support/api/v1
NEXT_PUBLIC_API_URL_V2=https://dev.monkeys.support/api/v2/
NEXT_PUBLIC_WSS_URL=wss://dev.monkeys.support/api/v1
NEXT_PUBLIC_WSS_URL_V2=wss://dev.monkeys.support/api/v2
NEXT_PUBLIC_LIVE_URL=https://themonkeys.live
AUTH_SECRET=76b281ed3be1a2166a859c755e853ea8
NEXTAUTH_SECRET=76b281ed3be1a2166a859c755e853ea8
NEXT_PUBLIC_GROWTHBOOK_CLIENT_KEY= test
NEXT_PUBLIC_GROWTHBOOK_API_HOST= test
EOF

mv .env.local apps/the_monkeys

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
