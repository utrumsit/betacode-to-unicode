# Betacode to Unicode

Convert [Betacode](https://stephanus.tlg.uci.edu/encoding.php) Greek entry, which allows using ordinary ASCII characters to write in ancient Greek, to Unicode in Neovim. This is a reworking of the script at http://www.ub-filosofie.ro/~solcan/wt/gnu/a/agvim.html, which I used for years. Thanks to the original author! 


## Features
- `:BetacodeToUnicode` - Convert the entire buffer from Betacode to Unicode.
- `:BetacodeToUnicodeVisual` - Convert only the visually selected text.
- Supports accents (`/`), breathing marks (`)`, `(`), macrons (`&`), breves (`'`), and automatic final sigma conversion.

## Installation

### LazyVim
Add to your `lazy.lua`:
```lua
{ "utrumsit/betacode-to-unicode" }
```


### Packer
```lua
use "utrumsit/betacode-to-unicode"
```

### Vim-Plug

```lua
Plug 'utrumsit/betacode-to-unicode'
```

## Usage

### Full Buffer Conversion
- **Command**: `:BetacodeToUnicode`
- **Effect**: Transforms all Betacode text in the current buffer to Unicode Greek, leaving non-Betacode text unchanged.
- **Example**: Type `pro/s kai/` in a buffer, run `:BetacodeToUnicode`, and get `πρός καί`.

### Visual Selection Conversion
- **Command**: `:BetacodeToUnicodeVisual`
- **Steps**:
  1. Enter visual mode (`v` for character-wise, `V` for line-wise).
  2. Select the Betacode text you want to convert.
  3. Run `:BetacodeToUnicodeVisual`.
- **Effect**: Only the selected text is converted, preserving surrounding content.
- **Example**: In `English pro/s here`, select `pro/s`, run the command, and get `English πρός here`.

## Examples
Here are some common Betacode inputs and their Unicode outputs:

| Betacode   | Unicode Output | Description                  |
|------------|----------------|------------------------------|
| `pro/s`    | `πρός`         | "Toward" with acute accent   |
| `kai/`     | `καί`          | "And" with acute accent      |
| `h)`       | `ἠ`            | Eta with smooth breathing    |
| `h(`       | `ἡ`            | Eta with rough breathing     |
| `a&`       | `ᾱ`            | Alpha with macron (long)     |
| `i'`       | `ῐ`            | Iota with breve (short)      |
| `lo/gos`   | `λόγος`        | "Word" with medial/final sigma |

## License
This plugin is licensed under the [GNU General Public License v3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.txt), following the original script’s licensing by Mihail Radu Solcan. See the `LICENSE` file for details.


