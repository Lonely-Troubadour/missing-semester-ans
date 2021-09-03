# Missing Semester Lecture 1

1. Create a new directory calling `missing` under `tmp`.

2. Look up the `touch` program.

3. Use `touch` to create a new file called `semester` in the `missing`.

4. Write the following into that file, one line at a line:

   ```bash
   #!/bin/sh
   curl --head --silent https://missing.csail.mit.ed
   ```

   **Solution:**

   ```bash
   echo '#!/bin/sh' > semester
   echo 'curl --head --silent https://missing.csail.mit.edu' >> semester
   ```

   Or,

   use `vim` to open `semester` file and type these lines.

5. Try to execute the file

   **Solution**: Run `./semester` in the terminal, and the result is `zsh: permission denied: ./semester`

6. Run the command by explicitly starting the `sh` interpreter, and giving it the file `semester` as the first argument, i.e. `sh semester`. Why does this work, while `./semester` didn't?

     **Solution:** use `ls -l` to check the permissions of the `semester` program, the result shows `.rw-r--r--` which means the current user does not have permission to execute the program. By explicitly calling `sh` program, the `sh` command takes the first argument as the path of program to be executed. and run the program. 

7. Look up the `chmod` program (e.g. use `man chmod`).

   **Solution:** use`man chmod` or `tldr chmod`.

8. Use `chmod` to make it possible to run the command `./semester` rather than having to type `sh semester`. How does your shell know that the file is supposed to be interpreted using `sh`? See this page on the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line for more information.

   **Solution:** `chmod u+x semester` to give the user owns the file the right to execute it. Use `ls -l` to check the permission again: `.rwxr--r--`.

9. Use  `|` and `>` to write the "last modified" date output by semester into a file called `last-modified.txt` in your home directory.

   **Solution:** Run command `./semester | grep -i "last-modified" > last-modified.txt`

10. Write a command that read out your laptop battery's power level or your desktop machines' CPU temperature from `/sys`. 

   **Solution:** Skipped.