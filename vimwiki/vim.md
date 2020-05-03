# Vim Workflow
Here my Vim workflow is documented.

I try to use a clean setup, with few plugins. I do this in order to keep a clean setup, with few problems.

## Commands

### Traversing history
When in command line mode, `<C-F>` opens up a search window, where normal search commands can be used.

## Jumping around

Jumping around, in same file, in other files, etc.

### Navigating the same page
Avoid clicking `hjkl` repetitively. Instead move around by clicking `HML` (High, Medium, Low), or `<C-U>` respectively `<C-D>`.
Also, remember to use motions and operators, to go where you want, *faster*.

### Searching
The `:find` command is great, especially when configured to accept tab and wild card searches.

### Tag
Tags are followed by using `<C-¨>` (to the right of `å`). This is strange, but it's because on an English keyboard, `]` is placed here.
Going back the jump list is done by pressing `<C-O>` (the letter `O`).

### Buffers
`:ls` shows all open buffers. `:b {buffNo}` jumps to another buffer. `<C-6>` is used to alternate between the two latest buffers.

