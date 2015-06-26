Chef::Log.info("******Builder strawberry perl install actions******")

Chef::Log.info("******download official strawberry perl actions******")
windows_package node['strawberryperl']['package_name'] do
  source node['strawberryperl']['url']
  options "INSTALLDIR=\"#{node['strawberryperl']['home']}\""
  action :install
end

# update path
windows_path node['strawberryperl']['home'] do
  action :add
end

Chef::Log.info("******Downloading replaced files from S3******")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

#node['replaced_strawberryperl']['zip_path'] = "#{node['strawberryperl']['home']}/#{['replaced_strawberryperl']['zip_fname']}"
#node['replaced_strawberryperl']['unzip_folder_path'] = "#{node['strawberryperl']['home']}/#{['replaced_strawberryperl']['unzip_foldername']}"

#Chef::Log.info("******replace file zip path: #{node['replaced_strawberryperl']['zip_path']}******")
#Chef::Log.info("******replace file zip path: #{node['replaced_strawberryperl']['unzip_folder_path']}******")

ruby_block "download-object" do
  block do
    require 'aws-sdk'
	
	Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

    s3_client = Aws::S3::Client.new(region: 'us-west-2')

    s3_client.get_object(bucket: node['replaced_strawberryperl']['s3_bucket'],
                     key: node['replaced_strawberryperl']['s3_key'],
                     response_target: node['replaced_strawberryperl']['zip_path'])
  end
  action :run
end

Chef::Log.info("******unzip to local folder path******")
#directory node['replaced_strawberryperl']['unzip_folder_path'] do
#  recursive true
#  action :delete
#  if { File.directory?(node['replaced_strawberryperl']['unzip_folder_path']) }
#end

windows_zipfile node['replaced_strawberryperl']['unzip_folder_path'] do
  source node['replaced_strawberryperl']['zip_path']
  action :unzip
  not_if { ::File.directory?(node['replaced_strawberryperl']['unzip_folder_path']) }
end

Chef::Log.info("******replace folder and contents******")
original_cpan_path = "#{node['replaced_strawberryperl']['unzip_folder_path']}\\cpan"
original_perl_path = "#{node['replaced_strawberryperl']['unzip_folder_path']}\\perl"

replaced_cpan_path = "#{node['strawberryperl']['home']}\\cpan"
replaced_perl_path = "#{node['strawberryperl']['home']}\\perl"

ruby_block "replace strawberry perl cpan" do
  block do
    FileUtils.mkdir_p replaced_cpan_path
    FileUtils.cp(replaced_cpan_path, original_cpan_path)
  end
end

#remote_directory original_cpan_path do
#  source replaced_cpan_path
#  overwrite true
#  action :create
#end

#powershell_script "Replace original Folders" do
#  code <<-EOH
#    copy-item -path replaced_cpan_path -destination original_cpan_path -verbose
#  EOH
#end

