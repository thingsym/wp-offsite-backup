#!/usr/bin/env bats

load bats-assertion/bats-assertion

setup() {
  cp ./test/config/my.cnf ./config/.test.my.cnf
  cp ./test/config/test-zstd ./config/default
}

teardown() {
  rm ./config/.test.my.cnf
  if [ -e ./log/test.log ]; then
    rm ./log/test.log
  fi
}

@test "default config (zstd) - return 0 exit code" {
  run ./bin/wp-offsite-backup

  assert_success
  assert_lines_match "start backup" 0
  assert_lines_match "wp-offsite-backup/bin/../config/default" 1
  assert_lines_equal "JOB_NAME: test.... WordPress backup" 2
  assert_lines_equal "CONFIG: default" 3
  assert_lines_match "create tmp directory" 4
  assert_lines_match "wp-offsite-backup/bin/../tmp." 4
  assert_lines_match "dump database ..." 5
  assert_lines_match "dump database to wordpress.sql" 6
  assert_lines_match "archive database to" 7
  assert_lines_match "estimated size" 8
  assert_lines_match "archive WordPress files to" 9
  assert_lines_match "compress file ..." 10
  assert_lines_match "zstd" 10
  assert_lines_match "compress file to wordpress-backup" 12
  assert_lines_match "verifying compressed file integrity ..." 13
  assert_lines_match "success verifying wordpress-backup-" 15

  if ! type ${USER_LOCAL_BIN_PATH}aws > /dev/null 2>&1; then
    assert_lines_equal "Not Found aws command" 16
    assert_lines_match "delete tmp directory" 17
    assert_lines_match "end backup" 18
  else
    assert_lines_match "delete tmp directory" 16
    assert_lines_match "end backup" 17
  fi

  assert_match "$(cat <<EXPECTED
JOB_NAME: test.... WordPress backup
CONFIG: default
EXPECTED
)"

}

@test "exists default config" {
  run ./bin/wp-offsite-backup --config

  assert_lines_match "default"

}
