user=$1
runner=$2
constant=$3
year=$4
author=$5
docer_base=$6


sed -ie "s/<RUNNER>/$(runner)/g" mumuki-sample-runer.gemspec
sed -ie "s/<CONSTANT>/$(constant)/g" mumuki-sample-runer.gemspec
mv mumuki-sample-runer.gemspec mumuki-$(runner)-runner.gemspec

sed -ie "s/<RUNNER>/$(runner)/g" config.ru
sed -ie "s/<RUNNER>/$(runner)/g" README.md
sed -ie "s/<YEAR>/$(year)/g" LICENSE
sed -ie "s/<AUTHOR>/$(author)/g" LICENSE
sed -ie "s/<RUNNER>/$(runner)/g" .travis.yml

sed -ie "s/<AUTHOR>/$(author)/g" worker/Dockerfile
sed -ie "s/<DOCKER_BASE>/$(docker_base)/g" worker/Dockerfile

sed -ie "s/<RUNNER>/$(runner)/g" spec/spec_helper.rb

sed -ie "s/<RUNNER>/$(runner)/g" lib/sample_runner.rb
mv lib/sample_runner.rb lib/$(runner)_runner.rb


sed -ie "s/<RUNNER>/$(runner)/g" lib/metadata_hook.rb
sed -ie "s/<RUNNER>/$(runner)/g" lib/test_hook.rb
sed -ie "s/<RUNNER>/$(runner)/g" lib/version_hook.rb
