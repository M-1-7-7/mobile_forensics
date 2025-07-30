# Sysdiagnose Processor

This script processes `sysdiagnose` archives (typically collected via MVT or macOS diagnostics) and extracts logs into `.log`, `.json`, or `.jsonl` formats.

## 📄 What It Does

Given a directory containing `sysdiagnose*.tar.gz` files, this script:

1. Extracts those archives into a temporary directory.
2. Searches for `.logarchive` files inside the extracted contents.
3. Converts each `.logarchive` into one or more of the following formats:
   - Plaintext `.log`
   - Structured `.json`
   - JSON Lines `.jsonl`
4. Places the outputs in your desired output directory.
5. Cleans up the temporary directory when done.

---

## 🚀 Usage

```bash
./process_sysdiagnose.sh -s <source_dir> -o <out_dir> -t <tmp_dir> [-l] [-j] [-x]
```

## Required flags

```bash
| Flag | Description                                                                   |
| ---- | ----------------------------------------------------------------------------- |
| `-s` | Path to the sysdiagnose directory (from MVT or similar)                       |
| `-o` | Directory where converted output files will be saved                          |
| `-t` | Temporary directory used for extraction (it will be deleted after processing) |
```

## Outup Format Flags

```bash
| Flag | Output Type                                    |
| ---- | ---------------------------------------------- |
| `-l` | Save logs as `.log` (plaintext via `log show`) |
| `-j` | Save logs as `.json` (structured JSON)         |
| `-x` | Save logs as `.jsonl` (newline-delimited JSON) |
```

## Examples

### Convert to .jsonl only (default)

```bash
./process_sysdiagnose.sh -s ./sysdiags -o ./output -t ./temp
```

### Convert to all formats

```bash
./process_sysdiagnose.sh -s ./sysdiags -o ./output -t ./temp -l -j -x
```

## Cleanup

After conversion, the temporary working directory (-t) will be automatically deleted.

## Known Issues

Paths must be quoted if they contain spaces.

realpath is not used — ensure relative paths are correct based on where you run the script.

There are a few typos in the original script (ehco, deleatiung, json_file -eq 1 in wrong context). Review or clean those before production use.

## Output Files

Each .logarchive gets converted and named using the first 3 underscore-delimited fields from its parent directory:

Example:

```bash
input: some_dir/2025_07_29_abc/logarchive.logarchive
output: out_dir/2025_07_29.log, .json, or .jsonl
```
