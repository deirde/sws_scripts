# SWS_SCRIPTS #

Description
-----
Simple shell scripts automizing routine procedures about the development and the maintenance of a (simple) website.<br/>
Rename the file _config.sample.sh in _config.sh filling it with correct values.<br/>
The root development server access and the services curlftpfs, sshfs and lftp are mandatory.

Features
---
. Import and dump local database<br/>
. Import and dump remote database<br/>
. Find and replace strings anywhere in database tables<br/>
. File mirroring from local to remote (FTP and SFTP)<br/>
. File mirroring from remote to local (FTP and SFTP)<br/>
. Mount and unmount remote filesystem (FTP and SSH)<br/>
. Sync the remote environment with the local one (files and database), requires WP-CLI.<br/>