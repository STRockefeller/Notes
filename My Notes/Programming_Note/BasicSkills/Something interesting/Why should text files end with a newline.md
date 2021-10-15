# Why should text files end with a newline?

一直對部分程式語言開發慣例中的這一點表示疑惑，於是找了下這麼做的原因

 [Why should text files end with a newline?](https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline)

 [What's the point in adding a new line to the end of a file?](https://unix.stackexchange.com/questions/18743/whats-the-point-in-adding-a-new-line-to-the-end-of-a-file)

> Because that’s [how the POSIX standard defines a **line**](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_206):
>
> > - **3.206 Line**
> >
> >   A sequence of zero or more non- <newline> characters plus a terminating <newline> character.
>
> Therefore, lines not ending in a newline character aren't considered actual lines. That's why some programs have problems processing the last line of a file if it isn't newline terminated.
>
> There's at least one hard advantage to this guideline when working on a terminal emulator: All Unix tools expect this convention and work with it. For instance, when concatenating files with `cat`, a file terminated by newline will have a different effect than one without:
>
> ```
> $ more a.txt
> foo
> $ more b.txt
> bar$ more c.txt
> baz
> $ cat {a,b,c}.txt
> foo
> barbaz
> ```
>
> And, as the previous example also demonstrates, when displaying the file on the command line (e.g. via `more`), a newline-terminated file results in a correct display. An improperly terminated file might be garbled (second line).
>
> For consistency, it’s very helpful to follow this rule – doing otherwise will incur extra work when dealing with the default Unix tools.
>
> ------
>
> Think about it differently: If lines aren’t terminated by newline, making commands such as `cat` useful is much harder: how do you make a command to concatenate files such that
>
> 1. it puts each file’s start on a new line, which is what you want 95% of the time; but
> 2. it allows merging the last and first line of two files, as in the example above between `b.txt` and `c.txt`?
>
> Of course this is *solvable* but you need to make the usage of `cat` more complex (by adding positional command line arguments, e.g. `cat a.txt --no-newline b.txt c.txt`), and now the *command* rather than each individual file controls how it is pasted together with other files. This is almost certainly not convenient.
>
> … Or you need to introduce a special sentinel character to mark a line that is supposed to be continued rather than terminated. Well, now you’re stuck with the same situation as on POSIX, except inverted (line continuation rather than line termination character).
>
> ------
>
> Now, on *non POSIX compliant* systems (nowadays that’s mostly Windows), the point is moot: files don’t generally end with a newline, and the (informal) definition of a line might for instance be “text that is *separated* by newlines” (note the emphasis). This is entirely valid. However, for structured data (e.g. programming code) it makes parsing minimally more complicated: it generally means that parsers have to be rewritten. If a parser was originally written with the POSIX definition in mind, then it might be easier to modify the token stream rather than the parser — in other words, add an “artificial newline” token to the end of the input.

> It's not about adding an extra newline at the end of a file, it's about not removing the newline that should be there.
>
> A [text file](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_392), under unix, consists of a series of [lines](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_205), each of which ends with a [newline character](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_238) (`\n`). A file that is not empty and does not end with a newline is therefore not a text file.
>
> Utilities that are supposed to operate on text files may not cope well with files that don't end with a newline; historical Unix utilities might ignore the text after the last newline, for example. [GNU](http://www.gnu.org/) utilities have a policy of behaving decently with non-text files, and so do most other modern utilities, but you may still encounter odd behavior with files that are missing a final newline¹.
>
> With GNU diff, if one of the files being compared ends with a newline but not the other, it is careful to note that fact. Since diff is line-oriented, it can't indicate this by storing a newline for one of the files but not for the others — the newlines are necessary to indicate where each line *in the diff file* starts and ends. So diff uses this special text `\ No newline at end of file` to differentiate a file that didn't end in a newline from a file that did.
>
> By the way, in a C context, a source file similarly consists of a series of lines. More precisely, a translation unit is viewed in an implementation-defined as a series of lines, each of which must end with a newline character ([n1256](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) §5.1.1.1). On unix systems, the mapping is straightforward. On DOS and Windows, each CR LF sequence (`\r\n`) is mapped to a newline (`\n`; this is what always happens when reading a file opened as text on these OSes). There are a few OSes out there which don't have a newline character, but instead have fixed- or variable-sized records; on these systems, the mapping from files to C source introduces a `\n` at the end of each record. While this isn't directly relevant to unix, it does mean that if you copy a C source file that's missing its final newline to a system with record-based text files, then copy it back, you'll either end up with the incomplete last line truncated in the initial conversion, or an extra newline tacked onto it during the reverse conversion.
>
> ¹ Example: the output of GNU sort always ends with a newline. So if the file `foo` is missing its final newline, you'll find that `sort foo | wc -c` reports one more character than `cat foo | wc -c`.

簡單來說在一部分可執行的程式語言中，line break符號代表行的終止，如果想要最後一行被正確執行，那就得在最後加入換行符號。

舉個例子，在複製command line或powershell指令，貼到自己的terminal執行時，如果有複製到line break 符號就會直接執行，沒有的話要另外按下<kbd>Enter</kbd>

此外還有一個原因就是unix的作業系統下文件必須以line break作為結尾，否則將不被視為文件。為了配合unix的開發者，使用其他OS的開發者也漸漸養成了這種習慣。

長此以往，在source code最後一行留下line break漸漸變成工程師的習慣，現在即便在不影響執行的情況下結尾的換行符號已然成為一種慣例。
