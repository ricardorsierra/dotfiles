

# Start an HTTP server from a directory, optionally specifying the port
server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Compile and execute a C source on the fly
csource() {
	[[ $1 ]]    || { echo "Missing operand" >&2; return 1; }
	[[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
	local output_path=${TMPDIR:-/tmp}/${1##*/};
	gcc "$1" -o "$output_path" && "$output_path";
	rm "$output_path";
	return 0;
}

######## go ########

# build go static binary from root of project
gostatic(){
	local dir=$1
	local arg=$2

	if [[ -z $dir ]]; then
		dir=$(pwd)
	fi

	local name=$(basename "$dir")
	(
	cd $dir
	export GOOS=linux
	echo "Building static binary for $name in $dir"

	case $arg in
		"netgo")
			set -x
			go build -a \
				-tags 'netgo static_build' \
				-installsuffix netgo \
				-ldflags "-w" \
				-o "$name" .
			;;
		"cgo")
			set -x
			CGO_ENABLED=1 go build -a \
				-tags 'cgo static_build' \
				-ldflags "-w -extldflags -static" \
				-o "$name" .
			;;
		*)
			set -x
			CGO_ENABLED=0 go build -a \
				-installsuffix cgo \
				-ldflags "-w" \
				-o "$name" .
			;;
	esac
	)
}

# go to a folder easily in your gopath
gogo(){
	local d=$1

	if [[ -z $d ]]; then
		echo "You need to specify a project name."
		return 1
	fi

	if [[ "$d" == github* ]]; then
		d=$(echo $d | sed 's/.*\///')
	fi
	d=${d%/}

	# search for the project dir in the GOPATH
	local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

	if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
		echo "Could not find a directory named $d in $GOPATH"
		echo "Maybe you need to 'go get' it ;)"
		return 1
	fi

	# enter the first path found
	cd "${path[0]}"
}

golistdeps(){
	(
	if [[ ! -z "$1" ]]; then
		gogo $@
	fi

	go list -e -f '{{join .Deps "\n"}}' ./... | xargs go list -e -f '{{if not .Standard}}{{.ImportPath}}{{end}}'
	)
}
