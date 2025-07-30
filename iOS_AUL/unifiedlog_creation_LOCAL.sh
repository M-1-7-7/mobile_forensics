#!/bin/bash

# Usage func
print_usage()
{
  ehco "FLAG MEANINGS:"
  echo "  -s  = The sysdiagnose directory from mvt (crashreport > DiagnosticLogs > sysdiagnosis)"
  echo "  -o  = The target output dir for .log , .json , .jsonl to land"
  echo "  -t  = The temp directory to store data to be processed (will be deleted)"
  ehco
  echo "Use one or all of the flags from bellow: (if none chosen defult = jsonl)"
  echo "  -l  = Ouput type as log"
  ehco "  -j  = Ouput type as json"
  echo "  -x  = Ouput type as jsonl"
  ehco
  echo "Usage:"
  echo "  $0 -s <source_dir> -o <out_dir> -t <tmp_dir> -l -j -x"
  exit 1
}

# Initialize variables and confirm user CLI flags
source_dir=""
out_dir=""
tmp_dir=""

# Values to see what the user wants to output the logs to, default is jsonl if none is chosen
to_log=0
to_json=0
to_jsonl=0

# Get User Arguments
while getopts ':s:o:t:ljx' OPTION; do
  case "$OPTION" in
    s) source_dir="$OPTARG" ;;
    o) out_dir="$OPTARG" ;;
    t) tmp_dir="$OPTARG" ;;
    l) to_log=1 ;;
    j) to_json=1 ;;
    x) to_jsonl=1 ;;
  esac
done

# Check for required arguments
if [[ -z "$source_dir" || -z "$out_dir" || -z "$tmp_dir" ]]; then
  echo "❌ Error: All of --source, --out, and --tmp must be specified."
  print_usage
fi


### Check id directories given in the comand line args exist, and if not create them 
check_dirs() {
  # Validate input directory and if it is a ral or absolute path
  if [ ! -d "$source_dir" ]; then
    echo "Error: Input directory '$source_dir' does not exist."
    exit 1
  fi

  if [ ! -d "$tmp_dir" ]; then
    mkdir -p "$tmp_dir"
  fi

  if [ ! -d "$out_dir" ]; then
    mkdir -p "$out_dir"

  fi
}

### Find all .logarchive files within this directory, extract them and move them to tmp dir
extract_logs() {
  # fins all sysdiagnose*.tar.gz and move them to the tmp_dir for processing
  find "$source_dir" -name "sysdiagnose*.tar.gz" | while IFS= read -r archive; do
    cp $archive $tmp_dir

  done

  cd $tmp_dir

  for a in *.tar.gz; do
    tar -xzf "$a"
  done

  rm -r *.tar.gz
}

# Turns .logarchive to a .log  
create_log_file(){

  # Create the unified log from logarchive
  find . -mindepth 1 -maxdepth 2 -name "*.logarchive" | while read -r sysdiag; do
    prefix=$(basename "$(dirname "$sysdiag")" | cut -d'_' -f1-3)
    file_name="${out_dir}${prefix}.log"
    
    echo $prefix
    echo "found $sysdiag, now converting to .log and directing it here $out_dir"
    echo
    log show --archive "$sysdiag" --info --debug --signpost --backtrace --loss > "$file_name"
  done

  # Create the unified log from diagnostics archive
  find . -name "diagnostics" | while read -r diag; do
    file_name="${diag}.log"
    echo "found $diag, now converting to .log and directing it here $out_dir"
    echo
    log show --archive "$diag" --info --debug --signpost --backtrace --loss > "$file_name"
  done

  # Create the unified log from uuidtext archive
  find . -name "uuidtext" | while read -r diag; do
    file_name="${diag}.log"
    echo "found $diag, now converting to .json and directing it here $out_dir"
    echo
    log show --archive "$diag" --info --debug --signpost --backtrace --loss > "$file_name"
  done
}

# Turns .logarchive to a .json  
create_json_file(){

  # Create the unified log from logarchive
  find . -mindepth 1 -maxdepth 2 -name "*.logarchive" | while read -r sysdiag; do
    prefix=$(basename "$(dirname "$sysdiag")" | cut -d'_' -f1-3)
    file_name="${out_dir}${prefix}.json"
    echo
    echo "found $sysdiag, now converting to .json and directing it here $out_dir"
    echo
    log show --archive "$sysdiag" --info --debug --signpost --backtrace --loss --style json > "$file_name"
  done

  # Create the unified log from diagnostics archive
  find . -name "diagnostics" | while read -r diag; do
    file_name="${diag}.json"
    echo "found $diag, now converting to .json and directing it here $out_dir"
    echo
    log show --archive "$diag" --info --debug --signpost --backtrace --loss --style json > "$file_name"
  done

  # Create the unified log from uuidtext archive
  find . -name "uuidtext" | while read -r diag; do
    file_name="${diag}.json"
    echo "found $diag, now converting to .json and directing it here $out_dir"
    echo
    log show --archive "$diag" --info --debug --signpost --backtrace --loss --style json > "$file_name"
  done
}

# Turns .json to jsonl
create_jsonl_file(){

  # check if this has been run before
  if [[ $json_file -eq 1 ]]; then
    create_json_file
  fi

  cd $out_dir

  # Create the unified log from logarchive
  for json_file in ./*.json; do

    jsonl_file="${json_file%.json}.jsonl"
    echo "🔄 Converting $json_file → $jsonl_file"

    # Use jq to write each object from an array on a new line
    jq -c '.[]' "$json_file" > "$jsonl_file" 
  
  done  
}

main(){
  check_dirs
  extract_logs

  # Check what file types the user is wanting
  if [[ $to_log -eq 1 ]]; then
    create_log_file
  fi

  if [[ $to_json -eq 1 ]]; then
    create_json_file
  fi

  if [[ $to_log -eq 0 && $to_json -eq 0 && $to_jsonl -eq 0 ]] || [[ $to_jsonl -eq 1 ]]; then
    create_jsonl_file
  fi

  # Clean up by deleating the syslogarchive diresctory that was made 
  rm -r $tmp_dir
}

main
