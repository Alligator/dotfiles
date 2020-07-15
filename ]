#!/bin/sh

find . -type f -path "*utils/*" -or -path "*bin/*" | xargs -i awk '
/^#!/ { nxt = 1; next }
nxt {
  sub("^# ?", "")
  desc = $0
  exit
}
END { printf("%-30s %s\n", FILENAME, desc) }
' {}
