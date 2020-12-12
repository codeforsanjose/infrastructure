# from pathlib import Path

# print("Hi")
# for path in Path('.').rglob('terragrunt.hcl'):
#     if "terragrunt-cache" not in path:
#         print(path)

# from os import listdir
# from os.path import isfile, join
# mypath='.'

# onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
# print(onlyfiles)

import os
import glob
# print(glob.glob("./*/terragrunt.hcl"))

# terra_modules=[]
# terra_dependencies = []

# for terra_file in glob.glob("./*/terragrunt.hcl"):
#     print(terra_file)
#     terra_modules.append(os.path.basename(os.path.dirname(terra_file)))
#     with open(terra_file) as terragrunt:
#         data=terragrunt.readlines()
#         for i in range(len(data)):
#             if "dependencies" in data[i]:
#                 print(data[i+1])
#                 print(type(data[i+1]))

# print(terra_modules)



import hcl2
import glob
import pprint
pp = pprint.pprint

terra_modules = []
terra_dependencies = []

for terra_file in glob.glob("./*/terragrunt.hcl"):
    print(terra_file)
    terra_module_dir = os.path.basename(os.path.dirname(terra_file))
    terra_modules.append(terra_module_dir)

    # with open(terra_file, 'r') as file:
    #     dict = hcl2.load(file)
    #     if "dependencies" in dict:
    #         pp(dict['dependencies'])


import subprocess
bashCmd = ["terragrunt", "graph-dependencies"]
process = subprocess.Popen(bashCmd, stdout=subprocess.PIPE)

output, error = process.communicate()

print(output)