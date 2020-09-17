if not exist "lib" mkdir lib

pushd lib
cl -nologo -MT -TC -O2 -c ..\lib_cgltf.c
lib -nologo lib_cgltf.obj -out:cgltf.lib
popd
