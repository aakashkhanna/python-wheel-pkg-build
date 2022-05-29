#!/bin/bash
echo "Running Poetry Package Build Script"

echo "SOURCE_DIR:               ${SOURCE_DIR}"
echo;
echo "GIT_DIR:                  ${GIT_DIR}"
echo;
echo "CONFIG_FILE_PATH:         ${CONFIG_FILE_PATH}"
echo;
echo "PUBLISH:                  ${PUBLISH}"
echo;
echo "RUN_TESTS:                ${RUN_TESTS}"
echo;
echo "Changing directory to project..."
cd /project

{ # try

    echo "Installing poetry..."
    poetry config virtualenvs.create false
    poetry install

} || { # catch
     
    echo "Failed while installing poetry."
    exit 1
}

{ # try

    version=`cat version.txt`
    version=`sed 's/-/+/1' <<< $version`
    echo "Version: ${version}"

} || { # catch
     
    echo "Failed while extracting version."
    exit 1
}

{ # try
    
    echo "Updating version to ${version} in poetry..."
    poetry version $version

} || { # catch
     
    echo "Failed while updating poetry version."
    exit 1
}

{ # try
    
    echo "Building package..."
    poetry build
    echo;

} || { # catch
     
    echo "Failed while building poetry."
    exit 1
}

if [ -n "$RUN_TESTS" ];
then
    
    { # try
    
    echo "Running tests."
    
    echo "Generating test coverage."
    poetry run pytest > pytest-coverage.txt
    echo;

    } || { # catch
        
        echo "Failed while running tests."
        exit 1
    }
fi

if [ -n "$PUBLISH" ];
then
    
    { # try
    
    echo "Publishing package.."
    poetry publish
    echo "Copying artifacts to root.."
    cp -a /project/output/. /
    echo;

    } || { # catch
         
        echo "Failed while publishing package."
        exit 1
    }
fi

