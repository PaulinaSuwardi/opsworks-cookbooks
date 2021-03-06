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

windows_zipfile node['replaced_strawberryperl']['unzip_folder_path'] do
  source node['replaced_strawberryperl']['zip_path']
  action :unzip
  not_if { ::File.directory?(node['replaced_strawberryperl']['unzip_folder_path']) }
end

Chef::Log.info("******replace folder and contents******")
replaced_cpan_path = "#{node['replaced_strawberryperl']['unzip_folder_path']}\\cpan"
replaced_perl_path = "#{node['replaced_strawberryperl']['unzip_folder_path']}\\perl"

ruby_block "replace original strawberry perl and cpan" do
  block do
    FileUtils.cp_r(replaced_cpan_path, node['strawberryperl']['home'], :preserve => true, :remove_destination => true)
	FileUtils.cp_r(replaced_perl_path, node['strawberryperl']['home'], :preserve => true, :remove_destination => true)
  end
end
