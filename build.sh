#! /bin/bash

set -o errexit
set -o pipefail
set -o nounset

app="107410"
steamuser="username"
steampass="password"

a3s_dir="/home/a3/a3sync"
repo_dir="/home/a3/a3sync/modules"
repo_name="hellenic-milsim_nautilus"
steam_dir="/home/a3/steamcmd"
modules_dir="/home/a3/serverfiles/modules"
workshop_dir="/home/a3/Steam/steamapps/workshop/content"

mv -t ${repo_dir} ${modules_dir}/* ${modules_dir}/.a3s

while IFS=, read -r name id cmd
do
	if [ ${cmd} == r ]
	then
		rm -r ${repo_dir}/${name}
	elif [ ${id} -gt 30000 ]
	then
		if [ ${cmd} == u ]
		then
			rm -r ${repo_dir}/${name}
		fi
		
		/bin/bash ${steam_dir}/steamcmd.sh +login "${steamuser}" "${steampass}" +workshop_download_item "${app}" "${id}" +quit
		mv ${workshop_dir}/${app}/${id} ${repo_dir}/${name}
		find ${repo_dir}/${name} -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;
	fi
done < modlist.csv

cd ${a3s_dir}
java -jar ${a3s_dir}/ArmA3Sync.jar -BUILD "${repo_name}"

mv -t ${modules_dir} ${repo_dir}/* ${repo_dir}/.a3s

/bin/bash /home/a3/a3s r

exit
