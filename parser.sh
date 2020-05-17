#!/bin/bash -e
cd  "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_stdout_file="$1"
[[ ! -f "$config_stdout_file" ]] && echo -e "First argument must be file containing stdout of ansible-config cli utility." && exit 66


read_file(){
    cat "$config_stdout_file" | grep '^[A-Z].*(.*) = ' 
}

while read -r key equals value; do
    [[ "$equals" != "=" ]] && continue
    _var="$(echo -e "$key"|cut -d'(' -f1)"
    _src="$(echo -e "$key"|cut -d'(' -f2|cut -d')' -f1)"
    cmd="jo option=\"$_var\" value=\"$value\" src=\"$_src\""
    eval $cmd
done < <(read_file)

