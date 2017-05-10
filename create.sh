#!/bin/bash
set -e

echo ""
echo ""
echo "   _____                       __   .__  __ __________               __            __                        "
echo "  /     \  __ __  _____  __ __|  | _|__|/  |\______   \ ____   _____/  |_  _______/  |_____________  ______  "
echo " /  \ /  \|  |  \/     \|  |  \  |/ /  \   __\    |  _//  _ \ /  _ \   __\/  ___/\   __\_  __ \__  \ \____ \ "
echo "/    Y    \  |  /  Y Y  \  |  /    <|  ||  | |    |   (  <_> |  <_> )  |  \___ \  |  |  |  | \// __ \|  |_> >"
echo "\____|__  /____/|__|_|  /____/|__|_ \__||__| |______  /\____/ \____/|__| /____  > |__|  |__|  (____  /   __/ "
echo "        \/            \/           \/               \/                        \/                   \/|__|    "
echo ""
echo ""

if [ $# -ne 4 ]; then
  echo "[Mumuki::SampleRunner] Missing arguments"
  echo ""
  echo "                       Usage:  ./create.sh <GITHUB_USER> <RUNNER> <CONSTANT> <DOCKER_BASE_IMAGE>"
  echo "                       Where:  GITHUB_USER is the Github username of the creator;"
  echo "                               RUNNER is the runners name, in snake-case-lower-case;"
  echo "                               CONSTANT is the runners name as a Ruby constant, in CamelCaseUpperCase;"
  echo "                               COPYRIGHT_YEAR is the Github username of the creator;"
  echo "                               DOCKER_BASE_IMAGE is the Docker base image used to run the code like foo/bar:0.2"
  echo ""
  exit 1
fi


user=$1
runner=$2
constant=$3
docker_base=$4

author=$user
year=$(date +%Y)


sed -i "s/<RUNNER>/$(runner)/g" mumuki-sample-runer.gemspec
sed -i "s/<CONSTANT>/$(constant)/g" mumuki-sample-runer.gemspec
mv mumuki-sample-runer.gemspec mumuki-$(runner)-runner.gemspec

sed -i "s/<RUNNER>/$(runner)/g" config.ru
sed -i "s/<RUNNER>/$(runner)/g" README.md
sed -i "s/<YEAR>/$(year)/g" LICENSE
sed -i "s/<AUTHOR>/$(author)/g" LICENSE
sed -i "s/<RUNNER>/$(runner)/g" .travis.yml

sed -i "s/<AUTHOR>/$(author)/g" worker/Dockerfile
sed -i "s/<DOCKER_BASE>/$(docker_base)/g" worker/Dockerfile

sed -i "s/<RUNNER>/$(runner)/g" spec/spec_helper.rb

sed -i "s/<RUNNER>/$(runner)/g" lib/sample_runner.rb
mv lib/sample_runner.rb lib/$(runner)_runner.rb


sed -i "s/<RUNNER>/$(runner)/g" lib/metadata_hook.rb
sed -i "s/<RUNNER>/$(runner)/g" lib/test_hook.rb
sed -i "s/<RUNNER>/$(runner)/g" lib/version_hook.rb
