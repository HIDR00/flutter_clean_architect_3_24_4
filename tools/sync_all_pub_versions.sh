#!/bin/zsh
declare -A version_maps
echo "${ZSH_VERSION}"
parent_path=$( cd "$(dirname "${(%):-%N}")" ; pwd -P ) # nals_flutter_project_template/tools
root_project_path=$(dirname $parent_path)

# Define paths to pubspec files
pubspec_app_path="$root_project_path/app/pubspec.yaml"
pubspec_data_path="$root_project_path/data/pubspec.yaml"
pubspec_domain_path="$root_project_path/domain/pubspec.yaml"
pubspec_shared_path="$root_project_path/shared/pubspec.yaml"
pubspec_initializer_path="$root_project_path/initializer/pubspec.yaml"
pubspec_resources_path="$root_project_path/resources/pubspec.yaml"
pubspec_nals_lints_path="$root_project_path/nals_lints/pubspec.yaml"
pubspec_versions_path="$root_project_path/pub_versions.yaml"

# Read the pub_versions.yaml and populate version_maps
while read line; do
    if [[ $line =~ ^[A-Za-z_]+:[[:space:]]*[\^]*[0-9]+.*$ ]]; then
        version_maps["${line%:*}"]="  $line" # Maintain two spaces and include caret if present
    fi
done < $pubspec_versions_path

# Function to replace versions in the given pubspec file
replaceVersions() {
    echo "=====$1====="
    n=1
    while read line; do
        if [[ $line =~ ^[A-Za-z_]+:[[:space:]]*[\^]*[0-9].*$ ]]; then
            value=${version_maps["${line%:*}"]}
            if [[ -n $value && "  $line" != "$value" ]]; then
                echo "replaced $line by $value"
                sed -i '' "${n}s/.*/$value/" "$1"
            fi
        fi
        n=$((n+1))
    done < "$1"
}

# Apply the replaceVersions function to each pubspec file
replaceVersions $pubspec_app_path
replaceVersions $pubspec_data_path
replaceVersions $pubspec_domain_path
replaceVersions $pubspec_shared_path
replaceVersions $pubspec_initializer_path
replaceVersions $pubspec_resources_path
replaceVersions $pubspec_nals_lints_path
