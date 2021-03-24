#!/usr/bin/env bash

sed -n '/^## /,/^## /p' CHANGELOG.md | head -n -1

