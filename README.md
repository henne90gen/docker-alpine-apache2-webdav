# minimal apache2/webdav vsftpd dockerimage with alpine linux

This image provides apache webdav serving with just 20MB (uncompressed).
It's built to be customizable and for multiple shares.

Each share is defined with an alias.

You can create a test container with the `test/docker-compose.yml` file.
Just checkout the code and run `docker-compose up` in the test folder.
After that you can connect to `https://localhost:8080/testuser` with
the user/pwd testuser/testuser.

## docker-compose.yml

Here is a example `docker-compose.yml` file to configure the service,
adapt it to your own settings.

```
apache2:
  image: yvess/alpine-apache2-webdav:0.1
  hostname: apache2
  environment:
    - SERVER_NAME=myserver
    - WWW_DATA_UID=33 # optional
    - WWW_DATA_GID=33 # optional
  volumes:
    - ./your_path/auth/apache2:/etc/auth/apache2
    - /your_path/your_dir:/var/www/testuser
  ports:
    - "8080:80"
```

The `WWW_DATA_UID` and `WWW_DATA_GID` env vars are optional and set so that it matches the ubuntu default of
33 for the `www-data` user/group. You need to change this, to match the uid/gid for your share mounts,
otherwise the user `www-data` can't write into your share.

## example share conf

You can have multiple shares in the folder `/var/www`.

The share file `testuser.conf` in `/etc/auth/apache2` looks like this.

```apacheconf
Alias /testuser "/var/www/testuser"
<Directory "/var/www/testuser">
    Include /etc/apache2/webdav_defaults.conf
    AuthUserFile "/etc/auth/apache2/testuser/users.passwd"
</Directory>
```

The password file `users.passwd` can be created like this.

```bash
touch users.passwd
htdigest users.passwd WebDAV alice
htdigest users.passwd WebDAV bob
```

Also mount the shares dir and auth files into the container.

```yaml
..
    - ./testuser:/var/www/testuser
..
```
