#!/usr/bin/env bats

load bats-assertion/bats-assertion

setup() {
  cp ./test/config/my.cnf ./config/.test.my.cnf
  cp ./test/config/test ./config/test
}

teardown() {
  rm ./config/.test.my.cnf
  rm ./config/test
  if [ -e ./log/test.log ]; then
    rm ./log/test.log
  fi
}

@test "customized config - return 0 exit code" {
  run ./bin/wp-offsite-backup test

  assert_success
  assert_lines_match "wp-offsite-backup/bin/../config/test" 0
  assert_lines_equal "JOB_NAME: test.... WordPress backup" 1
  assert_lines_equal "CONFIG: test" 2
  assert_lines_equal "create tmp directory" 3
  assert_lines_match "wp-offsite-backup/bin/../tmp." 4
  assert_lines_equal "backup database wordpress.sql" 5
  assert_lines_match "backup WordPress files on" 6
  assert_lines_match "backup file wordpress-backup-" 7
  assert_lines_match "test file wordpress-backup-" 8
  assert_lines_equal "Not Found aws commad" 9
  assert_lines_equal "delete tmp directory" 10

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
