# WP Offsite Backup

WP Offsite Backup is a Shell script for backup WordPress to offsite.

## Features

* Backup WordPress files and Databases
* Store backup file to Storage Service (Amazon S3)
* Scheduled automatic backup via Cron
* Setting customized configuration
* Rotate stored backup files by number of files
* Logging history

## Example

### Manual backup

```
bash wp-offsite-backup
```

### Scheduled automatic backup via Cron

```
crontab -e
```

```
MAILTO=hoge@example.com

20 0 * * * bash /path/to/wp-offsite-backup/bin/wp-offsite-backup
```

## Supported Storage Service

* [Amazon S3](https://aws.amazon.com/s3/)

### Future plans

* [Google Cloud Storage](https://cloud.google.com/storage/)
* [Microsoft Azure Storage](https://azure.microsoft.com/en-us/services/storage/)

## Required commands

* mysqldump
* tar
* gzip
* aws ([AWS Command Line Interface](https://aws.amazon.com/cli/))

## Getting Started

### 1. Clone to wp-offsite-backup directory

```
git clone https://github.com/thingsym/wp-offsite-backup wp-offsite-backup
```

### 2. Change directory

```
cd wp-offsite-backup
```

### 3. Set permission

```
chmod +x bin/wp-offsite-backup
```

### 4. Edit configuration as default settings.

```
vi config/default
```

### 5. Edit database configuration

```
vi config/.my.cnf
```

### 6. Testing backup

```
bash bin/wp-offsite-backup
```

have fun!

## Configuration

### WP Offsite Backup Configuration

```
JOB_NAME="WordPress backup"
BACKUP_NAME=wordpress-backup-`date +%Y-%m-%d_%H-%M-%S`
MAX_SAVED_FILES=12

WP_ROOT_PATH=/var/www/html
DB_NAME=wordpress
MYSQL_EXTRA_FILE=.my.cnf
MYSQL_FILE=wordpress.sql

S3_URI=
AWS_PROFILE=

EXCLUDE_EXTRA=(
  ".git"
  ".DS_Store"
)

EXCLUDE_WP_CONTENT=()

EXCLUDE_WP_CORE=()

LOG_FILE=history.log
MAX_LOG_LINES=300
```

* `JOB_NAME` name of backup job
* `BACKUP_NAME` name of backup (default: wordpress-backup-\`date +%Y-%m-%d_%H-%M-%S\`)
  * based on the backup file name e.g `wordpress-backup-2018-01-08_08-48-27`.tar.gz
* `MAX_SAVED_FILES` maximum number of backup files to stored (default: `12`)
    * When the number of stored files exceeds the maximum stored number, backup files are deleted from the older update date and time.
    * Set to `0` if saving unlimitedly
* `WP_ROOT_PATH` document root of WordPress (default: `/var/www/html`)
* `DB_NAME` name of database (default: `wordpress`)
* `MYSQL_EXTRA_FILE` name of mysql database configuration file (default: `.my.cnf`)
* `MYSQL_FILE` name of database backup data file (default: `wordpress.sql`)
* `S3_URI` path of a S3 bucket or prefix e.g `s3://[bucket]/[prefix]/`
* `AWS_PROFILE` aws configure named profile (default: `default`)
  * see [Named Profiles - Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html)
* `EXCLUDE_EXTRA` list exclude files or directories

Configuration example

```
EXCLUDE_EXTRA=(
  ".git"
  ".DS_Store"
)
```

empty the setting case

```
EXCLUDE_EXTRA=()
```

* `EXCLUDE_WP_CONTENT` list exclude files or directories in wp-content
* `EXCLUDE_WP_CORE` list exclude files or directories in WordPress Core files
* `LOG_FILE` name of log file
* `MAX_LOG_LINES` maximum number of log lines (default: `300`)
  * When the number of log lines exceeds the maximum number of lines, log lines are deleted from the older lines.
  * Set to `0` if logging unlimitedly

### Database Configuration

Database configuration file is invisible file as dot-file. e.g `.my.cnf`

```
[client]
user = put_database_user
password = put_database_password
host = localhost
port = 3306
```

* `user` Database user name
* `password` Database password
* `host` Database host (default: localhost)
* `port` Database port number (default: 3306)

And supports the other options. See [mysql Options](https://dev.mysql.com/doc/refman/5.7/en/mysql-command-options.html)

### Preset Configuration

The preset config is stored in `config` directory

* config-sample
* db-only-backup-config
* full-backup-config
* partial-backup-config
* wp-content-only-backup-config

## Script directory layout

* bin
  * wp-offsite-backup (core shell script)
* config (Stores Configuration files)
  * .my.cnf (Database configuration file)
  * config-sample
  * db-only-backup-config
  * default (default configuration file)
  * full-backup-config
  * partial-backup-config
  * wp-content-only-backup-config
* LICENSE
* log (Stores log files)
* README.md
* tmp (Create a temporary directory automatically when starting script execution. Delete a temporary directory at the end of script execution.)

## Archive directory layout

Archived file format is `tar.gz`.

* database (Stores database backup file)
  * wordpress.sql
* wp-config.php
* wp-content
* WordPress Core files and more...

## How to customized configuration

Create customized configuration as configuration name `customized-config`

```
cp config/config-sample config/customized-config
```

Edit customized configuration

```
vi config/customized-config
```

Run backup using customized configuration `customized-config`.

```
bash bin/wp-offsite-backup customized-config
```

Scheduled automatic backup via Cron

```
crontab -e
```

**Note**: Pass configuration name `customized-config` to environment variable `WP_OFFSITE_BACKUP_CONFIG`

```
MAILTO=hoge@example.com

20 0 * * * WP_OFFSITE_BACKUP_CONFIG=customized-config bash /path/to/wp-offsite-backup/bin/wp-offsite-backup
```

## Command Reference

### SYNOPSIS

Run backup using config/default configuration as default settings.

```
wp-offsite-backup
```

### Command parameter

```
wp-offsite-backup <parameter>
```

Run backup using customized settings.

**Note**: Pass configuration name to parameter [config]

```
wp-offsite-backup [config]
```

Display command info and usage.

```
wp-offsite-backup --help
```

List configuration.

```
wp-offsite-backup --config
```

## Tips

### Adding a command path to $PATH

The way to add a path to $PATH (the environment variable) is with the export command.

```
echo "export PATH=\$PATH:/path/to/wp-offsite-backup/bin" >> ~/.bash_profile
source ~/.bash_profile
```

or

The other way to make a symbolic link to /usr/bin.

```
sudo ln -s /path/to/wp-offsite-backup/bin/wp-offsite-backup /usr/bin
```

### Alert mail via Cron

Send log by email only on error as alert mail.
Just log it when the backup is successful.

```
MAILTO=hoge@example.com

20 0 * * * bash /path/to/wp-offsite-backup/bin/wp-offsite-backup >/dev/null
```

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [WP Offsite Backup](https://github.com/thingsym/wp-offsite-backup) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

* Version 0.2.1
  * perf: run command via symbolic link
* Version 0.2.0
  * refactor: add BASEPATH to the path
  * perf: create database dir
  * perf: store core shell script in bin directory
  * perf: add database port
* Version 0.1.0
  * initial release

## License

distributed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2018 thingsym
