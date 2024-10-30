# boilerplates

my temporary boilerplates project manager

```bash
# Method 1: Direct use (one-liner)
curl -s https://raw.githubusercontent.com/obiwor/boilerplates/refs/heads/main/create.sh | bash -s -- fastapi my-project

# Method 2: Local installation
# Step 1: Download the script
curl -o create.sh https://raw.githubusercontent.com/obiwor/boilerplates/refs/heads/main/create.sh
# Step 2: Make it executable
chmod +x create.sh
# Step 3: Run the script
./create.sh fastapi my-project
```