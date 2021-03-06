#!/bin/sh

mkdir tmp
ecb -config library_wizard.ecf -target library_wizard -finalize -c_compile -project_path tmp
mkdir -p spec/$ISE_PLATFORM
mv tmp/EIFGENs/wizard/F_code/wizard spec/$ISE_PLATFORM/wizard
rm -rf tmp

WIZ_TARGET=$ISE_EIFFEL/studio/wizards/new_projects/library
rm -rf $WIZ_TARGET
mkdir $WIZ_TARGET
cp -r resources $WIZ_TARGET/resources
cp -r spec $WIZ_TARGET/spec
cp library.dsc $WIZ_TARGET/../library.dsc
rm -rf spec
