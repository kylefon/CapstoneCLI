#!/bin/bash 

source config.sh

#checks if file is already in container
check_storage() {
    for FILEPATH in "$@"; do 
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
            upload "$FILEPATH"

            read -p "Do you want to generate a shareable link for $FILEPATH? (Y/N):" userInput

            case $userInput in
                [Yy])
                    generate_link "$FILEPATH"
                    ;;
                [Nn])
                    echo "Skipping link generation"
                    ;;
                *)
                    echo "Invalid input. Skipping link generation"
                    ;;
            esac
        fi
    done 
}

#check errors during upload
check_error() {
    if [ $? -ne 0 ]; then
    echo "Error: The command failed."
    else
        echo "Success: The command succeeded."
    fi
}

#upload files to container 
upload() {
    if [ -f $FILEPATH ]; then
        echo "Uploading $FILEPATH..."
        pv $FILEPATH | az storage blob upload --account-name $accName --container-name $conName --name "$(basename "$FILEPATH")" --type block --file "$FILEPATH" --auth-mode login 2>/dev/null
        check_error
    else
        echo "$FILEPATH does not exist"
    fi
}

generate_link() {
    local FILEPATH="$1"
    #Generate SAS
    local SAS_TOKEN=$(az storage blob generate-sas --account-name "$accName" --container-name "$conName" --name "$(basename $FILEPATH)" --auth-mode login  --as-user --permissions r --expiry "$(date -u --date='1 day' '+%Y-%m-%dT%H:%MZ')" --output tsv)
    #Display link
    local LINK="https://$accName.blob.core.windows.net/$conName/$(basename $FILEPATH)?$SAS_TOKEN"
    echo "Link for $FILEPATH"
    echo "$LINK"
}


#lists blobs in container
blob_list(){
    az storage blob list --account-name $accName --container-name $conName --output tsv --auth-mode login --query "[].name"
}

check_storage "$@"