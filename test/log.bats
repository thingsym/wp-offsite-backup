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

@test "exist log file" {
  run ./bin/wp-offsite-backup
  run [ -e ./log/test.log ]

  assert_success

}

@test "logging" {
  cat << EOS > ./log/test.log
EOS

  run ./bin/wp-offsite-backup

  assert_match "\[Success\] \[default\]" "$(cat ./log/test.log)"

}

@test "10 max log lines" {

  cat << EOS > ./log/test.log
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
[2018-03-26 13:39:26] [Success] [default] WordPress Backup complete!
EOS

  run ./bin/wp-offsite-backup
  lines="$(cat ./log/test.log | wc -l)"

  assert_equal "10" "$lines"

}
