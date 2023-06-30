# Debugging and Profiling
## Debugging

1. Use journalctl on Linux or log show on macOS to get the super user accesses and commands in the last day. If there aren’t any you can execute some harmless commands such as sudo ls and check again.

`journalctl --since "yesterday" | grep "sudo"`

2. Install shellcheck and try checking the following script. What is wrong with the code? Fix it. Install a linter plugin in your editor so you can get your warnings automatically.

```
Line 3:
for f in $(ls *.m3u)
         ^-- SC2045 (error): Iterating over ls output is fragile. Use globs.
              ^-- SC2035 (info): Use ./*glob* or -- *glob* so names with dashes won't become options.
 
Line 5:
  grep -qi hq.*mp3 $f \
           ^-- SC2062 (warning): Quote the grep pattern so the shell won't interpret it.
                   ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: (apply this, apply all SC2086)
  grep -qi hq.*mp3 "$f" \
 
Line 6:
    && echo -e 'Playlist $f contains a HQ file in mp3 format'
            ^-- SC3037 (warning): In POSIX sh, echo flags are undefined.
               ^-- SC2016 (info): Expressions don't expand in single quotes, use double quotes for that.
```

## Profiling

