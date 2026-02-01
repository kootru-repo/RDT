#!/usr/bin/env python3
"""
RDT Site FTP Upload Script
Uploads files from local RDT project to remote server via FTP.

Usage:
    python ftp-upload.py                    # Upload all files
    python ftp-upload.py index.html         # Upload single file
    python ftp-upload.py css/styles.css js/main.js  # Upload multiple files
"""

import os
import sys
from ftplib import FTP
from pathlib import Path

# Load credentials from config file
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_FILE = os.path.join(SCRIPT_DIR, 'ftp-credentials.txt')
TEMPLATE_FILE = os.path.join(SCRIPT_DIR, 'ftp-credentials.template.txt')

def load_config():
    if not os.path.exists(CONFIG_FILE):
        print(f'Error: Credentials file not found: {CONFIG_FILE}')
        print(f'Please copy {TEMPLATE_FILE} to {CONFIG_FILE} and fill in your password.')
        sys.exit(1)

    config = {}
    with open(CONFIG_FILE, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                config[key.strip()] = value.strip()
    return config

def get_all_files(local_folder):
    """Get all uploadable files from local folder."""
    files = []
    exclude = {'.git', '__pycache__', 'node_modules', '.env', 'assets', '.venv', '.python-version', 'scripts'}

    for root, dirs, filenames in os.walk(local_folder):
        # Skip excluded directories
        dirs[:] = [d for d in dirs if d not in exclude]

        for filename in filenames:
            if filename.startswith('.'):
                continue
            # Skip non-web files
            skip_files = {'rdt-formal-html.html', 'main.py', 'pyproject.toml', 'README.md', '.python-version'}
            if filename in skip_files:
                continue
            filepath = os.path.join(root, filename)
            relpath = os.path.relpath(filepath, local_folder)
            files.append(relpath.replace('\\', '/'))

    return files

def upload_files(files_to_upload=None):
    """Upload specified files or all files if none specified."""
    config = load_config()

    host = config['host']
    username = config['username']
    password = config['password']
    port = int(config['port'])
    remote_folder = config['remote_folder']
    local_folder_config = config['local_folder']

    # Resolve local folder relative to script directory
    if local_folder_config == '..':
        local_folder = os.path.dirname(SCRIPT_DIR)
    else:
        local_folder = os.path.abspath(os.path.join(SCRIPT_DIR, local_folder_config))

    if password == 'YOUR_FTP_PASSWORD_HERE':
        print('Error: Please set your FTP password in ftp-credentials.txt')
        sys.exit(1)

    # Determine files to upload
    if files_to_upload:
        files = files_to_upload
    else:
        files = get_all_files(local_folder)

    print(f'Connecting to FTP server {host}:{port}...')
    ftp = FTP()
    ftp.connect(host, port)
    ftp.login(username, password)
    print(f'Connected: {ftp.getwelcome()}')

    uploaded = 0
    failed = 0

    for file in files:
        local_path = os.path.join(local_folder, file)

        if not os.path.exists(local_path):
            print(f'  Skipped (not found): {file}')
            failed += 1
            continue

        # Navigate to remote directory
        remote_dir = f"{remote_folder}/{os.path.dirname(file)}".rstrip('/')
        try:
            ftp.cwd(remote_dir)
        except:
            # Create directory path if needed
            parts = remote_dir.split('/')
            current = ''
            for part in parts:
                if part:
                    current += '/' + part
                    try:
                        ftp.cwd(current)
                    except:
                        try:
                            ftp.mkd(current)
                            ftp.cwd(current)
                        except:
                            pass

        # Upload file
        filename = os.path.basename(file)
        try:
            with open(local_path, 'rb') as f:
                ftp.storbinary(f'STOR {filename}', f)
            size = os.path.getsize(local_path)
            print(f'  Uploaded: {file} ({size:,} bytes)')
            uploaded += 1
        except Exception as e:
            print(f'  Failed: {file} - {e}')
            failed += 1

    ftp.quit()
    print(f'\nFTP upload complete: {uploaded} uploaded, {failed} failed')
    print(f'Visit: https://relationaldrainage.org')

if __name__ == '__main__':
    if len(sys.argv) > 1:
        # Upload specific files
        upload_files(sys.argv[1:])
    else:
        # Upload all files
        upload_files()
