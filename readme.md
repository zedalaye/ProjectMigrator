# Project Migrator

This tools ease migration of a project files from an original source tree to a new one.

The aim is to migrate files using `git rm [-r] <file_or_dir> <file_or_dir>` and `git mv <file_or_dir> <file_or_dir>` to force git to keep files history.

## How to ?

*Prerequisites:*

- a legacy project with a mess of files. Say that original Repo resides within the `legacy` repository
- a fresh new git repository where you will cleanup all that mess, say you will call it `future`
- tons of motivation to refactor and cleanup this project and make is as fresh as a daisy

*Steps:*

1. Prepare a new, empty repository for your project, move files, reorganize, make it as perfect as you can. Try avoid renaming files at this step, just move them around and change build/project files to match new locations. Make sure everything build and that tests passes.

The obvious way from here is to delete all files from `legacy` working tree and to copy them from the `future`working tree. Then let git sort out renames and deletes.  Sometimes, it works. So you can stop this tutorial here, you just saved several hours of painful job.

If you're still here that means that git was not able to sort out renames.

The goal here is to create a bash script (if you're on Windows you will be able to run it by using the "Git Bash Here" console from [GitForWindows](https://gitforwindows.org/)) to move and delete files or directories.

1. Reset the `legacy`repository (`git reset --hard`) and make sure `future`repository is clean (you can create a clean clone next to the `future`working dir by using `git clone ../future future-empty`)
2. Start `ProjectMigrator`
3. In the "Source" column, point to the `legacy`repository. Click the `refresh` button to load its files and folders hierarchy.
4. In the "Destination" column, point to the `furure` (or `future-empty`) repository. Click the `refresh` button to load its file and folders hierarchy.
5. Click the `Create Destination Folders Hierarchy` button to add `mkdir`lines to the output script.
6. Then, the painful job... move files by drag-and-dropping files and folders from `Source` tree to `Destination` tree.
7. You can mark a source file or folder as deleted by right clicking on it.
8. The script panel updates in real time. But remember that this script is a simple text file, you can change, correct, move, remove or add lines manually.
9. You can run a simple check to make sure all files exists by clinking the `Verify Script` button above the script (only `git rm [-r]`and `git mv` commands are checked)
10. There is a `Save Current State` button to save the current state of both `Source` and `Destination` trees in a binary files that resides within user `%appdata%` (for me it's `C:\Users\zedalaye\AppData\Roaming\ProjectMigrator\state.bin`), the script is also saved at the same place in a `script.sh` text file.
11. When all files have been mapped from `Source` to `Destination` and you are happy with your job, you can try to run the script :
    1. Go to the working dir of `legacy` repository using `Git Bash Here` from `GitForWindows`
    2. Run `$ bash /c/Users/<you>/AppData/Roaming/ProjectMigrator/script.sh` you may have to modify the script to run extra cleanup actions like removing empty repositories.
    3. It everything worked as expected `git status` should report only `renamed...` or `deleted...` files.
    4. When you are happy, commit.
    5. Delete all files from `legacy` working directory
    6. Copy all files and folders from `future` (or `future-empty`) repository
    7. Commit
    8. You're done.

## Building ProjectMigrator

You will need `Delphi 10.3.3` (but it may work with previous versions too) I suggest that you try with the free [Delphi Starter Edition](https://www.embarcadero.com/products/delphi/starter)

**Dependencies**: the Project JEDI [JCL](https://github.com/project-jedi/jcl.git) and [JVCL](https://github.com/project-jedi/jvcl.git) libraries and the [VirtualTreeView](https://github.com/Virtual-TreeView/Virtual-TreeView.git) library must be installed.