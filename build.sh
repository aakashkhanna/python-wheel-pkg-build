echo "Running Poetry Package Build Script"

echo "SOURCE_DIR:               ${SOURCE_DIR}"
echo;
echo "GIT_DIR:                  ${GIT_DIR}"
echo;
echo "CONFIG_FILE_PATH:         ${CONFIG_FILE_PATH}"
echo;
echo "PUBLISH:                  ${PUBLISH}"
echo;

echo "Changing directory to project..."
cd /project


# echo "Setting artifactory target and source in poetry..."
# poetry config repositories.bxti_artifactory_target ${ARTIFACTORY_TARGET}
# poetry config repositories.bxti_artifactory_source ${ARTIFACTORY_SOURCE}
# echo;

echo "Installing poetry..."
poetry config virtualenvs.create false
poetry install

version=`cat version.txt`
version=`sed 's/-/+/1' <<< $version`
echo "Version: ${version}"

echo "Updating version to ${version} in poetry..."
poetry version $version

echo "Building package..."
poetry build
echo;

if [ -n "$PUBLISH" ];
then
    echo "Publishing package.."
    poetry publish | tee publish_info.txt
    echo;
fi

echo "Copying artifacts to root.."
cp -a /project/output/. /