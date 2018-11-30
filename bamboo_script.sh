#!/bin/bash

repo_name=${bamboo_reponame}
commit_sha=${bamboo_repository_revision_number}
branch=${bamboo_repository_branch_name}
build_time=$(date +"%s")
# default value
pull_request="false"
cwd=$(pwd)


#Log the curl version used
curl --version
curl -s https://scripts.scantist.com/staging/scantist-bom-detect.jar --output scantist-bom-detect.jar

java -jar scantist-bom-detect.jar -repo_name $repo_name -commit_sha $commit_sha -branch $branch -pull_request $pull_request -working_dir $cwd -build_time $build_time

#Log that the script download is complete and proceeding
echo "Uploading report at ${bamboo_SCANTIST_IMPORT_URL}"

curl -g -v -f -X POST -d '@dependency-tree.json' -H 'Cache-Control: no-cache' -H 'Content-Type:application/json' -H 'Authorization: '"${bamboo_SCANTISTTOKEN}"'' "${bamboo_SCANTIST_IMPORT_URL}"

cat dependency-tree.json

rm -f scantist-bom-detect.jar
rm -f dependency-tree.json
rm -f scantistDepGraph.py

#Exit with the curl command's output status
exit $?
