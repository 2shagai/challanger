#!/bin/bash
# Check if anonymous FTP access is restricted
if grep -q "anonymous_enable=NO" /etc/vsftpd.conf && grep -q "anon_upload_enable=NO" /etc/vsftpd.conf && grep -q "anon_mkdir_write_enable=NO" /etc/vsftpd.conf; then
    # Check if the script is executed by "red_user"
    if [ "$(whoami)" = "red_user" ]; then
        echo "Flag 3: Pwnboxing{H4ppy_h4cking}"
    else
        echo "You are not authorized to view this flag."
    fi
else
    echo "Anonymous FTP access is not fixed."
fi