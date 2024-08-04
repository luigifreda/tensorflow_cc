#!/usr/bin/env python3
import sys

kVerbose=False 

def replace_string_in_file(file_path, old_string, new_string):
    try:
        with open(file_path, 'r') as file:
            file_contents = file.read()

        file_contents = file_contents.replace(old_string, new_string)

        with open(file_path, 'w') as file:
            file.write(file_contents)

        if kVerbose:
            print(f"Successfully replaced '{old_string}' with '{new_string}' in '{file_path}'.")

    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python replace_string.py <file_path> <old_string> <new_string>")
        sys.exit(1)

    old_string = sys.argv[1]
    new_string = sys.argv[2]
    file_path = sys.argv[3]
    
    if kVerbose:
        print(f'Replacing "{old_string}" with "{new_string}" in "{file_path}"...')
    replace_string_in_file(file_path, old_string, new_string)

    sys.exit(0)