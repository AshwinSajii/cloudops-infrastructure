#!/usr/bin/env python3
import boto3, os, tarfile, sys
from config import *

if len(sys.argv) < 2:
    print("Usage: restore.py <backup-file>")
    sys.exit(1)

backup_file = sys.argv[1]
print(f"Restoring: {backup_file}")

# restore app files
with tarfile.open(backup_file, "r:gz") as tar:
    tar.extractall("/home/ashwin/cloudops")

print("Restore complete.")


