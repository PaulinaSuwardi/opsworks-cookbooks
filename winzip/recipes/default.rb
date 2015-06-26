Chef::Log.info("******Winzip install actions******")

download_filepath = "#{node['winzip']['download_folder']}\\winzip.zip"
Chef::Log.info("******Winzip create #{download_filepath}******")

Chef::Log.info("******Winzip create download directory******")
ruby_block "Create Directory" do
   block do
    require 'fileutils'
    FileUtils.mkdir_p(node['winzip']['download_folder'])
   end
end

#directory node['builder']['download_folder'] do
#  action :create
#end

Chef::Log.info("******Winzip downloading from S3******")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

ruby_block "download-object" do
  block do
    require 'aws-sdk'
	
	Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

    s3_client = Aws::S3::Client.new(region: node['winzip']['s3_region'])

    s3_client.get_object(bucket: node['winzip']['s3_bucket'],
                     key: node['winzip']['s3_key'],
                     response_target: download_filepath)
  end
  action :run
end

Chef::Log.info("******Winzip unzip to local folder path******")

windows_zipfile node['winzip']['home'] do
  source download_filepath
  action :unzip
  not_if { ::File.directory?(node['winzip']['home']) }
end

Chef::Log.info("******Winzip install exe*****")
installation_exe_path = "#{node['winzip']['home']}\\#{node['winzip']['exe_file']}"
windows_package 'winzip' do
  source installation_exe_path
  action :install
end
