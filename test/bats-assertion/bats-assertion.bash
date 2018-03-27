#!/usr/bin/env bash

# bats assertion helper script
# URL: https://github.com/thingsym/bats-assertion
# Version: 0.1.0
# Author: thingsym
# distributed under MIT.
# Copyright (c) 2018 thingsym

assert_status() {
    if [ "${status}" -ne "${1}" ]; then
        echo "Expected: ${1}"
        echo "Actual  : ${status}"
        return 1
    fi
}

assert_success() {
    if [ "${status}" -ne 0 ]; then
        echo "Expected: 0"
        echo "Actual  : ${status}"
        return 1
    fi
}

assert_failure() {
    if [ "${status}" -eq 0 ]; then
        echo "Expected: other than 0"
        echo "Actual  : ${status}"
        return 1
    fi
}

assert_equal() {
    _get_actual_output "${2}"

    if [ "${1}" != "${actual_output}" ]; then
        echo "Expected: ${1}"
        echo "Actual  : ${actual_output}"
        return 1
    fi
}

assert_fail_equal() {
    _get_actual_output "${2}"

    if [ "${1}" = "${actual_output}" ]; then
        echo "Unexpected: ${1}"
        echo "Actual    : ${actual_output}"
        return 1
    fi
}

assert_regexp() {
    return 1
}

assert_match() {
    _get_actual_output "${2}"

    if [[ ! "${actual_output}" =~ "${1}" ]]; then
        echo "Expected: ${1}"
        echo "Actual  : ${actual_output}"
        return 1
    fi
}

assert_fail_match() {
    _get_actual_output "${2}"

    if [[ "${actual_output}" =~ "${1}" ]]; then
        echo "Unexpected: ${1}"
        echo "Actual    : ${actual_output}"
        return 1
    fi
}

assert_lines_equal() {
    _get_actual_line_output "${2}"

    if [ ! "${actual_output}" = "${1}" ]; then
        echo "Expected: ${1}"
        echo "Actual  : ${actual_output}"
        echo "Index   : ${actual_index}"
        return 1
    fi
}

assert_fail_lines_equal() {
    _get_actual_line_output "${2}"

    if [ "${actual_output}" = "${1}" ]; then
        echo "Unexpected: ${1}"
        echo "Actual    : ${actual_output}"
        echo "Index     : ${actual_index}"
        return 1
    fi
}

assert_lines_match() {
    _get_actual_line_output "${2}"

    if [[ ! "${actual_output}" =~ "${1}" ]]; then
        echo "Expected: ${1}"
        echo "Actual  : ${actual_output}"
        echo "Index   : ${actual_index}"
        return 1
    fi
}

assert_fail_lines_match() {
    _get_actual_line_output "${2}"

    if [[ "${actual_output}" =~ "${1}" ]]; then
        echo "Unexpected: ${1}"
        echo "Actual    : ${actual_output}"
        echo "Index     : ${actual_index}"
        return 1
    fi
}

_get_actual_output() {
    if [ -z "${1}" ]; then
        actual_output=${output}
    else
        actual_output="${1}"
    fi
}

_get_actual_line_output() {
    if [ "${1}" = "first" ]; then
        actual_index=0
    elif [ "${1}" = "last" ]; then
        actual_index=$(expr ${#lines[@]} - 1)
    else
        actual_index="${1}"
    fi

    actual_output=${lines[${actual_index}]}
}

_dump() {
    echo "---- Dumper START ----"
    if [ -z "${1}" ]; then
        echo "${output}"
        echo "status : ${status}"
    else
        echo "${1}"
    fi
    echo "---- Dumper END ----"

    return 1
}
