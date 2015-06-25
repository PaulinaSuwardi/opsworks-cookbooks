if kernel['machine'] =~ /x86_64/
  default['strawberryperl']['url']          = "http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit.msi"
  default['strawberryperl']['package_name'] = "strawberry-perl-5.16.3.1 (x64 edition)"
else
  default['strawberryperl']['url']          = "http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-32bit.msi"
  default['strawberryperl']['package_name'] = "strawberry-perl-5.16.3.1"
end

default['strawberryperl']['home']    = "C:\\strawberry-perl-5.16.3.1"

default['replaced_strawberryperl']['s3_region'] = "us-west-2"
default['replaced_strawberryperl']['s3_bucket'] = "builder-poc"
default['replaced_strawberryperl']['s3_key'] = "strawberry-replace-file.zip"
default['replaced_strawberryperl']['zip_path'] = "C:\\strawberry-perl-5.16.3.1\\strawberry-replace-file.zip"
default['replaced_strawberryperl']['unzip_folder_path'] = "C:\\strawberry-perl-5.16.3.1\\strawberry-replace-file"

