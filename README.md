# example-blazor-component-library
 A simple startup kit for building a component library.


Getting Started

1. Copy the scripts folder somewhere on your machine
2. Run the entry point from within your target library.
    ```ssh
        # run
        \path\to\your\script\directory\scripts\Manage\Component-Manager.ps1
    ```
Optionally:
Register script location in your system's PATH environemnt to have global access to it.
- manually - Computer > Properties > Advanced system settings > System Properties > Environment Variables > System variables > Edit Path
- cmd: Linux and macOS
```ssh
nano ~/.bashrc
export PATH=$PATH:/path/to/your/script/directory
```
- cmd: Windows
```sh
setx PATH "%PATH%;C:\Path\To\Your\Script\Directory" /M
```