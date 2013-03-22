#
# Cookbook Name:: sphinx
# Recipe:: source
#
# Copyright 2013, Mikhail Pobolovets <styx.mp@gmail.com>
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

include_recipe "build-essential"
include_recipe "postgresql::client" if node[:sphinx][:use_postgres]
include_recipe "mysql::client" if node[:sphinx][:use_mysql]

remote_file "/tmp/sphinx-#{node[:sphinx][:version]}.tar.gz" do
  source node[:sphinx][:url]
  checksum node[:sphinx][:checksum]
  not_if { ::File.exist?('/usr/local/bin/searchd') }
end

execute "Extract Sphinx source" do
  cwd "/tmp"
  command "tar -zxvf /tmp/sphinx-#{node[:sphinx][:version]}.tar.gz"
  not_if { ::File.exist?('/usr/local/bin/searchd') }
end

if node[:sphinx][:use_stemmer]
  remote_file "/tmp/libstemmer_c.tgz" do
    source node[:stemmer][:url]
    checksum node[:stemmer][:checksum]
  end

  execute "Extract stemmer source" do
    cwd "/tmp"
    command "tar -C /tmp/sphinx-#{node[:sphinx][:version]} -zxf libstemmer_c.tgz"
    not_if { ::File.exists?("/tmp/sphinx-#{node[:sphinx][:version]}/libstemmer_c/src_c") }
  end
end

bash "Build and Install Sphinx Search" do
  cwd "/tmp/sphinx-#{node[:sphinx][:version]}"
  code <<-EOH
    ./configure --prefix=#{node[:sphinx][:install_path]} #{node[:sphinx][:configure_flags].join(" ")}
    make -j#{node[:cpu][:total]}
    make install
  EOH
  not_if { ::File.exists?("/usr/local/bin/searchd") }
end

