#!/bin/bash 

while getopts "a:c:f:" option; do
    case $option in
    a)
        accName="$OPTARG"
        ;;
    c)
        conName="$OPTARG"
        ;;
    f)
        FILEPATH="$OPTARG"
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done 

#check errors during upload
check_error() {
    if [ $? -ne 0 ]; then
    echo "Error: The command failed."
    else
        echo "Success: The command succeeded."
    fi
}

#lists blobs in container
blob_list(){
    az storage blob list --account-name $accName --container-name $conName --output tsv --auth-mode login --query "[].name"
}

#upload files to container 
upload() {
    if [ -f $FILEPATH ]; then
        echo "Uploading $FILEPATH"
        pv $FILEPATH | az storage blob upload --account-name $accName --container-name $conName --name "$(basename "$FILEPATH")" --type block --file "$FILEPATH" --auth-mode login 2>/dev/null
        check_error
    else
        echo "$FILEPATH does not exist"
    fi
}

#checks if file is already in container
check_storage() { 
    file_exist=false

    for FILE in $(blob_list); do
        if [ "$FILE" == "$FILEPATH" ]; then
            file_exist=true
            break
        fi
    done

    if [ $file_exist == true ]; then
        echo "$FILEPATH already exists"
    else
        upload
    fi
}

check_storage