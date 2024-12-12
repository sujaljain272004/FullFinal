import os

# List of directories and files to skip
SKIP_DIRS = {
    'node_modules',
    'build',
    'dist',
    'venv',
    '_pycache_',
    '.git',
    '.next',
    'Assets',
    'Assets.xcassets',
    'ios',
    'test',
    'macos',
    'linux',
    'windows',
    'build',
    'assets',
    '.dart_tool',
    'web',
    'flutter',
    'android',
    
}

SKIP_FILES = {
    'package-lock.json',
    'yarn.lock'
}

# Function to format and print the directory structure
def print_file_structure(root_dir, indent="", is_root=True):
    if is_root:
        # Print the root directory name
        print(f"{os.path.basename(root_dir)}/")

    try:
        # List all items in the directory
        items = os.listdir(root_dir)
    except (PermissionError, FileNotFoundError) as e:
        print(f"{indent}Error: {e}")
        return

    # Separate directories and files
    directories = [item for item in items if os.path.isdir(os.path.join(root_dir, item))]
    files = [item for item in items if os.path.isfile(os.path.join(root_dir, item))]

    # Print directories
    for i, directory in enumerate(directories):
        # Skip specified directories
        if directory in SKIP_DIRS:
            continue

        # Determine connector
        is_last = i == len(directories) - 1 and not files
        connector = "└── " if is_last else "├── "
        print(f"{indent}{connector}{directory}/")

        # Recursive call for subdirectories
        new_indent = indent + ("    " if is_last else "│   ")
        print_file_structure(os.path.join(root_dir, directory), new_indent, is_root=False)

    # Print files
    for i, filename in enumerate(files):
        # Skip specified files
        if filename in SKIP_FILES:
            continue

        # Determine connector
        is_last = i == len(files) - 1
        connector = "└── " if is_last else "├── "
        print(f"{indent}{connector}{filename}")

if __name__ == "__main__":
    root_directory = os.getcwd()  # Get the current working directory
    print_file_structure(root_directory)