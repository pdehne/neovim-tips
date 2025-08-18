Exit insert mode
# Title: Exit insert mode
# Category: Edit
# Tags: exit, insert, mode
---
Use `Esc` or `Ctrl+c` to exit insert mode and return to normal mode.

#### Example

```vim
Esc     " exit insert mode
Ctrl+c  " exit insert mode
```
===

Replace character
# Title: Replace character
# Category: Edit
# Tags: replace, character, editing
---
Use `r` followed by a character to replace the single character under the cursor.

#### Example

```vim
ra  " replace with 'a'
```
===

Time-based undo navigation
# Title: Time-based undo navigation
# Category: Edit
# Tags: undo, time, history
---
Use `:earlier 10m` to revert buffer to state 10 minutes ago, or `:later 5m` to go forward 5 minutes.

#### Example

```vim
:earlier 10m  " revert to 10 minutes ago
:later 5m     " go forward 5 minutes
```
===
