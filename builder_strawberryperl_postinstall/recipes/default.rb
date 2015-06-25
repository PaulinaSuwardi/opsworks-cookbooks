Chef::Log.info("******Builder post install strawberry perl actions******")

Chef::Log.info("******Downloading files from S3******")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

ruby_block "download-object" do
  block do
    require 'aws-sdk'
	
	Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

    s3_client = Aws::S3::Client.new(region: 'us-west-2')

    s3_client.get_object(bucket: node['builder_strawberryperl']['s3_bucket'],
                     key: node['builder_strawberryperl']['s3_key'],
                     response_target: node['builder_strawberryperl']['localpath'])
  end
  action :run
end

#Chef::Log.info("******unzip to local home******")
#windows_zipfile node['builder_strawberryperl']['unzip_home'] do
#  source node['builder_strawberryperl']['localpath']
#  action :unzip
#end

