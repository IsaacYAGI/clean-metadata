FROM ubuntu:20.04

RUN apt update && apt install -y software-properties-common && apt update

RUN add-apt-repository universe

RUN apt update && apt install -y exiftool mat2

WORKDIR /home/root/shared

CMD ["bash"]

# Build the image

# docker build -t metadata-remove:latest .

# run like this

# Note: we must mount a volume or folder so the docker image can access the file and save the cleaned version

# - Enter the machine

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest bash

# and you can execute the commands to remove exif data: exiftool file.pdf (to get exif metada)
# mat2 file.pdf to remove the metadata (the pages are converted to image and generate the pdf without metadata but the result file is really big)
# or mat2 --lightweight file.pdf to remove some metadata and the result file is smaller but we must check if is exiftdata still available

# or

# - Run only the exiftool command

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest exiftool file.pdf

# - Run only mat2 command

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest mat2 file.pdf
# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest mat2 --lightweight file.pdf
# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest mat2 --lightweight --inplace file.pdf # (to replace the original file)

# - Clean recursive
# 1. Find all pdf files 

# find . -name '*.pdf' > list_to_clean.txt

# 2. Get exift data from the listed files

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest bash -c 'cat list_to_clean.txt | while read in; do (exiftool "$in" && echo "----") >> result_exift.txt 2>> result_exift_error.txt; done'

# 3. Clean exiftdata from the listed files

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest bash -c 'cat list_to_clean.txt | while read in; do (mat2 --lightweight "$in" && echo "Cleaned $in") >> result_mat2.txt 2>> result_mat2_error.txt; done'

# 3.1. Or clean and replace the listed files

# docker run --rm -it -v $(pwd):/home/root/shared metadata-remove:latest bash -c 'cat list_to_clean.txt | while read in; do (mat2 --lightweight --inplace "$in" && echo "Cleaned $in") >> result_mat2.txt 2>> result_mat2_error.txt; done'