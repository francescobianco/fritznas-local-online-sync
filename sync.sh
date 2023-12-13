#!/usr/bin/env sh

source .env

lftp -e 'set ftp:ssl-allow no; ls; exit' -u "${FTP_USER},${FTP_PASSWORD}" -p "${FTP_PORT}" "${FTP_HOST}"
#lftp -e 'mirror --reverse /cartella/origine/remota /cartella/destinazione/remota' -u "${FTP_USER},${FTP_PASSWORD}" -p "${FTP_PORT}" "${FTP_HOST}"
