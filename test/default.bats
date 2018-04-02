#!/usr/bin/env bats

load bats-assertion/bats-assertion

setup() {
  cp ./test/config/my.cnf ./config/.test.my.cnf
  cp ./test/config/test ./config/default
}

teardown() {
  rm ./config/.test.my.cnf
  if [ -e ./log/test.log ]; then
    rm ./log/test.log
  fi
}

@test "default config - returns 0 exit code" {
  run ./bin/wp-offsite-backup

  assert_success
  assert_lines_match "wp-offsite-backup/bin/../config/default" 0
  assert_lines_equal "JOB_NAME: test.... WordPress backup" 1
  assert_lines_equal "CONFIG: default" 2
  assert_lines_equal "create tmp directory" 3
  assert_lines_match "wp-offsite-backup/bin/../tmp." 4
  assert_lines_equal "backup database wordpress.sql" 5
  assert_lines_match "backup WordPress files on" 6
  assert_lines_match "backup file wordpress-backup-" 7
  assert_lines_equal "Not Found aws commad" 8
  assert_lines_equal "delete tmp directory" 9

  assert_match "$(cat <<EXPECTED
JOB_NAME: test.... WordPress backup
CONFIG: default
create tmp directory
EXPECTED
)"

}

@test "exists default config" {
  run ./bin/wp-offsite-backup --config

  assert_lines_match "default"

}
