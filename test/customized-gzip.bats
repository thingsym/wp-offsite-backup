#!/usr/bin/env bats

load bats-assertion/bats-assertion

setup() {
  cp ./test/config/my.cnf ./config/.test.my.cnf
  cp ./test/config/test-gzip ./config/test
}

teardown() {
  rm ./config/.test.my.cnf
  rm ./config/test
  if [ -e ./log/test.log ]; then
    rm ./log/test.log
  fi
}

@test "customized config (gzip) - return 0 exit code" {
  run ./bin/wp-offsite-backup test

  assert_success
  assert_lines_match "start backup" 0
  assert_lines_match "wp-offsite-backup/bin/../config/test" 1
  assert_lines_equal "JOB_NAME: test.... WordPress backup" 2
  assert_lines_equal "CONFIG: test" 3
  assert_lines_match "create tmp directory" 4
  assert_lines_match "wp-offsite-backup/bin/../tmp." 4
  assert_lines_match "dump database ..." 5
  assert_lines_match "dump database to wordpress.sql" 6
  assert_lines_match "archive database to" 7
  assert_lines_match "estimated size" 8
  assert_lines_match "archive WordPress files to" 9
  assert_lines_match "compress file ..." 10
  assert_lines_match "gzip" 10
  assert_lines_match "compress file to wordpress-backup" 11
  assert_lines_match "verifying compressed file integrity ..." 12
  assert_lines_match "success verifying wordpress-backup-" 13

  if ! type ${USER_LOCAL_BIN_PATH}aws > /dev/null 2>&1; then
    assert_lines_equal "Not Found aws command" 14
    assert_lines_match "delete tmp directory" 15
    assert_lines_match "end backup" 16
  else
    assert_lines_match "delete tmp directory" 14
    assert_lines_match "end backup" 15
  fi

}

@test "not exists customized config - return 1 exit code" {
  run ./bin/wp-offsite-backup test1

  assert_failure
  assert_status 1
  assert_match "Not Found CONFIG"
  assert_match "wp-offsite-backup/bin/../config/test1"

}

@test "exists test config" {
  run ./bin/wp-offsite-backup --config

  assert_lines_match "test"

}
