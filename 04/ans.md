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

On Linux, use . An example of the boot history is listed below.
```
IDX BOOT ID                          FIRST ENTRY                 LAST ENTRY                 
 -6 1e55507193c445a08f1cd41bbc7c17eb Mon 2023-05-29 11:07:44 BST Mon 2023-05-29 11:24:29 BST
 -5 8c1089981ddd4d0d9634af1efe7ce5b9 Mon 2023-05-29 11:24:55 BST Mon 2023-05-29 11:27:46 BST
 -4 deba2c5aad584863ac479d52a44a4e8f Mon 2023-05-29 11:28:11 BST Mon 2023-05-29 11:50:23 BST
 -3 98243e9527a541b189f1d62bedcff7e5 Thu 2023-06-08 12:49:35 BST Thu 2023-06-08 13:23:27 BST
 -2 7b10420366294f85bd2daaf4101fec21 Thu 2023-06-08 13:23:53 BST Thu 2023-06-08 14:01:14 BST
 -1 5b33bbb800ba44468f3bfdfa246afaa8 Mon 2023-06-12 18:41:59 BST Mon 2023-06-12 19:07:16 BST
  0 1f264086c37c421e8a430f3cb6c0e63f Sat 2023-06-17 15:23:16 BST Sat 2023-06-17 16:25:35 BST
```

[If the system log does not store previous log history, enabling persistent storage of log messages is necessary. Change `Storage=auto` to `Storage=persistent` in `/etc/systemd/journald.conf` file.]: # 


```sh
for i in {0..9}; do
    journalctl -b-$i | grep -E "systemd[1]: Startup finished in" >> startup_time.txt
done

# Record examples:
# Jun 17 17:58:11 fedora systemd[1]: Startup finished in 2.010s (kernel) + 2.479s (initrd) + 8.869s (userspace) = 13.359s.
# Jun 17 15:23:26 fedora systemd[1]: Startup finished in 2.010s (kernel) + 2.329s (initrd) + 8.922s (userspace) = 13.262s.
# Jun 12 18:42:09 fedora systemd[1]: Startup finished in 2.000s (kernel) + 2.426s (initrd) + 8.817s (userspace) = 13.244s.
# Jun 08 13:24:03 fedora systemd[1]: Startup finished in 1.995s (kernel) + 2.241s (initrd) + 8.894s (userspace) = 13.131s.
# Jun 08 12:49:45 fedora systemd[1]: Startup finished in 2.008s (kernel) + 2.307s (initrd) + 8.811s (userspace) = 13.127s.
# May 29 11:28:21 fedora systemd[1]: Startup finished in 1.979s (kernel) + 2.190s (initrd) + 8.798s (userspace) = 12.967s.
# May 29 11:07:54 fedora systemd[1]: Startup finished in 2.008s (kernel) + 2.317s (initrd) + 8.802s (userspace) = 13.128s.


echo "Max system boot time:"
cat startup_time.txt | sed -E "s/.* = (.*)s\.$/\1/" | sort | tail -n1

echo "Average system boot time:"
echo "($(cat startup_time.txt | sed -E "s/.* = (.*)s\.$/\1/" | paste -sd+))/10" | bc -l

echo "Median system boot time:"
cat startup_time.txt | sed -E "s/.* = (.*)s\.$/\1/" | sort | awk '{a[i++]=$1} END { if (i%2) print a[(i+1)/2]; else print ((a[i/2] + a[i/2+1])/2.0); }'
```

### 5. Look for boot messages that are not shared between your past three reboots (see `journalctl’s -b` flag). Break this task down into multiple steps. First, find a way to get just the logs from the past three boots. There may be an applicable flag on the tool you use to extract the boot logs, or you can use `sed '0,/STRING/d'` to remove all lines previous to one that matches `STRING`. Next, remove any parts of the line that always varies (like the timestamp). Then, de-duplicate the input lines and keep a count of each one (`uniq` is your friend). And finally, eliminate any line whose count is 3 (since it was shared among all the boots).

The first step is to retrieve all log messages from the last three boots.

```sh
#!/bin/sh
for i in {0..2}; do
  journalctl -b-$i | sed -E "s/^.*:[0-9]{2} fedora (.*)$/\1/" | sort \
  | uniq -c | awk '{$1=""; print}' >> bootmsg.txt
done

cat bootmsg.txt | sort | uniq -c | awk '{if ($1 < 3) { $1=""; print ; }}' > unique_msg.txt
```
### 6. Find an online data set [this one](https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm), fetch it using curl and extract out just two columns of numerical data. If you’re fetching HTML data, pup might be helpful. For JSON data, try jq. Find the min and max of one column in a single command, and the difference of the sum of each column in another.
