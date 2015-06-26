Chef::Log.info("******Winzip install actions******")

Chef::Log.info("******Downloading replaced files from S3******")

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
                     response_target: node['winzip']['zip_path'])
  end
  action :run
end

Chef::Log.info("******unzip to local folder path******")

windows_zipfile node['winzip']['home'] do
  source node['winzip']['zip_path']
  action :unzip
  not_if { ::File.directory?(node['winzip']['home']) }
end
