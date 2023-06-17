# Missing Semester Lecture 3: Data Wrangling
### 1. Regex tutorial
[tutorial](https://regexone.com/)

### 2. Find the number of words (in `/usr/share/dict/words`) that contain at least three `a`s and don’t have a `'s` ending. What are the three most common last two letters of those words? sed’s y command, or the tr program, may help you with case insensitivity. How many of those two-letter combinations are there? And for a challenge: which combinations do not occur?

**Solution:** Use the following script to find the three most common last two letters:
```sh
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^.*a.*a.*(a|a.*)$" | grep -v -E ".*\'s$" | sed -E 's/^.*(..)$/\1/' | sort | uniq -c | sort -nk1,1 | tail -n3
```

How mnay of those two-letter combinations are there?
```sh
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^.*a.*a.*(a|a.*)$" | grep -v -E ".*\'s$"  | sed -E 's/^.*(..)$/\1/' | sort | uniq -c | wc -l
```

How many combinations do not occur? First, we write a shell function to generate all combinations of two letters, and write it to a file named `letters.txt`.

```sh
#!/bin/sh
#

for letter1 in {a..z}; do
    for letter2 in {a..z}; do
        echo "$letter1$letter2" >> letters.txt
    done
done
```

And we write the two-letter combinations to the other file `combinations.txt`.
```sh
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^.*a.*a.*(a|a.*)$" | grep -v -E ".*\'s$"  | sed -E 's/^.*(..)$/\1/' | sort | uniq > combinations.txt
```

The unoccured combination could be found by comparing two different files.
```sh
diff combinations.txt letters.txt
```

### 3. To do in-place substitution it is quite tempting to do something like `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`. However this is a bad idea, why? Is this particular to sed? Use man sed to find out how to accomplish this.

**Solution:** a blank `input.txt` file will be created first, and overwrites the original `input.txt` file. Use `-i` flag to create a backup file or doing in-place editing.
```sh
sed -i".bk" s/REGEX/SUBSTITUTION/ iput.txt
```

### 4. Find your average, median, and max system boot time over the last ten boots. Use journalctl on Linux and log show on macOS, and look for log timestamps near the beginning and end of each boot.

**Solution:** Use `log show` on mac, and output the result to a file for analysis.

```sh
log show | grep -E "(=== system boot:|Previous shutdown cause: 5)" > log.out
```

However, neither on Mac nor Linux does the system log stores previous logs. Enabling persistent storage of log messages is necessary. Change `Storage=auto` to `Storage=persistent` in `/etc/systemd/journald.conf` file.

```sh
for i in {0..9}; do
    journalctl -b-$i | grep -E "systemd[577]: Startup finished in" >> startup_time.txt
done

echo "Max system boot time:"
cat startup_time.txt | sed -E "s/.* = (.*)s\.$/\1" | sort | tail -n1

echo "Average system boot time:"
echo "($(cat startup_time.txt " | paste -sd+))/10" | bc -l

echo "Median system boot time:"
```

On Linux, use `systemd-analyze` to check boot time. 

### 5. Look for boot messages that are not shared between your past three reboots (see `journalctl’s -b` flag). Break this task down into multiple steps. First, find a way to get just the logs from the past three boots. There may be an applicable flag on the tool you use to extract the boot logs, or you can use `sed '0,/STRING/d'` to remove all lines previous to one that matches `STRING`. Next, remove any parts of the line that always varies (like the timestamp). Then, de-duplicate the input lines and keep a count of each one (`uniq` is your friend). And finally, eliminate any line whose count is 3 (since it was shared among all the boots).

The first step is to retrieve all log messages from the last 
