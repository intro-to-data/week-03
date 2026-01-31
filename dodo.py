# Manages project tasks.
# Assumes pydoit is installed globally.


import zipfile
from pathlib import Path
from doit.task import clean_targets


def task_style():
    files = []
    files.extend(Path("./data/").glob("*.R"))
    files.extend(Path("./").glob("*.R"))
    files.extend(Path("./").glob("*.qmd"))

    return{
        "file_dep": files,
        "actions": [
            f"Rscript -e \"styler::style_dir('./data/')\" ",
            f"Rscript -e \"styler::style_dir('.')\" ",
        ],
        "clean": True
    }

def task_data():
    file_targets = ["./data/mpg2020.csv"]
    file_actions = "./data/get_mpg.R"

    return{
        "file_dep": [file_actions],
        "targets": file_targets,
        "actions": [f"Rscript {file_actions}"],
        "clean": True
    }


def task_lecture():
    file_targets = ["./lecture.html"]
    file_actions = "./lecture.qmd"

    file_deps = []
    file_deps.extend(Path("./data/").glob("*.csv"))
    file_deps.extend(file_actions)
    
    return{
        "file_dep": file_deps,
        "targets": file_targets,
        "actions": [f"quarto preview {file_actions}"],
        "clean": True
    }


def create_zip(target_zip, files):
    """Used by task_zip to create the zip file."""
    with zipfile.ZipFile(target_zip, "w", zipfile.ZIP_DEFLATED) as zf:
        for fs in files:
            file_path = Path(".") / fs
            archive_name = file_path.relative_to(".")
            zf.write(file_path, arcname = archive_name)



def task_zip():
    """Creates the ZIP file to give to students."""
    files = []
    files.extend(Path("./data/").glob("*"))
    files.extend(Path("./includes/").glob("*"))
    files.extend(Path(".").glob("*.R"))
    files.extend(Path(".").glob("*.Rproj"))
    files.extend(Path(".").glob("*.qmd"))
    files.remove(Path("./lab-answers.qmd"))
    files = [f.relative_to(Path(".")) for f in files]
    target = Path("week-03.zip")
    return{
        "file_dep": files,
        "targets": [target],
        "actions": [(create_zip, [], {"target_zip": target, "files": files})],
    }
