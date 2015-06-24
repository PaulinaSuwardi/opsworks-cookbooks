#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: 7-zip
# Attribute:: default
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if kernel['machine'] =~ /x86_64/
  default['strawberryperl']['url']          = "http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-64bit.msi"
  default['strawberryperl']['package_name'] = "strawberry-perl-5.16.3.1 (x64 edition)"
else
  default['strawberryperl']['url']          = "http://strawberryperl.com/download/5.16.3.1/strawberry-perl-5.16.3.1-32bit.msi"
  default['strawberryperl']['package_name'] = "strawberry-perl-5.16.3.1"
end

default['strawberryperl']['home']    = "C:\\strawberry-perl-5.16.3.1"
