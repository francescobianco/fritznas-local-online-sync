#!/usr/bin/env sh
set -e

[ -f .env ] && source .env

sync_dir=Testing
source_dir=$(mktemp -d)

curlftpfs -v -o "user=${FTP_USER}:${FTP_PASSWORD}" "ftp://${FTP_HOST}:${FTP_PORT}/" "$source_dir"

#date > "${source_dir}/Local_storage/timestamp.txt"

#curlftpfs --version
ls -lh "$source_dir/Local_storage/${sync_dir}"
lftp -e "set ftp:ssl-allow no; ls /Online_storage/${sync_dir}; exit" -u "${FTP_USER},${FTP_PASSWORD}" -p "${FTP_PORT}" "${FTP_HOST}"

echo "-> Sync Local_storage to Online_storage"
lftp -e "set ftp:ssl-allow no; mirror --reverse ${source_dir}/Local_storage/${sync_dir} /Online_storage/${sync_dir}; exit" -u "${FTP_USER},${FTP_PASSWORD}" -p "${FTP_PORT}" "${FTP_HOST}"
echo "-> Sync Online_storage to Local_storage"
lftp -e "set ftp:ssl-allow no; mirror --reverse ${source_dir}/Online_storage/${sync_dir} /Local_storage/${sync_dir}; exit" -u "${FTP_USER},${FTP_PASSWORD}" -p "${FTP_PORT}" "${FTP_HOST}"

fusermount -u "$source_dir"
