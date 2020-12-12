import os
from time import sleep
import glob
import subprocess
import pathlib

class bcolors: 
    HEADER    = '\033[95m'
    OKBLUE    = '\033[94m'
    OKCYAN    = '\033[96m'
    OKGREEN   = '\033[92m'
    WARNING   = '\033[93m'
    FAIL      = '\033[91m'
    ENDC      = '\033[0m'
    BOLD      = '\033[1m'
    UNDERLINE = '\033[4m'

def subprocess_cmd(command): 
    process     = subprocess.Popen(command,stdout=subprocess.PIPE, shell=True)
    proc_stdout = process.communicate()[0].strip()
    print(proc_stdout)

def retrieve_terragrunt_modules(): 
    terra_modules = []
    for terragrunt_modules in glob.glob("./*/terragrunt.hcl"): 
        module = os.path.dirname(terragrunt_modules)
        terra_modules.append(module)
    terra_modules.sort()
    print(bcolors.OKCYAN + bcolors.BOLD + "Found modules: {}\n".format(terra_modules) + bcolors.ENDC)
    return terra_modules

    # return [ os.path.dirname(module) for module in glob.glob("./*/terragrunt.hcl") ]

def terragrunt_init_all(module_init_array): 
    module_array = module_init_array
    for module in module_array: 
        print(bcolors.OKCYAN + "\nChecking for Terragrunt Cache in {}".format(module) + bcolors.ENDC)
        terra_cache        = [ f for f in pathlib.Path(module).glob('.terragrunt-cache') ]
        if len(terra_cache) == 0:
            print(bcolors.OKBLUE + "Executing 'terragrunt init' for {}".format(module) + bcolors.ENDC)
            subprocess_cmd('cd {}; terragrunt init'.format(module))
        else: 
            print(bcolors.OKGREEN + '  .terragrunt-cache found for {}\n'.format(module) + bcolors.ENDC)
            print(bcolors.OKGREEN + '{}'.format(module_array) + bcolors.ENDC)
            module_array.remove(module)
            print(bcolors.OKGREEN + '{}'.format(module_array) + bcolors.ENDC)

    if len(module_array) == 0:
        print(bcolors.OKGREEN + bcolors.BOLD + "\n All modules contain .terragrunt-cache \n" + bcolors.ENDC)
    else: 
        print(bcolors.WARNING + "\nRE-TRYING BELOW MODULES:" + bcolors.ENDC)
        print(bcolors.WARNING + '{}\n'.format(module_array) + bcolors.ENDC)
        terragrunt_init_all(module_array)

terragrunt_modules = retrieve_terragrunt_modules()
terragrunt_init_all(terragrunt_modules)