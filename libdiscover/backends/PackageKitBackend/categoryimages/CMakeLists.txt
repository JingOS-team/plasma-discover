install( 
    DIRECTORY 
    categorys/
    DESTINATION ${KDE_INSTALL_FULL_DATAROOTDIR}/discover/pkcategories
    FILES_MATCHING PATTERN "*.png"
    PERMISSIONS WORLD_EXECUTE WORLD_WRITE WORLD_READ GROUP_EXECUTE GROUP_WRITE GROUP_READ OWNER_EXECUTE OWNER_WRITE OWNER_READ
    )
install( 
    FILES
    educationcrop.jpg
    fontcrop.jpg
    gamecrop.jpg
    graphiccrop.jpg
#     multimedia2.jpg
    multimediacrop.jpg
#     music.jpe
    officecrop.jpg
    sciencecrop.jpg
    accesscropped.jpg
    toolcrop.jpg
    accesscropped.jpg
    accessoriescrop.jpg
    applicationcrop.jpg
    internetcrop.jpg
    settingscrop.jpg
    categoriesinfo.json
    PERMISSIONS WORLD_EXECUTE WORLD_WRITE WORLD_READ GROUP_EXECUTE GROUP_WRITE GROUP_READ OWNER_EXECUTE OWNER_WRITE OWNER_READ
    DESTINATION ${KDE_INSTALL_FULL_DATAROOTDIR}/discover/pkcategories
    )
