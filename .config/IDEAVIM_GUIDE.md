# IdeaVim Configuration Guide

> Research findings and recommendations for improving `.ideavimrc` setup (2025-2026)

## 📋 Current Setup Analysis

### ✅ Already Configured (Good Choices!)

- **surround** - Add/delete/change surroundings (quotes, brackets, tags)
- **multiple-cursors** - Multi-cursor editing like VSCode
- **commentary** - Quick commenting/uncommenting with `gc`
- **argtextobj** - Function argument text objects (`cia`, `daa`)
- **easymotion** - Jump to locations with `<leader><leader>w`
- **textobj-entire** - Select entire file with `ae`, `ie`
- **ReplaceWithRegister** - Replace text with register using `gr{motion}`
- **highlightedyank** - Visual feedback when yanking text

## 🆕 Recommended Plugins to Add

### 🌟 Highly Recommended

#### 1. **which-key** - Keybinding Discovery
Shows available keybindings in a popup when you pause after pressing leader.

```vim
set which-key
set timeoutlen=500
let g:WhichKey_ShowVimActions = "true"
```

**Why**: Helps remember all your custom keybindings, especially useful with many leader mappings.

#### 2. **NERDTree** - Project Navigation
Navigate project panel with vim bindings.

```vim
set NERDTree

" Mappings
map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
```

**Usage**:
- `<leader>nt` - Toggle NERDTree panel
- `<leader>nf` - Find current file in tree
- `j`/`k` - Navigate
- `o` - Open file
- `t` - Open in new tab

#### 3. **exchange** - Text Swapping
Easily swap two text regions.

```vim
set exchange
```

**Usage**:
1. `cx{motion}` - Select first region
2. Move to second location
3. `cx{motion}` - Select second region (text swaps!)
4. `cxc` - Cancel exchange
5. `cxx` - Exchange current line

**Example**: Swap function arguments:
- Put cursor on first arg: `cxia`
- Move to second arg: `cxia`
- Arguments swap!

#### 4. **quickscope** - Enhanced f/F/t/T
Highlights unique characters for faster f/F/t/T jumps.

```vim
set quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
```

**Why**: Makes f/t jumps faster by highlighting the best target characters.

#### 5. **matchit** - Enhanced % Matching
Extends `%` to match if/endif, def/end, HTML tags, etc.

```vim
set matchit
```

**Usage**: Press `%` on `if` to jump to matching `endif`, etc.

### 🎯 Worth Adding

#### 6. **dial** - Advanced Increment/Decrement
Increment/decrement dates, booleans, operators, not just numbers.

```vim
set dial
```

**Usage**:
- `Ctrl-A` / `Ctrl-X` on:
  - Numbers: `42` → `43`
  - Dates: `2025-01-15` → `2025-01-16`
  - Booleans: `true` → `false`
  - Operators: `&&` → `||`
  - Days: `Monday` → `Tuesday`

#### 7. **vim-sneak** - 2-Character Jump
Jump to any location with 2 characters (faster than easymotion for short distances).

```vim
Plug 'justinmk/vim-sneak'
```

**Usage**:
- `s{char1}{char2}` - Jump forward to {char1}{char2}
- `S{char1}{char2}` - Jump backward
- `;` - Next match
- `,` - Previous match

**Example**: `sth` jumps to next occurrence of "th"

#### 8. **textobj-indent** - Indentation Text Objects
Text objects based on indentation levels (great for Python!).

```vim
set textobj-indent
```

**Usage**:
- `vai` - Select around indent (includes surrounding lines)
- `vii` - Select inner indent (current indent level only)
- `vaI` - Select around indent + blank lines
- `viI` - Select inner indent + blank lines

**Example**: In Python, `dii` deletes current indented block.

#### 9. **vim-paragraph-motion** - Better { } Motions
Improved paragraph motions that handle whitespace better.

```vim
set vim-paragraph-motion
```

#### 10. **mini.ai** - Enhanced a/i Text Objects
Better text objects for quotes and brackets.

```vim
set mini-ai
```

## 🐛 Bugs to Fix in Current Config

### 1. Typo on Line 6
```vim
# ❌ Current (wrong)
set ingorecase smartcase

# ✅ Fixed
set ignorecase smartcase
```

### 2. Missing Leader Key Definition
Add at the top of file:

```vim
" Define leader key (space is recommended)
let mapleader = " "
```

## 🚀 Modern Best Practices (2025-2026)

### 1. Use `<Action>` Syntax for IDE Actions

**Old way** (still works):
```vim
map <leader>r :action Run<CR>
```

**Modern way** (cleaner):
```vim
map <leader>r <Action>(Run)
map <leader>d <Action>(Debug)
map <leader>t <Action>(GotoTest)
```

### 2. Action Discovery

**Find available actions**:
```vim
:actionlist              " List all IDE actions
:actionlist Debug        " Filter actions containing "Debug"
:actionlist Refactor     " Find refactoring actions
```

**Enable action tracking** (see action IDs when clicking UI):
1. Press `Ctrl+Shift+A`
2. Type "IdeaVim: Track Action Ids"
3. Toggle it on
4. Now click any IDE button to see its action ID

### 3. IDE-Specific Settings

Already configured (good!):
```vim
set ideajoin              " J command uses IDE smart join
set ideastatusicon=gray   " Gray icon in status bar
set idearefactormode=keep " Keep visual mode after refactoring
set ideamarks             " Use IDE bookmarks (project-scope)
```

### 4. Clipboard Integration

Already configured:
```vim
set clipboard=unnamedplus  " System clipboard integration
set clipboard^=ideaput     " Use IDE paste (smart formatting)
```

## 📝 Additional Useful Mappings

### Navigation Enhancements

```vim
" Tab navigation
nnoremap <leader>[ <Action>(PreviousTab)
nnoremap <leader>] <Action>(NextTab)
nnoremap <leader>tc <Action>(CloseContent)
nnoremap <leader>to <Action>(CloseAllEditorsButActive)

" Show documentation
nnoremap K <Action>(QuickJavaDoc)
nnoremap <leader>k <Action>(QuickImplementations)

" Go to
nnoremap gd <Action>(GotoDeclaration)
nnoremap gi <Action>(GotoImplementation)
nnoremap gu <Action>(ShowUsages)
nnoremap gt <Action>(GotoTest)
nnoremap gT <Action>(TextSearchAction)
nnoremap ge <Action>(GotoNextError)
nnoremap gE <Action>(GotoPreviousError)
```

### Refactoring

```vim
" Rename
nnoremap <leader>rn <Action>(RenameElement)
nnoremap <leader>rf <Action>(RenameFile)

" Extract
nnoremap <leader>rm <Action>(ExtractMethod)
vnoremap <leader>rm <Action>(ExtractMethod)
nnoremap <leader>rv <Action>(IntroduceVariable)
vnoremap <leader>rv <Action>(IntroduceVariable)
nnoremap <leader>rc <Action>(IntroduceConstant)
nnoremap <leader>rp <Action>(IntroduceParameter)
nnoremap <leader>rf <Action>(IntroduceField)

" Inline
nnoremap <leader>ri <Action>(Inline)

" Change signature
nnoremap <leader>rs <Action>(ChangeSignature)

" Safe delete
nnoremap <leader>rd <Action>(SafeDelete)

" Optimize imports
nnoremap <leader>oi <Action>(OptimizeImports)
```

### Git Integration

```vim
" Git blame/annotate
nnoremap <leader>gb <Action>(Annotate)

" Git diff
nnoremap <leader>gd <Action>(Compare.SameVersion)

" Git history
nnoremap <leader>gh <Action>(Vcs.ShowTabbedFileHistory)

" Git commit
nnoremap <leader>gc <Action>(CheckinProject)

" Git pull
nnoremap <leader>gu <Action>(Vcs.UpdateProject)

" Git push
nnoremap <leader>gp <Action>(Vcs.Push)
```

### Testing

```vim
" Run test at cursor
nnoremap <leader>tr <Action>(RunClass)

" Run all tests in file
nnoremap <leader>tf <Action>(RerunTests)

" Rerun failed tests
nnoremap <leader>tF <Action>(RerunFailedTests)

" Run with coverage
nnoremap <leader>tc <Action>(Coverage)

" Show test results
nnoremap <leader>tt <Action>(ActivateRunToolWindow)
```

### Code Generation

```vim
" Generate menu
nnoremap <leader>cg <Action>(Generate)

" Getters/Setters
nnoremap <leader>cgs <Action>(GenerateGetterAndSetter)
nnoremap <leader>cgg <Action>(GenerateGetter)
nnoremap <leader>cgS <Action>(GenerateSetter)

" Constructor
nnoremap <leader>cgc <Action>(GenerateConstructor)

" toString
nnoremap <leader>cgt <Action>(GenerateToString)

" equals/hashCode
nnoremap <leader>cge <Action>(GenerateEquals)
```

### Search

```vim
" Search everywhere
nnoremap <leader>se <Action>(SearchEverywhere)

" Find in files
nnoremap <leader>sf <Action>(FindInPath)
vnoremap <leader>sf <Action>(FindInPath)

" Recent files
nnoremap <leader>sr <Action>(RecentFiles)

" Recent locations
nnoremap <leader>sl <Action>(RecentLocations)
```

## 🎯 Complete Recommended Config Addition

Add this to your `.ideavimrc`:

```vim
""" Leader Key
let mapleader = " "

""" Fix typo
" Change line: set ingorecase smartcase
" To: set ignorecase smartcase

""" New Plugins
set which-key
set NERDTree
set exchange
set matchit
set quickscope
set dial
set textobj-indent
set vim-paragraph-motion
Plug 'justinmk/vim-sneak'

""" Plugin Settings
" which-key
set timeoutlen=500
let g:WhichKey_ShowVimActions = "true"

" quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

""" Enhanced Mappings

" NERDTree
map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>

" Tabs
nnoremap <leader>[ <Action>(PreviousTab)
nnoremap <leader>] <Action>(NextTab)

" Documentation
nnoremap K <Action>(QuickJavaDoc)

" Refactoring
nnoremap <leader>rn <Action>(RenameElement)
vnoremap <leader>rm <Action>(ExtractMethod)
nnoremap <leader>rv <Action>(IntroduceVariable)
nnoremap <leader>ri <Action>(Inline)

" Git
nnoremap <leader>gb <Action>(Annotate)
nnoremap <leader>gd <Action>(Compare.SameVersion)

" Testing
nnoremap <leader>tr <Action>(RunClass)
nnoremap <leader>tf <Action>(RerunFailedTests)
```

## 📚 Resources

### Official Documentation
- [IdeaVim GitHub](https://github.com/JetBrains/ideavim)
- [IdeaVim Plugins Wiki](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
- [IdeaVim Plugin API](https://github.com/JetBrains/ideavim/wiki/Plugin-API-introduction)

### Community Configs
- [Share your ~/.ideavimrc - GitHub Discussion](https://github.com/JetBrains/ideavim/discussions/303)
- [The Ultimate IdeaVim Setup](https://www.cyberwizard.io/posts/the-ultimate-ideavim-setup/)
- [Get into IdeaVim Configuration](https://tegethoff.it/get-into-ideavim-configuration-from-basic-to-advanced)
- [The Essential IdeaVim Remaps](https://towardsdatascience.com/the-essential-ideavim-remaps-291d4cd3971b/)

### Vim Script Support
IdeaVim now supports Vim Script! You can:
- Use conditional logic: `if has('ide')`
- Check IDE name: `&ide` option
- Reuse existing vim configs: `source ~/.vimrc`

## 🔄 How to Apply Changes

1. Edit `~/.ideavimrc`
2. Reload config:
   - `:source ~/.ideavimrc` in IdeaVim command mode, OR
   - `Ctrl+Shift+A` → "IdeaVim: Reload .ideavimrc"
3. Restart PyCharm if plugins don't load

## 💡 Tips

### Plugin Priority
If you can only add a few, prioritize:
1. **which-key** (discover your own keybindings!)
2. **exchange** (super useful for swapping)
3. **NERDTree** (better project navigation)
4. **matchit** (essential for paired syntax)
5. **quickscope** (makes f/t much faster)

### Learning New Plugins
- Start with one plugin at a time
- Practice with it for a few days before adding the next
- Use `:actionlist` to discover available IDE actions

### Debugging
If a mapping doesn't work:
```vim
" Check if action exists
:actionlist ActionName

" Enable verbose mode
:set verbose=9

" Check if key is already mapped
:map <key>
```

## 📅 Last Updated
February 2026 - Based on latest IdeaVim features and community recommendations
